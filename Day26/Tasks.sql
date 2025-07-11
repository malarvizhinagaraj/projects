CREATE DATABASE day_26;
USE day_26;

-- 1. Create Employees Table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    position VARCHAR(50),
    manager_id INT,
    department VARCHAR(50),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id),
    CONSTRAINT no_self_manager CHECK (emp_id <> manager_id)
);

-- 2. Insert Sample Records
INSERT INTO Employees (emp_id, emp_name, position, manager_id, department) VALUES
(1, 'Alice', 'CEO', NULL, 'Executive'),
(2, 'Bob', 'Sales Manager', 1, 'Sales'),
(3, 'Carol', 'Engineering Manager', 1, 'Engineering'),
(4, 'David', 'Senior Engineer', 3, 'Engineering'),
(5, 'Eve', 'Sales Executive', 2, 'Sales'),
(6, 'Frank', 'Engineer', 4, 'Engineering'),
(7, 'Grace', 'Intern', 6, 'Engineering');

-- 3. Recursive CTE: Full Employee Hierarchy
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, position, department, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy
ORDER BY level, emp_id;

-- 4. Find All Subordinates of a Specific Manager (manager_id = 2)
WITH RECURSIVE Subordinates AS (
    SELECT emp_id, emp_name, manager_id, position, department, 1 AS level
    FROM Employees
    WHERE manager_id = 2

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department, s.level + 1
    FROM Employees e
    JOIN Subordinates s ON e.manager_id = s.emp_id
)
SELECT * FROM Subordinates;

-- 5. Create View: EmployeeHierarchyView
CREATE VIEW EmployeeHierarchyView AS
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, emp_name, manager_id, position, department, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy;

-- 6. Query View: Filter Level 3 Employees
SELECT * FROM EmployeeHierarchyView
WHERE level = 3;

-- 7. Find Maximum Level in Hierarchy
SELECT MAX(level) AS max_depth
FROM EmployeeHierarchyView;

-- 8. Manager and Their Immediate Team Count
SELECT manager_id, COUNT(*) AS team_count
FROM Employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 9. Count All Direct and Indirect Reports for Each Manager
WITH RECURSIVE ReportingTree AS (
    SELECT emp_id AS manager_id, emp_id AS employee_id
    FROM Employees

    UNION ALL

    SELECT rt.manager_id, e.emp_id
    FROM ReportingTree rt
    JOIN Employees e ON e.manager_id = rt.employee_id
)
SELECT manager_id, COUNT(employee_id) - 1 AS total_reports
FROM ReportingTree
GROUP BY manager_id;

-- 10. Show Path from CEO to Each Employee
WITH RECURSIVE PathCTE AS (
    SELECT emp_id, emp_name, manager_id, position, department,
           CAST(emp_name AS VARCHAR(1000)) AS path, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department,
           CONCAT(p.path, ' → ', e.emp_name), p.level + 1
    FROM Employees e
    JOIN PathCTE p ON e.manager_id = p.emp_id
)
SELECT * FROM PathCTE
ORDER BY level;

-- 11. Hierarchy Within Each Department
WITH RECURSIVE DeptHierarchy AS (
    SELECT emp_id, emp_name, manager_id, position, department, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, e.position, e.department, dh.level + 1
    FROM Employees e
    JOIN DeptHierarchy dh ON e.manager_id = dh.emp_id
)
SELECT * FROM DeptHierarchy
ORDER BY department, level;

-- 12. Find Depth of a Given Employee (e.g., emp_id = 7)
WITH RECURSIVE FindDepth AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE emp_id = 7

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, fd.level + 1
    FROM Employees e
    JOIN FindDepth fd ON e.emp_id = fd.manager_id
)
SELECT MAX(level) AS employee_depth
FROM FindDepth;

-- Create Salaries Table
CREATE TABLE Salaries (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

-- Insert Sample Data
INSERT INTO Salaries VALUES
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'HR', 55000),
(3, 'Carol', 'HR', 50000),
(4, 'David', 'IT', 70000),
(5, 'Eve', 'IT', 75000),
(6, 'Frank', 'IT', 80000),
(7, 'Grace', 'Finance', 60000),
(8, 'Heidi', 'Finance', 62000),
(9, 'Ivan', 'Finance', 58000),
(10, 'Judy', 'Finance', 60000);

--  Use ROW_NUMBER to rank by salary
SELECT *, ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM Salaries;

-- Use RANK() to handle ties
SELECT *, RANK() OVER (ORDER BY salary DESC) AS rank_pos
FROM Salaries;

-- Use DENSE_RANK() and compare
SELECT *, DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_pos
FROM Salaries;

--  Partition ranking by department
SELECT *, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;

-- Use LAG() to show previous salary
SELECT *, LAG(salary) OVER (ORDER BY salary DESC) AS prev_salary
FROM Salaries;

-- Use LEAD() to show next salary
SELECT *, LEAD(salary) OVER (ORDER BY salary DESC) AS next_salary
FROM Salaries;

-- Combine ROW_NUMBER and LAG
SELECT emp_id, emp_name, salary,
       ROW_NUMBER() OVER (ORDER BY salary) AS row_no,
       LAG(salary) OVER (ORDER BY salary) AS prev_salary
FROM Salaries;

--  Salary progression: show only if increased from previous
WITH SalaryProgress AS (
    SELECT emp_id, emp_name, salary,
           LAG(salary) OVER (ORDER BY salary) AS prev_salary
    FROM Salaries
)
SELECT * FROM SalaryProgress
WHERE salary > prev_salary;

-- Use NTILE to divide into 3 tiers
SELECT *, NTILE(3) OVER (ORDER BY salary DESC) AS tier
FROM Salaries;

-- FIRST_VALUE and LAST_VALUE per department
SELECT *,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS max_salary,
    LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_salary
FROM Salaries;

--  Salary distribution using CUME_DIST() and PERCENT_RANK()
SELECT *,
    CUME_DIST() OVER (ORDER BY salary) AS cume_dist,
    PERCENT_RANK() OVER (ORDER BY salary) AS percent_rank
FROM Salaries;

--  Moving average salary (window frame of 2 preceding rows)
SELECT *,
    AVG(salary) OVER (ORDER BY salary ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM Salaries;

--  Create view for real-time salary ranking
CREATE VIEW SalaryRankingView AS
SELECT *,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM Salaries;

--  Salary as percentage of department total
SELECT *,
    salary * 100.0 / SUM(salary) OVER (PARTITION BY department) AS salary_pct
FROM Salaries;

--  Salary difference from highest in department
SELECT *,
    MAX(salary) OVER (PARTITION BY department) - salary AS diff_from_max
FROM Salaries;

-- Comparison report of employees
SELECT emp_name, department, salary,
       salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_team
FROM Salaries;

--  Employees below department average
SELECT *
FROM (
    SELECT *, AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM Salaries
) AS sub
WHERE salary < dept_avg;

--  Group and rank by department
SELECT *, DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM Salaries;


--  Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE
);

-- Insert Sample Data (20 Orders, 5 Customers)
INSERT INTO Orders VALUES
(1, 101, 15000, '2024-06-01'),
(2, 101, 8000, '2024-06-05'),
(3, 102, 12000, '2024-06-10'),
(4, 103, 9000, '2024-06-11'),
(5, 104, 20000, '2024-06-12'),
(6, 105, 3000, '2024-06-13'),
(7, 101, 7000, '2024-06-14'),
(8, 102, 14000, '2024-06-15'),
(9, 103, 9500, '2024-06-16'),
(10, 104, 11000, '2024-06-17'),
(11, 105, 4000, '2024-06-18'),
(12, 101, 20000, '2024-06-19'),
(13, 102, 6000, '2024-06-20'),
(14, 103, 16000, '2024-06-21'),
(15, 104, 18000, '2024-06-22'),
(16, 105, 5000, '2024-06-23'),
(17, 101, 8500, '2024-06-24'),
(18, 102, 12500, '2024-06-25'),
(19, 103, 21000, '2024-06-26'),
(20, 104, 13000, '2024-06-27');

-- CTE to Filter Orders > ₹10,000
WITH HighOrders AS (
    SELECT * FROM Orders WHERE amount > 10000
)
SELECT * FROM HighOrders;

--  CTE: Total Order Amount per Customer
WITH TotalAmount AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM TotalAmount;

--  CTE: Count Orders > 3
WITH OrderCounts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM OrderCounts
WHERE order_count > 3;

--  Two CTEs: Top Spenders and Frequent Buyers
WITH TopSpenders AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    HAVING SUM(amount) > 40000
),
FrequentBuyers AS (
    SELECT customer_id, COUNT(*) AS orders
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 3
)
SELECT * FROM TopSpenders
INTERSECT
SELECT * FROM FrequentBuyers;

-- Recursive CTE: Tree Structure of Product Categories
CREATE TABLE Categories (
    cat_id INT PRIMARY KEY,
    cat_name VARCHAR(50),
    parent_id INT
);

INSERT INTO Categories VALUES
(1, 'Electronics', NULL),
(2, 'Mobiles', 1),
(3, 'Smartphones', 2),
(4, 'Feature Phones', 2),
(5, 'Laptops', 1);

WITH RECURSIVE CategoryTree AS (
    SELECT cat_id, cat_name, parent_id, 1 AS level
    FROM Categories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.cat_id, c.cat_name, c.parent_id, ct.level + 1
    FROM Categories c
    JOIN CategoryTree ct ON c.parent_id = ct.cat_id
)
SELECT * FROM CategoryTree;

-- Recursive CTE: Factorial of 5
WITH RECURSIVE Factorial(n, fact) AS (
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, fact * (n + 1)
    FROM Factorial
    WHERE n < 5
)
SELECT * FROM Factorial;

-- Running Total of Daily Sales
WITH RunningSales AS (
    SELECT order_date, SUM(amount) AS daily_sales
    FROM Orders
    GROUP BY order_date
),
RunningTotal AS (
    SELECT order_date, daily_sales,
        SUM(daily_sales) OVER (ORDER BY order_date) AS running_total
    FROM RunningSales
)
SELECT * FROM RunningTotal;

-- CTE View for Simplified Reporting
CREATE VIEW CustomerSpending AS
WITH Summary AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT * FROM Summary;

-- Chain Multiple CTEs
WITH A AS (
    SELECT customer_id, COUNT(*) AS orders FROM Orders GROUP BY customer_id
),
B AS (
    SELECT customer_id, SUM(amount) AS total FROM Orders GROUP BY customer_id
)
SELECT A.customer_id, A.orders, B.total
FROM A JOIN B ON A.customer_id = B.customer_id;

-- Compare Long Nested Query vs CTE (demonstration only)

-- Recursive CTE: All Managers (use Employees table from Part A)
WITH RECURSIVE AllManagers AS (
    SELECT emp_id, emp_name, manager_id
    FROM Salaries
    WHERE emp_id = 10

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id
    FROM Salaries e
    JOIN AllManagers am ON e.emp_id = am.manager_id
)
SELECT * FROM AllManagers;

-- Temporary Table for Top 5 Customers Per Region (Region column not available here; skip or extend schema if needed)

-- Combine CTE + Window to Rank Customers by Order Total
WITH CustomerTotal AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT *, RANK() OVER (ORDER BY total_spent DESC) AS rank_by_spending
FROM CustomerTotal;
