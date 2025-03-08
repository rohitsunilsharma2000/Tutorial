# **🔹 Deploying a Docker Registry (Self-Hosted Private Registry)** 🚀  

## **✅ What is a Docker Registry?**
A **Docker Registry** is a storage system for Docker images. By default, Docker uses **Docker Hub**, but you can host a **private registry** for better control.

### **🔹 Why Use a Private Docker Registry?**
✅ **Store images privately** (No external access)  
✅ **Improve security** (Control who accesses images)  
✅ **Speed up deployments** (Local network access)  
✅ **Use with CI/CD** (Self-hosted image storage)  

---

## **📌 1️⃣ Deploy a Private Docker Registry**
You can run a **self-hosted registry** using Docker.

### **🔹 Step 1: Run the Registry Container**
```sh
docker run -d -p 5000:5000 --name my-private-registry registry:2
```
✔ Runs a **private registry on port 5000**.

### **🔹 Step 2: Verify the Registry is Running**
```sh
docker ps | grep my-private-registry
```
✔ Expected output:
```
CONTAINER ID   IMAGE      COMMAND     STATUS     PORTS
abcdef123456   registry   "/entrypoint.sh"   Up 2m    0.0.0.0:5000->5000/tcp
```

### **🔹 Step 3: Test the Registry**
List all images in the registry:
```sh
curl http://localhost:5000/v2/_catalog
```
✔ If empty, returns:
```json
{"repositories":[]}
```

---

## **📌 2️⃣ Push an Image to the Private Registry**
To store images, you must **tag and push** them.

### **🔹 Step 1: Tag an Image**
```sh
docker tag demo-app localhost:5000/demo-app:v1.0
```

### **🔹 Step 2: Push the Image**
```sh
docker push localhost:5000/demo-app:v1.0
```

### **🔹 Step 3: Verify the Image is Stored**
```sh
curl http://localhost:5000/v2/_catalog
```
✔ Expected output:
```json
{"repositories":["demo-app"]}
```

---

## **📌 3️⃣ Pull an Image from the Private Registry**
### **🔹 Step 1: Remove Local Image**
```sh
docker rmi localhost:5000/demo-app:v1.0
```

### **🔹 Step 2: Pull the Image from the Registry**
```sh
docker pull localhost:5000/demo-app:v1.0
```
✔ Confirms the **image is stored in the private registry**.

---

## **📌 4️⃣ Running a Registry with Persistent Storage**
By default, the registry **does not store data permanently**.  
To persist images, **mount a volume**.

```sh
docker run -d -p 5000:5000 --restart=always --name my-private-registry \
  -v /data/registry:/var/lib/registry registry:2
```
✔ This ensures images are **not lost after a container restart**.

---

## **📌 5️⃣ Secure the Private Registry with Authentication**
For security, enable **basic authentication**.

### **🔹 Step 1: Install `htpasswd` Tool**
```sh
apt install apache2-utils -y
```

### **🔹 Step 2: Create a Password File**
```sh
mkdir auth
htpasswd -Bbn myuser mypassword > auth/htpasswd
```

### **🔹 Step 3: Run the Registry with Authentication**
```sh
docker run -d -p 5000:5000 --restart=always --name my-secure-registry \
  -v /data/registry:/var/lib/registry \
  -v $(pwd)/auth:/auth \
  -e "REGISTRY_AUTH=basic" \
  -e "REGISTRY_AUTH_BASIC_REALM=Registry Realm" \
  -e "REGISTRY_AUTH_BASIC_HTPASSWD_PATH=/auth/htpasswd" \
  registry:2
```
✔ This enables **user authentication**.

### **🔹 Step 4: Login to the Private Registry**
```sh
docker login localhost:5000 -u myuser -p mypassword
```

✔ You can now **push and pull images securely**.

---

## **✅ Summary: Key Commands**
| **Task** | **Command** |
|----------|------------|
| **Run a private registry** | `docker run -d -p 5000:5000 --name my-private-registry registry:2` |
| **List stored images** | `curl http://localhost:5000/v2/_catalog` |
| **Tag an image** | `docker tag demo-app localhost:5000/demo-app:v1.0` |
| **Push an image** | `docker push localhost:5000/demo-app:v1.0` |
| **Pull an image** | `docker pull localhost:5000/demo-app:v1.0` |
| **Enable authentication** | `htpasswd -Bbn myuser mypassword > auth/htpasswd` |
| **Login to registry** | `docker login localhost:5000 -u myuser -p mypassword` |

---
This guide **sets up a secure private Docker registry** for **efficient image management**! 🚀🔥  

### **🔹 Automated Script for Deploying a Secure Private Docker Registry** 🚀  

This **Bash script** automates **setting up a private Docker registry** with:  
✅ **Persistent storage** (avoids data loss)  
✅ **Authentication** (prevents unauthorized access)  
✅ **Easy image management** (push, pull, list)  

---

## **📌 Features:**
✅ Deploys a **local Docker registry** (`localhost:5000`)  
✅ Creates **persistent storage** (`/data/registry`)  
✅ Enables **username & password authentication**  
✅ Supports **image tagging, pushing, and pulling**  

---

## **🔹 Script: `deploy_docker_registry.sh`**
```bash
#!/bin/bash

# Set variables
REGISTRY_PORT=5000
REGISTRY_NAME="my-secure-registry"
DATA_DIR="/data/registry"
AUTH_DIR="./auth"
USERNAME="myuser"
PASSWORD="mypassword"

# Function to install necessary packages
install_tools() {
    echo "🔹 Installing required tools..."
    apt update && apt install -y apache2-utils
}

# Function to create authentication credentials
setup_auth() {
    echo "🔹 Setting up authentication..."
    mkdir -p "$AUTH_DIR"
    htpasswd -Bbn "$USERNAME" "$PASSWORD" > "$AUTH_DIR/htpasswd"
}

# Function to start the secure Docker registry
start_registry() {
    echo "🚀 Deploying a secure Docker registry on port $REGISTRY_PORT..."
    mkdir -p "$DATA_DIR"
    
    docker run -d -p $REGISTRY_PORT:5000 --restart=always --name $REGISTRY_NAME \
        -v "$DATA_DIR":/var/lib/registry \
        -v "$AUTH_DIR":/auth \
        -e "REGISTRY_AUTH=basic" \
        -e "REGISTRY_AUTH_BASIC_REALM=Registry Realm" \
        -e "REGISTRY_AUTH_BASIC_HTPASSWD_PATH=/auth/htpasswd" \
        registry:2

    echo "✅ Private registry is running at http://localhost:$REGISTRY_PORT"
}

# Function to tag and push an image
push_image() {
    read -p "Enter the local image name (e.g., demo-app): " IMAGE_NAME
    read -p "Enter the version/tag (e.g., v1.0): " IMAGE_TAG

    REGISTRY_IMAGE="localhost:$REGISTRY_PORT/$IMAGE_NAME:$IMAGE_TAG"

    echo "🔹 Tagging image..."
    docker tag "$IMAGE_NAME" "$REGISTRY_IMAGE"

    echo "🔹 Logging in to registry..."
    docker login localhost:$REGISTRY_PORT -u "$USERNAME" -p "$PASSWORD"

    echo "🚀 Pushing image to registry..."
    docker push "$REGISTRY_IMAGE"

    echo "✅ Image successfully pushed: $REGISTRY_IMAGE"
}

# Function to pull an image from the registry
pull_image() {
    read -p "Enter image name to pull (e.g., demo-app:v1.0): " IMAGE_NAME

    REGISTRY_IMAGE="localhost:$REGISTRY_PORT/$IMAGE_NAME"

    echo "🔹 Logging in to registry..."
    docker login localhost:$REGISTRY_PORT -u "$USERNAME" -p "$PASSWORD"

    echo "🚀 Pulling image from registry..."
    docker pull "$REGISTRY_IMAGE"

    echo "✅ Image successfully pulled: $REGISTRY_IMAGE"
}

# Function to list stored images
list_images() {
    echo "🔍 Listing images in the private registry..."
    curl -s http://localhost:$REGISTRY_PORT/v2/_catalog | jq
}

# Function to stop and remove the registry
stop_registry() {
    echo "🛑 Stopping and removing the registry..."
    docker stop $REGISTRY_NAME && docker rm $REGISTRY_NAME
    echo "✅ Registry stopped and removed."
}

# Menu options
while true; do
    echo "===================================="
    echo " 🛠️  Secure Docker Registry Manager 🛠️  "
    echo "===================================="
    echo "1. Install required tools"
    echo "2. Deploy a secure Docker registry"
    echo "3. Push an image to the registry"
    echo "4. Pull an image from the registry"
    echo "5. List stored images"
    echo "6. Stop and remove the registry"
    echo "7. Exit"
    echo "===================================="
    
    read -p "Select an option (1-7): " choice
    
    case $choice in
        1) install_tools ;;
        2) setup_auth && start_registry ;;
        3) push_image ;;
        4) pull_image ;;
        5) list_images ;;
        6) stop_registry ;;
        7) echo "Exiting..."; exit ;;
        *) echo "❌ Invalid option. Please try again." ;;
    esac
done
```

---

## **📌 How to Use This Script**
### **Step 1: Save the Script**
```sh
nano deploy_docker_registry.sh
```
Paste the script and **save (`Ctrl + X`, `Y`, Enter)**.

### **Step 2: Make the Script Executable**
```sh
chmod +x deploy_docker_registry.sh
```

### **Step 3: Run the Script**
```sh
./deploy_docker_registry.sh
```

---

## **✅ What This Script Automates**
| **Task** | **Command in Script** |
|----------|-----------------------|
| **Install authentication tools** | `apt install -y apache2-utils` |
| **Set up authentication** | `htpasswd -Bbn myuser mypassword > auth/htpasswd` |
| **Deploy a private registry** | `docker run -d -p 5000:5000 --restart=always registry:2` |
| **Tag and push an image** | `docker tag demo-app localhost:5000/demo-app:v1.0 && docker push localhost:5000/demo-app:v1.0` |
| **Pull an image** | `docker pull localhost:5000/demo-app:v1.0` |
| **List stored images** | `curl -s http://localhost:5000/v2/_catalog | jq` |
| **Stop and remove registry** | `docker stop my-secure-registry && docker rm my-secure-registry` |

---

## **🚀 This script automates private Docker registry management!**
### **🔹 Automated Script for Managing Docker Registry: Search, Push, Sign, Pull, and Delete Images** 🚀  

This **Bash script** automates **searching, pushing, signing, pulling, and deleting images** in a Docker registry.

---

## **📌 Features:**
✅ **Search images** (Docker Hub & Private Registry)  
✅ **Push an image to a registry**  
✅ **Sign an image for security**  
✅ **Pull an image from a registry**  
✅ **Delete an image from a registry**  

---

## **🔹 Script: `docker_registry_manager.sh`**
```bash
#!/bin/bash

# Set registry URL (modify if using a private registry)
REGISTRY="localhost:5000"

# Function to search images in Docker Hub
search_docker_hub() {
    read -p "Enter search term: " term
    docker search "$term"
}

# Function to list images in private registry
list_registry_images() {
    echo "🔍 Searching images in the private registry..."
    curl -s http://$REGISTRY/v2/_catalog | jq
}

# Function to tag and push an image
push_image() {
    read -p "Enter local image name (e.g., demo-app): " IMAGE_NAME
    read -p "Enter version/tag (e.g., v1.0): " IMAGE_TAG

    REGISTRY_IMAGE="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

    echo "🔹 Tagging image..."
    docker tag "$IMAGE_NAME" "$REGISTRY_IMAGE"

    echo "🚀 Pushing image to registry..."
    docker push "$REGISTRY_IMAGE"

    echo "✅ Image successfully pushed: $REGISTRY_IMAGE"
}

# Function to sign and push an image with Docker Content Trust
sign_and_push_image() {
    export DOCKER_CONTENT_TRUST=1
    read -p "Enter image name to sign and push: " IMAGE_NAME
    read -p "Enter tag (e.g., v1.0): " IMAGE_TAG
    REGISTRY_IMAGE="$REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

    echo "🚀 Signing and pushing image..."
    docker push "$REGISTRY_IMAGE"

    echo "✅ Image signed and pushed: $REGISTRY_IMAGE"
}

# Function to pull an image from the registry
pull_image() {
    read -p "Enter image name to pull (e.g., demo-app:v1.0): " IMAGE_NAME
    REGISTRY_IMAGE="$REGISTRY/$IMAGE_NAME"

    echo "🚀 Pulling image from registry..."
    docker pull "$REGISTRY_IMAGE"

    echo "✅ Image successfully pulled: $REGISTRY_IMAGE"
}

# Function to delete an image from the registry
delete_image() {
    read -p "Enter image name to delete (e.g., demo-app): " IMAGE
    read -p "Enter tag (e.g., v1.0): " TAG

    # Get the manifest digest
    echo "🔍 Fetching image digest..."
    DIGEST=$(curl -s -I -X GET http://$REGISTRY/v2/$IMAGE/manifests/$TAG | grep -i "Docker-Content-Digest" | awk '{print $2}' | tr -d '\r')

    if [ -z "$DIGEST" ]; then
        echo "❌ Error: Image not found in the registry."
        return
    fi

    echo "🚀 Deleting image from registry..."
    curl -X DELETE "http://$REGISTRY/v2/$IMAGE/manifests/$DIGEST"

    echo "✅ Image successfully deleted: $IMAGE:$TAG"
}

# Menu options
while true; do
    echo "===================================="
    echo " 🛠️  Docker Registry Manager 🛠️  "
    echo "===================================="
    echo "1. Search images on Docker Hub"
    echo "2. List images in private registry"
    echo "3. Push an image to registry"
    echo "4. Sign and push an image"
    echo "5. Pull an image from registry"
    echo "6. Delete an image from registry"
    echo "7. Exit"
    echo "===================================="
    
    read -p "Select an option (1-7): " choice
    
    case $choice in
        1) search_docker_hub ;;
        2) list_registry_images ;;
        3) push_image ;;
        4) sign_and_push_image ;;
        5) pull_image ;;
        6) delete_image ;;
        7) echo "Exiting..."; exit ;;
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
Paste the script and **save (`Ctrl + X`, `Y`, Enter)**.

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
| **Search for images on Docker Hub** | `docker search nginx` |
| **List images in private registry** | `curl -s http://localhost:5000/v2/_catalog | jq` |
| **Tag and push an image** | `docker tag demo-app localhost:5000/demo-app:v1.0 && docker push localhost:5000/demo-app:v1.0` |
| **Sign and push an image** | `export DOCKER_CONTENT_TRUST=1 && docker push localhost:5000/demo-app:v1.0` |
| **Pull an image from a registry** | `docker pull localhost:5000/demo-app:v1.0` |
| **Delete an image from a registry** | `curl -X DELETE "http://localhost:5000/v2/demo-app/manifests/$TOKEN"` |

---
## **🚀 This script automates Docker registry management for efficiency!**
Would you like **an additional function to clean up old images automatically?** 😊