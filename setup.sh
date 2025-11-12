#!/bin/bash

echo "Setting up Rails User Management System..."

# Create necessary directories
mkdir -p app/controllers app/models app/views config db

# Build and start containers
docker compose build
docker compose up -d db

# Wait for database to be ready
echo "Waiting for database..."
sleep 5

# Create Rails app structure
docker compose run web rails new . --force --database=postgresql --skip-test
docker compose run web bundle install

# Run database setup
docker compose run web rails db:create
docker compose run web rails db:migrate

echo "Setup complete! Run 'docker compose up' to start the application"
