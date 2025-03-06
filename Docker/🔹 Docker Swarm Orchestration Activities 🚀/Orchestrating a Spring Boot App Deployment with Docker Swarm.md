# 🔹 Orchestrating a Spring Boot App Deployment with Docker Swarm


### **🔹 Orchestrating a Spring Boot App Deployment with Docker Swarm**
This guide demonstrates **orchestration activities** by:
1. **Creating a Spring Boot Application** with **JDK 17**.
2. **Building a JAR and Containerizing** it using **Docker**.
3. **Deploying it to Docker Swarm** as a scalable service.

---

## **🛠 1️⃣ Setup Spring Boot Application**
Navigate to your workspace and **generate a Spring Boot project** using Maven:
```sh
mkdir spring-boot-swarm && cd spring-boot-swarm
```
Create the **Spring Boot Application** structure:
```sh
mkdir -p src/main/java/com/example/demo
mkdir -p src/main/resources
```
---

### **📌 Create `DemoApplication.java`**
Inside `src/main/java/com/example/demo/DemoApplication.java`, add:

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}

@RestController
@RequestMapping("/api")
class HelloController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello from Spring Boot running in Swarm!";
    }
}
```
- This is a simple **REST API** exposing `/api/hello`.

---

### **📌 Create `application.properties`**
Inside `src/main/resources/application.properties`:
```properties
server.port=8080
```
---

### **📌 Create `pom.xml`**
Use the provided `pom.xml` (with JDK 17) and save it in your project root.

To build the JAR file:
```sh
mvn clean package
```
- This will create `target/demo-0.0.1-SNAPSHOT.jar`.

---

## **🐳 2️⃣ Create a `Dockerfile`**
Create a `Dockerfile` in the project root:
```dockerfile
# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## **📌 3️⃣ Build and Tag the Docker Image**
```sh
docker build -t spring-boot-swarm .
```
- This creates a Docker image named `spring-boot-swarm`.

---

## **🚀 4️⃣ Deploy as a Stack in Docker Swarm**
### **Initialize Swarm Mode**
If Swarm is not enabled:
```sh
docker swarm init
```

### **📌 Create `docker-compose.yml` for Stack Deployment**
```yaml
version: "3.8"

services:
  app:
    image: spring-boot-swarm:latest
    build: .
    ports:
      - "9090:8080"  # Running on a different port
    deploy:
      replicas: 3  # Run 3 instances
      restart_policy:
        condition: on-failure
```

### **Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml spring-app
```
- This runs **3 replicas** of the Spring Boot app.

---

## **📌 5️⃣ Validate the Deployment**
### **List Running Services**
```sh
docker stack services spring-app
```

### **List Running Containers**
```sh
docker ps
```

### **Test the API**
```sh
curl http://localhost:9090/api/hello
```
**Expected Output:**
```
Hello from Spring Boot running in Swarm!
```

---

## **📌 6️⃣ Orchestrate Services**
### **Scale the Service**
Increase replicas dynamically:
```sh
docker service scale spring-app_app=5
```

### **Update the Image**
After making changes:
```sh
docker build -t spring-boot-swarm .
docker service update --image spring-boot-swarm:latest spring-app_app
```

### **View Logs**
```sh
docker service logs -f spring-app_app
```

### **Remove the Stack**
```sh
docker stack rm spring-app
```

---

## **✅ Summary**
| **Task** | **Command** |
|----------|------------|
| Initialize Swarm | `docker swarm init` |
| Build Image | `docker build -t spring-boot-swarm .` |
| Deploy Stack | `docker stack deploy -c docker-compose.yml spring-app` |
| List Services | `docker stack services spring-app` |
| Scale Up | `docker service scale spring-app_app=5` |
| Rolling Update | `docker service update --image spring-boot-swarm:latest spring-app_app` |
| View Logs | `docker service logs -f spring-app_app` |
| Remove Stack | `docker stack rm spring-app` |

Would you like to integrate **a database (PostgreSQL)** in the stack? 🚀




### **🔹 Updated Dockerfile and `docker-compose.yml` for Project Name: `demo`**
Since your project name is `demo`, I’ve updated the **Dockerfile** and **docker-compose.yml** accordingly.

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

## **📌 2️⃣ Updated `docker-compose.yml`**
```yaml
version: "3.8"

services:
  demo:
    image: demo:latest
    build: .
    ports:
      - "9090:8080"  # Exposing on host port 9090, mapping to container's 8080
    deploy:
      replicas: 3  # Running 3 instances
      restart_policy:
        condition: on-failure
```

---

## **🚀 3️⃣ Build and Deploy the Stack**
### **Step 1: Build the JAR**
Run the following in your project root where `pom.xml` is located:
```sh
mvn clean package
```
- This will generate `target/demo-0.0.1-SNAPSHOT.jar`.

### **Step 2: Build the Docker Image**
```sh
docker build -t demo .
```

### **Step 3: Initialize Docker Swarm (If not already initialized)**
```sh
docker swarm init
```

### **Step 4: Deploy the Stack**
```sh
docker stack deploy -c docker-compose.yml demo
```
- This deploys the **Spring Boot application** as a **Swarm stack**.

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
Increase the number of replicas dynamically:
```sh
docker service scale demo_demo=5
```

---

## **📌 6️⃣ Updating the Service**
After making code changes:
```sh
mvn clean package
docker build -t demo .
docker service update --image demo:latest demo_demo
```

---

## **📌 7️⃣ Viewing Logs**
Monitor logs for debugging:
```sh
docker service logs -f demo_demo
```

---

## **📌 8️⃣ Removing the Stack**
To stop and clean up:
```sh
docker stack rm demo
```

---

### **✅ Summary**
| **Task** | **Command** |
|----------|------------|
| Build JAR | `mvn clean package` |
| Build Image | `docker build -t demo .` |
| Deploy Stack | `docker stack deploy -c docker-compose.yml demo` |
| List Services | `docker stack services demo` |
| Scale Up | `docker service scale demo_demo=5` |
| Rolling Update | `docker service update --image demo:latest demo_demo` |
| View Logs | `docker service logs -f demo_demo` |
| Remove Stack | `docker stack rm demo` |

Your Spring Boot app should now be **accessible via `curl http://localhost:9090/api/hello`** 🚀.

Would you like to add **Redis or a database (PostgreSQL/MySQL)** in this stack? 😊


