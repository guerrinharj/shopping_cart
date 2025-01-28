chmod +x ./devops/rails/restart.sh

echo "Running database commands"
docker compose run web bundle install
docker compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web rails db:drop 
docker compose run web rails db:create
docker compose run web rails db:migrate 
docker compose run web rails db:seed