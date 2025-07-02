CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(100)
);
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    Credits INT
);
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    Date DATE,
    Status VARCHAR(10),  -- 'Present' or 'Absent'
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
INSERT INTO Students VALUES
(1, 'Alice', 'CS'),
(2, 'Bob', 'Math'),
(3, 'Charlie', 'Physics');

INSERT INTO Courses VALUES
(101, 'Data Structures', 4),
(102, 'Calculus', 3);


INSERT INTO Attendance (StudentID, CourseID, Date, Status) VALUES
(1, 101, '2025-07-01', 'Present'),
(2, 101, '2025-07-01', 'Absent'),
(3, 101, '2025-07-01', 'Present'),
(1, 101, '2025-07-02', 'Present'),
(2, 101, '2025-07-02', 'Present'),
(3, 101, '2025-07-02', 'Absent'),
(1, 101, '2025-07-03', 'Present'),
(2, 101, '2025-07-03', 'Present'),
(3, 101, '2025-07-03', 'Present');


SELECT S.Name, A.CourseID,
ROUND((SUM(CASE WHEN A.Status = 'Present' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Attendance_Percentage
FROM Attendance A
JOIN Students S ON A.StudentID = S.StudentID
GROUP BY A.CourseID, A.StudentID
HAVING Attendance_Percentage > 90;


SELECT S.Name, A.CourseID
FROM Attendance A
JOIN Students S ON A.StudentID = S.StudentID
WHERE A.Date = '2025-07-01' AND A.Status = 'Absent';
