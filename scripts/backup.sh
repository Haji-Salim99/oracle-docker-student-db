#!/usr/bin/env bash
# Exports the STUDENT_USER schema with Data Pump and copies the dump file to ./backups
set -euo pipefail
export MSYS_NO_PATHCONV=1
cd "$(dirname "$0")/.."
source .env

name="student_user_$(date +%Y%m%d_%H%M%S)"

docker exec oracle-xe mkdir -p /opt/oracle/oradata/backup
docker exec oracle-xe expdp "system/${ORACLE_PASSWORD}@//localhost/XEPDB1" \
  SCHEMAS=student_user DIRECTORY=backup_dir \
  DUMPFILE="${name}.dmp" LOGFILE="${name}_export.log"

mkdir -p backups
docker cp "oracle-xe:/opt/oracle/oradata/backup/${name}.dmp" backups/
docker cp "oracle-xe:/opt/oracle/oradata/backup/${name}_export.log" backups/

echo "Backup saved to backups/${name}.dmp"
