#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 
   exit 1
fi

echo "🚀 Starting Docker Security Setup..."

# === STEP 1: CHECK NAMESPACES OF RUNNING CONTAINERS ===
echo "🔍 Checking namespaces of running containers..."
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

read -p "Enter a container name or ID to inspect namespaces: " CONTAINER_ID
CONTAINER_PID=$(docker inspect --format '{{ .State.Pid }}' $CONTAINER_ID)
lsns | grep $CONTAINER_PID

echo "✅ Namespaces checked."

# === STEP 2: APPLY CGROUP LIMITS TO A CONTAINER ===
echo "⚙️ Setting CPU & Memory limits..."
docker run -d --name limited-nginx --memory=512m --cpus=1 nginx
echo "✅ Nginx container started with 512MB RAM & 1 CPU."

# Show running containers and resource usage
echo "📊 Running containers with resource usage:"
docker stats --no-stream

# === STEP 3: CONFIGURE TLS FOR SECURE DOCKER COMMUNICATION ===
echo "🔐 Setting up TLS Certificates..."
mkdir -p ~/docker-tls && cd ~/docker-tls

# Generate Certificate Authority (CA)
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

# Generate Server Certificate
openssl genrsa -out server-key.pem 4096
openssl req -new -key server-key.pem -out server.csr
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -days 365 -sha256

# Move certificates to Docker
sudo mkdir -p /etc/docker/certs.d
sudo cp server-cert.pem server-key.pem ca.pem /etc/docker/certs.d/

# Configure Docker Daemon
echo "⚙️ Configuring Docker Daemon for TLS..."
cat <<EOF > /etc/docker/daemon.json
{
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs.d/ca.pem",
  "tlscert": "/etc/docker/certs.d/server-cert.pem",
  "tlskey": "/etc/docker/certs.d/server-key.pem",
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"]
}
EOF

# Restart Docker to apply changes
systemctl restart docker
echo "✅ Docker TLS Security Setup Complete."

# === STEP 4: VERIFY SECURE CONNECTION ===
echo "🔍 Verifying secure Docker connection..."
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="/etc/docker/certs.d/"
docker -H tcp://localhost:2376 info

echo "🎉 Setup Complete! Docker is now secured with namespaces, cgroups, and TLS."
