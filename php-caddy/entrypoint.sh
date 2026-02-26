#!/bin/sh
set -eu

echo "Starting PHP built-in server..."
exec php -S 0.0.0.0:8000 -t /app/public

exec "$@"
