# **🔹 Docker Registry Functions: Pushing, Pulling, and Managing Images** 🚀  

## **✅ What is a Docker Registry?**
A **Docker Registry** is a storage system where Docker images are stored, shared, and managed.  
Popular registries include:  
✅ **Docker Hub** (`hub.docker.com`)  
✅ **Amazon Elastic Container Registry (ECR)`  
✅ **Google Container Registry (GCR)**  
✅ **Azure Container Registry (ACR)**  
✅ **Self-hosted Registries** (`registry:2`)

---

## **📌 1️⃣ Key Docker Registry Functions**
| **Function** | **Command** |
|-------------|------------|
| **Login to a Registry** | `docker login <registry_url>` |
| **Tag an Image** | `docker tag <image> <registry>/<repository>:<tag>` |
| **Push an Image** | `docker push <registry>/<repository>:<tag>` |
| **Pull an Image** | `docker pull <registry>/<repository>:<tag>` |
| **List Images in Local Registry** | `docker images` |
| **Remove an Image from Local Machine** | `docker rmi <image_id>` |

---

## **📌 2️⃣ Demonstrating Docker Registry Functions**
### **🔹 Step 1: Login to a Docker Registry**
```sh
docker login
```
✔ Prompts for **username and password**.

For private registries:
```sh
docker login myregistry.com
```
✔ Logs into **a custom registry**.

---

### **🔹 Step 2: Tagging an Image for a Registry**
Before pushing, tag the image:
```sh
docker tag demo-app myrepo/demo-app:v1.0
```
✔ **Renames the image** to include the **repository name**.

For a private registry:
```sh
docker tag demo-app myregistry.com/myrepo/demo-app:v1.0
```

---

### **🔹 Step 3: Pushing an Image to a Registry**
```sh
docker push myrepo/demo-app:v1.0
```
For a private registry:
```sh
docker push myregistry.com/myrepo/demo-app:v1.0
```
✔ Uploads the image to the **remote registry**.

---

### **🔹 Step 4: Pulling an Image from a Registry**
```sh
docker pull myrepo/demo-app:v1.0
```
For private registry:
```sh
docker pull myregistry.com/myrepo/demo-app:v1.0
```
✔ Downloads the image to the **local machine**.

---

### **🔹 Step 5: Remove an Image from Local Machine**
```sh
docker rmi myrepo/demo-app:v1.0
```
✔ Deletes the image locally **without affecting the remote registry**.

---

## **📌 3️⃣ Setting Up a Private Docker Registry**
You can **self-host** a registry:
```sh
docker run -d -p 5000:5000 --name my-registry registry:2
```
✔ Creates a **private registry on `localhost:5000`**.

### **🔹 Push an Image to Your Private Registry**
```sh
docker tag demo-app localhost:5000/demo-app:v1.0
docker push localhost:5000/demo-app:v1.0
```
✔ The image is now stored in **your private registry**.

---

## **✅ Summary: Managing Images in a Registry**
| **Task** | **Command** |
|----------|------------|
| **Login to a registry** | `docker login` |
| **Tag an image** | `docker tag demo-app myrepo/demo-app:v1.0` |
| **Push an image** | `docker push myrepo/demo-app:v1.0` |
| **Pull an image** | `docker pull myrepo/demo-app:v1.0` |
| **Run a private registry** | `docker run -d -p 5000:5000 registry:2` |

---
This guide **simplifies image storage and management** in **Docker registries**! 🚀🔥  
### **🔹 Docker Registry Automation Script: Push, Pull, and Manage Images** 🚀  

This **Bash script** automates **logging in, tagging, pushing, pulling, and managing images** in a Docker registry.

---

## **📌 Features:**
✅ **Login to a Docker Registry**  
✅ **Tag an Image for a Registry**  
✅ **Push an Image to a Registry**  
✅ **Pull an Image from a Registry**  
✅ **List Available Images**  
✅ **Remove an Image Locally**  
✅ **Run a Private Docker Registry**  

---

## **🔹 Script: `docker_registry_manager.sh`**
```bash
#!/bin/bash

# Function to log in to a Docker registry
login_registry() {
    read -p "Enter registry URL (or press Enter for Docker Hub): " registry
    if [ -z "$registry" ]; then
        docker login
    else
        docker login "$registry"
    fi
}

# Function to tag an image
tag_image() {
    read -p "Enter local image name (e.g., demo-app): " local_image
    read -p "Enter target repository (e.g., myrepo/demo-app): " repo
    read -p "Enter tag (e.g., v1.0): " tag
    docker tag "$local_image" "$repo:$tag"
    echo "✅ Image tagged as $repo:$tag"
}

# Function to push an image to a registry
push_image() {
    read -p "Enter image to push (e.g., myrepo/demo-app:v1.0): " image
    docker push "$image"
    echo "✅ Image pushed to registry: $image"
}

# Function to pull an image from a registry
pull_image() {
    read -p "Enter image to pull (e.g., myrepo/demo-app:v1.0): " image
    docker pull "$image"
    echo "✅ Image pulled from registry: $image"
}

# Function to list available Docker images
list_images() {
    echo "🔍 Listing all Docker images..."
    docker images
}

# Function to remove a local Docker image
remove_image() {
    read -p "Enter image ID or name to remove: " image
    docker rmi "$image"
    echo "✅ Image removed: $image"
}

# Function to run a private Docker registry
run_private_registry() {
    echo "🚀 Running a private Docker registry on port 5000..."
    docker run -d -p 5000:5000 --name my-private-registry registry:2
    echo "✅ Private registry running at localhost:5000"
}

# Menu options
while true; do
    echo "===================================="
    echo " 🛠️  Docker Registry Manager 🛠️  "
    echo "===================================="
    echo "1. Login to a registry"
    echo "2. Tag an image"
    echo "3. Push an image"
    echo "4. Pull an image"
    echo "5. List all images"
    echo "6. Remove a local image"
    echo "7. Run a private registry"
    echo "8. Exit"
    echo "===================================="
    
    read -p "Select an option (1-8): " choice
    
    case $choice in
        1) login_registry ;;
        2) tag_image ;;
        3) push_image ;;
        4) pull_image ;;
        5) list_images ;;
        6) remove_image ;;
        7) run_private_registry ;;
        8) echo "Exiting..."; exit ;;
        *) echo "❌ Invalid option. Please try again." ;;
    esac
done
```

---

## **📌 How to Use This Script**
### **Step 1: Save the Script**
```sh
nano docker_registry_manager.sh
```
Paste the script and **save the file (`Ctrl + X`, `Y`, Enter)**.

### **Step 2: Make the Script Executable**
```sh
chmod +x docker_registry_manager.sh
```

### **Step 3: Run the Script**
```sh
./docker_registry_manager.sh
```

---

## **✅ What This Script Automates**
| **Task** | **Command in Script** |
|----------|-----------------------|
| **Login to a registry** | `docker login <registry>` |
| **Tag an image** | `docker tag demo-app myrepo/demo-app:v1.0` |
| **Push an image** | `docker push myrepo/demo-app:v1.0` |
| **Pull an image** | `docker pull myrepo/demo-app:v1.0` |
| **List all images** | `docker images` |
| **Remove a local image** | `docker rmi <image_id>` |
| **Run a private registry** | `docker run -d -p 5000:5000 registry:2` |

---