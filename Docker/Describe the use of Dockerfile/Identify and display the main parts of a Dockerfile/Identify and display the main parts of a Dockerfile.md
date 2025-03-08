## **🔹 Main Parts of a Dockerfile** 🚀  

A **Dockerfile** is a script containing **instructions** to define how a Docker image is built. Below are the **main parts of a Dockerfile**, along with explanations and examples.

---

## **📌 1️⃣ `FROM` (Base Image)**
✔ Specifies the **base image** used to build the container.  
✔ Every Dockerfile **must start** with `FROM`.

**Example:**
```dockerfile
FROM openjdk:17-jdk-slim
```
✔ Uses **OpenJDK 17** as the base image.

---

## **📌 2️⃣ `WORKDIR` (Set Working Directory)**
✔ Defines **where commands will be executed** inside the container.  
✔ Prevents **relative path issues**.

**Example:**
```dockerfile
WORKDIR /app
```
✔ All following commands **will run inside `/app`**.

---

## **📌 3️⃣ `COPY` or `ADD` (Copy Files)**
✔ Copies files from the **host machine** to the **container**.  
✔ Use **`COPY`** for normal file copying.  
✔ Use **`ADD`** for auto-extracting `.tar.gz` files or downloading from URLs.

**Example:**
```dockerfile
COPY target/demo.jar app.jar
```
✔ Copies `demo.jar` from the **host machine** to `/app.jar` inside the container.

---

## **📌 4️⃣ `RUN` (Execute Commands at Build Time)**
✔ Runs **commands inside the image** during **build time**.  
✔ Used for **installing dependencies, updating packages, or configuring the environment**.

**Example:**
```dockerfile
RUN apt-get update && apt-get install -y curl
```
✔ Installs `curl` inside the container.

---

## **📌 5️⃣ `ENV` (Set Environment Variables)**
✔ Defines **environment variables** inside the container.

**Example:**
```dockerfile
ENV APP_ENV=production
```
✔ Sets `APP_ENV` to `"production"` inside the container.

---

## **📌 6️⃣ `EXPOSE` (Define Listening Port)**
✔ Informs Docker that the **container listens on a specific port**.  
✔ This **does NOT publish the port**, only documents it.

**Example:**
```dockerfile
EXPOSE 8080
```
✔ Indicates the container **listens on port `8080`**.

To **publish the port externally**, run:
```sh
docker run -p 9090:8080 demo-app
```
✔ Maps **host `9090` → container `8080`**.

---

## **📌 7️⃣ `VOLUME` (Persistent Data Storage)**
✔ Defines a **mount point for persistent data**.  
✔ Data **persists even if the container stops**.

**Example:**
```dockerfile
VOLUME /app/data
```
✔ Creates a **volume mount** at `/app/data`.

To mount a volume when running:
```sh
docker run -v /my/local/folder:/app/data demo-app
```
✔ Maps **local storage** to **container storage**.

---

## **📌 8️⃣ `ENTRYPOINT` vs `CMD` (Define Startup Commands)**
| **Feature** | **ENTRYPOINT** | **CMD** |
|------------|--------------|---------|
| **Fixed command** | ✅ Yes | ❌ No |
| **Allows overriding** | ❌ No | ✅ Yes |
| **Used for** | Main process execution | Default arguments |

✔ Use `ENTRYPOINT` for **mandatory commands**.  
✔ Use `CMD` to **provide default arguments**.

**Example:**
```dockerfile
ENTRYPOINT ["java", "-jar"]
CMD ["app.jar"]
```
✔ Running `docker run demo-app another.jar` will execute **`java -jar another.jar`**.

---

## **📌 9️⃣ Full Example Dockerfile**
```dockerfile
# 1️⃣ Base image
FROM openjdk:17-jdk-slim

# 2️⃣ Set working directory
WORKDIR /app

# 3️⃣ Copy application JAR file
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# 4️⃣ Set environment variables
ENV APP_ENV=production

# 5️⃣ Expose the application port
EXPOSE 8080

# 6️⃣ Create a persistent volume for logs
VOLUME /app/logs

# 7️⃣ Run the application
ENTRYPOINT ["java", "-jar"]
CMD ["app.jar"]
```

---

## **📌 1️⃣0️⃣ Build & Run the Docker Image**
### **Build the Image**
```sh
docker build -t demo-app .
```
### **Run the Container**
```sh
docker run -d -p 8080:8080 --name demo-container demo-app
```
### **Check Running Containers**
```sh
docker ps
```
---

## **✅ Summary: Main Parts of a Dockerfile**
| **Instruction** | **Purpose** | **Example** |
|---------------|------------|------------|
| **`FROM`** | Defines the **base image** | `FROM ubuntu:latest` |
| **`WORKDIR`** | Sets the **working directory** inside the container | `WORKDIR /app` |
| **`COPY`** | Copies files from host to container | `COPY app.jar /app/` |
| **`ADD`** | Copies & extracts files (supports URLs) | `ADD data.tar.gz /app/` |
| **`RUN`** | Executes commands during **build time** | `RUN apt-get update` |
| **`ENV`** | Sets **environment variables** | `ENV APP_ENV=production` |
| **`EXPOSE`** | Declares the **container's listening port** | `EXPOSE 8080` |
| **`VOLUME`** | Creates **persistent storage** | `VOLUME /app/data` |
| **`ENTRYPOINT`** | Defines **fixed command execution** | `ENTRYPOINT ["java", "-jar"]` |
| **`CMD`** | Sets **default arguments** | `CMD ["app.jar"]` |

---
This **optimizes your Docker images** for **better performance and portability**! 🚀🔥  

