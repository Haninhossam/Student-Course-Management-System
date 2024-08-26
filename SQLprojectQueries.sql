--to run this code select each Queries separate and do execute
--Database Setup
CREATE DATABASE StudentCourseManagement;
--Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL
); 

--Instructors Table
CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
--Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT,
    instructor_id int FOREIGN KEY REFERENCES Instructors(instructor_id),
);

--Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT FOREIGN KEY REFERENCES Students(student_id),
    course_id INT FOREIGN KEY REFERENCES Courses(course_id),
    enrollment_date DATE NOT NULL
);
--Insert Students

INSERT INTO Students (first_name, last_name, email, date_of_birth)
VALUES 
('John', 'Doe', 'john.doe@email.com', '2001-05-14'),
('Jane', 'Smith', 'jane.smith@email.com', '2002-07-21'),
('Sam', 'Brown', 'sam.brown@email.com', '2000-11-30'),
('Emily', 'Davis', 'emily.davis@email.com', '1999-03-14'),
('Michael', 'Wilson', 'michael.wilson@email.com', '2003-12-05'),
('Sarah', 'Miller', 'sarah.miller@email.com', '2001-01-24'),
('Chris', 'Johnson', 'chris.johnson@email.com', '2000-09-17'),
('Ashley', 'Moore', 'ashley.moore@email.com', '2002-08-10'),
('Jessica', 'Taylor', 'jessica.taylor@email.com', '2001-04-29'),
('David', 'Anderson', 'david.anderson@email.com', '2003-06-18');

--Insert Courses
INSERT INTO Courses (course_name, course_description,instructor_id)
VALUES 
('Database Systems', 'Introduction to databases, SQL, and relational models','1'),
('Operating Systems', 'Study of operating system concepts and design','2'),
('Algorithms', 'Introduction to algorithms and data structures','3'),
('Software Engineering', 'Principles of software design and development','3'),
('Machine Learning', 'Introduction to machine learning concepts and techniques','1');

--Insert Instructors
INSERT INTO Instructors (first_name, last_name, email)
VALUES 
('Dr. Alan', 'Turing', 'alan.turing@email.com'),
('Dr. Grace', 'Hopper', 'grace.hopper@email.com'),
('Dr. Ada', 'Lovelace', 'ada.lovelace@email.com');

--Insert Enrollments
INSERT INTO Enrollments (student_id, course_id, enrollment_date)
VALUES 
(1, 1, '2024-01-15'),
(2, 2, '2024-01-16'),
(3, 3, '2024-01-17'),
(4, 4, '2024-01-18'),
(5, 5, '2024-01-19'),
(6, 1, '2024-01-20'),
(7, 2, '2024-01-21'),
(8, 3, '2024-01-22'),
(9, 4, '2024-01-23'),
(10, 5,'2024-01-24'),
(1, 2, '2024-01-25'),
(2, 3, '2024-01-26'),
(3, 4, '2024-01-27'),
(4, 5, '2024-01-28'),
(5, 1, '2024-01-29');

--Select All Students
SELECT * FROM Students;

--Select All Courses
SELECT * FROM Courses;


--Select All Enrollments with Student Names and Course Names
SELECT 
    e.enrollment_id, 
    s.first_name + ' ' + s.last_name AS student_name, 
    c.course_name, 
    e.enrollment_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;
GO
---Select Students Who Enrolled in a Specific Course
SELECT 
    s.first_name, 
    s.last_name, 
    c.course_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Machine Learning';
GO
--Select Courses with More Than 5 Students
SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 5;
GO
--Update a Student's Email
UPDATE Students
SET email = 'new.@email.com'
WHERE student_id = 1;
GO
--Delete a Course That No Students Are Enrolled In
DELETE FROM Courses
WHERE course_id NOT IN (SELECT course_id FROM Enrollments);
GO
--Calculate the Average Age of Students
SELECT 
    AVG(DATEDIFF(YEAR, date_of_birth, GETDATE())) AS average_age
FROM Students;
GO

--Find the Course with the Maximum Enrollments
SELECT TOP 1 
    c.course_name, 
    COUNT(e.student_id) AS enrollment_count
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY enrollment_count DESC;
GO


--List Courses Along with the Number of Students Enrolled
SELECT 
    c.course_name, 
    COUNT(e.student_id) AS student_count
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;
GO

--Select All Students with Their Enrolled Courses
SELECT 
    s.first_name + ' ' + s.last_name AS student_name, 
    c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
GO

--List All Instructors and Their Courses
SELECT 
    i.first_name + ' ' + i.last_name AS instructor_name, 
    c.course_name
FROM Instructors i
JOIN Courses c ON i.instructor_id = c.instructor_id;
GO

--Find Students Who Are Not Enrolled in Any Course
SELECT 
    s.first_name, 
    s.last_name
FROM Students s
WHERE s.student_id NOT IN (SELECT student_id FROM Enrollments);
GO

--Select Students Enrolled in More Than One Course
SELECT 
    s.first_name, 
    s.last_name
FROM Students s
WHERE s.student_id IN (
    SELECT student_id
    FROM Enrollments
    GROUP BY student_id
    HAVING COUNT(course_id) > 1
);
GO

--Find Courses Taught by a Specific Instructor
SELECT 
    course_name
FROM 
    Courses
WHERE 
    instructor_id = (
        SELECT 
            instructor_id 
        FROM 
            Instructors 
        WHERE
            last_name = 'Hopper'
    );


--Select the Top 3 Students with the Most Enrollments
SELECT TOP 3 
    s.first_name, 
    s.last_name, 
    COUNT(e.course_id) AS enrollment_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.first_name, s.last_name
ORDER BY enrollment_count DESC;
GO

----Use UNION to Combine Results of Two Different SELECT Queries
SELECT 
    first_name, 
    last_name
FROM Students
WHERE first_name LIKE 'A%'

UNION

SELECT 
    first_name, 
    last_name
FROM Instructors
WHERE first_name LIKE 'A%';
GO

--Create a Stored Procedure to Add a New Student
CREATE PROCEDURE AddStudent
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @DateOfBirth DATE
AS
BEGIN
    INSERT INTO Students (first_name, last_name, email, date_of_birth)
    VALUES (@FirstName, @LastName, @Email, @DateOfBirth);
END;
GO
--Create a Function to Calculate the Age of a Student Based on Their Date of Birth
CREATE FUNCTION CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DateOfBirth, GETDATE());
END;
GO

--Calculate the Total Number of Students
SELECT COUNT(*) AS total_students FROM Students;
GO

--Calculate the Average, Minimum, and Maximum Number of Enrollments Per Course
SELECT 
    AVG(enrollment_count) AS avg_enrollments,
    MIN(enrollment_count) AS min_enrollments,
    MAX(enrollment_count) AS max_enrollments
FROM (
    SELECT COUNT(student_id) AS enrollment_count
    FROM Enrollments
    GROUP BY course_id
) AS EnrollmentStats;
GO

--Create Aliases for Complex Column Names
SELECT 
    s.first_name + ' ' + s.last_name AS student_name, 
    c.course_name AS course_title
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
GO

--Use CASE to Categorize Students Based on Their Age
SELECT 
    first_name, 
    last_name,
    CASE 
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 20 THEN 'Teenager'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 20 AND 30 THEN 'Young Adult'
        ELSE 'Adult'
    END AS age_category
FROM Students;
GO
--Use EXISTS to Find Courses with At Least One Enrolled Student
SELECT 
    course_name
FROM Courses c
WHERE EXISTS (
    SELECT 1
    FROM Enrollments e
    WHERE e.course_id = c.course_id
);
GO

--Create Comments in SQL for Clarity
-- Select all students with their enrolled courses
SELECT 
    s.first_name + ' ' + s.last_name AS student_name, 
    c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;
GO

