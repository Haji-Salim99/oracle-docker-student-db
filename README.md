# Oracle Database on Docker: Student Schema

Oracle Database 21c Express Edition running in Docker, with a small student records schema. The scripts cover the usual admin work: creating users and roles, building and changing tables, loading and editing data, and backing up and restoring the schema with Oracle Data Pump.

I first set this up on an Ubuntu virtual machine (VirtualBox) and worked through it by hand in SQL*Plus. This repo turns those steps into scripts so the whole thing can be run again from scratch.

## What's in it

```
docker-compose.yml   Oracle XE 21c (gvenzl/oracle-xe:21-slim)
.env.example         passwords, copy to .env
sql/
  01_users_and_roles.sql   schema owner, read-only role, app account, backup directory
  02_create_tables.sql     students, courses, enrollments
  03_alter_tables.sql      add email and grade columns, widen last_name
  04_grants.sql            SELECT on all tables to the read-only role
  05_sample_data.sql       courses, students, enrollments
  06_update_delete.sql     updates, a delete, and a report joining all three tables
  07_check_app_user.sql    app_user can read but not insert or delete
  08_row_counts.sql        row counts, used to check a restore
  09_simulate_data_loss.sql  drops a table and deletes rows on purpose
scripts/
  setup.sh      runs 01 to 07 in order
  backup.sh     Data Pump export of the schema to ./backups
  restore.sh    Data Pump import from a dump file
  run-sql.sh    runs any file from sql/ as a given user
```

## Schema

| Table | Columns |
|---|---|
| `students` | student_id (PK), first_name, last_name, date_of_birth, email (unique), created_at |
| `courses` | course_id (PK), course_name, credits (must be above 0) |
| `enrollments` | enrollment_id (identity PK), student_id (FK), course_id (FK), enrolled_on, grade |

A student can only enroll in the same course once (unique key on student_id + course_id), and grades are limited to A, B+, B, C, D, E or F.

## Users and permissions

| Account | What it can do |
|---|---|
| `student_user` | Owns the tables. Can create tables, sequences and views. |
| `app_user` | Can log in and read the three tables through the `student_reader` role. Cannot insert, update or delete. |

Giving read access through a role rather than directly to the account means another reporting account only needs `GRANT student_reader TO new_user`.

## Running it

You need Docker, and a bash shell for the scripts (Linux, macOS, or Git Bash on Windows). The image is about 0.8 GB to download.

```bash
cp .env.example .env        # then change the passwords in .env
docker compose up -d
scripts/setup.sh
```

The first start takes a minute or two while Oracle creates the database. `setup.sh` waits until the container reports healthy before running anything.

To open SQL*Plus yourself:

```bash
docker exec -it oracle-xe sqlplus student_user/<password>@//localhost/XEPDB1
```

The database also listens on `localhost:1521` (service name `XEPDB1`), so tools like SQL Developer or DBeaver can connect to it.

## Backup and restore

Back up the schema:

```bash
scripts/backup.sh
# Backup saved to backups/student_user_20260214_101500.dmp
```

To test the restore, break the data first, then restore from the dump file:

```bash
scripts/run-sql.sh student_user 08_row_counts.sql          # students 4, courses 5, enrollments 5
scripts/run-sql.sh student_user 09_simulate_data_loss.sql  # drops enrollments, deletes 2 students
scripts/restore.sh backups/student_user_20260214_101500.dmp
```

`restore.sh` prints the row counts at the end, which should match the counts from before.

The export runs as SYSTEM in the `XEPDB1` pluggable database with `SCHEMAS=student_user`, so the dump holds the tables, constraints, data and grants for that schema. The import uses `TABLE_EXISTS_ACTION=REPLACE`, which recreates tables that were dropped and replaces the ones still there.

## Clean up

```bash
docker compose down       # stop, keep the data
docker compose down -v    # stop and delete the database volume
```
