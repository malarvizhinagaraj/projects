
-- -----------------------------
-- SECTION A: VIEWS
-- -----------------------------

-- 1. ActiveEmployees View
CREATE OR REPLACE VIEW ActiveEmployees AS
SELECT * FROM Employees WHERE status = 'Active';

-- 2. HighSalaryEmployees View
CREATE OR REPLACE VIEW HighSalaryEmployees AS
SELECT * FROM Employees WHERE salary > 50000;

-- 3. View joining Employees and Departments
CREATE OR REPLACE VIEW EmployeeDepartmentView AS
SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.department_id = d.dept_id;

-- 4. Update HighSalaryEmployees to include department
CREATE OR REPLACE VIEW HighSalaryEmployees AS
SELECT e.*, d.dept_name
FROM Employees e
JOIN Departments d ON e.department_id = d.dept_id
WHERE e.salary > 50000;

-- 5. View hiding salary for security
CREATE OR REPLACE VIEW EmployeeSecureView AS
SELECT emp_id, emp_name FROM Employees;

-- 6. ITEmployees View
CREATE OR REPLACE VIEW ITEmployees AS
SELECT * FROM Employees WHERE department = 'IT';

-- 7. Drop ITEmployees View
DROP VIEW IF EXISTS ITEmployees;

-- 8. Customers who joined in last 6 months
CREATE OR REPLACE VIEW RecentCustomers AS
SELECT * FROM Customers
WHERE join_date >= CURDATE() - INTERVAL 6 MONTH;

-- 9. Alias view
CREATE OR REPLACE VIEW EmployeeAliasView AS
SELECT emp_name AS EmployeeName, d.dept_name AS Dept
FROM Employees e
JOIN Departments d ON e.department_id = d.dept_id;

-- 10. Filter out NULL email
CREATE OR REPLACE VIEW ValidEmailEmployees AS
SELECT * FROM Employees WHERE email IS NOT NULL;

-- 11. Employees hired in the last year
CREATE OR REPLACE VIEW RecentHires AS
SELECT * FROM Employees
WHERE hire_date >= CURDATE() - INTERVAL 1 YEAR;

-- 12. View with computed column
CREATE OR REPLACE VIEW EmployeeBonusView AS
SELECT *, salary * 0.10 AS bonus FROM Employees;

-- 13. Join 3 tables: Orders, Customers, Products
CREATE OR REPLACE VIEW OrderDetailsView AS
SELECT o.order_id, c.customer_name, p.product_name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

-- 14. GROUP BY: total salary by department
CREATE OR REPLACE VIEW TotalSalaryByDept AS
SELECT department, SUM(salary) AS total_salary
FROM Employees
GROUP BY department;

-- 15. Read-only view for junior staff
CREATE OR REPLACE VIEW JuniorStaffView AS
SELECT emp_id, emp_name, department FROM Employees;

-- -----------------------------
-- SECTION B: STORED PROCEDURES
-- -----------------------------

-- 16. GetAllEmployees
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM Employees;
END;
// DELIMITER ;

-- 17. Call GetAllEmployees
CALL GetAllEmployees();

-- 18. GetEmployeesByDept
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
    SELECT * FROM Employees WHERE department = dept_name;
END;
// DELIMITER ;

-- 19. Call GetEmployeesByDept
CALL GetEmployeesByDept('HR');

-- 20. Insert employee with parameters
DELIMITER //
CREATE PROCEDURE InsertEmployee(
    IN eid INT, IN ename VARCHAR(100),
    IN dept VARCHAR(50), IN sal DECIMAL(10,2)
)
BEGIN
    INSERT INTO Employees(emp_id, emp_name, department, salary)
    VALUES (eid, ename, dept, sal);
END;
// DELIMITER ;

-- 21. Delete employee by emp_id
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN eid INT)
BEGIN
    DELETE FROM Employees WHERE emp_id = eid;
END;
// DELIMITER ;

-- 22. Update salary for employee
DELIMITER //
CREATE PROCEDURE UpdateSalary(IN eid INT, IN new_salary DECIMAL(10,2))
BEGIN
    UPDATE Employees SET salary = new_salary WHERE emp_id = eid;
END;
// DELIMITER ;

-- 23. Total number of employees (OUT)
DELIMITER //
CREATE PROCEDURE TotalEmployees(OUT emp_count INT)
BEGIN
    SELECT COUNT(*) INTO emp_count FROM Employees;
END;
// DELIMITER ;

-- 24. Modify stored procedure (example)
DROP PROCEDURE IF EXISTS GetAllEmployees;
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT emp_id, emp_name FROM Employees;
END;
// DELIMITER ;

-- 25. Names starting with a letter
DELIMITER //
CREATE PROCEDURE GetEmployeesByInitial(IN letter CHAR(1))
BEGIN
    SELECT * FROM Employees WHERE emp_name LIKE CONCAT(letter, '%');
END;
// DELIMITER ;

-- 26. Average salary per department
DELIMITER //
CREATE PROCEDURE AvgSalaryByDept()
BEGIN
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department;
END;
// DELIMITER ;

-- 27. Count employees in each department
DELIMITER //
CREATE PROCEDURE CountByDept()
BEGIN
    SELECT department, COUNT(*) AS emp_count
    FROM Employees
    GROUP BY department;
END;
// DELIMITER ;

-- 28. Employees who joined this month
DELIMITER //
CREATE PROCEDURE ThisMonthJoinees()
BEGIN
    SELECT * FROM Employees
    WHERE MONTH(hire_date) = MONTH(CURDATE())
    AND YEAR(hire_date) = YEAR(CURDATE());
END;
// DELIMITER ;

-- 29. Procedure with multiple queries
DELIMITER //
CREATE PROCEDURE MultiActionProcedure()
BEGIN
    SELECT * FROM Employees;
    INSERT INTO LogTable(action, log_time) VALUES ('Fetched Employees', NOW());
END;
// DELIMITER ;

-- 30. Transaction with rollback
DELIMITER //
CREATE PROCEDURE SafeInsert()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    START TRANSACTION;
    INSERT INTO Employees(emp_id, emp_name) VALUES (9999, 'Test User');
    INSERT INTO ErrorTable VALUES (NULL); -- Intentional error
    COMMIT;
END;
// DELIMITER ;

-- -----------------------------
-- SECTION C: FUNCTIONS
-- -----------------------------

-- 31. EmployeeCount Function
DELIMITER //
CREATE FUNCTION EmployeeCount(dept_name VARCHAR(50)) RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Employees WHERE department = dept_name;
    RETURN total;
END;
// DELIMITER ;

-- 32. Average salary function
DELIMITER //
CREATE FUNCTION AvgSalary(dept_name VARCHAR(50)) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE avg_sal DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_sal FROM Employees WHERE department = dept_name;
    RETURN avg_sal;
END;
// DELIMITER ;

-- 33. Calculate age
DELIMITER //
CREATE FUNCTION CalculateAge(dob DATE) RETURNS INT
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END;
// DELIMITER ;

-- 34. Highest salary
DELIMITER //
CREATE FUNCTION MaxSalary() RETURNS DECIMAL(10,2)
BEGIN
    DECLARE max_sal DECIMAL(10,2);
    SELECT MAX(salary) INTO max_sal FROM Employees;
    RETURN max_sal;
END;
// DELIMITER ;

-- 35. Full name format
DELIMITER //
CREATE FUNCTION FullName(first_name VARCHAR(50), last_name VARCHAR(50)) RETURNS VARCHAR(100)
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END;
// DELIMITER ;

-- 36. Department exists check
DELIMITER //
CREATE FUNCTION DepartmentExists(dept_name VARCHAR(50)) RETURNS BOOLEAN
BEGIN
    RETURN EXISTS (SELECT 1 FROM Departments WHERE dept_name = dept_name);
END;
// DELIMITER ;

-- 37. Working days since joining
DELIMITER //
CREATE FUNCTION WorkingDays(join_date DATE) RETURNS INT
BEGIN
    RETURN DATEDIFF(CURDATE(), join_date);
END;
// DELIMITER ;

-- 38. Total orders per customer
DELIMITER //
CREATE FUNCTION OrdersCount(customer_id INT) RETURNS INT
BEGIN
    DECLARE count_orders INT;
    SELECT COUNT(*) INTO count_orders FROM Orders WHERE customer_id = customer_id;
    RETURN count_orders;
END;
// DELIMITER ;

-- 39. Bonus eligibility
DELIMITER //
CREATE FUNCTION IsEligibleForBonus(salary DECIMAL(10,2)) RETURNS BOOLEAN
BEGIN
    RETURN salary > 60000;
END;
// DELIMITER ;

-- -----------------------------
-- SECTION D: TRIGGERS
-- -----------------------------

-- 41. Create audit table
CREATE TABLE Employee_Audit (
    emp_id INT,
    action VARCHAR(20),
    action_time DATETIME
);

-- 42. AFTER INSERT trigger
DELIMITER //
CREATE TRIGGER logNewEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit(emp_id, action, action_time)
    VALUES (NEW.emp_id, 'INSERT', NOW());
END;
// DELIMITER ;

-- 43. Insert employee to test audit
INSERT INTO Employees(emp_id, emp_name, department, salary)
VALUES (101, 'Audit Test', 'QA', 45000);

-- 44. BEFORE UPDATE trigger to prevent salary decrease
DELIMITER //
CREATE TRIGGER preventSalaryDrop
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be decreased!';
    END IF;
END;
// DELIMITER ;

-- 45. Update salary to test trigger
UPDATE Employees SET salary = 40000 WHERE emp_id = 101;

-- 46. AFTER DELETE trigger to backup deleted employees
CREATE TABLE Deleted_Employees_Backup (
    emp_id INT,
    deleted_at DATETIME
);

DELIMITER //
CREATE TRIGGER backupDeletedEmployee
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Employees_Backup(emp_id, deleted_at)
    VALUES (OLD.emp_id, NOW());
END;
// DELIMITER ;

-- 47. Trigger to update LastModified
ALTER TABLE Employees ADD COLUMN LastModified DATETIME;

DELIMITER //
CREATE TRIGGER updateLastModified
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    UPDATE Employees SET LastModified = NOW() WHERE emp_id = NEW.emp_id;
END;
// DELIMITER ;

-- 48. Default role insert on user creation
CREATE TABLE UserRoles (
    user_id INT,
    role VARCHAR(50)
);

DELIMITER //
CREATE TRIGGER defaultUserRole
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO UserRoles(user_id, role)
    VALUES (NEW.user_id, 'Employee');
END;
// DELIMITER ;

-- 49. Drop trigger
DROP TRIGGER IF EXISTS logNewEmployee;

-- 50. Prevent delete if active projects
DELIMITER //
CREATE TRIGGER preventDeleteIfActiveProjects
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Projects WHERE emp_id = OLD.emp_id AND status = 'Active') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employee assigned to active projects.';
    END IF;
END;
// DELIMITER ;
