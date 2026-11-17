-- Run as STUDENT_USER. Quick check used before and after a restore.
SET HEADING ON
SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL SELECT 'courses', COUNT(*) FROM courses
UNION ALL SELECT 'enrollments', COUNT(*) FROM enrollments;
