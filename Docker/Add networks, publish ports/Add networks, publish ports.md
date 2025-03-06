### **🔹 Enhancing Docker Swarm Deployment with Networks and Published Ports**
To improve the **Spring Boot** application's **networking and accessibility**, we will:
✅ **Define a custom network** for communication.  
✅ **Publish ports** to allow external access.  
✅ **Ensure proper service discovery** within Swarm.

---

## **📌 1️⃣ Updated `docker-compose.yml` with Networks & Published Ports**
Here’s the **updated** stack file:

```yaml
version: "3.8"

services:
  demo:
    image: demo:latest
    build: .
    networks:
      - demo-net  # Attach service to custom network
    ports:
      - "9090:8080"  # Publish container's 8080 port to host 9090
    deploy:
      replicas: 5  # Increased replicas
      restart_policy:
        condition: on-failure

networks:
  demo-net:
    driver: overlay  # Enables communication across multiple nodes
```

---

## **📌 2️⃣ Deploy the Updated Stack**
After updating `docker-compose.yml`, redeploy the stack:
```sh
docker stack deploy -c docker-compose.yml demo
```
This will:
✅ Create a custom network (`demo-net`).  
✅ Attach the `demo` service to `demo-net`.  
✅ Map **host port `9090`** to **container port `8080`**.  
✅ Deploy the service with **5 replicas**.

---

## **📌 3️⃣ Verify the Network**
Check if the network exists:
```sh
docker network ls
```
Look for `demo-net`.

Inspect the network details:
```sh
docker network inspect demo-net
```
It should show the connected **containers (replicas of `demo` service`).**

---

## **📌 4️⃣ Test the Application**
Run:
```sh
curl http://localhost:9090/api/hello
```
You should see:
```
Hello from Spring Boot running in Swarm!
```

---

## **📌 5️⃣ View Service Details**
Check published ports:
```sh
docker service ls
```
You should see:
```
ID            NAME        MODE        REPLICAS   IMAGE          PORTS
abcd1234      demo_demo   replicated  5/5        demo:latest    *:9090->8080/tcp
```
- **Host port `9090`** maps to **container `8080`**.

Check running instances:
```sh
docker service ps demo_demo
```

---

## **📌 6️⃣ Testing Network Communication**
To check service discovery **inside Swarm**, start an interactive shell in one of the containers:
```sh
docker exec -it $(docker ps | grep demo_demo | awk '{print $1}') sh
```
Now test internal communication:
```sh
curl http://demo:8080/api/hello
```
Since Swarm **automatically resolves service names**, this should return:
```
Hello from Spring Boot running in Swarm!
```

---

## **✅ Summary**
| **Task** | **Command** |
|----------|------------|
| Deploy Stack with Networking | `docker stack deploy -c docker-compose.yml demo` |
| List Networks | `docker network ls` |
| Inspect Network | `docker network inspect demo-net` |
| Verify Services | `docker service ls` |
| Check Running Instances | `docker service ps demo_demo` |
| Test External Access | `curl http://localhost:9090/api/hello` |
| Test Internal Access | `curl http://demo:8080/api/hello` from inside a container |

This setup ensures **better service isolation, communication, and accessibility**.  
Would you like to **add a database (PostgreSQL/MySQL) to this stack?** 🚀