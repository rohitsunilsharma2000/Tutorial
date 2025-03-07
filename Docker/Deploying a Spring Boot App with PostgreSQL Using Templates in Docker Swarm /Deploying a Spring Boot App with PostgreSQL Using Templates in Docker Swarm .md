### **🔹 Deploying a Spring Boot App with PostgreSQL Using Templates in Docker Swarm** 🚀  

We will extend the **Spring Boot + Docker Swarm** deployment by:  
✅ Adding **PostgreSQL as a database**  
✅ Using **dynamic volume mounts** for persistence  
✅ Applying **Swarm service templates**  

---

## **📌 1️⃣ Updated `docker-compose.yml` with PostgreSQL & Templates**
```yaml
version: "3.8"

networks:
  demo-net:
    driver: overlay

volumes:
  postgres-data:  # Persistent storage for PostgreSQL
  demo-logs:  # Persistent logs for Spring Boot

services:
  demo:
    image: demo:latest
    build: .
    networks:
      - demo-net
    environment:
      - SERVICE_NAME={{.Service.Name}}
      - NODE_NAME={{.Node.Hostname}}
      - DB_HOST=postgres
      - DB_USER=demo_user
      - DB_PASSWORD=demo_pass
      - DB_NAME=demo_db
    hostname: "{{.Node.Hostname}}-{{.Task.Slot}}"
    volumes:
      - demo-logs:/app/logs
    ports:
      - "9090:8080"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure

  postgres:
    image: postgres:latest
    networks:
      - demo-net
    environment:
      POSTGRES_USER: demo_user
      POSTGRES_PASSWORD: demo_pass
      POSTGRES_DB: demo_db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    deploy:
      mode: global  # Runs on every node
      restart_policy:
        condition: on-failure
```

### **🔹 What’s New?**
✔ **PostgreSQL database** with persistent storage (`postgres-data`).  
✔ **Environment variables** in Spring Boot dynamically pass database details.  
✔ **Swarm templates** for `SERVICE_NAME`, `NODE_NAME`, and unique hostnames.  

---

## **📌 2️⃣ Update `application.properties` for PostgreSQL**
Modify `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://${DB_HOST}:5432/${DB_NAME}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```
✔ **Uses environment variables from `docker-compose.yml`**.  

---

## **🚀 3️⃣ Build and Deploy the Stack**
### **Step 1: Build the JAR**
```sh
mvn clean package
```

### **Step 2: Build and Tag the Docker Image**
```sh
docker build -t demo .
```

### **Step 3: Initialize Swarm (If not already initialized)**
```sh
docker swarm init
```

### **Step 4: Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml demo
```
- Deploys **Spring Boot** with **PostgreSQL** in **Swarm mode**.

---

## **📌 4️⃣ Verify the Deployment**
### **Check Running Services**
```sh
docker stack services demo
```

### **Check Running Containers**
```sh
docker ps
```

### **Verify PostgreSQL is Running**
```sh
docker logs $(docker ps -q -f name=postgres)
```

---

## **📌 5️⃣ Test the Spring Boot + PostgreSQL Connection**
### **Step 1: Get a Running Container ID**
```sh
docker ps | grep demo
```

### **Step 2: Connect to PostgreSQL from Inside a Container**
```sh
docker exec -it <container_id> sh
apt update && apt install -y postgresql-client
psql -h postgres -U demo_user -d demo_db
```
Run:
```sql
SELECT datname FROM pg_database;
```
✔ **Expected Output:**
```
demo_db
postgres
template1
template0
```
✅ **Database is working inside the Swarm service**.

---

## **📌 6️⃣ Scaling the Spring Boot Service**
To increase the number of Spring Boot instances:
```sh
docker service scale demo_demo=5
```
✔ Runs **5 replicas** of the Spring Boot application.

---

## **📌 7️⃣ Viewing Logs**
```sh
docker service logs -f demo_demo
docker service logs -f demo_postgres
```
✔ Monitors **Spring Boot and PostgreSQL logs**.

---

## **📌 8️⃣ Updating the Service**
If code changes are made:
```sh
mvn clean package
docker build -t demo:v2 .
docker service update --image demo:v2 demo_demo
```
✔ Updates **Spring Boot instances without downtime**.

---

## **📌 9️⃣ Removing the Stack**
To clean up:
```sh
docker stack rm demo
docker swarm leave --force
```
✔ Removes **all services, volumes, and networks**.

---

## **✅ Summary: Spring Boot + PostgreSQL + Templates**
| **Feature** | **Command** |
|------------|------------|
| **Deploy the stack** | `docker stack deploy -c docker-compose.yml demo` |
| **Scale up Spring Boot** | `docker service scale demo_demo=5` |
| **Check running services** | `docker stack services demo` |
| **Connect to PostgreSQL** | `docker exec -it <container_id> psql -h postgres -U demo_user -d demo_db` |
| **Check logs** | `docker service logs -f demo_demo` |
| **Update Spring Boot** | `docker service update --image demo:v2 demo_demo` |
| **Remove Stack** | `docker stack rm demo` |

---
Your **Spring Boot App now runs in Docker Swarm with PostgreSQL** using **templates, dynamic volume mounts, and constraints**! 🚀🔥  

Would you like to **add a message queue like RabbitMQ** for real-time events? 😊