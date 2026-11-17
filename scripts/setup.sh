#!/usr/bin/env bash
# Creates the users, tables and sample data. Run once after "docker compose up -d".
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

echo "Waiting for the database to be ready (first start takes a minute or two)..."
until [ "$(docker inspect --format '{{.State.Health.Status}}' oracle-xe 2>/dev/null)" = "healthy" ]; do
  sleep 5
done

scripts/run-sql.sh system       01_users_and_roles.sql "$STUDENT_USER_PASSWORD" "$APP_USER_PASSWORD"
scripts/run-sql.sh student_user 02_create_tables.sql
scripts/run-sql.sh student_user 03_alter_tables.sql
scripts/run-sql.sh student_user 04_grants.sql
scripts/run-sql.sh student_user 05_sample_data.sql
scripts/run-sql.sh student_user 06_update_delete.sql
scripts/run-sql.sh app_user     07_check_app_user.sql

echo "Setup finished."
