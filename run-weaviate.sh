#!/bin/bash

# Variables for easier management
COMPOSE_PROFILE="weaviate"
PRIMARY_NODE="weaviate-node-1"
ALL_NODES=("weaviate-node-1" "weaviate-node-2" "weaviate-node-3")
PRIMARY_PORT="8080"  # The exposed port of the primary node

# Colors for better visibility
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_node_status() {
  local node=$1
  if docker ps | grep -q $node; then
    echo -e "${GREEN}✓${NC} $node is running"
    return 0
  else
    echo -e "${RED}✗${NC} $node is not running"
    return 1
  fi
}

case "$1" in
  start)
    echo -e "${YELLOW}Starting Weaviate cluster...${NC}"
    # Start the entire cluster with the weaviate profile
    docker compose --profile $COMPOSE_PROFILE up -d

    # Wait a moment for containers to initialize
    sleep 3

    # Check status of all nodes
    echo -e "\n${YELLOW}Cluster status:${NC}"
    all_running=true
    for node in "${ALL_NODES[@]}"; do
      if ! check_node_status $node; then
        all_running=false
      fi
    done

    if $all_running; then
      echo -e "\n${GREEN}Weaviate cluster is fully operational!${NC}"
      echo -e "Primary node is available at ${GREEN}http://localhost:$PRIMARY_PORT${NC}"
      echo -e "Additional nodes at http://localhost:8081 and http://localhost:8082"
    else
      echo -e "\n${RED}Some nodes failed to start. Check docker logs for details:${NC}"
      echo -e "  docker logs weaviate-node-1"
    fi
    ;;

  stop)
    echo -e "${YELLOW}Stopping Weaviate cluster...${NC}"
    # Stop all containers with the weaviate profile
    docker compose --profile $COMPOSE_PROFILE stop
    echo -e "${GREEN}Weaviate cluster stopped${NC}"
    ;;

  restart)
    echo -e "${YELLOW}Restarting Weaviate cluster...${NC}"
    docker compose --profile $COMPOSE_PROFILE restart

    # Wait a moment for containers to restart
    sleep 5

    # Check if all nodes are running
    echo -e "\n${YELLOW}Cluster status after restart:${NC}"
    all_running=true
    for node in "${ALL_NODES[@]}"; do
      if ! check_node_status $node; then
        all_running=false
      fi
    done

    if $all_running; then
      echo -e "\n${GREEN}Weaviate cluster successfully restarted!${NC}"
    else
      echo -e "\n${RED}Some nodes failed to restart. Check docker logs for details${NC}"
    fi
    ;;

  status)
    echo -e "${YELLOW}Weaviate cluster status:${NC}"

    # Check if any nodes are running
    any_running=false
    for node in "${ALL_NODES[@]}"; do
      if check_node_status $node; then
        any_running=true
      fi
    done

    if $any_running; then
      # If at least one node is running, show cluster health
      echo -e "\n${YELLOW}Cluster health check:${NC}"
      if docker ps | grep -q $PRIMARY_NODE; then
        # Use curl to check primary node health
        echo -e "\nQuerying primary node health endpoint..."
        HEALTH_STATUS=$(curl -s http://localhost:$PRIMARY_PORT/v1/.well-known/ready || echo "Failed to connect")

        if [[ $HEALTH_STATUS == *"true"* ]]; then
          echo -e "${GREEN}Cluster is healthy!${NC}"
        else
          echo -e "${RED}Cluster may not be fully operational${NC}"
          echo "Health check response: $HEALTH_STATUS"
        fi
      else
        echo -e "${RED}Primary node ($PRIMARY_NODE) is not running - cluster is incomplete${NC}"
      fi
    else
      echo -e "${RED}Weaviate cluster is not running${NC}"
    fi
    ;;

  logs)
    node="${2:-$PRIMARY_NODE}"  # Default to primary node if none specified
    echo -e "${YELLOW}Showing logs for $node...${NC}"

    if [[ " ${ALL_NODES[@]} " =~ " ${node} " ]]; then
      docker logs --tail 100 -f $node
    else
      echo -e "${RED}Invalid node name: $node${NC}"
      echo "Available nodes: ${ALL_NODES[@]}"
    fi
    ;;

  *)
    echo -e "${YELLOW}Weaviate Cluster Management Script${NC}"
    echo -e "Usage: $0 {start|stop|restart|status|logs [node]|prune}"
    echo
    echo "Commands:"
    echo "  start    - Start all Weaviate cluster nodes"
    echo "  stop     - Stop all Weaviate cluster nodes"
    echo "  restart  - Restart all Weaviate cluster nodes"
    echo "  status   - Show status of all cluster nodes"
    echo "  logs     - Show logs for a specific node (default: primary node)"
    exit 1
    ;;
esac
