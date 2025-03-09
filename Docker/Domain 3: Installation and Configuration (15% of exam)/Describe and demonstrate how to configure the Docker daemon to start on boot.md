### **What is a Daemon?**
A **daemon** is a background process that runs continuously and performs tasks without direct user interaction. In Unix-like systems (Linux/macOS), daemons typically have names ending with **"d"**, like:
- `sshd` (Secure Shell Daemon)
- `httpd` (Apache HTTP Daemon)
- `dockerd` (Docker Daemon)

On **Windows**, the equivalent of a daemon is a **service**.

---

### **What is the Docker Daemon (`dockerd`)?**
The **Docker Daemon (`dockerd`)** is the core service that manages Docker containers. It:
- Listens for **Docker CLI/API requests**.
- Creates, runs, stops, and removes **containers**.
- Manages **images**, **volumes**, **networks**, and **plugins**.
- Handles **container orchestration** (e.g., Docker Swarm).

#### **Docker Daemon vs Docker CLI**
- **Docker CLI (`docker` command)**: A command-line tool that communicates with `dockerd`.
- **Docker Daemon (`dockerd`)**: The background process that executes the commands.

For example:
```bash
docker run -d nginx
```
This command asks `dockerd` to **pull the Nginx image, create a container, and run it in detached mode**.

---

### **How to Check if Docker Daemon is Running**
On **Linux/macOS**, use:
```bash
systemctl status docker
```
or
```bash
ps aux | grep dockerd
```

On **Windows**, check:
```powershell
Get-Service -Name "Docker Desktop Service"
```

---

### **How to Start/Stop the Docker Daemon**
#### **On Linux/macOS**
```bash
sudo systemctl start docker    # Start daemon
sudo systemctl stop docker     # Stop daemon
sudo systemctl restart docker  # Restart daemon
```

#### **On Windows**
1. Open **Docker Desktop**.
2. Click on **Start Docker**.

---

### **Customizing the Docker Daemon**
The Docker daemon settings are stored in **`/etc/docker/daemon.json`** (Linux/macOS) or **`C:\ProgramData\Docker\config\daemon.json`** (Windows).

Example of enabling debug mode:
```json
{
  "debug": true
}
```
Restart the daemon after changes:
```bash
sudo systemctl restart docker
```

---

### **Summary**
- A **daemon** is a background service that runs automatically.
- The **Docker daemon (`dockerd`)** manages containers and listens for commands from the Docker CLI.
- You can **check, start, stop, and configure** the Docker daemon using system commands.

### **Configuring Docker Daemon to Start on Boot (Mac, Linux, and Windows)**

To ensure that the **Docker daemon** starts automatically when the system boots, follow the instructions based on your operating system.

---

## **1. macOS (Docker Desktop)**
On macOS, Docker Desktop **does not run as a system daemon** but as an application.

### **Enable Docker to Start on Boot (GUI)**
1. Open **Docker Desktop**.
2. Click on **Settings** (⚙️).
3. Navigate to **General**.
4. Check the box **"Start Docker Desktop when you log in"**.
5. Restart your Mac to confirm that Docker starts automatically.

### **Enable Docker to Start on Boot (Terminal)**
For a command-line solution:
```bash
mkdir -p ~/Library/LaunchAgents
cat <<EOF > ~/Library/LaunchAgents/com.docker.launch.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.docker.launch</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/Docker.app/Contents/MacOS/Docker</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
launchctl load ~/Library/LaunchAgents/com.docker.launch.plist
```
This will configure Docker to start automatically.

---

## **2. Linux (Systemd)**
On most Linux distributions (Ubuntu, Debian, CentOS, etc.), Docker runs as a **systemd** service.

### **Enable Docker Daemon to Start on Boot**
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### **Verify Docker Status**
```bash
systemctl status docker
```

### **Restart Docker Manually (If Needed)**
```bash
sudo systemctl restart docker
```

### **Disable Docker from Starting on Boot**
If you ever want to disable automatic startup:
```bash
sudo systemctl disable docker
```

---

## **3. Windows (Docker Desktop)**
On Windows, Docker Desktop **runs as an application**, similar to macOS.

### **Enable Docker to Start on Boot (GUI)**
1. Open **Docker Desktop**.
2. Click on **Settings** (⚙️).
3. Navigate to **General**.
4. Enable **"Start Docker Desktop when you log in"**.
5. Restart your PC to verify.

### **Enable Docker via Windows Services (Alternative)**
1. Open **Run** (`Win + R`).
2. Type `services.msc` and press **Enter**.
3. Locate **Docker Desktop Service**.
4. Right-click → **Properties** → Set **Startup Type** to **Automatic**.
5. Click **OK** and restart your system.

---

## **4. Configure Docker Daemon Options (Optional)**
To modify the **Docker daemon configuration**, edit the **daemon.json** file.

### **On Linux/macOS**
```bash
sudo nano /etc/docker/daemon.json
```

Example configuration:
```json
{
  "log-driver": "json-file",
  "log-level": "warn",
  "storage-driver": "overlay2"
}
```
Save and restart Docker:
```bash
sudo systemctl restart docker
```

### **On Windows**
Modify the file:
```
C:\ProgramData\Docker\config\daemon.json
```
Then restart Docker Desktop.

---

## **Summary**
- **macOS**: Use **Docker Desktop settings** or a **launch agent**.
- **Linux**: Use `systemctl enable docker` for automatic startup.
- **Windows**: Enable startup in **Docker Desktop settings** or **Windows Services**.

