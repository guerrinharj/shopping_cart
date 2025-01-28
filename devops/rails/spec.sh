#!/bin/bash

chmod +x ./devops/rails/spec.sh

docker compose exec web ./bin/rails spec