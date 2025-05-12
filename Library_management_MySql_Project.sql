-- Part A: Database & Table Creation

-- Create the UniversityDB database
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dob DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Create Professors table
CREATE TABLE Professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Part B: Data Insertion

-- Insert departments
INSERT INTO Departments (name) VALUES ('Computer Science'), ('Mechanical'), ('Electrical');

-- Insert students
INSERT INTO Students ( first_name, last_name, email, dob, department_id) VALUES
('Suraj', 'Singh', 'suraj@example.com', '1992-01-26', 1),
('shiwani', 'Kumari', 'shiwani@example.com', '2001-07-02', 2),
('Chandni', 'Parween', 'chandni@example.com', '2000-12-15', 3),
('Divya', 'Sinha', 'divya@example.com', '2002-07-25', 1),
('Eva', 'Garg', 'eva@example.com', '2001-03-30', 2),
('Faiz', 'Ali', 'faiz@example.com', '2000-11-05', 3),
('Gourav', 'Das', 'gaurav@example.com', '2002-06-18', 1),
('Hari', 'vatsa', 'hari@example.com', '2001-08-14', 2),
('Isha', 'mishra', 'isha@example.com', '2003-01-22', 3),
('Javed', 'Ali', 'javed@example.com', '2000-04-19', 1);

-- Insert courses
INSERT INTO Courses (course_name, department_id) VALUES
('Database Systems', 1),
('Thermodynamics', 2),
('Power Electronics', 3),
('AIPA', 1),
('Machine Design', 2);

-- Insert professors
INSERT INTO Professors (name, department_id) VALUES
('Dr. Richard Feynman', 1),
('Dr. Nikola Tesla', 3);

-- Insert enrollments
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-02-15'),
(2, 2, '2024-02-16'),
(3, 3, '2024-02-17'),
(4, 4, '2024-02-18'),
(5, 5, '2024-02-19');

--  Part C: Basic Queries

-- Display all students
SELECT * FROM Students;

-- List all courses from the "Computer Science" department
SELECT course_name FROM Courses
WHERE department_id = (SELECT department_id FROM Departments WHERE name = 'Computer Science');

-- Find all students enrolled in the "AIPA" course
SELECT s.first_name, s.last_name FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'AIPA';

-- Show the names of all professors in the "Mechanical" department
SELECT name FROM Professors
WHERE department_id = (SELECT department_id FROM Departments WHERE name = 'Mechanical');

-- Display the names of students and the courses they are enrolled in
SELECT s.first_name, s.last_name, c.course_name FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- Part D: Update & Delete

-- Update the email of a student with student_id = 2
UPDATE Students SET email = 'bob.johnson@university.com' WHERE student_id = 2;

-- Delete a course with course_id = 3
DELETE FROM Enrollments WHERE course_id = 3;
DELETE FROM Courses WHERE course_id = 3;

-- Change the department of a professor to "Electrical"
UPDATE Professors SET department_id = (SELECT department_id FROM Departments WHERE name = 'Electrical') WHERE professor_id = 1;

-- Part E: Aggregate Functions

-- Count the total number of students in each department
SELECT d.name AS department_name, COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Find the total number of courses offered by each department
SELECT d.name AS department_name, COUNT(c.course_id) AS total_courses
FROM Departments d
LEFT JOIN Courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Find the most popular course (the course with the highest number of enrollments)
SELECT c.course_name, COUNT(e.enrollment_id) AS total_enrollments
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
ORDER BY total_enrollments DESC
LIMIT 1;
