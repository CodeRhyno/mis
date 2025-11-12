# User Management System

A comprehensive Ruby on Rails application for managing users, records, permissions, circles, and branches with role-based access control.

## Features

- **User Management**: Create, edit, delete, suspend, and activate users
- **Role-Based Access Control**: Admin, Circle Admin, Maker, and Checker roles
- **Record Management**: Create and manage records with verification workflow
- **Permission System**: Fine-grained permissions for users and records
- **Circle & Branch Management**: Organize users and records by circles and branches
- **Bootstrap UI**: Modern, responsive interface

## Prerequisites

- Docker
- Docker Compose

## Installation

1. Clone this repository
2. Navigate to the project directory
3. Build and start the containers:

```bash
docker compose build
docker compose up -d
```

4. Create and setup the database:

```bash
docker compose run web rails db:create db:migrate db:seed
```

5. Access the application at `http://localhost:3000`

## Default Credentials

- Admin: `admin@example.com` / `password123`
- Circle Admin: `circle_admin@example.com` / `password123`
- Maker: `maker@example.com` / `password123`
- Checker: `checker@example.com` / `password123`

## User Roles

### Admin
- Full system access
- Manage all users, records, permissions, circles, and branches
- View system-wide statistics

### Circle Admin
- Manage branches within their assigned circle
- View circle-level records and statistics

### Maker
- Create records with documents
- Upload and manage their own records
- Cannot verify records

### Checker
- Verify records created by makers
- Object to records with reasons
- View unverified records in their branch

## Development

To run Rails commands:

```bash
docker compose run web rails console
docker compose run web rails db:migrate
```

To view logs:

```bash
docker compose logs -f web
```

## Project Structure

- `app/models/` - ActiveRecord models
- `app/controllers/` - Controllers for handling requests
- `app/views/` - ERB templates with Bootstrap styling
- `db/migrate/` - Database migrations
- `config/routes.rb` - Application routes

## License

MIT
