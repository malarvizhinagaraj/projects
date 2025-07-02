CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT NOT NULL
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert Students
INSERT INTO Students (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666'),
('Charlie', 'charlie@example.com', '7778889999');

-- Insert Courses
INSERT INTO Courses (CourseName, Credits)
VALUES
('Database Systems', 3),
('Operating Systems', 4),
('Data Structures', 3),
('Computer Networks', 3);

-- Insert Enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
VALUES
(1, 1, '2025-06-10'),  -- Alice in Database Systems
(1, 2, '2025-06-11'),  -- Alice in Operating Systems
(2, 1, '2025-06-12'),  -- Bob in Database Systems
(2, 3, '2025-06-13'),  -- Bob in Data Structures
(3, 1, '2025-06-14'),  -- Charlie in Database Systems
(3, 2, '2025-06-15'),  -- Charlie in Operating Systems
(3, 3, '2025-06-16');  -- Charlie in Data Structures

SELECT c.CourseID, c.CourseName
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.CourseID IS NULL;


SELECT s.StudentID, s.Name, COUNT(e.EnrollmentID) AS EnrolledCourses
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING COUNT(e.EnrollmentID) > 2;
