CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    Position VARCHAR(100),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    BaseSalary DECIMAL(10, 2),
    Bonus DECIMAL(10, 2),
    TotalSalary AS (BaseSalary + Bonus) STORED,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Finance');

INSERT INTO Employees VALUES
(101, 'Alice', 1, 'HR Manager'),
(102, 'Bob', 2, 'Software Engineer'),
(103, 'Charlie', 2, 'Software Engineer'),
(104, 'Diana', 3, 'Accountant'),
(105, 'Ethan', 2, 'DevOps Engineer'),
(106, 'Fiona', 1, 'Recruiter'),
(107, 'George', 3, 'Financial Analyst'),
(108, 'Hannah', 2, 'Backend Developer'),
(109, 'Ivan', 3, 'Auditor'),
(110, 'Jenny', 2, 'Frontend Developer');


INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus) VALUES
(101, 50000, 5000),
(102, 70000, 8000),
(103, 72000, 6000),
(104, 45000, 3000),
(105, 68000, 5000),
(106, 48000, 2000),
(107, 55000, 4000),
(108, 71000, 7000),
(109, 52000, 3000),
(110, 69000, 6500);


SELECT E.Name, D.DepartmentName, S.BaseSalary + S.Bonus AS TotalSalary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
JOIN Salaries S ON E.EmployeeID = S.EmployeeID
WHERE D.DepartmentName = 'Engineering' AND (S.BaseSalary + S.Bonus) > 70000;

UPDATE Salaries
SET BaseSalary = BaseSalary * 1.10
WHERE EmployeeID IN (
    SELECT EmployeeID FROM Employees WHERE Position = 'DevOps Engineer'
);
