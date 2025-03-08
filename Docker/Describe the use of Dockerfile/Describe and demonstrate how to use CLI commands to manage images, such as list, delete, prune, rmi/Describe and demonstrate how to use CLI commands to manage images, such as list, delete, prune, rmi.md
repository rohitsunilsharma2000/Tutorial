# **🔹 Managing Docker Images Using CLI Commands** 🚀  

## **✅ Overview**
Docker provides **CLI commands** to **list, remove, prune, and manage images**.  
This guide covers **essential image management commands** for efficiency.

---

## **📌 1️⃣ List Docker Images**
### **🔹 Command:**
```sh
docker images
```
✔ Displays all **locally available images**.

### **🔹 Example Output:**
```
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
demo-app       latest    abcd12345678   2 hours ago     300MB
postgres       latest    efgh98765432   1 week ago      150MB
```
✔ **Key Columns**:
- **Repository** → Image name.
- **Tag** → Version of the image (`latest`, `v1.0`, etc.).
- **Image ID** → Unique identifier for the image.
- **Size** → Image size.

### **🔹 List Only Image IDs**
```sh
docker images -q
```
✔ Outputs only the **Image IDs**.

---

## **📌 2️⃣ Remove an Image**
### **🔹 Command:**
```sh
docker rmi <image_id>
```
✔ Deletes a **specific image**.

### **🔹 Example:**
```sh
docker rmi abcd12345678
```
✔ Removes the image **if no containers are using it**.

### **🔹 Force Delete an Image**
```sh
docker rmi -f <image_id>
```
✔ **Forcibly deletes** even if containers **depend on the image**.

---

## **📌 3️⃣ Remove All Unused Images**
### **🔹 Command:**
```sh
docker image prune
```
✔ Deletes **unused images** (**not associated with any containers**).

### **🔹 Remove ALL Unused Images (Without Prompt)**
```sh
docker image prune -a -f
```
✔ Removes **all unused images** (even those with no containers).

---

## **📌 4️⃣ Remove ALL Images**
### **🔹 Command:**
```sh
docker rmi $(docker images -q)
```
✔ **Deletes all images** in the system.

---

## **📌 5️⃣ Pull an Image from Docker Hub**
### **🔹 Command:**
```sh
docker pull <image_name>:<tag>
```
### **🔹 Example:**
```sh
docker pull nginx:latest
```
✔ Pulls the latest `nginx` image from Docker Hub.

---

## **📌 6️⃣ Push an Image to Docker Hub**
### **🔹 Command:**
```sh
docker push <username>/<image_name>:<tag>
```
### **🔹 Example:**
```sh
docker tag demo-app myrepo/demo-app:v1.0
docker push myrepo/demo-app:v1.0
```
✔ Pushes `demo-app` to **Docker Hub**.

---

## **📌 7️⃣ Check Image History**
### **🔹 Command:**
```sh
docker history <image_name>
```
### **🔹 Example:**
```sh
docker history demo-app
```
✔ Shows **layer-by-layer build history**.

---

## **📌 8️⃣ Inspect Image Details**
### **🔹 Command:**
```sh
docker inspect <image_id>
```
✔ Displays **detailed metadata** about an image.

---

## **✅ Summary: Key Docker Image Commands**
| **Task** | **Command** |
|----------|------------|
| **List Images** | `docker images` |
| **List Only Image IDs** | `docker images -q` |
| **Remove an Image** | `docker rmi <image_id>` |
| **Force Remove an Image** | `docker rmi -f <image_id>` |
| **Remove Unused Images** | `docker image prune` |
| **Remove All Images** | `docker rmi $(docker images -q)` |
| **Pull an Image** | `docker pull <image_name>:<tag>` |
| **Push an Image** | `docker push <username>/<image_name>:<tag>` |
| **Inspect an Image** | `docker inspect <image_id>` |
| **View Image History** | `docker history <image_name>` |

---

