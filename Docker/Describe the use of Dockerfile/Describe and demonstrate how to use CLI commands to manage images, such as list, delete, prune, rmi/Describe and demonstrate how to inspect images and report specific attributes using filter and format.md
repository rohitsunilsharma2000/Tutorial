# **🔹 Inspecting Docker Images and Extracting Specific Attributes Using Filters & Formatting** 🚀  

## **✅ Overview**
Docker provides **CLI commands** to **inspect images and extract specific details** efficiently using **filters (`--filter`)** and **custom formatting (`--format`)**.

### **Why Inspect Images?**
✅ **Extract metadata** (ID, size, creation date, labels).  
✅ **Filter specific images** (by repository, dangling state, labels).  
✅ **Format output** for **better readability & scripting**.

---

## **📌 1️⃣ Inspect an Image (`docker inspect`)**
### **🔹 Command:**
```sh
docker inspect <image_id>
```
✔ Displays **detailed JSON metadata** of an image.

### **🔹 Example:**
```sh
docker inspect demo-app
```
✔ Outputs detailed **metadata**, including:
- **Image ID**
- **Creation date**
- **Size**
- **Environment variables**
- **Exposed ports**

---

## **📌 2️⃣ Extract Specific Attributes (`--format`)**
Use `--format` with `docker inspect` to **extract** specific fields.

### **🔹 Get Image ID**
```sh
docker inspect --format='{{.Id}}' demo-app
```
✔ Returns **only the Image ID**.

### **🔹 Get Image Size**
```sh
docker inspect --format='{{.Size}}' demo-app
```
✔ Displays the **image size in bytes**.

### **🔹 Get Creation Date**
```sh
docker inspect --format='{{.Created}}' demo-app
```
✔ Shows the **image creation timestamp**.

### **🔹 Get Entrypoint**
```sh
docker inspect --format='{{.Config.Entrypoint}}' demo-app
```
✔ Extracts the **entrypoint command**.

### **🔹 Get Environment Variables**
```sh
docker inspect --format='{{json .Config.Env}}' demo-app | jq
```
✔ Lists **environment variables**.

---

## **📌 3️⃣ Filtering Images (`docker images --filter`)**
### **🔹 List Only Images Without a Repository (Dangling Images)**
```sh
docker images --filter "dangling=true"
```
✔ Shows **unused images** that can be removed.

### **🔹 List Images by Label**
If an image has a label (`version=1.0`):
```sh
docker images --filter "label=version=1.0"
```
✔ Displays only **images with that label**.

### **🔹 List Images by Name**
```sh
docker images --filter "reference=nginx"
```
✔ Shows **all versions** of the `nginx` image.

---

## **📌 4️⃣ Custom Output Formatting (`--format`)**
### **🔹 Display Only Image ID and Size**
```sh
docker images --format "table {{.ID}}\t{{.Size}}"
```
✔ Outputs in a **table format**.

### **🔹 List Only Repository and Tag**
```sh
docker images --format "table {{.Repository}}\t{{.Tag}}"
```
✔ Shows only the **name and tag** of each image.

---

## **✅ Summary: Inspecting & Filtering Docker Images**
| **Task** | **Command** |
|----------|------------|
| **Inspect full image details** | `docker inspect demo-app` |
| **Get only Image ID** | `docker inspect --format='{{.Id}}' demo-app` |
| **Get Image Size** | `docker inspect --format='{{.Size}}' demo-app` |
| **List only dangling images** | `docker images --filter "dangling=true"` |
| **Filter images by label** | `docker images --filter "label=version=1.0"` |
| **Display Image ID & Size** | `docker images --format "table {{.ID}}\t{{.Size}}"` |

---
These **filtering and formatting techniques** make Docker image management **faster and more efficient**! 🚀🔥  

Here is a **Bash script** to automate **Docker image filtering and inspection**. 🚀  

### **📌 Features:**
✅ List all images with size and creation date.  
✅ Filter images by **name, tag, or label**.  
✅ Show **dangling images** for cleanup.  
✅ Inspect a specific image for **ID, size, entrypoint**.  

---

## **🔹 Script: `docker_image_manager.sh`**
```bash
#!/bin/bash

# Function to list all images with size and creation date
list_images() {
    echo "🔍 Listing all Docker images..."
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedAt}}"
}

# Function to filter images by name
filter_by_name() {
    read -p "Enter image name to filter: " image_name
    docker images --filter "reference=$image_name" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
}

# Function to filter images by label
filter_by_label() {
    read -p "Enter label key=value (e.g., version=1.0): " label
    docker images --filter "label=$label" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
}

# Function to show dangling images
list_dangling_images() {
    echo "🗑️  Listing dangling (unused) images..."
    docker images --filter "dangling=true" --format "table {{.ID}}\t{{.Size}}"
}

# Function to inspect an image
inspect_image() {
    read -p "Enter image name or ID to inspect: " image_name
    echo "🔍 Inspecting image: $image_name"
    docker inspect --format='
    Image ID: {{.Id}}
    Size: {{.Size}} bytes
    Entrypoint: {{.Config.Entrypoint}}
    Created: {{.Created}}
    ' $image_name
}

# Menu options
while true; do
    echo "===================================="
    echo " 🛠️  Docker Image Manager Script 🛠️  "
    echo "===================================="
    echo "1. List all images"
    echo "2. Filter images by name"
    echo "3. Filter images by label"
    echo "4. Show dangling images"
    echo "5. Inspect an image"
    echo "6. Exit"
    echo "===================================="
    
    read -p "Select an option (1-6): " choice
    
    case $choice in
        1) list_images ;;
        2) filter_by_name ;;
        3) filter_by_label ;;
        4) list_dangling_images ;;
        5) inspect_image ;;
        6) echo "Exiting..."; exit ;;
        *) echo "❌ Invalid option. Please try again." ;;
    esac
done
```

---

## **📌 How to Use This Script**
### **Step 1: Save the Script**
```sh
nano docker_image_manager.sh
```
Paste the script and **save the file (`Ctrl + X`, `Y`, Enter)**.

### **Step 2: Make the Script Executable**
```sh
chmod +x docker_image_manager.sh
```

### **Step 3: Run the Script**
```sh
./docker_image_manager.sh
```

---

## **✅ What This Script Can Do**
| **Feature** | **Command in Script** |
|------------|-----------------------|
| List all images | `docker images --format` |
| Filter images by name | `docker images --filter "reference=..."` |
| Filter images by label | `docker images --filter "label=..."` |
| Show dangling images | `docker images --filter "dangling=true"` |
| Inspect an image | `docker inspect --format` |

---
