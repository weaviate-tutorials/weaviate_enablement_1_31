#!/bin/bash

case "$1" in
  start)
    echo "Starting Weaviate..."
    docker compose --profile weaviate up -d weaviate
    echo "Weaviate is running at http://localhost:8080"
    ;;
  stop)
    echo "Stopping Weaviate..."
    docker compose stop weaviate
    ;;
  status)
    if docker ps | grep -q weaviate; then
      echo "Weaviate is running"
    else
      echo "Weaviate is not running"
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac
