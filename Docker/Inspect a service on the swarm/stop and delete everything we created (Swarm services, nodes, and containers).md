To **stop and delete** everything we created (Swarm services, nodes, and containers), follow these steps:

---

### **1. Remove the Webserver Service**
First, remove the `webserver` service:
```sh
docker service rm webserver
```
Verify the removal:
```sh
docker service ls
```
It should no longer list the service.

---

### **2. Leave and Disable Swarm Mode**
Make the node leave the Swarm:
```sh
docker swarm leave --force
```
Verify that the node is no longer part of the Swarm:
```sh
docker info | grep Swarm
```
It should now show:
```
Swarm: inactive
```

---

### **3. Stop and Remove All Containers**
List all running and stopped containers:
```sh
docker ps -a
```
Stop and remove all containers:
```sh
docker stop $(docker ps -aq)
docker rm -f $(docker ps -aq)
```
Verify cleanup:
```sh
docker ps -a  # Should return nothing
```

---

### **4. Remove Unused Docker Networks**
To clean up unused networks:
```sh
docker network prune -f
```

---

### **5. Remove Docker Images (Optional)**
If you want to remove the **nginx** image (and other unused images):
```sh
docker rmi nginx
docker image prune -a -f
```

---

### **6. Remove Any Remaining Volumes (Optional)**
To remove Docker volumes:
```sh
docker volume prune -f
```

---

### **7. Remove Any Leftover Docker System Resources (Optional)**
For a full cleanup:
```sh
docker system prune -a --volumes -f
```

---

### **Final Verification**
Run:
```sh
docker ps -a
docker images
docker network ls
docker volume ls
```
Everything should now be clean.

---

### **Automating Cleanup with a Script**
If you want to automate this, create a **cleanup script** (`cleanup_docker.sh`):

```sh
#!/bin/bash

# Remove Swarm service if exists
docker service rm webserver 2>/dev/null

# Leave Swarm if active
docker swarm leave --force 2>/dev/null

# Stop and remove all containers
docker stop $(docker ps -aq) 2>/dev/null
docker rm -f $(docker ps -aq) 2>/dev/null

# Remove networks, images, and volumes
docker network prune -f
docker rmi nginx 2>/dev/null
docker image prune -a -f
docker volume prune -f

# Clean up system
docker system prune -a --volumes -f

echo "Docker environment cleaned up!"
```

Make it executable:
```sh
chmod +x cleanup_docker.sh
```
Run it:
```sh
./cleanup_docker.sh
```

---

### **Summary**
- ✅ **Stop and remove the Swarm service**
- ✅ **Leave and disable Swarm mode**
- ✅ **Remove all containers, networks, images, and volumes**
- ✅ **Use a script to automate cleanup**

This will **completely reset your Docker environment** 🚀 Let me know if you need more help!