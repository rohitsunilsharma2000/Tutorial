# Manipulate a running stack of services

### **🔹 Manipulating a Running Docker Swarm Stack of Services** 🚀  
Once your **stack** is running in Docker Swarm, you can manipulate it in various ways:  
✔ Scale services up or down  
✔ Update images and configurations  
✔ Restart or remove services  
✔ Inspect logs and status  
✔ Rolling updates and rollbacks  

---

## **1️⃣ Check Running Services in the Stack**
To **list all services** in a running stack:
```sh
docker stack services flask-stack
```
Example Output:
```
ID                  NAME                MODE                REPLICAS            IMAGE                  PORTS
x12bc34d5e67        flask-stack_flask-app   replicated          3/3                 flask-redis-app:latest  *:8080->8000/tcp
y98za76x5b43        flask-stack_redis       replicated          1/1                 redis:latest
```
- The `flask-app` service has **3 replicas**.
- The `redis` service has **1 replica**.

---

## **2️⃣ Scale Services Up or Down**
Increase or decrease the **number of replicas** dynamically.

- **Scale Flask App to 5 replicas**:
  ```sh
  docker service scale flask-stack_flask-app=5
  ```
  - The system will schedule additional instances on available nodes.

- **Scale Redis down to 1 replica**:
  ```sh
  docker service scale flask-stack_redis=1
  ```

- **Verify the scaling**:
  ```sh
  docker service ps flask-stack_flask-app
  ```
  - This lists all replicas running for `flask-app`.

---

## **3️⃣ Update a Service (Rolling Update)**
You can update an image, environment variables, or configurations **without downtime**.

### **Update the Flask App Image**
1. **Rebuild the image** (if modified):
   ```sh
   docker build -t flask-redis-app:latest .
   ```
2. **Push the new image (if using a registry)**:
   ```sh
   docker tag flask-redis-app:latest myrepo/flask-redis-app:v2
   docker push myrepo/flask-redis-app:v2
   ```
3. **Update the running service**:
   ```sh
   docker service update --image myrepo/flask-redis-app:v2 flask-stack_flask-app
   ```

---

## **4️⃣ Change Port Mappings**
Modify the published port **without recreating the stack**.

```sh
docker service update --publish-add 9090:8000 flask-stack_flask-app
```
- Now, the Flask app will also be accessible on `http://localhost:9090`.

---

## **5️⃣ Modify Environment Variables**
Change the Redis hostname dynamically:
```sh
docker service update --env-add REDIS_HOST=myredis flask-stack_flask-app
```
- Check if the new **environment variable** was added:
  ```sh
  docker inspect flask-stack_flask-app | grep REDIS_HOST
  ```

---

## **6️⃣ Restart or Remove a Service**
Restart all replicas of a service:
```sh
docker service update --force flask-stack_flask-app
```
- This forces all tasks to **restart** with the latest config.

Remove a service from the stack:
```sh
docker service rm flask-stack_flask-app
```

---

## **7️⃣ Monitor Logs and Status**
### **View Service Logs**
```sh
docker service logs -f flask-stack_flask-app
```
- This streams logs from all replicas.

### **View Detailed Service Status**
```sh
docker service ps flask-stack_flask-app
```
- Lists all running instances and their node assignments.

---

## **8️⃣ Rollback to a Previous Version**
If an update **breaks the service**, rollback to the previous version:
```sh
docker service rollback flask-stack_flask-app
```
- Swarm will restore the **last working version** automatically.

---

## **9️⃣ Remove the Entire Stack**
To delete all services and clean up:
```sh
docker stack rm flask-stack
```
- This **removes all running services** under the stack.

Leave Swarm mode:
```sh
docker swarm leave --force
```

---

## **✅ Summary**
| **Action** | **Command** |
|------------|------------|
| Check running services | `docker stack services flask-stack` |
| Scale service replicas | `docker service scale flask-stack_flask-app=5` |
| Update an image | `docker service update --image myrepo/flask-redis-app:v2 flask-stack_flask-app` |
| Add a new port | `docker service update --publish-add 9090:8000 flask-stack_flask-app` |
| Add an environment variable | `docker service update --env-add REDIS_HOST=myredis flask-stack_flask-app` |
| Restart all replicas | `docker service update --force flask-stack_flask-app` |
| View logs | `docker service logs -f flask-stack_flask-app` |
| Rollback to previous version | `docker service rollback flask-stack_flask-app` |
| Remove service | `docker service rm flask-stack_flask-app` |
| Remove stack | `docker stack rm flask-stack` |

---

### **🔹 Next Steps**
Would you like help with **automating stack updates** using a **CI/CD pipeline**? 🚀