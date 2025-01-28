#!/bin/bash

chmod +x ./devops/compose/down.sh

echo "Stopping Sidekiq process in the Rails app container..."
docker exec web pkill -f sidekiq

echo "Stopping and removing Docker containers..."
docker compose down --remove-orphans

echo "Removing stale PIDs..."
rm -rf tmp/pids

echo "All services have been stopped and removed."
