#!/bin/bash

chmod +x ./devops/compose/up.sh

echo "Cleaning up stopped Docker containers..."
docker container prune -f

echo "Starting Docker containers..."
docker compose up -d

echo "Docker containers are up and running."

echo "Starting Sidekiq in the Rails app container..."
docker compose exec web bundle exec sidekiq

echo "Sidekiq is now running."
