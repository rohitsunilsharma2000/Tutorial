### **🔹 Running Replicated vs. Global Services in Docker Swarm for a Spring Boot App** 🚀  

Docker Swarm offers two **service deployment modes**:  
1. **Replicated Mode** → Runs a **specified number of replicas** across available nodes.  
2. **Global Mode** → Runs **one instance per node** in the Swarm cluster.  

---

## **📌 1️⃣ Updated `docker-compose.yml` for Replicated & Global Mode**
We’ll configure:
- **`demo-replicated`** → Runs 3 replicas.
- **`demo-global`** → Runs 1 instance **on every node**.

```yaml
version: "3.8"

networks:
  demo-net:
    driver: overlay  # Overlay network for Swarm communication

services:
  demo-replicated:
    image: demo:latest
    build: .
    networks:
      - demo-net
    ports:
      - "9090:8080"  # Map host 9090 to container 8080
    deploy:
      mode: replicated  # Runs multiple instances
      replicas: 3
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == worker  # Only deploy replicas on worker nodes

  demo-global:
    image: demo:latest
    networks:
      - demo-net
    ports:
      - "9191:8080"  # Separate port to avoid conflicts
    deploy:
      mode: global  # Runs exactly one instance on each node
      restart_policy:
        condition: on-failure
```

---

## **🚀 2️⃣ Build and Deploy the Stack**
### **Step 1: Build the JAR**
```sh
mvn clean package
```

### **Step 2: Build and Tag the Docker Image**
```sh
docker build -t demo .
```

### **Step 3: Initialize Docker Swarm**
If Swarm is not initialized:
```sh
docker swarm init
```

### **Step 4: Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml demo
```
- This deploys **both replicated and global services**.

---

## **📌 3️⃣ Verify Running Services**
### **Check Service List**
```sh
docker stack services demo
```
**Expected Output:**
```
ID          NAME             MODE        REPLICAS  IMAGE
abcd1234    demo-replicated  replicated  3/3       demo:latest
efgh5678    demo-global      global      2/2       demo:latest
```
- `demo-replicated` runs **3 replicas**.
- `demo-global` runs **on every node**.

### **Check Running Tasks**
```sh
docker service ps demo-replicated
docker service ps demo-global
```
- Lists each instance and its assigned node.

---

## **📌 4️⃣ Test the Services**
### **Replicated Mode**
```sh
curl http://localhost:9090/api/hello
```
- The request will be **load-balanced** across **3 instances**.

### **Global Mode**
```sh
curl http://localhost:9191/api/hello
```
- The request hits **one instance per node**.

---

## **📌 5️⃣ Scaling the Replicated Service**
To increase the number of replicas:
```sh
docker service scale demo_replicated=5
```
- Now, **5 instances** of `demo-replicated` will be running.

To check:
```sh
docker service ps demo-replicated
```

---

## **📌 6️⃣ Updating the Service**
If you make code changes, **update the running services**:
```sh
mvn clean package
docker build -t demo:v2 .
docker service update --image demo:v2 demo-replicated
docker service update --image demo:v2 demo-global
```
- This updates both **replicated** and **global** services **without downtime**.

---

## **📌 7️⃣ Viewing Logs**
To monitor logs:
```sh
docker service logs -f demo-replicated
docker service logs -f demo-global
```

---

## **📌 8️⃣ Removing the Stack**
To stop and clean up:
```sh
docker stack rm demo
docker swarm leave --force
```

---

## **✅ Summary: Replicated vs. Global Mode**
| **Feature** | **Replicated Mode** | **Global Mode** |
|------------|------------------|--------------|
| **Definition** | Runs **N replicas** across nodes | Runs **one instance per node** |
| **Example Use Case** | Scalable web servers, microservices | Log collectors, monitoring agents |
| **Scaling** | **Manually set replicas** (`docker service scale`) | **One per node**, automatically managed |
| **Load Balancing** | Yes | No (Each node handles requests) |
| **Example Service** | `demo-replicated` | `demo-global` |

---
This **demonstrates both Replicated & Global services** for your **Spring Boot App**! 🚀🔥  

Would you like to integrate **database storage or a message queue** for a real-world microservice? 😊