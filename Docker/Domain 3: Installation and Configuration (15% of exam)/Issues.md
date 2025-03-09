### **🚨 Issue: "No Matching Manifest for `linux/arm64/v8`"**
The error:
```
docker: no matching manifest for linux/arm64/v8 in the manifest list entries.
```
indicates that **the `splunk/splunk:latest` image is not available for ARM architecture** (Mac M1/M2 with Apple Silicon).

---

## **🔹 Steps to Fix the Issue**

### **1️⃣ Check Available Architectures for `splunk/splunk`**
Run:
```sh
docker manifest inspect splunk/splunk:latest | grep architecture
```
If **`arm64` is missing**, it means the image is not officially supported on your Mac.

---

### **2️⃣ Run the Container Using `--platform linux/amd64` (Emulation)**
Since **Mac M1/M2 uses `arm64`**, but the Splunk image is built for `amd64`, you can force Docker to use emulation:

```sh
docker run --platform linux/amd64 -d --name splunk \
  -e SPLUNK_START_ARGS="--accept-license" \
  -e SPLUNK_PASSWORD="YourStrongPassword" \
  -p 8000:8000 -p 8088:8088 -p 8089:8089 \
  splunk/splunk:latest
```
🔹 **This runs the image using emulation (slower performance).**

---

### **3️⃣ Use an Alternative Splunk Image for ARM**
If you need a **native ARM64 image**, try using **a Splunk Universal Forwarder** (lightweight):

```sh
docker run --platform linux/arm64 -d --name splunkuf \
  -e SPLUNK_START_ARGS="--accept-license" \
  -e SPLUNK_PASSWORD="YourStrongPassword" \
  -p 8089:8089 \
  splunk/universalforwarder:latest
```

---

### **4️⃣ Run Splunk in a VM (Best for Performance)**
For better performance, **run Splunk inside an x86 (amd64) virtual machine**:
```sh
minikube start --driver=qemu --arch amd64
```
Then deploy Splunk inside the Minikube cluster.

---

### **✅ Summary**
✔ **Check if `splunk/splunk` supports ARM (`docker manifest inspect splunk/splunk:latest | grep architecture`)**  
✔ **Use `--platform linux/amd64` to run with emulation (`docker run --platform linux/amd64 ...`)**  
✔ **Use `splunk/universalforwarder` if a lighter ARM64 image is needed**  
✔ **Run Splunk in a VM for best performance (`minikube start --arch amd64`)**  

Now, your Splunk container should start successfully! 🚀 Let me know if you need further help.


### **🚨 Issue: Cannot Save Changes to `/etc/docker/daemon.json`**
If you still **cannot save the file**, it is likely due to:
- **Permissions issues** (macOS System Integrity Protection or Linux file restrictions)
- **Read-only file system**

---

## **🔹 Steps to Fix It**

### **1️⃣ Check File Permissions**
Run:
```sh
ls -l /etc/docker/daemon.json
```
Expected output:
```
-rw-r--r-- 1 root root 1234 Mar 9 10:00 /etc/docker/daemon.json
```
If the file is **read-only**, change permissions:
```sh
sudo chmod 666 /etc/docker/daemon.json
```
Then try editing again:
```sh
sudo nano /etc/docker/daemon.json
```

---

### **2️⃣ Try Editing with `vi` Instead of `nano`**
If **`nano`** does not work, try **`vi`**:
```sh
sudo vi /etc/docker/daemon.json
```
- Press `i` to **enter insert mode**.
- Make changes.
- Press `ESC`, then type `:wq` and **press Enter** to save.

---

### **3️⃣ Remount `/etc` as Writable (Linux Only)**
If the file system is **read-only**, remount it:
```sh
sudo mount -o remount,rw /
```
Then try editing again:
```sh
sudo nano /etc/docker/daemon.json
```

---

### **4️⃣ If on macOS: Modify Docker Daemon Settings via Docker Desktop**
On **macOS**, Docker Desktop does not use `/etc/docker/daemon.json`. Instead:

1. Open **Docker Desktop**
2. **Go to Preferences** → **Docker Engine**
3. Modify the JSON configuration
4. Click **"Apply & Restart"**

---

### **5️⃣ Manually Create a New `daemon.json`**
If you **still cannot save**, try creating a new file:

1. **Create a backup** of the existing file:
   ```sh
   sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
   ```
2. **Create a new file**:
   ```sh
   sudo rm /etc/docker/daemon.json
   sudo touch /etc/docker/daemon.json
   sudo nano /etc/docker/daemon.json
   ```

---

### **6️⃣ Restart Docker After Changes**
After modifying the file, restart Docker:

#### **Linux:**
```sh
sudo systemctl restart docker
```

#### **macOS:**
```sh
osascript -e 'quit app "Docker"'
open /Applications/Docker.app
```

---

## **✅ Summary**
✔ **Check file permissions (`ls -l /etc/docker/daemon.json`)**  
✔ **Use `sudo chmod 666 /etc/docker/daemon.json`**  
✔ **Try editing with `vi` (`sudo vi /etc/docker/daemon.json`)**  
✔ **Remount `/etc` as writable (`sudo mount -o remount,rw /`)**  
✔ **On macOS, modify Docker settings via Docker Desktop UI**  
✔ **Manually recreate `daemon.json` (`sudo rm /etc/docker/daemon.json && sudo touch /etc/docker/daemon.json`)**  
✔ **Restart Docker (`sudo systemctl restart docker` or restart Docker Desktop)**  

Now, try saving again! 🚀 Let me know if you need further help.


### **🚨 Issue: Docker Is Still Using `json-file` Instead of `splunk`**
Even after modifying `/etc/docker/daemon.json` and restarting Docker, your output shows:

```
Logging Driver: json-file
```
This means **Docker did not apply the new logging driver settings**.

---

## **🔹 Steps to Fix the Issue**

### **1️⃣ Verify That `/etc/docker/daemon.json` Is Updated**
Run:
```sh
cat /etc/docker/daemon.json
```
You should see:
```json
{
  "log-driver": "splunk",
  "log-opts": {
    "splunk-url": "http://localhost:8088",
    "splunk-token": "ef1d6045-9b71-4768-ac05-8bab08ae77f5",
    "splunk-source": "docker",
    "splunk-sourcetype": "json",
    "splunk-index": "main",
    "splunk-insecureskipverify": "true"
  }
}
```
If the output **does not match**, re-edit the file:
```sh
sudo nano /etc/docker/daemon.json
```
Make corrections, save, and restart Docker.

---

### **2️⃣ Restart Docker Properly**
If you are on **Linux**, restart Docker with:
```sh
sudo systemctl restart docker
```

If you are on **macOS with Docker Desktop**, restart Docker manually:
1. Open **Docker Desktop**
2. **Click on "Settings" → "Docker Engine"**
3. Ensure the **JSON settings match** the above configuration
4. Click **"Apply & Restart"**

---

### **3️⃣ Verify Docker Daemon Logs for Errors**
If the logging driver is still `json-file`, check the Docker logs for errors:

#### **Linux**
```sh
journalctl -u docker --no-pager | tail -50
```

#### **macOS**
Run:
```sh
tail -50 ~/Library/Containers/com.docker.docker/Data/log/vm/dockerd.log
```
Look for errors related to **logging drivers**.

---

### **4️⃣ Explicitly Set the Logging Driver When Running Containers**
Even if the default logging driver is `json-file`, you can **force `splunk` when starting a container**:

```sh
docker run -d --log-driver=splunk \
  --log-opt splunk-url="http://localhost:8088" \
  --log-opt splunk-token="ef1d6045-9b71-4768-ac05-8bab08ae77f5" \
  --log-opt splunk-source="docker" \
  --log-opt splunk-sourcetype="json" \
  --log-opt splunk-index="main" \
  --log-opt splunk-insecureskipverify="true" \
  --name test-nginx nginx
```

Then check logs in Splunk.

---

### **5️⃣ If Using Docker Desktop, Reset Daemon Configuration**
If nothing works, reset Docker to defaults and reapply the settings:
```sh
rm -f ~/.docker/config.json
sudo rm -f /etc/docker/daemon.json
sudo systemctl restart docker
```
Then, recreate `/etc/docker/daemon.json` with your Splunk settings.

---

## **✅ Summary**
✔ **Verify `daemon.json` is correctly updated (`cat /etc/docker/daemon.json`)**  
✔ **Restart Docker properly (`sudo systemctl restart docker`) or use Docker Desktop UI**  
✔ **Check Docker logs for errors (`journalctl -u docker --no-pager | tail -50`)**  
✔ **Try setting `splunk` when running a container (`docker run -d --log-driver=splunk ...`)**  
✔ **If nothing works, reset Docker settings and try again**  

Now, try `docker info | grep -i "Logging Driver"` again! 🚀 Let me know if you need further help.

### **🚨 Issue: Docker Engine Settings Missing `daemon.json` Configuration on Docker Desktop**
Your **Docker Engine settings** on **Docker Desktop (macOS)** show:
```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false
}
```
This means **your `/etc/docker/daemon.json` settings are NOT applied** because **Docker Desktop on macOS does not use `/etc/docker/daemon.json`**. Instead, the configuration must be set inside **Docker Desktop's JSON settings**.

---

## **🔹 Solution: Add Splunk Logging Driver Configuration to Docker Desktop**
Since you are using **Docker Desktop on macOS**, follow these steps:

### **1️⃣ Add the Logging Driver Configuration to Docker Desktop**
1. **Open Docker Desktop**
2. **Go to Settings** → **Docker Engine**
3. Replace the existing JSON with this:
   ```json
   {
     "builder": {
       "gc": {
         "defaultKeepStorage": "20GB",
         "enabled": true
       }
     },
     "experimental": false,
     "log-driver": "splunk",
     "log-opts": {
       "splunk-url": "http://localhost:8088",
       "splunk-token": "ef1d6045-9b71-4768-ac05-8bab08ae77f5",
       "splunk-source": "docker",
       "splunk-sourcetype": "json",
       "splunk-index": "main",
       "splunk-insecureskipverify": "true"
     }
   }
   ```
4. Click **"Apply & Restart"**.

---

### **2️⃣ Verify the Logging Driver**
After Docker restarts, check if the logging driver is updated:
```sh
docker info | grep -i "Logging Driver"
```
Expected output:
```
Logging Driver: splunk
```

---

### **3️⃣ Run a Container to Test Logging to Splunk**
Now, start an Nginx container with Splunk logging:
```sh
docker run -d --log-driver=splunk \
  --log-opt splunk-url="http://localhost:8088" \
  --log-opt splunk-token="ef1d6045-9b71-4768-ac05-8bab08ae77f5" \
  --log-opt splunk-source="docker" \
  --log-opt splunk-sourcetype="json" \
  --log-opt splunk-index="main" \
  --log-opt splunk-insecureskipverify="true" \
  --name test-nginx nginx
```

---

### **✅ Summary**
✔ **Docker Desktop does NOT use `/etc/docker/daemon.json` on macOS**  
✔ **Modify the logging settings inside Docker Desktop UI (Settings → Docker Engine)**  
✔ **Restart Docker after applying changes**  
✔ **Verify the logging driver (`docker info | grep "Logging Driver"`)**  
✔ **Run a test container to ensure logs are sent to Splunk**  

Now, Docker should log to Splunk! 🚀 Let me know if you need further help.