# README Patient Management

This README documents the necessary steps to get the **Patient Management** Rails application up and running.

## Ruby version
- Ruby 3.4.5

## Rails version
- Rails 8.0.3

## System dependencies
- PostgreSQL 17.6
- Redis 8.0

## Configuration

Make sure you have Ruby installed (3.4.5) along with Rails 8.0.3. You'll also need PostgreSQL 17.6 and Redis 8.0 installed and running.

## Database creation

Create the PostgreSQL database as configured in `config/database.yml`.

Commands to create and setup the database:
```
rails db:create
rails db:migrate
```

## Database initialization

If you have seeds, run:
`rails db:seed`

## Services (job queues, cache servers, search engines, etc.)

This app uses Redis 8.0 for caching and job queuing.

Make sure Redis server is installed and running:

## How to install PostgreSQL 17 on Ubuntu

1. Update package index and install required packages:
`sudo apt update`
2. Add PostgreSQL 17 repository:
`sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'`
3. Import repository signing key: 
`curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg`
4. Update package list:
`sudo apt update`
5. Install PostgreSQL 17:
`sudo apt install postgresql-17`

6. Start and enable PostgreSQL service:

```
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

7. Verify installation:

psql --version

## How to install dependencies on Ubuntu
```
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

### MacOS (using Homebrew)
```
brew update
brew install postgresql redis
brew services start postgresql
brew services start redis
```

## How to run the application locally

### Prerequisites

- Docker and Docker Compose installed on your machine
- `.env.development` file with environment variables configured

### Steps

1. Build and start the containers with:
`docker-compose --env-file .env.development up --build -d`
2. Run database setup (migrations and seed) inside the web container (if needed):
`docker-compose exec web bin/rails db:setup`
3. Access the Rails application at [http://localhost:3000](http://localhost:3000)

### Alternative: run Rails server directly (without Docker)

Make sure you have Ruby and dependencies installed, then run:
`bin/rails server`
