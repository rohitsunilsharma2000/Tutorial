#!/bin/bash

# === CONFIGURE VARIABLES ===
REGISTRY_DOMAIN="myregistry.com"
REGISTRY_PORT="5000"
CERTS_DIR="/etc/docker/certs.d/${REGISTRY_DOMAIN}:${REGISTRY_PORT}"
BACKUP_DIR="${HOME}/docker_certs_backup"

# Ensure running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 
   exit 1
fi

echo "🚀 Starting Docker Certificate-Based Authentication Setup..."

# === STEP 1: GENERATE TLS CERTIFICATES ===
echo "🔐 Generating Certificate Authority (CA)..."
mkdir -p ${CERTS_DIR} && cd ${CERTS_DIR}
mkdir -p ${BACKUP_DIR}

openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

echo "📜 Generating Registry Certificate..."
openssl genrsa -out registry-key.pem 4096
openssl req -new -key registry-key.pem -out registry.csr

openssl x509 -req -in registry.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out registry-cert.pem -days 365 -sha256

echo "📜 Generating Client Certificate..."
openssl genrsa -out client-key.pem 4096
openssl req -new -key client-key.pem -out client.csr
openssl x509 -req -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -days 365 -sha256

# Backup certificates
cp *.pem ${BACKUP_DIR}/

# === STEP 2: SET UP REGISTRY WITH TLS ===
echo "📦 Setting up a Secure Docker Registry..."
docker run -d --restart=always --name registry \
  -v ${CERTS_DIR}:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry-cert.pem \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry-key.pem \
  -p ${REGISTRY_PORT}:5000 registry:2

# === STEP 3: CONFIGURE DOCKER DAEMON ===
echo "⚙️ Configuring Docker Daemon for TLS..."
mkdir -p ${CERTS_DIR}

cp client-cert.pem ${CERTS_DIR}/client-cert.pem
cp client-key.pem ${CERTS_DIR}/client-key.pem
cp ca.pem ${CERTS_DIR}/ca.pem

# Restart Docker to apply changes
systemctl restart docker

# === STEP 4: VERIFY SECURE CONNECTION ===
echo "✅ Verifying Secure Access to Registry..."
curl --cacert ${CERTS_DIR}/ca.pem https://${REGISTRY_DOMAIN}:${REGISTRY_PORT}/v2/ || { echo "❌ Registry authentication failed!"; exit 1; }

# === STEP 5: TEST PULL & PUSH OPERATIONS ===
echo "🚀 Testing Docker Push/Pull to Secure Registry..."
docker pull busybox
docker tag busybox ${REGISTRY_DOMAIN}:${REGISTRY_PORT}/busybox
docker push ${REGISTRY_DOMAIN}:${REGISTRY_PORT}/busybox || { echo "❌ Push to registry failed!"; exit 1; }

echo "✅ Docker TLS Authentication Setup Completed Successfully!"
