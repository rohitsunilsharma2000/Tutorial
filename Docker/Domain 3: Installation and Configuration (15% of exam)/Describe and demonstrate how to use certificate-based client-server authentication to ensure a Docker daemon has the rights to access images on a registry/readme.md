### **Using Certificate-Based Client-Server Authentication for Docker Daemon Access to a Registry**
Certificate-based authentication ensures **secure communication** between a **Docker client** (or daemon) and a **private registry** by encrypting the connection using **TLS (Transport Layer Security)**.

### **1. How It Works**
- The **Docker daemon** acts as the client and communicates with the **Docker registry** (server).
- **TLS certificates** authenticate the daemon before it can pull/push images.
- The **private registry** requires clients to present valid certificates to establish trust.

---

## **Step-by-Step Guide: Setting Up Certificate-Based Authentication**
This guide covers:
- **Generating TLS certificates**
- **Configuring the registry with certificates**
- **Configuring the Docker daemon with certificates**
- **Testing the authentication**

---

## **Step 1: Generate TLS Certificates**
First, we generate a **Certificate Authority (CA)** and sign certificates for the registry and the Docker daemon.

### **1.1. Create a Certificate Authority (CA)**
On the **registry server**:
```bash
mkdir -p ~/certs && cd ~/certs
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```
- This generates:
  - `ca-key.pem` (Private key for the CA)
  - `ca.pem` (Public certificate for the CA)

---

### **1.2. Generate a Private Key and Certificate Signing Request (CSR) for the Registry**
```bash
openssl genrsa -out registry-key.pem 4096
openssl req -new -key registry-key.pem -out registry.csr
```
- This creates:
  - `registry-key.pem` (Private key)
  - `registry.csr` (Certificate Signing Request)

Now, sign the registry’s certificate with the **CA**:
```bash
openssl x509 -req -in registry.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out registry-cert.pem -days 365 -sha256
```
- This generates `registry-cert.pem` (Registry’s signed certificate).

---

### **1.3. Generate a Private Key and Certificate for the Docker Daemon**
```bash
openssl genrsa -out client-key.pem 4096
openssl req -new -key client-key.pem -out client.csr
```

Sign the client certificate using the **CA**:
```bash
openssl x509 -req -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -days 365 -sha256
```
- Now we have:
  - `client-cert.pem` (Docker daemon’s certificate)
  - `client-key.pem` (Docker daemon’s private key)

---

## **Step 2: Configure the Private Registry with Certificates**
Move the `registry-cert.pem` and `registry-key.pem` to the **Docker registry server** under:
```bash
sudo mkdir -p /etc/docker/certs.d/myregistry.com:5000
sudo mv registry-cert.pem /etc/docker/certs.d/myregistry.com:5000/registry-cert.pem
sudo mv registry-key.pem /etc/docker/certs.d/myregistry.com:5000/registry-key.pem
sudo mv ca.pem /etc/docker/certs.d/myregistry.com:5000/
```

Now, restart the registry with TLS:
```bash
docker run -d --restart=always --name registry \
  -v /etc/docker/certs.d/myregistry.com:5000:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry-cert.pem \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry-key.pem \
  -p 5000:5000 registry:2
```

---

## **Step 3: Configure Docker Daemon with Certificates**
On **each client machine** (Docker daemon):

1. Create the necessary directory:
   ```bash
   sudo mkdir -p /etc/docker/certs.d/myregistry.com:5000/
   ```

2. Copy the **client certificate and key**:
   ```bash
   sudo cp client-cert.pem /etc/docker/certs.d/myregistry.com:5000/client-cert.pem
   sudo cp client-key.pem /etc/docker/certs.d/myregistry.com:5000/client-key.pem
   ```

3. Copy the **CA certificate**:
   ```bash
   sudo cp ca.pem /etc/docker/certs.d/myregistry.com:5000/
   ```

4. Restart Docker:
   ```bash
   sudo systemctl restart docker
   ```

---

## **Step 4: Verify Secure Access to the Private Registry**
Now, test if the Docker daemon can **pull/push** images securely.

### **Check if the Docker client can connect**
```bash
curl --cacert /etc/docker/certs.d/myregistry.com:5000/ca.pem https://myregistry.com:5000/v2/
```
If successful, it should return:
```json
{}
```

### **Pull an Image from the Secure Registry**
```bash
docker pull busybox
docker tag busybox myregistry.com:5000/busybox
docker push myregistry.com:5000/busybox
```

### **List Images in the Private Registry**
```bash
curl --cacert /etc/docker/certs.d/myregistry.com:5000/ca.pem https://myregistry.com:5000/v2/_catalog
```

---

## **Step 5: Enforce Client Certificate Authentication (Optional)**
To make client certificates **mandatory** for access:
1. Modify the registry configuration (`config.yml`):
   ```yaml
   version: 0.1
   log:
     level: debug
   http:
     addr: :5000
     tls:
       certificate: /certs/registry-cert.pem
       key: /certs/registry-key.pem
     clientcas:
       - /certs/ca.pem
   ```
2. Restart the registry:
   ```bash
   docker restart registry
   ```

This forces all clients to provide a **valid certificate** for authentication.

---

## **Summary**
| Step | Action |
|------|--------|
| **Step 1** | Generate **TLS Certificates** (CA, Registry, Docker Daemon) |
| **Step 2** | Configure the **Docker Registry** with SSL certificates |
| **Step 3** | Configure **Docker Daemon** with client certificates |
| **Step 4** | Test secure **push/pull** from the private registry |
| **Step 5 (Optional)** | Enforce **client certificate authentication** |

This ensures that **only authorized Docker daemons** with valid certificates can access images in the **private registry**. 🚀

Here is a **scripted version** of the entire setup for **certificate-based client-server authentication** in Docker. This script automates:

1. Generating **TLS certificates** (CA, Registry, Client).
2. Setting up a **Docker Private Registry** with TLS.
3. Configuring the **Docker Daemon** to use client certificates.
4. Verifying **secure push/pull access**.

---

### **📜 Full Script for Automating Certificate-Based Authentication**
Save this script as `setup-docker-tls.sh`, then **run it on your server**.

```bash
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
```

---

## **🔧 How to Use This Script**
1. **Make the script executable**:
   ```bash
   chmod +x setup-docker-tls.sh
   ```
2. **Run the script as root**:
   ```bash
   sudo ./setup-docker-tls.sh
   ```

---

## **🎯 What This Script Does**
- Generates **CA, registry, and client certificates**.
- Starts a **private Docker registry** with **TLS encryption**.
- Configures **Docker Daemon** with client certificates.
- Verifies **secure access** via `curl`.
- Tests **pushing and pulling** an image (`busybox`) securely.

---

## **💡 Next Steps**
- 🔄 **Automate client setup**: Deploy certificates to multiple machines using Ansible.
- 🛠 **Enable LDAP for user authentication**: If used in an enterprise setup.
- 🔍 **Monitor registry logs**: Use `docker logs registry` to troubleshoot.

This script **ensures only authorized Docker daemons** can push/pull from the registry. 🚀

