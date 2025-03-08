# **🔹 Docker Image Management: Tagging, Creating from a File, and Viewing Layers** 🚀  

This guide covers:
✅ **Tagging an Image**  
✅ **Creating a Docker Image from a File**  
✅ **Displaying Image Layers**  

---

# **📌 1️⃣ Tagging a Docker Image (`docker tag`)**
### **What is Image Tagging?**
- A **tag** is a label that allows you to **identify and manage versions** of Docker images.  
- You can **rename** an image or **prepare it for pushing to a registry**.

### **🔹 Tagging an Image**
```sh
docker tag <source_image> <target_repository>:<tag>
```

### **🔹 Example:**
```sh
docker tag demo-app myrepo/demo-app:v1.0
```
✔ **Renames** the `demo-app` image to `myrepo/demo-app:v1.0`.

### **🔹 Verify the Tag**
```sh
docker images
```
✔ **Expected Output:**
```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
myrepo/demo-app     v1.0      abcd12345678   2 minutes ago    250MB
```

---

# **📌 2️⃣ Creating a Docker Image from a File (`Dockerfile`)**
### **🔹 What is a Dockerfile?**
A **Dockerfile** is a script that **automates image creation**.

### **🔹 Example: `Dockerfile`**
```dockerfile
# Use a base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy application JAR
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
```

### **🔹 Build the Image**
```sh
docker build -t demo-app:v1.0 .
```
✔ Creates an image called `demo-app:v1.0`.

### **🔹 Verify the Image**
```sh
docker images | grep demo-app
```
✔ Confirms that the image is built.

---

# **📌 3️⃣ Viewing Image Layers (`docker history`)**
### **🔹 What are Image Layers?**
- Every `Dockerfile` **instruction (`RUN`, `COPY`, etc.)** creates a **new layer**.  
- Layers are **cached** to optimize builds.  

### **🔹 Command:**
```sh
docker history <image_name>
```

### **🔹 Example:**
```sh
docker history demo-app:v1.0
```
✔ **Expected Output:**
```
IMAGE          CREATED        CREATED BY                  SIZE
abcd12345678   2 minutes ago  CMD ["java","-jar","app"]   0B
efgh98765432   2 minutes ago  COPY target/demo.jar /app/  80MB
ijkl56789012   3 minutes ago  FROM openjdk:17-jdk-slim   250MB
```
✔ **Each row is a layer** with its size and creation step.

---

# **✅ Summary: Key Commands**
| **Task** | **Command** |
|----------|------------|
| **Tag an Image** | `docker tag demo-app myrepo/demo-app:v1.0` |
| **Verify the Tag** | `docker images` |
| **Create an Image from Dockerfile** | `docker build -t demo-app:v1.0 .` |
| **View Image Layers** | `docker history demo-app:v1.0` |

---
This guide **optimizes Docker image management** and helps **track changes in layers**! 🚀🔥  

# **🔹 Optimizing Docker Images Using Multi-Stage Builds** 🚀  

## **✅ Why Use Multi-Stage Builds?**
A **multi-stage build** allows you to:
✅ **Reduce image size** → Keeps only required files.  
✅ **Improve security** → Removes build dependencies.  
✅ **Optimize performance** → Faster startup and lower memory usage.  

---

# **📌 1️⃣ How Multi-Stage Builds Work**
- The first stage (`builder`) **compiles and prepares** the application.  
- The second stage (`final`) **copies only essential files** into a smaller base image.  
- This eliminates unnecessary tools (e.g., compilers, dependencies).  

---

# **📌 2️⃣ Example: Optimized Dockerfile for a Spring Boot App**
### **🔹 Multi-Stage `Dockerfile`**
```dockerfile
# 🔹 Stage 1: Build the application
FROM maven:3.8.6-openjdk-17 AS builder

WORKDIR /app

# Copy source files and dependencies
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# 🔹 Stage 2: Create a lightweight runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the built JAR file from the builder stage
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
```

---

# **📌 3️⃣ Why This Dockerfile is Efficient?**
| **Optimization** | **Why?** |
|-----------------|---------|
| **Uses `maven:3.8.6-openjdk-17` only for building** | Keeps compilers & dependencies **out of the final image** |
| **Final stage uses `openjdk:17-jdk-slim`** | Reduces image size **by ~50%** |
| **Copies only the compiled JAR (`COPY --from=builder`)** | Avoids copying unnecessary files |
| **No unnecessary layers** | Reduces build time & attack surface |

---

# **📌 4️⃣ Build & Run the Optimized Image**
### **Step 1: Build the Image**
```sh
docker build -t demo-app:optimized .
```
✔ **Multi-stage build automatically optimizes the image**.

### **Step 2: Check Image Size**
```sh
docker images | grep demo-app
```
✔ The optimized image is **smaller** than a traditional Dockerfile build.

### **Step 3: Run the Container**
```sh
docker run -d -p 8080:8080 demo-app:optimized
```

---

# **📌 5️⃣ Compare Image Sizes (With & Without Multi-Stage)**
### **🔹 Standard Dockerfile (Without Multi-Stage)**
```sh
docker build -t demo-app:large .
docker images | grep demo-app
```
✔ **Size**: ~600MB  

### **🔹 Optimized Multi-Stage Dockerfile**
```sh
docker build -t demo-app:optimized .
docker images | grep demo-app
```
✔ **Size**: ~250MB (**Reduced by ~60%**)

---

# **✅ Summary: Multi-Stage Build Advantages**
| **Feature** | **Without Multi-Stage** | **With Multi-Stage** |
|------------|----------------|----------------|
| **Image Size** | **600MB+** | **250MB (50-60% smaller)** |
| **Security** | More dependencies | **Fewer attack surfaces** |
| **Performance** | Slower | **Faster startup** |
| **Storage Usage** | High | **Optimized** |

---
This **drastically improves efficiency** for **Dockerized applications**! 🚀🔥  

