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
