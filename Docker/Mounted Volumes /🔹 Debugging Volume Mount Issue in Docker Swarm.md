### **🔹 Debugging Volume Mount Issue in Docker Swarm**
The error indicates that:
1. **The container is not finding `/app/logs`** inside the filesystem.
2. **The volume exists (`docker volume ls` shows `demo_demo-logs`)**, but it might not be correctly mounted in the container.

---

## **📌 1️⃣ Verify the Volume is Mounted Inside the Container**
Run:
```sh
docker inspect demo_demo
```
Look for the **`Mounts` section** to check if `/app/logs` is correctly mapped.

Alternatively, get a specific container ID and inspect:
```sh
docker ps  # Find the actual running container ID for demo_demo
docker inspect <container_id> | jq '.[0].Mounts'
```
- If `/app/logs` is missing, the volume **did not mount correctly**.

---

## **📌 2️⃣ Manually Enter a Running Container**
Since `docker exec -it $(docker ps -q -f name=demo_demo) sh` failed, manually **get the correct container ID** and retry:

```sh
docker ps | grep demo_demo  # Find the correct container ID
docker exec -it <container_id> sh
```
Once inside, **list mounted volumes**:
```sh
mount | grep /app
ls -l /app/
```
- If `/app/logs` **does not exist**, the volume was **not mounted correctly**.

---

## **📌 3️⃣ Ensure `/app/logs` Directory Exists Inside the Container**
Inside your `Dockerfile`, **add a command** to create the `/app/logs` folder before starting the app.

### **🔹 Fix `Dockerfile`**
Modify your `Dockerfile`:
```dockerfile
# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Create logs directory (Ensure it exists)
RUN mkdir -p /app/logs

# Copy the built JAR file into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```
Rebuild the image:
```sh
docker build -t demo .
```

---

## **📌 4️⃣ Redeploy the Stack**
Remove the existing stack and redeploy:
```sh
docker stack rm demo
docker stack deploy -c docker-compose.yml demo
```
Then, check if the issue is resolved:
```sh
docker ps | grep demo_demo  # Get container ID
docker exec -it <container_id> sh
ls -l /app/logs  # Should now list the logs directory
```

---

## **📌 5️⃣ If the Issue Persists, Manually Mount the Volume**
Check the volume manually:
```sh
docker volume inspect demo_demo-logs
```
Manually start a test container with the volume:
```sh
docker run --rm -it -v demo_demo-logs:/app/logs alpine sh
```
Then check:
```sh
ls -l /app/logs
```
- If `/app/logs` **exists**, the issue was with the Swarm service configuration.
- If it **does not exist**, recreate the volume:
  ```sh
  docker volume rm demo_demo-logs
  docker volume create demo_demo-logs
  ```

---

## **✅ Summary of Fixes**
| **Step** | **Command** |
|----------|------------|
| Verify volume is mounted | `docker inspect <container_id> | jq '.[0].Mounts'` |
| Manually enter container | `docker exec -it <container_id> sh` |
| Check mounted directories | `mount | grep /app` |
| Ensure `/app/logs` exists | Add `RUN mkdir -p /app/logs` in `Dockerfile` |
| Rebuild and redeploy | `docker build -t demo . && docker stack deploy -c docker-compose.yml demo` |
| Check volume manually | `docker volume inspect demo_demo-logs` |
| Test volume manually | `docker run --rm -it -v demo_demo-logs:/app/logs alpine sh` |

Try these fixes and let me know what you find! 🚀🔥