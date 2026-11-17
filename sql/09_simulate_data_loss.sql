-- Run as STUDENT_USER. Breaks the data on purpose so the restore can be tested.
SET ECHO ON

DROP TABLE enrollments PURGE;
DELETE FROM students WHERE student_id IN (3, 4);
COMMIT;
