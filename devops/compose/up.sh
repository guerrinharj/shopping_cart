chmod +x ./devops/compose/up.sh


echo "Cleaning up stopped Docker containers..."
docker container prune -f

echo "Starting Docker containers..."
docker compose up -d

echo "Docker containers are up and running."