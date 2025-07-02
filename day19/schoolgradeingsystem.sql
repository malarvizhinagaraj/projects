CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Class VARCHAR(20)
);
CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(100)
);
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    SubjectID INT,
    Grade DECIMAL(5,2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);
INSERT INTO Students VALUES
(1, 'Alice', '10A'),
(2, 'Bob', '10A'),
(3, 'Charlie', '10B'),
(4, 'Diana', '10B');

INSERT INTO Subjects VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'English');

INSERT INTO Grades (StudentID, SubjectID, Grade) VALUES
(1, 101, 92.5),
(2, 101, 78.0),
(3, 101, 85.0),
(4, 101, 88.0),

(1, 102, 76.5),
(2, 102, 89.0),
(3, 102, 90.0),
(4, 102, 65.0),

(1, 103, 55.0),
(2, 103, 67.0),
(3, 103, 40.0),
(4, 103, 82.0);


SELECT S.SubjectName, ST.Name, G.Grade
FROM Grades G
JOIN Students ST ON G.StudentID = ST.StudentID
JOIN Subjects S ON G.SubjectID = S.SubjectID
WHERE (G.SubjectID, G.Grade) IN (
    SELECT SubjectID, MAX(Grade)
    FROM Grades
    GROUP BY SubjectID
);
SELECT ST.Name, S.SubjectName, G.Grade
FROM Grades G
JOIN Students ST ON G.StudentID = ST.StudentID
JOIN Subjects S ON G.SubjectID = S.SubjectID
WHERE G.Grade < 50;
