#!/usr/bin/env bash
# Runs one SQL file inside the container.
# Usage: scripts/run-sql.sh <system|student_user|app_user> <file in sql/> [arguments]
set -euo pipefail
export MSYS_NO_PATHCONV=1   # stops Git Bash on Windows from rewriting /opt/... paths
cd "$(dirname "$0")/.."
source .env

user=$1
file=$2
shift 2

case "$user" in
  system)       password=$ORACLE_PASSWORD ;;
  student_user) password=$STUDENT_USER_PASSWORD ;;
  app_user)     password=$APP_USER_PASSWORD ;;
  *) echo "Unknown user: $user" >&2; exit 1 ;;
esac

# Stop on the first SQL error (07_check_app_user.sql turns this off on purpose)
printf 'WHENEVER SQLERROR EXIT SQL.SQLCODE\n@/opt/sql/%s %s\nEXIT\n' "$file" "$*" \
  | docker exec -i oracle-xe sqlplus -s -L "${user}/${password}@//localhost/XEPDB1"
