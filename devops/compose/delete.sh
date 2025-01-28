chmod +x ./devops/compose/delete.sh

echo "Stopping and removing Docker containers..."
docker compose down --remove-orphans --volumes --rmi=all

echo "All services have been stopped and removed."