### **🔹 Purpose of the Custom Network in Docker Swarm**
When deploying a **Spring Boot** application using Docker Swarm, defining a **custom overlay network** like `demo-net` serves several important purposes:

| **Feature**           | **Purpose in Swarm** |
|----------------------|--------------------|
| **Service Discovery** | Allows services to communicate using their **service names** instead of IP addresses (e.g., `demo` can reach `redis` using `http://redis:6379`). |
| **Multi-Node Communication** | Ensures seamless **inter-container networking across different Swarm nodes**. |
| **Container Isolation** | Prevents unintended access from **external services or containers** outside the network. |
| **Automatic Load Balancing** | Evenly distributes internal traffic among multiple **replicas** of a service. |
| **Simplifies Scaling** | New service instances **automatically join the network**, ensuring **zero reconfiguration needed**. |
| **External Port Exposure** | Publishes ports (`9090:8080`) for external access to services running inside the cluster. |

---

## **📌 How the Network Works in Swarm**
### **1️⃣ Without a Custom Network**
By default, Swarm services use `ingress` and `bridge` networks:
- Services on different nodes **cannot communicate directly**.
- Cannot resolve service names like `demo` or `redis`.
- Requires manually exposing ports for every service.

### **2️⃣ With a Custom Overlay Network**
```yaml
networks:
  demo-net:
    driver: overlay
```
- Services inside the network **can communicate securely**.
- **No need to expose ports for internal communication** (e.g., `demo` can talk to `redis` directly).

---

## **📌 Example: Internal & External Communication**
After deploying:
```sh
docker stack deploy -c docker-compose.yml demo
```

### **✔ External Communication**
- Access from the **host machine** using:
  ```sh
  curl http://localhost:9090/api/hello
  ```

### **✔ Internal Service-to-Service Communication**
- Inside the Swarm cluster:
  ```sh
  docker exec -it $(docker ps | grep demo_demo | awk '{print $1}') sh
  curl http://demo:8080/api/hello
  ```
- If you add **Redis**, the Flask app can connect using:
  ```sh
  redis-cli -h redis
  ```

---

## **✅ Key Benefits of Using a Custom Overlay Network**
| **Advantage** | **Without Overlay Network** | **With Overlay Network (`demo-net`)** |
|--------------|----------------|--------------------|
| **Cross-Node Communication** | ❌ No (limited to one host) | ✅ Yes (multi-node support) |
| **Service Discovery** | ❌ No (requires manual IPs) | ✅ Yes (use service names) |
| **Security** | ❌ Containers exposed publicly | ✅ Isolated services, no exposure unless specified |
| **Load Balancing** | ❌ Requires external tools | ✅ Built-in across replicas |

---

### **🚀 Next Steps**
Would you like to **extend this setup** by adding **PostgreSQL or Redis for stateful data management?** 😊