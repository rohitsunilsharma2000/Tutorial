# Describe and demonstrate how to extend the instructions to run individual containers into running services under swarm

### **Extending Single Containers to Swarm Services**
In Docker Swarm mode, instead of running individual containers using `docker run`, we deploy **services** that Swarm manages across multiple nodes. Services provide high availability, automatic scaling, and load balancing.

---

## **🔹 Steps to Convert a Single Container to a Swarm Service**
1. **Run a single container (traditional approach)**
   ```sh
   docker run -d -p 8080:80 --name webserver nginx
   ```
   This runs a single Nginx container but does not leverage Swarm’s features.

2. **Convert this into a Swarm Service**
   ```sh
   docker service create --name webserver --publish 8080:80 --replicas 3 nginx
   ```
   - `--name webserver`: Assigns a name to the service.
   - `--publish 8080:80`: Maps port 8080 on the host to 80 inside the container.
   - `--replicas 3`: Ensures three instances of the container run across the Swarm.

3. **Verify the service status**
   ```sh
   docker service ls
   ```
   - It should show the service name, number of replicas, and port mappings.

4. **Check the running containers (tasks)**
   ```sh
   docker service ps webserver
   ```
   - Lists which nodes are running the `webserver` service instances.

5. **Scale the service up or down**
   ```sh
   docker service scale webserver=5
   ```
   - This increases the replicas to 5.
   - Swarm distributes them across the available worker nodes.

6. **Check the logs of a service**
   ```sh
   docker service logs webserver
   ```

---

## **🔹 Running a More Complex Multi-Service Application**
For a more practical example, let’s deploy a **multi-container application** using **Swarm services**.

### **Example: Deploying a Web App with a Database**
Let's deploy a web app (Python Flask) with a Redis database.

1. **Create a `docker-compose.yml` file**
   ```yaml
   version: '3.8'

   services:
     web:
       image: python:3.9
       command: python -m http.server 8000
       ports:
         - "8000:8000"
       deploy:
         replicas: 3
         restart_policy:
           condition: on-failure

     redis:
       image: redis:latest
       deploy:
         replicas: 1
   ```

2. **Deploy the stack in Swarm mode**
   ```sh
   docker stack deploy -c docker-compose.yml myapp
   ```
   - This creates and manages the `web` and `redis` services under a Swarm stack.
   - `replicas: 3` ensures the web app is distributed across nodes.

3. **Verify the running stack**
   ```sh
   docker stack services myapp
   ```
   - This lists all services running in the `myapp` stack.

4. **Inspect running tasks for a specific service**
   ```sh
   docker service ps myapp_web
   ```

5. **Remove the stack**
   ```sh
   docker stack rm myapp
   ```
   - This stops and removes all services in the stack.

---

## **🔹 Benefits of Using Swarm Services Over Containers**
| Feature         | `docker run` (Standalone) | `docker service` (Swarm Mode) |
|----------------|-------------------------|-------------------------------|
| **Scaling**    | Manual (run multiple containers) | Automated with `--replicas` |
| **Load Balancing** | No built-in balancing | Built-in across nodes |
| **Fault Tolerance** | Container crashes = manual restart | Auto-restarts failed tasks |
| **Multi-host Deployment** | Single-node | Multi-node capable |
| **Rolling Updates** | Not available | Supported (`docker service update`) |

---

## **✅ Summary**
- **Containers (`docker run`)** run on a single host.
- **Swarm services (`docker service create`)** distribute and manage containers across multiple nodes.
- **Swarm stacks (`docker stack deploy`)** help deploy multi-container applications.

Would you like help with a real-world use case like running a **Java Spring Boot app** in Swarm? 🚀