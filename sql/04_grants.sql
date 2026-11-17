-- Run as STUDENT_USER. Gives the read-only role access to the tables.
SET ECHO ON

GRANT SELECT ON students    TO student_reader;
GRANT SELECT ON courses     TO student_reader;
GRANT SELECT ON enrollments TO student_reader;
