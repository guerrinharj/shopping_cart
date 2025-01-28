chmod +x ./devops/compose/exec.sh

echo "Starting an interactive shell in the web container."
docker compose exec web bash
