## **🔹 Dockerfile: Image Creation, Management, and Registry** 🚀  

A **Dockerfile** is a script containing a set of instructions to **automate the creation of Docker images**. It defines how a **container should be built, configured, and run**.

---
## **📌 1️⃣ Why Use a Dockerfile?**
✅ **Automates image creation** → No need to manually configure containers  
✅ **Ensures consistency** → Same image can be used in **development, testing, and production**  
✅ **Optimized deployment** → Images are lightweight and **portable**  

---

## **📌 2️⃣ Basic Structure of a Dockerfile**
```dockerfile
# Base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy files into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose ports
EXPOSE 8080

# Define environment variables
ENV APP_ENV=production

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---
## **📌 3️⃣ Dockerfile Instructions**
| **Instruction** | **Description** |
|---------------|----------------|
| `FROM` | Specifies the **base image** (e.g., `ubuntu`, `alpine`, `openjdk`) |
| `WORKDIR` | Sets the **working directory** inside the container |
| `COPY` | Copies files from the **host machine to the container** |
| `EXPOSE` | Specifies the **port** that the container will listen on |
| `ENV` | Sets **environment variables** |
| `ENTRYPOINT` | Defines the **main command** to run the container |
| `CMD` | Provides **default arguments** to the `ENTRYPOINT` |
| `RUN` | Executes commands **during image build** (e.g., installing dependencies) |

---

## **📌 4️⃣ Building and Running an Image**
### **🔹 Step 1: Build the Image**
```sh
docker build -t demo-app .
```
### **🔹 Step 2: Run the Container**
```sh
docker run -d -p 8080:8080 --name demo-container demo-app
```
### **🔹 Step 3: Verify Running Containers**
```sh
docker ps
```

---

## **📌 5️⃣ Optimizing Dockerfile for Efficiency**
### **✅ Use Multi-Stage Builds**
```dockerfile
# Build Stage
FROM maven:3.8.6-openjdk-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package

# Production Stage
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```
✔ **Reduces image size** by **excluding build dependencies**.

---

## **📌 6️⃣ Managing Docker Images**
### **List Available Images**
```sh
docker images
```

### **Tag an Image**
```sh
docker tag demo-app myrepo/demo-app:v1.0
```

### **Push an Image to Docker Hub**
```sh
docker login
docker push myrepo/demo-app:v1.0
```

### **Remove an Image**
```sh
docker rmi demo-app
```

---

## **✅ Summary of Key Commands**
| **Task** | **Command** |
|----------|------------|
| **Build an Image** | `docker build -t demo-app .` |
| **Run a Container** | `docker run -d -p 8080:8080 demo-app` |
| **List Images** | `docker images` |
| **Tag an Image** | `docker tag demo-app myrepo/demo-app:v1.0` |
| **Push to Docker Hub** | `docker push myrepo/demo-app:v1.0` |
| **Remove an Image** | `docker rmi demo-app` |

---
This covers **Dockerfile creation, image management, and optimization** for **containerized workloads**! 🚀🔥  

# **🔹 Docker Compose: Simplifying Multi-Container Applications** 🚀  

## **✅ What is Docker Compose?**
Docker Compose is a tool for **defining and running multi-container Docker applications** using a **single YAML file** (`docker-compose.yml`). It allows you to:
✅ **Manage multiple containers easily**  
✅ **Use a single command to start/stop services**  
✅ **Define networks, volumes, and dependencies**  

---

## **📌 1️⃣ Installing Docker Compose**
If not already installed, get Docker Compose:
```sh
docker --version   # Verify Docker is installed
docker-compose --version  # Verify Docker Compose
```
If missing, install it:
```sh
sudo apt-get install docker-compose
```

---

## **📌 2️⃣ Basic `docker-compose.yml` Structure**
A simple **Spring Boot + PostgreSQL** setup:
```yaml
version: "3.8"

services:
  app:
    image: demo-app:latest
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_USER: demo_user
      DB_PASSWORD: demo_pass
      DB_NAME: demo_db
    networks:
      - app-network

  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: demo_user
      POSTGRES_PASSWORD: demo_pass
      POSTGRES_DB: demo_db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network

networks:
  app-network:

volumes:
  postgres-data:
```
✔ **Defines two services (`app` and `db`)**  
✔ **Uses a shared network (`app-network`)**  
✔ **Mounts persistent storage (`postgres-data`)**  

---

## **📌 3️⃣ Running Docker Compose**
### **🔹 Step 1: Build & Start the Services**
```sh
docker-compose up -d
```
- `-d` → Runs in detached mode (background).

### **🔹 Step 2: Check Running Services**
```sh
docker-compose ps
```

### **🔹 Step 3: View Logs**
```sh
docker-compose logs -f
```

### **🔹 Step 4: Stop the Services**
```sh
docker-compose down
```

---

## **📌 4️⃣ Scaling Services**
Increase app instances **dynamically**:
```sh
docker-compose up --scale app=3 -d
```
✔ Now **3 replicas** of the `app` service are running!

---

## **📌 5️⃣ Updating a Service**
If code changes, rebuild the app:
```sh
docker-compose build
docker-compose up -d
```

---

## **📌 6️⃣ Removing Containers, Volumes & Networks**
### **Stop & Remove Services**
```sh
docker-compose down
```
### **Remove Everything (Volumes & Networks)**
```sh
docker-compose down -v
```

---

## **✅ Summary: Key Commands**
| **Task** | **Command** |
|----------|------------|
| **Start Services** | `docker-compose up -d` |
| **View Running Services** | `docker-compose ps` |
| **Follow Logs** | `docker-compose logs -f` |
| **Stop & Remove Containers** | `docker-compose down` |
| **Scale Services** | `docker-compose up --scale app=3 -d` |
| **Rebuild Image & Restart** | `docker-compose build && docker-compose up -d` |
| **Remove Everything** | `docker-compose down -v` |

---
This simplifies **managing multi-container applications** using **Docker Compose**! 🚀🔥  

