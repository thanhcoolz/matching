#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait for MySQL to be ready
until netcat -z -v -w30 db 3306
do
  echo 'Waiting for MySQL...'
  sleep 1
done
echo "MySQL is up and running!"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
