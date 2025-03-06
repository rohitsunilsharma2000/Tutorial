### **🔹 Deploying and Orchestrating a Spring Boot App in Docker Swarm with Networks & Published Ports** 🚀

This guide extends the **Spring Boot Swarm deployment** by:
✅ **Adding networks** for better communication  
✅ **Publishing ports** for external access  
✅ **Scaling and updating the service dynamically**  

---

## **📌 1️⃣ Updated `Dockerfile`**
```dockerfile
# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the built JAR file into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080 inside the container
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## **📌 2️⃣ Updated `docker-compose.yml` (With Networks & Published Ports)**
```yaml
version: "3.8"

networks:
  demo-net:
    driver: overlay  # Enable multi-node communication in Swarm

services:
  demo:
    image: demo:latest
    build: .
    networks:
      - demo-net  # Attach service to the custom network
    ports:
      - "9090:8080"  # Exposing on host port 9090, mapping to container's 8080
    deploy:
      replicas: 3  # Running 3 instances
      restart_policy:
        condition: on-failure
```
- **Added `demo-net` network** → Ensures **isolated** communication within Swarm.  
- **Published port `9090`** → Maps **external traffic to the container’s `8080`**.  

---

## **🚀 3️⃣ Build and Deploy the Stack**
### **Step 1: Build the JAR**
```sh
mvn clean package
```
- This compiles and packages the application into a JAR file.

### **Step 2: Build and Tag the Docker Image**
```sh
docker build -t demo .
```

### **Step 3: Initialize Docker Swarm (If not already initialized)**
```sh
docker swarm init
```
- Initializes Swarm mode if it’s not already running.

### **Step 4: Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml demo
```
- Deploys the **Spring Boot app** as a **Swarm stack**.

---

## **📌 4️⃣ Verify and Test the Deployment**
### **Check Running Services**
```sh
docker stack services demo
```

### **Check Running Containers**
```sh
docker ps
```

### **Test the API Endpoint**
Run:
```sh
curl http://localhost:9090/api/hello
```
**Expected Output:**
```
Hello from Spring Boot running in Swarm!
```

---

## **📌 5️⃣ Scaling the Service**
To increase the number of replicas dynamically:
```sh
docker service scale demo_demo=5
```
- This scales the `demo` service to **5 replicas**.

### **Verify Scaling**
```sh
docker service ps demo_demo
```
- Confirms **all replicas** are running.

---

## **📌 6️⃣ Updating the Service**
### **🔹 Solution 1: Use `--force` to Trigger Update**
If Swarm does not detect changes, force a restart:
```sh
docker service update --force demo_demo
```

### **🔹 Solution 2: Update Image with Registry**
1. **Rebuild the Image**
   ```sh
   docker build -t demo:v2 .
   ```
2. **Push to a Local Registry**
   ```sh
   docker tag demo:v2 localhost:5000/demo
   docker push localhost:5000/demo
   ```
3. **Update the Service**
   ```sh
   docker service update --image localhost:5000/demo demo_demo
   ```

---

## **📌 7️⃣ Viewing Logs**
To monitor logs:
```sh
docker service logs -f demo_demo
```
- Shows **real-time logs** for debugging.

---

## **📌 8️⃣ Removing the Stack**
To stop and clean up:
```sh
docker stack rm demo
```
- Removes **all services** from the Swarm.

To leave Swarm mode:
```sh
docker swarm leave --force
```

---

## **✅ Summary of Orchestration Activities**
| **Orchestration Activity** | **Command** |
|---------------------------|-------------|
| **Service Deployment** | `docker stack deploy -c docker-compose.yml demo` |
| **Scaling Services** | `docker service scale demo_demo=5` |
| **Load Balancing** | `curl http://localhost:9090/api/hello` |
| **Rolling Updates** | `docker service update --image demo:v2 demo_demo` |
| **Health Monitoring** | `docker service ps demo_demo` |
| **Self-Healing** | Swarm **auto-restarts failed containers** |
| **Service Discovery** | `docker network inspect demo-net` |
| **Rollback** | `docker service rollback demo_demo` |

---
Your Spring Boot app is now **fully orchestrated in Docker Swarm** with **networking, scaling, and updates**. 🚀🔥  

Would you like to **add a database (PostgreSQL/MySQL)** to this setup? 😊