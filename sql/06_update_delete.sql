-- Run as STUDENT_USER. Day-to-day changes to the data.
SET ECHO ON
SET LINESIZE 120
COLUMN student FORMAT A20
COLUMN course FORMAT A35
COLUMN email FORMAT A30

-- A student changes email
UPDATE students SET email = 'neema.k@example.com' WHERE student_id = 3;

-- Grades come in
UPDATE enrollments SET grade = 'B' WHERE student_id = 3 AND course_id = 104;

-- A student drops a course
DELETE FROM enrollments WHERE student_id = 4 AND course_id = 103;

COMMIT;

-- Result: every enrollment with student and course names
SELECT s.first_name || ' ' || s.last_name AS student,
       c.course_name                      AS course,
       c.credits,
       e.grade
FROM   enrollments e
JOIN   students s ON s.student_id = e.student_id
JOIN   courses  c ON c.course_id  = e.course_id
ORDER  BY s.student_id, c.course_id;
