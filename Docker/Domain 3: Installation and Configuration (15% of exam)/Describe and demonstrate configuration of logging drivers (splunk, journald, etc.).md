# **🔹 Configure Docker Logging with Splunk as the Logging Driver** 🚀  

## **✅ Overview**
By default, Docker logs are stored in **JSON files**. However, you can configure **Splunk** as a **logging driver** to centralize and analyze logs in **real-time**.

---

## **📌 1️⃣ Install and Configure Splunk**
### **🔹 Step 1: Install Splunk**
For **Ubuntu/Linux**, install Splunk:
```sh
wget -O splunk.deb https://download.splunk.com/products/splunk/releases/latest/linux/splunk-latest-linux-2.6-amd64.deb
sudo dpkg -i splunk.deb
sudo /opt/splunk/bin/splunk enable boot-start
sudo /opt/splunk/bin/splunk start --accept-license
```
For **Docker-based Splunk installation**:
```sh
docker run -d --name splunk \
  -p 8000:8000 -p 8088:8088 -p 9997:9997 \
  -e "SPLUNK_START_ARGS=--accept-license" \
  -e "SPLUNK_PASSWORD=changeme" \
  splunk/splunk:latest
```
✔ Splunk will be **available at `http://localhost:8000`**.

---

### **🔹 Step 2: Create a Splunk HEC Token**
1. **Login to Splunk** at `http://localhost:8000`
2. **Go to Settings → Data Inputs**
3. **Enable HTTP Event Collector (HEC)**
4. **Create a New Token**
   - **Name:** `docker_logs`
   - **Source Type:** `_json`
   - **Index:** `main`
   - **Copy the generated token** (used in the Docker configuration)

---

## **📌 2️⃣ Configure Docker to Use Splunk Logging Driver**
### **🔹 Step 1: Modify Docker Daemon Configuration**
Edit Docker’s **daemon.json** file:
```sh
sudo nano /etc/docker/daemon.json
```
Add the following configuration:
```json
{
  "log-driver": "splunk",
  "log-opts": {
    "splunk-token": "<your_splunk_token>",
    "splunk-url": "http://localhost:8088",
    "splunk-insecureskipverify": "true",
    "splunk-index": "main",
    "splunk-source": "docker-logs",
    "splunk-sourcetype": "_json"
  }
}
```
Save and exit (`CTRL + X`, `Y`, `ENTER`).

---

### **🔹 Step 2: Restart Docker**
```sh
sudo systemctl restart docker
```

---

## **📌 3️⃣ Test Docker Logging with Splunk**
### **🔹 Step 1: Run a Container with Splunk Logging**
```sh
docker run --log-driver=splunk \
  --log-opt splunk-token="<your_splunk_token>" \
  --log-opt splunk-url="http://localhost:8088" \
  --log-opt splunk-index="main" \
  --log-opt splunk-source="docker-logs" \
  --log-opt splunk-sourcetype="_json" \
  alpine echo "Hello, Splunk Logging!"
```
✔ This **sends logs** to **Splunk’s HTTP Event Collector (HEC)**.

---

### **🔹 Step 2: Verify Logs in Splunk**
1. **Login to Splunk (`http://localhost:8000`)**
2. **Go to Search & Reporting**
3. **Run the search query:**
   ```splunk
   index=main sourcetype=_json source=docker-logs
   ```
4. **See the logs appear in real-time**!

---

## **📌 4️⃣ Verify the Logging Driver**
Check the **configured logging driver**:
```sh
docker info | grep "Logging Driver"
```
✔ Expected Output:
```
Logging Driver: splunk
```

---

## **✅ Summary: Configuring Splunk as Docker's Logging Driver**
| **Task** | **Command/Action** |
|----------|--------------------|
| **Install Splunk** | `docker run -d --name splunk -p 8000:8000 -p 8088:8088 splunk/splunk:latest` |
| **Create Splunk HEC Token** | **Splunk UI → Settings → Data Inputs → HTTP Event Collector** |
| **Modify Docker Logging Config** | Edit `/etc/docker/daemon.json` |
| **Restart Docker** | `sudo systemctl restart docker` |
| **Run a Container with Splunk Logging** | `docker run --log-driver=splunk --log-opt ...` |
| **Verify Logs in Splunk** | `index=main sourcetype=_json source=docker-logs` |

---
This setup **integrates Docker logs with Splunk** for **real-time monitoring**! 🚀🔥  

### **🔹 Fixing Issues with Splunk Docker Installation on Mac M1/M2 (ARM64)** 🚀  

You're facing **two main issues**:  
1️⃣ **Docker scan plugin error** → This warning is not critical, but you can remove the plugin.  
2️⃣ **Splunk image issue (`no matching manifest for linux/arm64/v8`)** → This happens because Splunk does not have a native ARM64 version.

---

## **📌 1️⃣ Fixing the Docker Scan Plugin Issue**
### **🔹 Remove the invalid plugin**
```sh
rm -rf ~/.docker/cli-plugins/docker-scan
```
✔ This will **remove the invalid scan plugin**.

---

## **📌 2️⃣ Running Splunk on Mac M1/M2 (ARM64)**
### **🔹 Step 1: Pull the Correct Splunk Image**
Splunk **does not support ARM64**, so we must run it using **platform emulation**.

```sh
docker run --platform linux/amd64 -d --name splunk \
  -p 8000:8000 -p 8088:8088 -p 9997:9997 \
  -e "SPLUNK_START_ARGS=--accept-license" \
  -e "SPLUNK_PASSWORD=changeme" \
  splunk/splunk:latest
```
✔ This forces **Docker to run the AMD64 version** on an ARM-based Mac.

### **🔹 Step 2: Verify Splunk is Running**
```sh
docker ps
```
✔ Check if the Splunk container is **up and running**.

### **🔹 Step 3: Open Splunk**
Go to **`http://localhost:8000`** and log in using:  
- **Username:** `admin`  
- **Password:** `changeme`

---

## **📌 3️⃣ Configure Splunk as Docker's Logging Driver**
Since **macOS uses Docker Desktop (a virtualized environment)**, `daemon.json` is not directly available. Instead, use this command:

```sh
docker run --log-driver=splunk \
  --log-opt splunk-token="<your_splunk_token>" \
  --log-opt splunk-url="http://localhost:8088" \
  --log-opt splunk-insecureskipverify="true" \
  --log-opt splunk-index="main" \
  alpine echo "Hello, Splunk Logging!"
```

---

## **✅ Summary of Fixes**
| **Issue** | **Fix** |
|-----------|--------|
| **Docker Scan Plugin Error** | `rm -rf ~/.docker/cli-plugins/docker-scan` |
| **Splunk Image Not Found for ARM64** | Use `--platform linux/amd64` when running Splunk |
| **Verify Running Containers** | `docker ps` |
| **Access Splunk UI** | `http://localhost:8000` |

---
This setup **fixes your Mac M1/M2 compatibility issues** and enables **Docker logging with Splunk**! 🚀🔥  

### **🔹 Check if the Splunk Container is Running** 🚀  

After running the Splunk container, you can verify its status using **Docker commands**.

---

## **📌 1️⃣ Check Running Containers**
Run the following command:
```sh
docker ps | grep splunk
```
✔ This will show if the **Splunk container is running**.

### **🔹 Expected Output (If Running)**
```
CONTAINER ID   IMAGE               STATUS        PORTS
abcdef123456   splunk/splunk:latest Up 2 minutes 0.0.0.0:8000->8000/tcp
```
✔ If you see **"Up X minutes"**, Splunk is **running correctly**.

---

## **📌 2️⃣ Check Splunk Logs**
If the container is **not running**, check logs for issues:
```sh
docker logs splunk
```
✔ Look for errors like:
- License not accepted → **Fix by adding `--accept-license`**
- Authentication issues → **Check `SPLUNK_PASSWORD`**
- Port conflicts → **Ensure ports `8000`, `8088`, `9997` are free**

---

## **📌 3️⃣ Check Container Status Even if Stopped**
If Splunk is **not running**, check stopped containers:
```sh
docker ps -a | grep splunk
```
✔ If you see **"Exited"**, the container crashed.

### **🔹 Restart Splunk**
```sh
docker start splunk
```

---

## **📌 4️⃣ Check if Splunk Web UI is Accessible**
Open:
```
http://localhost:8000
```
✔ **Default Login Credentials**:
- **Username:** `admin`
- **Password:** `changeme` (or the password you set)

---

## **✅ Summary: Checking if Splunk is Running**
| **Check** | **Command** |
|-----------|------------|
| **List running containers** | `docker ps | grep splunk` |
| **Check Splunk logs** | `docker logs splunk` |
| **Check stopped containers** | `docker ps -a | grep splunk` |
| **Restart Splunk** | `docker start splunk` |
| **Access Splunk Web UI** | `http://localhost:8000` |

---
If Splunk is **not running**, let me know what error you see! 🚀🔥