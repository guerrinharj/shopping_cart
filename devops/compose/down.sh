chmod +x ./devops/compose/down.sh

echo "Stopping and removing Docker containers..."
docker compose down --remove-orphans

echo "Removing stale PIDs..."
rm -rf tmp/pids

echo "All services have been stopped and removed."