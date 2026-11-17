#!/usr/bin/env bash
# Restores the STUDENT_USER schema from a dump file made by backup.sh
# Usage: scripts/restore.sh backups/student_user_YYYYMMDD_HHMMSS.dmp
set -euo pipefail
export MSYS_NO_PATHCONV=1
cd "$(dirname "$0")/.."
source .env

dump=${1:?Give the path to a .dmp file, for example backups/student_user_20260101_120000.dmp}
file=$(basename "$dump")
name=${file%.dmp}

docker exec oracle-xe mkdir -p /opt/oracle/oradata/backup
docker cp "$dump" "oracle-xe:/opt/oracle/oradata/backup/${file}"

# REPLACE drops and recreates tables that still exist, and recreates any that were dropped.
# EXCLUDE=USER skips recreating the account itself, which already exists after setup.sh
status=0
docker exec oracle-xe impdp "system/${ORACLE_PASSWORD}@//localhost/XEPDB1" \
  SCHEMAS=student_user DIRECTORY=backup_dir \
  DUMPFILE="${file}" LOGFILE="${name}_import.log" \
  TABLE_EXISTS_ACTION=REPLACE EXCLUDE=USER || status=$?

# impdp exits with 5 when it finishes with warnings
if [ "$status" -ne 0 ] && [ "$status" -ne 5 ]; then
  echo "Import failed (exit code $status)" >&2
  exit "$status"
fi

echo "Restore finished. Row counts:"
scripts/run-sql.sh student_user 08_row_counts.sql
