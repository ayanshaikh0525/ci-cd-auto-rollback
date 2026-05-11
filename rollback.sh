#!/bin/bash

APP_NAME="app"

echo "Rolling back deployment..."

docker stop $APP_NAME || true
docker rm $APP_NAME || true

docker run -d \
  -p 80:3000 \
  --name $APP_NAME \
  ayanshaikh0525/devops-demo:previous

echo "Rollback completed successfully!"