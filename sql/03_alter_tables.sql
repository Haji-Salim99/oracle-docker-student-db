-- Run as STUDENT_USER. Changes made after the tables were first created.
SET ECHO ON

-- New column for contact email, must be unique
ALTER TABLE students ADD (email VARCHAR2(100));
ALTER TABLE students ADD CONSTRAINT uq_students_email UNIQUE (email);

-- Allow longer last names
ALTER TABLE students MODIFY (last_name VARCHAR2(80));

-- Record the final grade for each enrollment
ALTER TABLE enrollments ADD (grade VARCHAR2(2));
ALTER TABLE enrollments ADD CONSTRAINT ck_grade
  CHECK (grade IN ('A', 'B+', 'B', 'C', 'D', 'E', 'F'));
