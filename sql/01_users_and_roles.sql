-- Run as SYSTEM in the XEPDB1 pluggable database.
-- Arguments: 1 = password for STUDENT_USER, 2 = password for APP_USER
SET VERIFY OFF
SET ECHO ON

-- Schema owner: owns the tables, can create objects
CREATE USER student_user IDENTIFIED BY "&1"
  DEFAULT TABLESPACE users
  QUOTA 100M ON users;

GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO student_user;

-- Read-only role for applications and reporting
CREATE ROLE student_reader;

-- Application account: can log in, gets read access only through the role
CREATE USER app_user IDENTIFIED BY "&2";
GRANT CREATE SESSION TO app_user;
GRANT student_reader TO app_user;

-- Folder inside the container used by Data Pump for backups
CREATE OR REPLACE DIRECTORY backup_dir AS '/opt/oracle/oradata/backup';
