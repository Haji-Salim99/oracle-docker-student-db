-- Run as APP_USER. Shows that the account can read but not change data.
SET ECHO ON
WHENEVER SQLERROR CONTINUE

-- Works: the student_reader role allows SELECT
SELECT COUNT(*) AS total_students FROM student_user.students;

-- Fails with ORA-01031 (insufficient privileges): no INSERT rights
INSERT INTO student_user.courses VALUES (106, 'Databases', 3);

-- Fails with ORA-01031 as well: no DELETE rights
DELETE FROM student_user.students WHERE student_id = 1;
