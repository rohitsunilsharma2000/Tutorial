# **🔹 Using Templates with `docker service create` in Docker Swarm** 🚀  

**Templates** allow dynamic values in **Docker Swarm services**, making it possible to:
✅ Assign **unique container names** dynamically  
✅ Use **hostnames** based on the node name  
✅ Inject **environment variables dynamically**  
✅ Configure **volumes, logs, and labels** per container  

---

## **📌 1️⃣ What are Templates in Swarm?**
Templates in `docker service create` use **Go template syntax**, enabling dynamic values.  
Some commonly used **Swarm placeholders** include:

| **Placeholder** | **Description** | **Example Output** |
|---------------|----------------|--------------------|
| `{{.Service.Name}}` | Name of the service | `spring-boot-app` |
| `{{.Node.ID}}` | Node ID where the service runs | `abcdef12345` |
| `{{.Node.Hostname}}` | Hostname of the Swarm node | `worker-1` |
| `{{.Task.ID}}` | Unique ID of the task | `task-xyz789` |
| `{{.Task.Slot}}` | Slot number for replicas | `1, 2, 3...` |

---

## **📌 2️⃣ Example: Create a Spring Boot Service with Templates**
We’ll deploy a **Spring Boot service** in Swarm using templates for:
✔ **Dynamic container names**  
✔ **Unique log directories per task**  
✔ **Custom environment variables**  

### **Run the Command**
```sh
docker service create \
  --name demo \
  --replicas 3 \
  --network demo-net \
  --env SERVICE_NAME={{.Service.Name}} \
  --env NODE_NAME={{.Node.Hostname}} \
  --hostname "{{.Node.Hostname}}-{{.Task.Slot}}" \
  --mount type=volume,source=demo-logs-{{.Task.ID}},target=/app/logs \
  -p 9090:8080 \
  demo:latest
```

---

## **📌 3️⃣ Explanation of Templates in the Command**
| **Option** | **Template Used** | **Purpose** |
|------------|------------------|-------------|
| `--name demo` | `{{.Service.Name}}` | Dynamically injects the service name as `demo` |
| `--env NODE_NAME={{.Node.Hostname}}` | `{{.Node.Hostname}}` | Injects **Swarm node hostname** as an environment variable |
| `--hostname "{{.Node.Hostname}}-{{.Task.Slot}}"` | `{{.Node.Hostname}}-{{.Task.Slot}}` | Sets unique hostnames like `worker-1-1`, `worker-2-2` |
| `--mount type=volume,source=demo-logs-{{.Task.ID}},target=/app/logs` | `{{.Task.ID}}` | Creates a unique **volume per task** (`demo-logs-xyz789`) |

---

## **📌 4️⃣ Verify the Running Service**
### **Check Service Details**
```sh
docker service ps demo
```
**Expected Output:**
```
ID          NAME     IMAGE         NODE        DESIRED STATE
xyz12345    demo.1  demo:latest   worker-1    Running
abc67890    demo.2  demo:latest   worker-2    Running
def45678    demo.3  demo:latest   worker-3    Running
```

### **Verify Unique Hostnames**
```sh
docker ps --format "table {{.ID}}\t{{.Names}}"
```
**Expected Output:**
```
CONTAINER ID   NAMES
1234567890ab   worker-1-1
abcdef123456   worker-2-2
9876543210ab   worker-3-3
```
✅ **Each container has a unique hostname based on the node name and task slot.**

---

## **📌 5️⃣ Check Environment Variables Inside a Running Container**
First, get the container ID:
```sh
docker ps | grep demo
```
Then, inspect environment variables:
```sh
docker exec -it <container_id> env | grep NODE_NAME
```
**Expected Output:**
```
NODE_NAME=worker-1
```
✅ **Each container dynamically gets its node hostname**.

---

## **📌 6️⃣ Inspect Log Volumes**
List all created volumes:
```sh
docker volume ls | grep demo-logs
```
✅ Each task has a **unique log directory** (`demo-logs-xyz123`).

---

## **📌 7️⃣ Remove the Service**
```sh
docker service rm demo
```
✅ This removes **all running instances** of `demo`.

---

## **✅ Summary of `docker service create` with Templates**
| **Task** | **Command** |
|----------|------------|
| Deploy Service | `docker service create --name demo --replicas 3 demo:latest` |
| Use Templates for Hostnames | `--hostname "{{.Node.Hostname}}-{{.Task.Slot}}"` |
| Set Environment Variables | `--env NODE_NAME={{.Node.Hostname}}` |
| Create Unique Log Volumes | `--mount type=volume,source=demo-logs-{{.Task.ID}},target=/app/logs` |
| Check Running Services | `docker service ps demo` |
| View Container Names | `docker ps --format "table {{.ID}}\t{{.Names}}"` |
| Inspect Environment Variables | `docker exec -it <container_id> env | grep NODE_NAME` |
| Remove Service | `docker service rm demo` |

---
This **automates deployments dynamically** using templates! 🚀🔥  

Would you like to **add a database with dynamic volume mounts** next? 😊