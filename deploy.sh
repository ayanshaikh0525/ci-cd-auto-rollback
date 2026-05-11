#!/bin/bash

APP_NAME="app"
IMAGE="ayanshaikh0525/devops-demo:latest"

echo "Saving current running version..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

CURRENT_IMAGE=$(docker inspect $APP_NAME \
--format='{{.Config.Image}}' 2>/dev/null)

if [ ! -z "$CURRENT_IMAGE" ]; then
    docker tag $CURRENT_IMAGE devops-demo:previous
fi

echo "Pulling new image..."

docker pull $IMAGE

echo "Stopping old container..."

docker stop $APP_NAME || true
docker rm $APP_NAME || true

echo "Starting new container..."

docker run -d \
  -p 80:3000 \
  --name $APP_NAME \
  $IMAGE

echo "Waiting for health check..."

sleep 10

STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
http://localhost/health)

if [ "$STATUS" != "200" ]; then

    echo "Health Check Failed!"

    ./rollback.sh

    exit 1
fi

echo "Deployment successful!"