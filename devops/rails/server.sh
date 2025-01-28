chmod +x ./devops/rails/server.sh

rm -rf tmp/pids

docker compose exec web bundle exec rails s -b '0.0.0.0' -p 3000
