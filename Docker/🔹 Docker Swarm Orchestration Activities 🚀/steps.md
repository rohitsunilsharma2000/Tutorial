### **🔹 Orchestrating the Spring Boot Application in Docker Swarm**
This section demonstrates how to perform **orchestration activities** for the **Spring Boot application** deployed in Docker Swarm.

| **Orchestration Activity**  | **Command & Description** |
|-----------------------------|--------------------------|
| **Service Deployment** | `docker stack deploy -c docker-compose.yml demo` → Deploys the Spring Boot app and runs it across multiple nodes. |
| **Scaling Services** | `docker service scale demo_demo=5` → Increases the number of replicas for the `demo` service. |
| **Load Balancing** | Swarm automatically distributes traffic across replicas when accessed via `curl http://localhost:9090/api/hello`. |
| **Rolling Updates** | `docker service update --image demo:v2 demo_demo` → Updates the service to a newer version **without downtime**. |
| **Health Monitoring** | `docker service ps demo_demo` → Lists service status and **restarts failed tasks automatically**. |
| **Self-Healing** | If a container crashes, Swarm automatically **reschedules it on a healthy node**. |
| **Service Discovery** | The service is reachable via `http://demo_demo:8080/api/hello` from other containers in the Swarm network. |
| **Rollback** | `docker service rollback demo_demo` → Reverts to the previous working version if an update fails. |

---

## **📌 1️⃣ Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml demo
```
- Deploys the **Spring Boot app** with **3 replicas**.

---

## **📌 2️⃣ Scale the Service**
```sh
docker service scale demo_demo=5
```
- Runs **5 instances** of the application.

### **Check the Running Tasks**
```sh
docker service ps demo_demo
```
- Lists active replicas.

---

## **📌 3️⃣ Load Balancing**
Swarm **automatically distributes** traffic across replicas.

Test with:
```sh
curl http://localhost:9090/api/hello
```
Each request is **handled by different replicas**, proving load balancing.

---

## **📌 4️⃣ Perform a Rolling Update**
After modifying the **Spring Boot app**:
1. **Rebuild the JAR**
   ```sh
   mvn clean package
   ```
2. **Rebuild the Docker Image**
   ```sh
   docker build -t demo:v2 .
   ```
3. **Update the Service**
   ```sh
   docker service update --image demo:v2 demo_demo
   ```

- Swarm **replaces old containers** **gradually** **without downtime**.

---

## **📌 5️⃣ Monitor Health and Logs**
### **View Service Status**
```sh
docker service ps demo_demo
```
- Shows if any replica **failed** and if Swarm is **recovering** it.

### **Follow Logs**
```sh
docker service logs -f demo_demo
```
- Monitors **real-time logs**.

---

## **📌 6️⃣ Simulate Failure & Observe Self-Healing**
1. **Kill a Running Container**
   ```sh
   docker ps | grep demo_demo
   docker rm -f <container_id>
   ```
2. **Check if Swarm Restarts It**
   ```sh
   docker service ps demo_demo
   ```
   - Swarm **automatically starts a new instance** to replace the terminated one.

---

## **📌 7️⃣ Perform a Rollback**
If an update **fails**, rollback to the previous version:
```sh
docker service rollback demo_demo
```
- The service **returns to the last working state**.

---

## **📌 8️⃣ Remove the Stack**
To clean up:
```sh
docker stack rm demo
```
- This **removes all services** from the Swarm.

---

### **✅ Summary**
| **Task** | **Command** |
|----------|------------|
| Deploy Stack | `docker stack deploy -c docker-compose.yml demo` |
| Scale Service | `docker service scale demo_demo=5` |
| Perform Rolling Update | `docker service update --image demo:v2 demo_demo` |
| Monitor Logs | `docker service logs -f demo_demo` |
| Check Service Health | `docker service ps demo_demo` |
| Simulate Failure | `docker rm -f <container_id>` |
| Perform Rollback | `docker service rollback demo_demo` |
| Remove Stack | `docker stack rm demo` |

---
This ensures **high availability, self-healing, and automated deployments** for your **Spring Boot microservice**! 🚀🔥

Would you like to **add PostgreSQL** or **Redis** for a more complex architecture? 😊