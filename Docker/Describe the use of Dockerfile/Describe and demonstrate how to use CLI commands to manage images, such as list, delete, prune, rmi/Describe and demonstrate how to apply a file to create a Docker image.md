# **🔹 Creating a Docker Image Using a File (Dockerfile)** 🚀  

## **✅ Overview**
A **Dockerfile** is a text file that contains **instructions** to build a Docker image.  
This guide will cover **how to create a Docker image using a Dockerfile**.

---

## **📌 1️⃣ Steps to Create a Docker Image Using a File**
### **🔹 Step 1: Create a Dockerfile**
A **Dockerfile** defines how an image is built.  

```sh
nano Dockerfile
```
Paste the following content:

```dockerfile
# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy application files
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
```
Save and exit (`CTRL+X`, then `Y`, then `ENTER`).

---

### **🔹 Step 2: Build the Docker Image**
Run the following command:
```sh
docker build -t demo-app:v1.0 .
```
✔ `-t demo-app:v1.0` → Names the image as `demo-app` with **tag `v1.0`**.  
✔ `.` → Uses the **Dockerfile in the current directory**.  

---

### **🔹 Step 3: Verify the Image**
Check if the image was created:
```sh
docker images | grep demo-app
```
✔ Expected output:
```
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
demo-app       v1.0      abcd12345678   2 minutes ago   250MB
```

---

### **🔹 Step 4: Run the Docker Container**
```sh
docker run -d -p 8080:8080 --name demo-container demo-app:v1.0
```
✔ `-d` → Runs in **detached mode** (background).  
✔ `-p 8080:8080` → Maps **host port `8080` to container port `8080`**.  

Check running containers:
```sh
docker ps
```

---

### **🔹 Step 5: Test the Running Application**
If your app exposes a REST API:
```sh
curl http://localhost:8080/api/hello
```

---

## **✅ Summary: Commands to Apply a File and Create an Image**
| **Task** | **Command** |
|----------|------------|
| **Create a Dockerfile** | `nano Dockerfile` |
| **Build an Image** | `docker build -t demo-app:v1.0 .` |
| **List Images** | `docker images` |
| **Run the Container** | `docker run -d -p 8080:8080 demo-app:v1.0` |
| **Check Running Containers** | `docker ps` |
| **Test the App** | `curl http://localhost:8080/api/hello` |

---
