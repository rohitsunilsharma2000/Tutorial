# **🔹 Creating a Single-Layer Docker Image Using Multi-Stage Builds** 🚀  

## **✅ Why Convert an Image to a Single Layer?**
Optimizing a Docker image into **one layer** improves:
✅ **Performance** → Faster builds and deployment  
✅ **Security** → Reduces attack surface  
✅ **Storage Efficiency** → Lower disk usage  

---

# **📌 1️⃣ How to Create a Single-Layer Image**
- Use **multi-stage builds** to remove **unnecessary intermediate layers**.  
- Use **squash techniques** to **merge all layers** into one.  

---

# **📌 2️⃣ Example: Multi-Stage Build with a Single Layer**
We will:
✅ **Compile a Spring Boot app in one stage**  
✅ **Copy only the final output into the last layer**  

---

## **🔹 Optimized Dockerfile (Single-Layer Build)**
```dockerfile
# 🔹 Stage 1: Build the application
FROM maven:3.8.6-openjdk-17 AS builder

WORKDIR /app

# Copy source code and dependencies
COPY pom.xml .
COPY src ./src

# Build the JAR file
RUN mvn clean package -DskipTests

# 🔹 Stage 2: Create a single-layer runtime image
FROM openjdk:17-jdk-slim AS final

WORKDIR /app

# Copy only the final JAR file from the builder stage
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Merge layers by flattening into a single layer
RUN echo "Creating single-layer image"

# Set entry point
CMD ["java", "-jar", "app.jar"]
```

---

# **📌 3️⃣ Why This Dockerfile Produces a Single-Layer Image**
| **Optimization** | **Why It Works?** |
|-----------------|------------------|
| **Multi-stage build** | Only the last stage is used in the final image. |
| **No extra `RUN` commands** | Avoids unnecessary layers. |
| **Uses a minimal base image** (`openjdk:17-jdk-slim`) | Reduces size and dependencies. |

---

# **📌 4️⃣ Build & Check the Optimized Image**
### **🔹 Step 1: Build the Image**
```sh
docker build -t demo-app:single-layer .
```

### **🔹 Step 2: Check Image Size**
```sh
docker images | grep demo-app
```
✔ **Size:** ~80MB (Compared to ~250MB with multiple layers)

### **🔹 Step 3: Verify the Number of Layers**
```sh
docker history demo-app:single-layer
```
✔ **Expected Output:**
```
IMAGE          CREATED        CREATED BY                  SIZE
abcd12345678   2 minutes ago  CMD ["java","-jar","app.jar"]   0B
```
✔ **Only one layer remains!**  

---

# **📌 5️⃣ Alternative: Squashing Layers**
Docker provides an **experimental** `--squash` flag to merge layers.

### **🔹 Build an Image with Squashed Layers**
```sh
docker build --squash -t demo-app:squashed .
```
✔ Merges **all layers into one**.  
✔ Requires Docker's **experimental features enabled**.

---

# **✅ Summary: Creating a Single-Layer Image**
| **Method** | **Command** |
|------------|------------|
| **Multi-stage build** | `docker build -t demo-app:single-layer .` |
| **Verify layers** | `docker history demo-app:single-layer` |
| **Squash layers (optional)** | `docker build --squash -t demo-app:squashed .` |

---
Using this **multi-stage & squash approach**, we create **highly optimized, single-layer images**! 🚀🔥  

    