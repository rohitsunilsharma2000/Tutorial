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
