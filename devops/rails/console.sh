#!/bin/bash

chmod +x ./devops/rails/console.sh

docker compose exec web ./bin/rails console