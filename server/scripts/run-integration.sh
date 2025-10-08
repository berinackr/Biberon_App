#!/usr/bin/env bash
# scripts/run-integration.sh

DIR="$(cd "$(dirname "$0")" && pwd)"
docker-compose -f docker-compose.integration.yml up -d
echo '🟡 - Waiting for database to be ready...'
$DIR/wait-for-it.sh "127.0.0.1:5432" -- echo '🟢 - Database is ready!'