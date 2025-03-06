# **🔹 Docker Swarm Orchestration Activities** 🚀

## **🔹 What is Orchestration?**
Container orchestration automates the **deployment, scaling, networking, and management** of containerized applications across a cluster.  
Docker Swarm provides built-in orchestration features, making it easier to manage services.

---

## **🔹 Orchestration Activities in Docker Swarm**
| **Orchestration Activity**  | **Description** |
|--------------------------|------------------|
| **Service Deployment** | Running containerized applications across multiple nodes |
| **Scaling Services** | Adjusting the number of replicas dynamically |
| **Load Balancing** | Distributing traffic evenly across replicas |
| **Rolling Updates** | Updating applications **without downtime** |
| **Health Monitoring** | Automatically detecting and replacing failed tasks |
| **Self-Healing** | Restarting failed containers automatically |
| **Service Discovery** | Assigning unique names and internal networking to services |
| **Rollback** | Reverting to a previous working state if an update fails |

---

## **🔹 Step-by-Step Demonstration of Orchestration Activities**
### **📌 1️⃣ Initialize Docker Swarm**
First, ensure that Swarm mode is enabled:
```sh
docker swarm init
```
- This **creates a Swarm cluster** with a single manager node.

### **📌 2️⃣ Deploy a Flask + Redis Stack**
Create a `docker-compose.yml` file:
```yaml
version: "3.8"

services:
  flask-app:
    image: flask-redis-app:latest
    build: .
    ports:
      - "8080:8000"  # Using a different port
    depends_on:
      - redis
    environment:
      - REDIS_HOST=redis
    deploy:
      replicas: 3  # Running 3 instances
      restart_policy:
        condition: on-failure

  redis:
    image: redis:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
```
Deploy the application using:
```sh
docker stack deploy -c docker-compose.yml flask-stack
```
Verify that the services are running:
```sh
docker stack services flask-stack
```

---

## **🔹 Orchestration Activity Demonstrations**
### **📌 3️⃣ Scaling a Service**
Increase the number of Flask replicas dynamically:
```sh
docker service scale flask-stack_flask-app=5
```
- Swarm will automatically distribute new replicas across nodes.

Check if the scaling was successful:
```sh
docker service ps flask-stack_flask-app
```

---

### **📌 4️⃣ Load Balancing**
Swarm provides **automatic load balancing**. Test it by sending multiple requests:
```sh
for i in {1..10}; do curl http://localhost:8080; sleep 1; done
```
- You should see responses served from different replicas.

---

### **📌 5️⃣ Rolling Updates (Zero Downtime)**
Upgrade the Flask app by **pushing a new version**:
1. **Build and push the new image**:
   ```sh
   docker build -t myrepo/flask-redis-app:v2 .
   docker push myrepo/flask-redis-app:v2
   ```
2. **Update the service**:
   ```sh
   docker service update --image myrepo/flask-redis-app:v2 flask-stack_flask-app
   ```
3. **Check rolling updates progress**:
   ```sh
   docker service ps flask-stack_flask-app
   ```

---

### **📌 6️⃣ Self-Healing and Health Monitoring**
1. **Manually stop a running container**:
   ```sh
   docker ps  # Find the container ID
   docker kill <container_id>
   ```
2. **Swarm should detect and restart the container automatically**:
   ```sh
   docker service ps flask-stack_flask-app
   ```
3. **Check service logs**:
   ```sh
   docker service logs -f flask-stack_flask-app
   ```

---

### **📌 7️⃣ Rolling Back to a Previous Version**
If an update **breaks the app**, rollback to the last working version:
```sh
docker service rollback flask-stack_flask-app
```
- Swarm automatically restores the previous image.

---

### **📌 8️⃣ Service Discovery and Networking**
Each service can communicate using its **service name** instead of IP.  
1. **Access the Flask app inside a running container**:
   ```sh
   docker exec -it $(docker ps -q --filter "name=flask-app") sh
   ```
2. **Test Redis connection using the service name**:
   ```sh
   ping redis
   ```

---

### **📌 9️⃣ Removing a Stack**
To remove the running stack:
```sh
docker stack rm flask-stack
```
Leave Swarm mode:
```sh
docker swarm leave --force
```

---

## **✅ Summary of Key Commands**
| **Activity** | **Command** |
|-------------|------------|
| **Initialize Swarm** | `docker swarm init` |
| **Deploy a Stack** | `docker stack deploy -c docker-compose.yml flask-stack` |
| **Check Running Services** | `docker stack services flask-stack` |
| **Scale Up/Down** | `docker service scale flask-stack_flask-app=5` |
| **Rolling Update** | `docker service update --image myrepo/flask-redis-app:v2 flask-stack_flask-app` |
| **Rollback** | `docker service rollback flask-stack_flask-app` |
| **Monitor Logs** | `docker service logs -f flask-stack_flask-app` |
| **Kill a Container (Self-Healing Test)** | `docker kill <container_id>` |
| **Remove Stack** | `docker stack rm flask-stack` |

---

## **✅ Key Takeaways**
✔ **Scaling** services dynamically improves availability.  
✔ **Load balancing** distributes traffic across multiple replicas.  
✔ **Rolling updates** allow seamless application updates.  
✔ **Self-healing** ensures high availability.  
✔ **Rollback** helps restore stability after failed updates.  
✔ **Service discovery** enables easy inter-service communication.

Would you like a **real-world scenario**, such as running this setup in **AWS or Kubernetes**? 🚀