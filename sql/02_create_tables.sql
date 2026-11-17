-- Run as STUDENT_USER
SET ECHO ON

CREATE TABLE students (
  student_id    NUMBER        PRIMARY KEY,
  first_name    VARCHAR2(50)  NOT NULL,
  last_name     VARCHAR2(50)  NOT NULL,
  date_of_birth DATE,
  created_at    DATE          DEFAULT SYSDATE NOT NULL
);

CREATE TABLE courses (
  course_id   NUMBER         PRIMARY KEY,
  course_name VARCHAR2(100)  NOT NULL,
  credits     NUMBER(2)      NOT NULL CHECK (credits > 0)
);

CREATE TABLE enrollments (
  enrollment_id NUMBER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_id    NUMBER  NOT NULL REFERENCES students (student_id),
  course_id     NUMBER  NOT NULL REFERENCES courses (course_id),
  enrolled_on   DATE    DEFAULT SYSDATE NOT NULL,
  CONSTRAINT uq_student_course UNIQUE (student_id, course_id)
);
