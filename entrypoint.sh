#!/bin/bash
set -e

# Wait for PostgreSQL using environment variables
until pg_isready -h $DB_HOST -U $DB_USER; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "PostgreSQL is up - executing command"

# Create and migrate database
bundle install
bundle exec rails db:prepare

exec "$@"
