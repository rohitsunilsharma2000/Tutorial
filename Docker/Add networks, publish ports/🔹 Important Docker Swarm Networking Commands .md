### **🔹 Important Docker Swarm Networking Commands** 🖧

Docker Swarm **networking** enables services to communicate securely across nodes. Below are essential **commands to manage networks** in Swarm.

---

## **📌 1️⃣ List All Networks**
```sh
docker network ls
```
- Lists all available networks in **Swarm mode**.

**Example Output:**
```
NETWORK ID          NAME                DRIVER          SCOPE
12a34bc56d78       bridge              bridge          local
78x6gh90pkl1       demo-net            overlay         swarm
bc23de34fg56       host                host            local
```
- **Overlay** networks (`demo-net`) allow multi-node communication.
- **Bridge** networks (`bridge`) are for standalone containers.

---

## **📌 2️⃣ Inspect a Network**
```sh
docker network inspect demo-net
```
- Shows **detailed information** about a network, including connected services.

**Example Output (Formatted JSON using `jq`)**
```sh
docker network inspect demo-net | jq
```
```json
{
  "Name": "demo-net",
  "Driver": "overlay",
  "Scope": "swarm",
  "Containers": {
    "abc123...": {
      "Name": "demo_demo.1",
      "IPv4Address": "10.0.0.5/24"
    },
    "def456...": {
      "Name": "demo_demo.2",
      "IPv4Address": "10.0.0.6/24"
    }
  }
}
```
- **Connected services**: `demo_demo.1` and `demo_demo.2`.
- **IP Addresses** assigned inside the Swarm **overlay network**.

---

## **📌 3️⃣ Create a Custom Network**
```sh
docker network create --driver overlay demo-custom-net
```
- Creates a **Swarm overlay network** named `demo-custom-net`.

---

## **📌 4️⃣ Attach a Running Service to a Network**
```sh
docker network connect demo-net demo_demo.1
```
- Connects the **running container (`demo_demo.1`)** to `demo-net`.

---

## **📌 5️⃣ Disconnect a Service from a Network**
```sh
docker network disconnect demo-net demo_demo.1
```
- Removes `demo_demo.1` from `demo-net`.

---

## **📌 6️⃣ Remove a Network**
```sh
docker network rm demo-custom-net
```
- Deletes a custom network **(only if no services are using it)**.

---

## **📌 7️⃣ Verify Service-to-Service Communication**
Each service can be **accessed using its service name** in Swarm mode.

For example, if **`demo`** is running inside `demo-net`, log into a container:
```sh
docker exec -it $(docker ps -q -f name=demo_demo) sh
```
Then test communication:
```sh
curl http://demo:8080/api/hello
```
- If the service responds, networking **is correctly set up**.

---

## **📌 8️⃣ Expose a Service on Multiple Ports**
To **publish multiple ports**, modify `docker-compose.yml`:
```yaml
services:
  demo:
    image: demo:latest
    networks:
      - demo-net
    ports:
      - "9090:8080"  # External port 9090 → Container port 8080
      - "7070:8080"  # External port 7070 → Container port 8080
```

Apply changes:
```sh
docker stack deploy -c docker-compose.yml demo
```

---

## **✅ Summary of Networking Commands**
| **Command** | **Description** |
|------------|----------------|
| `docker network ls` | List all available networks |
| `docker network inspect demo-net` | Show details of a specific network |
| `docker network create --driver overlay demo-custom-net` | Create a Swarm overlay network |
| `docker network connect demo-net demo_demo.1` | Attach a running service to a network |
| `docker network disconnect demo-net demo_demo.1` | Remove a service from a network |
| `docker network rm demo-custom-net` | Remove a network (if unused) |
| `curl http://demo:8080/api/hello` | Test communication between services |
| Modify `ports:` in `docker-compose.yml` | Publish additional ports |

---
These commands help in **networking, debugging, and ensuring connectivity between services** in **Swarm mode**. 🚀🔥  

Would you like to add **network security policies** like restricting access between services? 😊