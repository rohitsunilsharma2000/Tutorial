### **🔹 Interpreting the Output of `docker inspect` Commands**
The `docker inspect` command retrieves detailed information about Docker **containers, images, networks, volumes, or services** in JSON format.

---

## **1️⃣ Inspect a Container**
```sh
docker inspect <container_id>
```
### **📌 Example Output**
```json
[
  {
    "Id": "d1cbaef456a4...",
    "Created": "2024-03-05T12:34:56.789Z",
    "Path": "nginx",
    "State": {
      "Status": "running",
      "Running": true,
      "Paused": false,
      "Restarting": false,
      "OOMKilled": false,
      "Dead": false,
      "Pid": 1234,
      "ExitCode": 0
    },
    "NetworkSettings": {
      "IPAddress": "172.17.0.2",
      "MacAddress": "02:42:ac:11:00:02",
      "Ports": {
        "80/tcp": [
          {
            "HostIp": "0.0.0.0",
            "HostPort": "8080"
          }
        ]
      }
    }
  }
]
```
### **🔍 Key Fields Explained**
| Field | Description |
|-------|------------|
| **Id** | Unique container ID |
| **Created** | Timestamp of when the container was created |
| **State.Status** | `running`, `exited`, or `paused` |
| **State.Running** | `true` if the container is currently running |
| **State.ExitCode** | Exit status (0 means success) |
| **NetworkSettings.IPAddress** | Internal container IP |
| **NetworkSettings.Ports** | Port mappings between the host and the container |

**✅ Interpretation:**  
- The container is running (`"Status": "running"`).  
- It is assigned the internal IP `172.17.0.2`.  
- The **host port `8080`** is mapped to **container port `80`**.

---

## **2️⃣ Inspect an Image**
```sh
docker inspect nginx
```
### **📌 Example Output**
```json
[
  {
    "Id": "sha256:9d1111...",
    "RepoTags": ["nginx:latest"],
    "Size": 14234567,
    "Architecture": "amd64",
    "Os": "linux",
    "Config": {
      "Cmd": ["nginx", "-g", "daemon off;"]
    }
  }
]
```
### **🔍 Key Fields**
| Field | Description |
|-------|------------|
| **Id** | Unique image ID (SHA256 hash) |
| **RepoTags** | Name and tag (e.g., `nginx:latest`) |
| **Size** | Image size in bytes |
| **Architecture** | CPU architecture (`amd64`, `arm64`, etc.) |
| **Cmd** | Default command when running a container from this image |

**✅ Interpretation:**  
- The `nginx` image is `14 MB` and uses the `amd64` architecture.  
- When run, it executes `nginx -g "daemon off;"`.

---

## **3️⃣ Inspect a Network**
```sh
docker network inspect bridge
```
### **📌 Example Output**
```json
[
  {
    "Name": "bridge",
    "Id": "12a34bc...",
    "Driver": "bridge",
    "IPAM": {
      "Config": [
        {
          "Subnet": "192.168.1.0/24",
          "Gateway": "192.168.1.1"
        }
      ]
    },
    "Containers": {
      "d1cbaef456a4": {
        "Name": "webserver",
        "IPv4Address": "192.168.1.100/24"
      }
    }
  }
]
```
### **🔍 Key Fields**
| Field | Description |
|-------|------------|
| **Name** | Network name (`bridge`, `host`, or custom) |
| **Driver** | Type of network (`bridge`, `overlay`, etc.) |
| **IPAM.Config.Subnet** | Subnet range for containers |
| **Containers** | List of containers connected to the network |

**✅ Interpretation:**  
- The network `bridge` is using the `192.168.1.0/24` subnet.  
- The container **`webserver`** has **IP `192.168.1.100`**.

---

## **4️⃣ Inspect a Swarm Service**
```sh
docker service inspect webserver
```
### **📌 Example Output**
```json
[
  {
    "ID": "zxy123...",
    "Spec": {
      "Name": "webserver",
      "Mode": {
        "Replicated": {
          "Replicas": 3
        }
      },
      "EndpointSpec": {
        "Ports": [
          {
            "PublishedPort": 8080,
            "TargetPort": 80
          }
        ]
      }
    }
  }
]
```
### **🔍 Key Fields**
| Field | Description |
|-------|------------|
| **ID** | Unique service ID |
| **Name** | Service name (`webserver`) |
| **Replicas** | Number of container instances (`3`) |
| **PublishedPort** | External port (`8080`) mapped to the container's `80` |

**✅ Interpretation:**  
- The `webserver` service runs **3 replicas**.  
- It exposes port **80** inside the container and maps it to **8080** on the host.

---

## **✅ Summary**
| Command | Purpose | Key Information Retrieved |
|---------|---------|---------------------------|
| `docker inspect <container>` | Inspect a container | State, IP, port mappings |
| `docker inspect <image>` | Inspect an image | Image ID, size, default command |
| `docker network inspect <network>` | Inspect a network | Subnet, connected containers |
| `docker service inspect <service>` | Inspect a Swarm service | Replicas, port mappings |

Would you like a **real-world troubleshooting example** using `docker inspect`? 🚀


To extract specific details from a **Docker container instance** using `docker inspect`, follow these queries. These commands will help you get an **IP address, MAC address, log path, image name, port bindings, specific port mapping, and subsections in JSON format**.

---

## **🔹 Setup: Pull Required Dependencies & Run a Test Container**
Before running `docker inspect`, ensure you have a running container.

1. **Pull the Nginx image** (if not already pulled):
   ```sh
   docker pull nginx
   ```
2. **Run a test container** (exposing ports):
   ```sh
   docker run -d --name mynginx -p 8080:80 nginx
   ```
3. **Verify the container is running**:
   ```sh
   docker ps
   ```
   - This should show a running **nginx** container with **ID**.

---

## **🔹 Extracting Specific Details Using `docker inspect`**
### **1️⃣ Get an Instance's IP Address**
```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mynginx
```
**Example Output:**
```
172.17.0.2
```
- This fetches the **internal IP address** assigned by Docker.

---

### **2️⃣ Get an Instance's MAC Address**
```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' mynginx
```
**Example Output:**
```
02:42:ac:11:00:02
```
- Useful for **network configurations and security auditing**.

---

### **3️⃣ Get an Instance's Log Path**
```sh
docker inspect -f '{{.LogPath}}' mynginx
```
**Example Output:**
```
/var/lib/docker/containers/12345abc/log.json
```
- This helps find logs if you need **troubleshooting**.

---

### **4️⃣ Get an Instance's Image Name**
```sh
docker inspect -f '{{.Config.Image}}' mynginx
```
**Example Output:**
```
nginx
```
- This shows which **image** was used to create the container.

---

### **5️⃣ List All Port Bindings**
```sh
docker inspect -f '{{json .NetworkSettings.Ports}}' mynginx | jq
```
**Example Output:**
```json
{
  "80/tcp": [
    {
      "HostIp": "0.0.0.0",
      "HostPort": "8080"
    }
  ]
}
```
- Displays all **host-container port mappings**.
- The port `8080` on the **host** is mapped to `80` inside the **container**.

---

### **6️⃣ Find a Specific Port Mapping**
To get the **host port mapped to container port 80**, run:
```sh
docker inspect -f '{{(index .NetworkSettings.Ports "80/tcp" 0).HostPort}}' mynginx
```
**Example Output:**
```
8080
```
- This extracts the **specific port mapping** for `80/tcp`.

---

### **7️⃣ Get a Subsection in JSON Format**
To get **detailed network settings in JSON**, run:
```sh
docker inspect mynginx --format '{{json .NetworkSettings}}' | jq
```
**Example Output (Formatted JSON):**
```json
{
  "Bridge": "",
  "SandboxID": "abcdef12345",
  "HairpinMode": false,
  "LinkLocalIPv6Address": "",
  "LinkLocalIPv6PrefixLen": 0,
  "Ports": {
    "80/tcp": [
      {
        "HostIp": "0.0.0.0",
        "HostPort": "8080"
      }
    ]
  },
  "IPAddress": "172.17.0.2",
  "MacAddress": "02:42:ac:11:00:02"
}
```
- **`jq`** formats JSON output for better readability.

---

## **✅ Summary of Commands**
| **Requirement** | **Command** |
|---------------|------------|
| **Get IP Address** | `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mynginx` |
| **Get MAC Address** | `docker inspect -f '{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' mynginx` |
| **Get Log Path** | `docker inspect -f '{{.LogPath}}' mynginx` |
| **Get Image Name** | `docker inspect -f '{{.Config.Image}}' mynginx` |
| **List All Port Bindings** | `docker inspect -f '{{json .NetworkSettings.Ports}}' mynginx | jq` |
| **Find Specific Port Mapping** | `docker inspect -f '{{(index .NetworkSettings.Ports "80/tcp" 0).HostPort}}' mynginx` |
| **Get Subsection in JSON** | `docker inspect mynginx --format '{{json .NetworkSettings}}' | jq` |

---

## **📌 Next Steps**
- **Want to test with multiple containers?** Try creating a Swarm cluster.
- **Want more structured output?** Use `jq` for JSON parsing.
- **Need logs for debugging?** Check the log path output.

Would you like help with **automating this using a script**? 🚀

### **🔹 How to Access Docker Container Logs**
There are two main ways to access container logs:

### **1️⃣ Using `docker logs` (Recommended)**
If your container is running, use the following command to **view real-time logs**:
```sh
docker logs mynginx
```
- To **follow logs live** (like `tail -f`):
  ```sh
  docker logs -f mynginx
  ```
- To see the **last 100 log lines**:
  ```sh
  docker logs --tail 100 mynginx
  ```
- To include **timestamps**:
  ```sh
  docker logs --timestamps mynginx
  ```

---

### **2️⃣ Access Logs via the Log File**
If you found the log file path using:
```sh
docker inspect -f '{{.LogPath}}' mynginx
```
Example Output:
```
/var/lib/docker/containers/12345abc/log.json
```
You can manually read it using:
```sh
cat /var/lib/docker/containers/12345abc/log.json
```
OR for **real-time updates**:
```sh
tail -f /var/lib/docker/containers/12345abc/log.json
```

**📌 Note:**  
- The logs are stored in **JSON format** by default.
- You may need **root permissions** to access the file:
  ```sh
  sudo cat /var/lib/docker/containers/12345abc/log.json
  ```

---

### **3️⃣ Pretty-Print JSON Logs (Optional)**
Since the log file is in JSON, you can format it for better readability using `jq`:
```sh
sudo cat /var/lib/docker/containers/12345abc/log.json | jq
```

---

### **4️⃣ Change Log Driver (Optional)**
Docker uses the **json-file** log driver by default.  
To check which log driver is being used:
```sh
docker inspect -f '{{.HostConfig.LogConfig.Type}}' mynginx
```
Example Output:
```
json-file
```
You can change it to **syslog**, **journald**, or **local** by modifying `docker run`:
```sh
docker run --log-driver=local -d --name mynginx nginx
```

---

## **✅ Summary**
| **Method** | **Command** | **Use Case** |
|------------|------------|--------------|
| View logs | `docker logs mynginx` | See logs in real-time |
| Follow logs | `docker logs -f mynginx` | Monitor logs live |
| Get log file path | `docker inspect -f '{{.LogPath}}' mynginx` | Find the log file location |
| Read log file | `cat /var/lib/docker/containers/12345abc/log.json` | Access logs manually |
| Live log file | `tail -f /var/lib/docker/containers/12345abc/log.json` | Watch log file updates |
| Pretty-print logs | `cat /var/lib/docker/containers/12345abc/log.json | jq` | Format JSON logs |

Would you like a **script** to automate this process? 🚀