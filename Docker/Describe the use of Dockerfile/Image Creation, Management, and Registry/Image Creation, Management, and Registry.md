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

Would you like to explore **Docker Compose** next? 😊