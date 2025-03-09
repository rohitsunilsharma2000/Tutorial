### **Configuring Logging Drivers Using Splunk in Docker**
Docker provides built-in logging drivers, and one of the most powerful logging drivers is **Splunk**. The `splunk` logging driver sends container logs to a Splunk HTTP Event Collector (HEC).

---

## **1. Prerequisites**
Before configuring the Splunk logging driver, ensure the following:

- **Docker Installed:** Ensure that Docker is installed on your system.
- **Splunk Server Running:** A Splunk server must be set up and configured to accept HTTP Event Collector (HEC) logs.
- **HEC Token:** You need a Splunk HEC (HTTP Event Collector) token.
- **Network Connectivity:** The Docker host must be able to communicate with the Splunk server.
- **Docker Compose (optional):** If using `docker-compose`, ensure it is installed.

---

## **2. All Prerequisite Commands**
Run the following commands to install required dependencies:

### **A. Install Docker (If not already installed)**
```bash
# Update package list and install dependencies
sudo apt update
sudo apt install -y curl ca-certificates gnupg lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
docker --version
```

---

### **B. Install and Start Splunk**
You can use a Docker container to set up a Splunk server quickly:

```bash
docker run -d --name splunk \
  -e SPLUNK_START_ARGS="--accept-license" \
  -e SPLUNK_PASSWORD="YourStrongPassword" \
  -p 8000:8000 -p 8088:8088 -p 8089:8089 \
  splunk/splunk:latest
```
- **Splunk UI**: Open `http://localhost:8000` in a browser and log in with:
  - **Username**: `admin`
  - **Password**: `YourStrongPassword`
- **Enable HEC (HTTP Event Collector)**:
  1. Go to **Settings > Data Inputs > HTTP Event Collector**.
  2. Click **New Token**.
  3. Name it `docker-logs` and enable it.
  4. Copy the generated token for use in the logging configuration.

---

## **3. Step-by-Step Configuration for Beginners**
Once you have Splunk running and an HEC token, follow these steps to configure Docker logging:

### **A. Configure Docker to Use the Splunk Logging Driver**
#### **Method 1: Set Splunk as the Default Logging Driver**
1. Open Docker's **daemon.json** file:
   ```bash
   sudo nano /etc/docker/daemon.json
   ```
2. Add or modify the following content:
   ```json
   {
     "log-driver": "splunk",
     "log-opts": {
       "splunk-url": "http://localhost:8088",
       "splunk-token": "your-splunk-hec-token",
       "splunk-source": "docker",
       "splunk-sourcetype": "json",
       "splunk-index": "main",
       "splunk-insecureskipverify": "true"
     }
   }
   ```
3. Save the file (`CTRL + X`, then `Y`, then `ENTER`).
4. Restart Docker:
   ```bash
   sudo systemctl restart docker
   ```
5. Verify the configuration:
   ```bash
   docker info | grep -i "Logging Driver"
   ```
   It should show:
   ```
   Logging Driver: splunk
   ```

---

### **B. Configure a Single Container to Use the Splunk Logging Driver**
If you don’t want to set Splunk as the global logging driver, you can configure it per container.

Run the container with Splunk logging:
```bash
docker run -d --log-driver=splunk \
  --log-opt splunk-url="http://localhost:8088" \
  --log-opt splunk-token="your-splunk-hec-token" \
  --log-opt splunk-source="docker" \
  --log-opt splunk-sourcetype="json" \
  --log-opt splunk-index="main" \
  --log-opt splunk-insecureskipverify="true" \
  --name test-container nginx
```

---

### **C. Configure Splunk Logging in Docker-Compose**
If you use `docker-compose.yml`, configure the logging driver like this:

```yaml
version: '3'
services:
  web:
    image: nginx
    container_name: nginx-container
    logging:
      driver: splunk
      options:
        splunk-url: "http://localhost:8088"
        splunk-token: "your-splunk-hec-token"
        splunk-source: "docker"
        splunk-sourcetype: "json"
        splunk-index: "main"
        splunk-insecureskipverify: "true"
```

Deploy the container:
```bash
docker-compose up -d
```

---

### **D. Verify Logs in Splunk**
1. Open **Splunk Web UI** at `http://localhost:8000`.
2. Log in and go to **Search & Reporting**.
3. Search for logs:
   ```
   index="main" sourcetype="json"
   ```
   You should see logs from your Docker containers.

---

## **Summary**
✅ **Step 1:** Install Docker and run Splunk.  
✅ **Step 2:** Enable HEC and get a token.  
✅ **Step 3:** Configure Docker daemon or per-container logging.  
✅ **Step 4:** Deploy containers with Splunk logging enabled.  
✅ **Step 5:** Check logs in the Splunk Web UI.  

This step-by-step guide helps beginners integrate **Docker logging** with **Splunk** efficiently. 🚀