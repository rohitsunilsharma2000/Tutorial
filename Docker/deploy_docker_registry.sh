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
