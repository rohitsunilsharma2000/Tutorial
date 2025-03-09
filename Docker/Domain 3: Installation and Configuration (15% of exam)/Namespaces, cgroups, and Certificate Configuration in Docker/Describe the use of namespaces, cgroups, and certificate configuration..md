### **Namespaces, cgroups, and Certificate Configuration in Docker**  
These three concepts—**namespaces, cgroups, and certificates**—are essential for **container isolation, resource management, and security** in Docker.

---

## **1️⃣ Namespaces: Container Isolation**
**Namespaces** provide **process isolation** in Linux, ensuring that a container sees only its own processes, network, and filesystem.

### **How Namespaces Work in Docker**
When you start a Docker container, it runs in a separate namespace so that it:
- **Cannot see or interfere** with other containers.
- Has its **own network stack** (IP, ports).
- Has its **own mount points** (filesystems).

### **Key Linux Namespaces Used by Docker**
| Namespace | Purpose |
|-----------|---------|
| **PID** | Isolates process IDs (so containers don’t see each other’s processes). |
| **NET** | Provides each container with its own virtual network stack. |
| **MNT** | Controls file system mounts to separate container storage. |
| **IPC** | Isolates inter-process communication (so shared memory stays within a container). |
| **UTS** | Allows a container to have a separate hostname. |
| **USER** | Separates user IDs inside a container from the host system. |

### **Example: Viewing Docker Container Namespaces**
List namespaces used by a running container:
```bash
docker ps
docker inspect <container_id> | grep Pid
lsns | grep <container_pid>
```
View the network namespace of a container:
```bash
sudo nsenter -t <container_pid> -n ip a
```

---

## **2️⃣ cgroups (Control Groups): Resource Management**
**cgroups** (control groups) are a Linux kernel feature that **limits and monitors resources** (CPU, memory, I/O, network) for containers.

### **How Docker Uses cgroups**
- Prevents a single container from **using too much CPU or memory**.
- Ensures **fair resource allocation** among containers.
- Enables **monitoring and prioritization** of processes.

### **Example: Set Resource Limits on a Container**
Limit a container to **1 CPU and 512MB RAM**:
```bash
docker run -d --name myapp --memory=512m --cpus=1 nginx
```
Check the container's **cgroup limits**:
```bash
cat /sys/fs/cgroup/memory/docker/<container_id>/memory.limit_in_bytes
cat /sys/fs/cgroup/cpu/docker/<container_id>/cpu.shares
```

### **Example: View Running Containers with Their Resource Usage**
```bash
docker stats
```

---

## **3️⃣ Certificate Configuration: Secure Docker Communication**
Certificates (**TLS/SSL**) secure communication between:
- **Docker Daemon and Docker CLI** (protects against unauthorized access).
- **Docker Client and Private Registry** (ensures secure image transfers).
- **Docker Swarm Nodes** (encrypts data between managers and workers).

### **How Docker Uses Certificates**
| Certificate | Purpose |
|------------|---------|
| **CA Certificate (ca.pem)** | Trusts the TLS connection. |
| **Server Certificate (server-cert.pem)** | Identifies the registry or daemon. |
| **Client Certificate (client-cert.pem)** | Identifies the user or daemon requesting access. |

### **Example: Configure Docker Daemon with TLS**
1️⃣ **Generate TLS Certificates** (CA, Server, Client)
```bash
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```
2️⃣ **Enable TLS in Docker Daemon** (`daemon.json`)
```json
{
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs.d/ca.pem",
  "tlscert": "/etc/docker/certs.d/server-cert.pem",
  "tlskey": "/etc/docker/certs.d/server-key.pem",
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"]
}
```
Restart Docker:
```bash
systemctl restart docker
```
3️⃣ **Connect Docker Client Securely**
```bash
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="/etc/docker/certs.d/"
docker -H tcp://myserver:2376 info
```

---

## **🔹 Summary**
| Concept | Purpose | Example |
|---------|---------|---------|
| **Namespaces** | Isolates containers (processes, networking, filesystem). | `lsns` to list namespaces. |
| **cgroups** | Limits container resources (CPU, memory, I/O). | `docker run --memory=512m --cpus=1 nginx` |
| **Certificates** | Secures Docker communication via TLS. | `docker -H tcp://myserver:2376 info` |

### **Step-by-Step Guide for Freshers: Docker Security with Namespaces, cgroups, and Certificates**  
This guide will help you understand and implement **container isolation, resource management, and secure communication** using **namespaces, cgroups, and certificates** in Docker.  

---

## **1️⃣ Step 1: Understanding and Using Namespaces (Container Isolation)**  
Namespaces **isolate Docker containers** from each other and the host system.  

### **Check the Namespaces of a Running Container**  
#### **1. Start a Container**
Run an **nginx container** in the background:
```bash
docker run -d --name my-nginx nginx
```
Find the **process ID (PID)** of the running container:
```bash
docker inspect --format '{{ .State.Pid }}' my-nginx
```
Example Output:
```
12345
```
Now, let’s check what **namespaces** this container is using.

---

#### **2. View Container Namespaces**
Run this command to see the **namespaces associated with the container**:
```bash
lsns | grep 12345
```
(Replace `12345` with the actual PID from the previous step.)

It will show:
```
4026532645        12345     net
4026532646        12345     mnt
4026532647        12345     pid
...
```
Each line represents an **isolated namespace** for networking, filesystem, and processes.

---

#### **3. Enter the Container’s Namespace**
To execute commands **inside the container’s namespace**, use:
```bash
nsenter -t 12345 -n ip a
```
(Replace `12345` with your actual container PID.)

This shows the **network interfaces** inside the container.

---

## **2️⃣ Step 2: Managing Resources with cgroups (Control Groups)**  
cgroups allow us to **limit CPU, memory, and disk I/O usage** for a container.

### **1. Limit CPU and Memory Usage**
Start an nginx container with **512MB RAM and 1 CPU**:
```bash
docker run -d --name limited-nginx --memory=512m --cpus=1 nginx
```

Check the applied limits:
```bash
cat /sys/fs/cgroup/memory/docker/$(docker inspect --format '{{ .Id }}' limited-nginx)/memory.limit_in_bytes
```
It should show:
```
536870912   # (512MB in bytes)
```

---

### **2. Monitor Resource Usage of Running Containers**
```bash
docker stats
```
This shows:
```
CONTAINER ID   NAME             CPU %   MEM USAGE / LIMIT  NETWORK I/O
abc123         limited-nginx    0.5%    64MiB / 512MiB     100MB / 50MB
```
This helps you monitor **CPU, memory, and network usage** of all running containers.

---

## **3️⃣ Step 3: Configuring Secure Communication with TLS Certificates**  
### **1. Create a Certificate Authority (CA)**
First, create a folder for certificates:
```bash
mkdir -p ~/docker-tls && cd ~/docker-tls
```
Generate a **CA key and certificate**:
```bash
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```
- This creates a **Certificate Authority (CA)** to sign certificates.

---

### **2. Generate Server Certificates for Docker Daemon**
```bash
openssl genrsa -out server-key.pem 4096
openssl req -new -key server-key.pem -out server.csr
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -days 365 -sha256
```
Move the certificates to the **Docker daemon’s cert directory**:
```bash
sudo mkdir -p /etc/docker/certs.d
sudo cp server-cert.pem server-key.pem ca.pem /etc/docker/certs.d/
```

---

### **3. Configure Docker Daemon to Use TLS**
Edit the Docker daemon configuration file:
```bash
sudo nano /etc/docker/daemon.json
```
Add the following lines:
```json
{
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs.d/ca.pem",
  "tlscert": "/etc/docker/certs.d/server-cert.pem",
  "tlskey": "/etc/docker/certs.d/server-key.pem",
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"]
}
```
Save and exit.

Restart Docker to apply the changes:
```bash
sudo systemctl restart docker
```

---

### **4. Connect Docker Client Securely**
On the client machine, copy the **CA certificate**:
```bash
sudo cp ~/docker-tls/ca.pem /etc/docker/certs.d/
```
Then, connect securely:
```bash
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="/etc/docker/certs.d/"
docker -H tcp://your-server-ip:2376 info
```
If everything is set up correctly, you will see:
```
Server:
 TLS Verify: true
 Server Version: 24.x
```

---

## **📌 Final Summary: What You Have Learned**
| Concept | What It Does | Commands |
|---------|-------------|----------|
| **Namespaces** | Isolates containers (network, process, filesystem) | `lsns`, `nsenter` |
| **cgroups** | Limits CPU, memory, and network usage of containers | `docker run --memory=512m --cpus=1` |
| **TLS Certificates** | Secures communication between Docker client and daemon | `openssl genrsa`, `docker -H tcp://server:2376 info` |

---
✅ **Now you have:**  
✔ **Isolated** your container with namespaces  
✔ **Managed resource limits** using cgroups  
✔ **Secured Docker communication** using TLS certificates  

Here is an **automated script** that sets up **namespaces, cgroups, and TLS certificates** for securing Docker.  

### **📜 Script: `setup-docker-security.sh`**  
This script will:  
✔ **Check and display namespaces of running containers**  
✔ **Apply cgroup limits (CPU & Memory) to a container**  
✔ **Set up TLS certificates for secure Docker communication**  

---

### **📌 How to Use the Script**  
1️⃣ **Download and make it executable:**  
```bash
chmod +x setup-docker-security.sh
```
2️⃣ **Run the script as root:**  
```bash
sudo ./setup-docker-security.sh
```

---

### **🚀 Full Script**
```bash
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
```

---

## **📌 What This Script Does**
✔ **Step 1:** Lists namespaces of a running container  
✔ **Step 2:** Runs a container with **CPU & Memory limits**  
✔ **Step 3:** **Generates TLS certificates** and configures Docker for **secure communication**  
✔ **Step 4:** **Restarts Docker** and verifies **TLS setup**  

---

## **📌 Next Steps**
- Test pulling and pushing images securely:
  ```bash
  docker pull busybox
  docker tag busybox localhost:2376/busybox
  docker push localhost:2376/busybox
  ```
- Automate deployment of **secure Docker clusters** using this script.  

🚀 **Now, your Docker setup is more secure!** Let me know if you need additional customizations. 😊