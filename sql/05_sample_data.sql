-- Run as STUDENT_USER
SET ECHO ON

INSERT INTO courses VALUES (101, 'Introduction to Computer Science', 4);
INSERT INTO courses VALUES (102, 'Calculus I', 3);
INSERT INTO courses VALUES (103, 'Modern World History', 3);
INSERT INTO courses VALUES (104, 'Physics: Mechanics', 4);
INSERT INTO courses VALUES (105, 'Digital Marketing', 2);

INSERT INTO students (student_id, first_name, last_name, date_of_birth, email)
  VALUES (1, 'Amina', 'Mussa', DATE '2003-04-12', 'amina.mussa@example.com');
INSERT INTO students (student_id, first_name, last_name, date_of_birth, email)
  VALUES (2, 'Baraka', 'Mwakyusa', DATE '2002-09-30', 'baraka.m@example.com');
INSERT INTO students (student_id, first_name, last_name, date_of_birth, email)
  VALUES (3, 'Neema', 'Kimaro', DATE '2004-01-08', 'neema.kimaro@example.com');
INSERT INTO students (student_id, first_name, last_name, date_of_birth, email)
  VALUES (4, 'Juma', 'Ali', DATE '2003-11-21', 'juma.ali@example.com');

INSERT INTO enrollments (student_id, course_id, grade) VALUES (1, 101, 'A');
INSERT INTO enrollments (student_id, course_id, grade) VALUES (1, 102, 'B+');
INSERT INTO enrollments (student_id, course_id, grade) VALUES (2, 101, 'B');
INSERT INTO enrollments (student_id, course_id, grade) VALUES (3, 104, NULL);
INSERT INTO enrollments (student_id, course_id, grade) VALUES (4, 105, 'C');
INSERT INTO enrollments (student_id, course_id, grade) VALUES (4, 103, NULL);

COMMIT;
