-- Task 1
CREATE TABLE Departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50) UNIQUE
);
INSERT INTO Departments VALUES (1, 'HR'), (2, 'IT'), (3, 'Finance');

-- Task 2
CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  department INT,
  salary DECIMAL(10,2),
  FOREIGN KEY (department) REFERENCES Departments(dept_id)
);
INSERT INTO Employees VALUES 
  (1, 'Alice', 1, 50000),
  (2, 'Bob', 2, 55000),
  (3, 'Charlie', 3, 45000),
  (4, 'David', 1, 40000),
  (5, 'Eve', 2, 60000);

-- Task 3
INSERT INTO Employees (emp_id, name) VALUES (6, 'Frank');

-- Task 4
INSERT INTO Employees (name, salary, emp_id, department) VALUES ('Grace', 52000, 7, 3);

-- Task 5
INSERT INTO Employees (emp_id, name, department, salary) VALUES 
  (8, 'Helen', 1, 47000),
  (9, 'Ian', 2, 49000);

-- Task 6
INSERT INTO Employees (emp_id, name, department) VALUES (10, 'Jack', 2);

-- Task 7 (Should fail if FOREIGN KEY enforced)
-- INSERT INTO Employees (emp_id, name, department) VALUES (11, 'Kim', 99);

-- Task 8 (Should fail due to PRIMARY KEY)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Liam', 1, 43000);

-- Task 9 (Should fail if UNIQUE on dept_name)
-- INSERT INTO Departments (dept_id, dept_name) VALUES (4, 'HR');

-- Task 10
CREATE TABLE Attendance (
  emp_id INT,
  date DATE DEFAULT CURRENT_DATE,
  status VARCHAR(10) DEFAULT 'Present',
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);
INSERT INTO Attendance (emp_id) VALUES (1), (2), (3);

-- Task 11
UPDATE Employees SET salary = salary + 5000 WHERE department = 1;

-- Task 12
UPDATE Employees SET department = 3 WHERE emp_id = 2;

-- Task 13
UPDATE Employees SET salary = 45000 WHERE salary < 40000;

-- Task 14
UPDATE Employees SET name = 'Michael Scott' WHERE emp_id = 3;

-- Task 15
UPDATE Employees SET salary = salary * 1.10 WHERE department = 2;

-- Task 16 (Fails if salary is NOT NULL)
-- UPDATE Employees SET salary = NULL WHERE department = 4;

-- Task 17
UPDATE Employees SET department = 4 WHERE department IS NULL;

-- Task 18
UPDATE Employees SET department = 2, salary = 48000 WHERE emp_id = 6;

-- Task 19
UPDATE Employees 
SET salary = salary + 1000 
WHERE salary < (SELECT AVG(salary) FROM Employees);

-- Task 20
ALTER TABLE Employees ADD bonus DECIMAL(10,2);
UPDATE Employees SET bonus = salary * 0.05;


-- Task 21
DELETE FROM Employees WHERE emp_id = 2;

-- Task 22
DELETE FROM Employees WHERE department = 3;

-- Task 23
DELETE FROM Employees WHERE salary < 30000;

-- Task 24
DELETE FROM Employees;

-- Task 25 (Fails if department still referenced)
-- DELETE FROM Departments WHERE dept_id = 1;

-- Task 26 (Assuming join_date exists)
-- DELETE FROM Employees WHERE YEAR(join_date) < 2022;

-- Task 27
DELETE FROM Employees WHERE department NOT IN (
  SELECT dept_id FROM Departments WHERE dept_name = 'HR'
);

-- Task 28
DELETE FROM Employees WHERE department IS NULL;

-- Task 29
DELETE FROM Employees WHERE emp_id = 9;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (9, 'Ian', 2, 49000);

-- Task 30
START TRANSACTION;
DELETE FROM Employees WHERE emp_id = 4;
ROLLBACK;


-- Task 31
-- Already done in Task 1

-- Task 32
-- Already done in Task 2

-- Task 33
ALTER TABLE Employees ADD CONSTRAINT chk_salary CHECK (salary > 3000);

-- Task 34
-- Already done as FOREIGN KEY in Task 2

-- Task 35 (Fails due to NOT NULL)
-- INSERT INTO Employees (emp_id, department, salary) VALUES (12, 1, 40000);

-- Task 36 (Fails due to CHECK)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (13, 'Nina', 1, 2000);

-- Task 37 (Fails due to UNIQUE)
-- INSERT INTO Departments (dept_id, dept_name) VALUES (5, 'HR');

-- Task 38 (Fails due to FK)
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (14, 'Omar', 99, 50000);

-- Task 39
ALTER TABLE Employees ADD CONSTRAINT chk_bonus CHECK (bonus >= 0);

-- Task 40
ALTER TABLE Employees DROP CONSTRAINT chk_bonus;

-- Task 41
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (15, 'Paul', 2, 50000);
INSERT INTO Employees (emp_id, name, department, salary) VALUES (16, 'Quinn', 3, 48000);
COMMIT;

-- Task 42
START TRANSACTION;
UPDATE Employees SET salary = 70000 WHERE emp_id = 1;
ROLLBACK;

-- Task 43
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES (17, 'Ravi', 1, 52000);
SAVEPOINT sp1;
UPDATE Employees SET salary = 55000 WHERE emp_id = 17;
ROLLBACK TO sp1;

-- Task 44
START TRANSACTION;
DELETE FROM Employees WHERE emp_id IN (15, 16);
COMMIT;

-- Task 45
START TRANSACTION;
UPDATE Employees SET salary = salary + 5000 WHERE emp_id = 1;
SAVEPOINT sp1;
UPDATE Employees SET salary = salary + 3000 WHERE emp_id = 3;
SAVEPOINT sp2;
ROLLBACK TO sp1;

-- Task 46
-- Done using DB tools or sessions (simulate manually)

-- Task 47
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES 
  (18, 'Steve', 2, 50000),
  (19, 'Tina', 3, 48000);
-- Simulate error:
-- INSERT INTO Employees (emp_id, name, department, salary) VALUES (1, 'Duplicate', 1, 50000);
ROLLBACK;

-- Task 48
START TRANSACTION;
UPDATE Departments SET dept_name = CONCAT(dept_name, ' Dept');
-- Simulate check all success then
COMMIT;

-- Task 49
START TRANSACTION;
INSERT INTO Employees (emp_id, name, department, salary) VALUES 
  (20, 'Uma', 2, 50000),
  (1, 'Duplicate', 1, 50000); -- This fails
ROLLBACK;

-- Task 50
START TRANSACTION;
UPDATE Employees SET department = 2 WHERE emp_id = 3;
INSERT INTO Employee_Logs (emp_id, change_type, change_date) VALUES (3, 'Transferred', CURRENT_DATE);
COMMIT;
