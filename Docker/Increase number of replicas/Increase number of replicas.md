### **🔹 Increase the Number of Replicas for the Spring Boot Service in Docker Swarm**
Scaling up the number of replicas ensures **higher availability** and **load balancing** of your Spring Boot application in Docker Swarm.

---

## **📌 1️⃣ Scale the Service Using `docker service scale`**
To increase the number of replicas for the `demo` service:
```sh
docker service scale demo_demo=5
```
- This scales the `demo` service to **5 replicas**.

### **🔍 Verify Scaling**
Check if the replicas have been created:
```sh
docker service ps demo_demo
```
- You should see **5 running instances** of `demo_demo`.

---

## **📌 2️⃣ Scale Up via `docker-compose.yml`**
You can also **modify the stack file** to set a higher replica count.

### **Updated `docker-compose.yml`**
```yaml
version: "3.8"

services:
  demo:
    image: demo:latest
    build: .
    ports:
      - "9090:8080"
    deploy:
      replicas: 5  # Increased replicas from 3 to 5
      restart_policy:
        condition: on-failure
```

After updating, apply the changes by running:
```sh
docker stack deploy -c docker-compose.yml demo
```
- This redeploys the stack with **5 replicas**.

---

## **📌 3️⃣ Monitor Load Balancing**
Each request should now be **handled by different replicas**.

Run:
```sh
for i in {1..10}; do curl http://localhost:9090/api/hello; sleep 1; done
```
- You will see requests distributed across different instances.

---

## **📌 4️⃣ Reduce the Number of Replicas**
If you need to **scale down** the service, run:
```sh
docker service scale demo_demo=2
```
- This reduces the replicas to **2**, removing extra instances.

---

## **✅ Summary**
| **Task** | **Command** |
|----------|------------|
| Scale Up to 5 Replicas | `docker service scale demo_demo=5` |
| Check Running Instances | `docker service ps demo_demo` |
| Update Stack File | Modify `docker-compose.yml` and `docker stack deploy -c docker-compose.yml demo` |
| Reduce Replicas to 2 | `docker service scale demo_demo=2` |

Would you like to **automate scaling** based on CPU usage? 🚀