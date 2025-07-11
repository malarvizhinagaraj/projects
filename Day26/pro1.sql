USE day_26;
-- Organizational Chart Reporting System
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

CREATE VIEW OrgHierarchyView AS
WITH RECURSIVE EmpCTE AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, c.level + 1
    FROM Employees e
    JOIN EmpCTE c ON e.manager_id = c.emp_id
)
SELECT c.emp_id, c.emp_name, c.manager_id, c.level, m.emp_name AS manager_name
FROM EmpCTE c
LEFT JOIN Employees m ON c.manager_id = m.emp_id;

-- Salary Ranking Dashboard
CREATE TABLE Salaries (
    emp_id INT,
    emp_name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2)
);

SELECT *,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_val,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM Salaries;

--Customer Order Recency Report
CREATE TABLE Orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);

WITH OrderGap AS (
    SELECT *,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_days
    FROM Orders
)
SELECT * FROM OrderGap WHERE gap_days > 30;

-- Product Category Tree Visualizer
CREATE TABLE ProductCategories (
    cat_id INT PRIMARY KEY,
    cat_name VARCHAR(100),
    parent_id INT
);

WITH RECURSIVE CatTree AS (
    SELECT cat_id, cat_name, parent_id, 1 AS level,
           CAST(cat_name AS VARCHAR(1000)) AS path
    FROM ProductCategories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.cat_id, c.cat_name, c.parent_id, t.level + 1,
           CONCAT(t.path, ' > ', c.cat_name)
    FROM ProductCategories c
    JOIN CatTree t ON c.parent_id = t.cat_id
)
SELECT * FROM CatTree;

-- Employee Promotion Tracker
CREATE TABLE EmployeeSalaries (
    emp_id INT,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    salary_date DATE
);

WITH SalaryChange AS (
    SELECT *,
        LAG(salary) OVER (PARTITION BY emp_id ORDER BY salary_date) AS prev_salary
    FROM EmployeeSalaries
    WHERE YEAR(salary_date) = YEAR(CURDATE())
)
SELECT * FROM SalaryChange
WHERE prev_salary IS NOT NULL AND salary > prev_salary;

-- Customer Segmentation System
WITH CustomerSpend AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT *,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent DESC)
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM CustomerSpend;

-- Salesperson Hierarchy and Performance Tracker
CREATE TABLE Salespersons (
    emp_id INT,
    emp_name VARCHAR(100),
    manager_id INT,
    sales_amount DECIMAL(10, 2),
    FOREIGN KEY (manager_id) REFERENCES Salespersons(emp_id)
);

WITH RECURSIVE SalesTree AS (
    SELECT emp_id, emp_name, manager_id, sales_amount, 1 AS level
    FROM Salespersons
    WHERE manager_id IS NULL

    UNION ALL

    SELECT s.emp_id, s.emp_name, s.manager_id, s.sales_amount, t.level + 1
    FROM Salespersons s
    JOIN SalesTree t ON s.manager_id = t.emp_id
)
SELECT *,
    SUM(sales_amount) OVER (PARTITION BY manager_id) AS team_sales,
    RANK() OVER (PARTITION BY manager_id ORDER BY sales_amount DESC) AS team_rank
FROM SalesTree;


-- ✅ 1. Organizational Chart Reporting System
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

CREATE VIEW OrgHierarchyView AS
WITH RECURSIVE EmpCTE AS (
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.emp_name, e.manager_id, c.level + 1
    FROM Employees e
    JOIN EmpCTE c ON e.manager_id = c.emp_id
)
SELECT c.emp_id, c.emp_name, c.manager_id, c.level, m.emp_name AS manager_name
FROM EmpCTE c
LEFT JOIN Employees m ON c.manager_id = m.emp_id;

-- ✅ 2. Salary Ranking Dashboard
CREATE TABLE Salaries (
    emp_id INT,
    emp_name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2)
);

SELECT *,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_val,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS prev_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM Salaries;

-- ✅ 3. Customer Order Recency Report
CREATE TABLE Orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);

WITH OrderGap AS (
    SELECT *,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_days
    FROM Orders
)
SELECT * FROM OrderGap WHERE gap_days > 30;

-- ✅ 4. Product Category Tree Visualizer
CREATE TABLE ProductCategories (
    cat_id INT PRIMARY KEY,
    cat_name VARCHAR(100),
    parent_id INT
);

WITH RECURSIVE CatTree AS (
    SELECT cat_id, cat_name, parent_id, 1 AS level,
           CAST(cat_name AS VARCHAR(1000)) AS path
    FROM ProductCategories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.cat_id, c.cat_name, c.parent_id, t.level + 1,
           CONCAT(t.path, ' > ', c.cat_name)
    FROM ProductCategories c
    JOIN CatTree t ON c.parent_id = t.cat_id
)
SELECT * FROM CatTree;

-- ✅ 5. Employee Promotion Tracker
CREATE TABLE EmployeeSalaries (
    emp_id INT,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    salary_date DATE
);

WITH SalaryChange AS (
    SELECT *,
        LAG(salary) OVER (PARTITION BY emp_id ORDER BY salary_date) AS prev_salary
    FROM EmployeeSalaries
    WHERE YEAR(salary_date) = YEAR(CURDATE())
)
SELECT * FROM SalaryChange
WHERE prev_salary IS NOT NULL AND salary > prev_salary;

-- ✅ 6. Customer Segmentation System
WITH CustomerSpend AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT *,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent DESC)
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM CustomerSpend;

-- ✅ 7. Salesperson Hierarchy and Performance Tracker
CREATE TABLE Salespersons (
    emp_id INT,
    emp_name VARCHAR(100),
    manager_id INT,
    sales_amount DECIMAL(10, 2),
    FOREIGN KEY (manager_id) REFERENCES Salespersons(emp_id)
);

WITH RECURSIVE SalesTree AS (
    SELECT emp_id, emp_name, manager_id, sales_amount, 1 AS level
    FROM Salespersons
    WHERE manager_id IS NULL

    UNION ALL

    SELECT s.emp_id, s.emp_name, s.manager_id, s.sales_amount, t.level + 1
    FROM Salespersons s
    JOIN SalesTree t ON s.manager_id = t.emp_id
)
SELECT *,
    SUM(sales_amount) OVER (PARTITION BY manager_id) AS team_sales,
    RANK() OVER (PARTITION BY manager_id ORDER BY sales_amount DESC) AS team_rank
FROM SalesTree;
-- Finance Department Budget Tracker
CREATE TABLE Budgets (
    dept_id INT,
    department VARCHAR(100),
    spend DECIMAL(12, 2)
);

WITH RankedBudget AS (
    SELECT *,
        RANK() OVER (ORDER BY spend DESC) AS dept_rank,
        MAX(spend) OVER () AS top_spend
    FROM Budgets
),
Filtered AS (
    SELECT * FROM RankedBudget WHERE spend > 50000
)
SELECT department, spend, dept_rank, top_spend - spend AS spend_delta
FROM Filtered;

-- Daily Transaction Trend Analyzer
CREATE TABLE DailyTransactions (
    txn_date DATE,
    amount DECIMAL(10, 2)
);

WITH RecentTxns AS (
    SELECT * FROM DailyTransactions
    WHERE txn_date >= CURRENT_DATE - INTERVAL 30 DAY
),
Trend AS (
    SELECT *,
        AVG(amount) OVER (ORDER BY txn_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_7day
    FROM RecentTxns
)
SELECT * FROM Trend WHERE amount > avg_7day;

-- Online Learning Progress Report
CREATE TABLE QuizScores (
    student_id INT,
    quiz_date DATE,
    score INT
);

WITH ScoreCompare AS (
    SELECT *,
        LAG(score) OVER (PARTITION BY student_id ORDER BY quiz_date) AS prev_score
    FROM QuizScores
),
Status AS (
    SELECT *,
        CASE 
            WHEN score > prev_score THEN 'Improving'
            WHEN score < prev_score THEN 'Declining'
            WHEN score = prev_score THEN 'Stagnant'
            ELSE 'First Attempt'
        END AS progress
    FROM ScoreCompare
)
SELECT * FROM Status;

-- E-commerce Purchase Funnel Report
CREATE TABLE FunnelActivity (
    user_id INT,
    activity_stage VARCHAR(50),
    activity_time DATETIME
);

CREATE VIEW FunnelDropOffView AS
WITH StageDepth AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY activity_time) AS stage_rank
    FROM FunnelActivity
)
SELECT user_id, COUNT(*) AS stages_completed
FROM StageDepth
GROUP BY user_id;

-- Warehouse Inventory Snapshot System
CREATE TABLE InventorySnapshots (
    item_id INT,
    snapshot_date DATE,
    stock_level INT
);

WITH StockChanges AS (
    SELECT *,
        LAG(stock_level) OVER (PARTITION BY item_id ORDER BY snapshot_date) AS prev_stock
    FROM InventorySnapshots
),
SharpDrops AS (
    SELECT *,
        stock_level - prev_stock AS stock_change
    FROM StockChanges
    WHERE prev_stock IS NOT NULL AND stock_level - prev_stock < -10
),
TopMovers AS (
    SELECT item_id, AVG(ABS(stock_level - prev_stock)) AS avg_daily_change
    FROM StockChanges
    WHERE prev_stock IS NOT NULL
    GROUP BY item_id
    ORDER BY avg_daily_change DESC
    LIMIT 10
)
SELECT * FROM SharpDrops;

-- Student Class Hierarchy Tracker
CREATE TABLE Mentors (
    student_id INT,
    student_name VARCHAR(100),
    mentor_id INT
);

CREATE VIEW MentorHierarchy AS
WITH RECURSIVE MentorTree AS (
    SELECT student_id, student_name, mentor_id, 1 AS level,
           CAST(student_name AS VARCHAR(1000)) AS path
    FROM Mentors
    WHERE mentor_id IS NULL

    UNION ALL

    SELECT m.student_id, m.student_name, m.mentor_id, t.level + 1,
           CONCAT(t.path, ' > ', m.student_name)
    FROM Mentors m
    JOIN MentorTree t ON m.mentor_id = t.student_id
)
SELECT * FROM MentorTree;

-- Job Application Status Pipeline
CREATE TABLE Applications (
    applicant_id INT,
    stage VARCHAR(50),
    update_time DATETIME
);

WITH StageFlow AS (
    SELECT *,
        LAG(stage) OVER (PARTITION BY applicant_id ORDER BY update_time) AS prev_stage,
        LEAD(stage) OVER (PARTITION BY applicant_id ORDER BY update_time) AS next_stage
    FROM Applications
),
Stalled AS (
    SELECT * FROM StageFlow
    WHERE stage != 'Offered' AND TIMESTAMPDIFF(DAY, update_time, NOW()) > 7
)
SELECT * FROM Stalled;

-- IT Support Ticket Resolution Report
CREATE TABLE Tickets (
    ticket_id INT,
    user_id INT,
    assigned_to INT,
    created_at DATETIME,
    resolved_at DATETIME
);

WITH TicketDurations AS (
    SELECT *,
        DATEDIFF(resolved_at, created_at) AS resolution_days,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS ticket_order
    FROM Tickets
),
Overdue AS (
    SELECT * FROM TicketDurations WHERE resolution_days > 5
)
SELECT assigned_to, AVG(resolution_days) AS avg_resolution_time
FROM TicketDurations
GROUP BY assigned_to;

WITH TicketWithResolution AS (
  SELECT *,
         LEAD(resolved_at) OVER (PARTITION BY user_id ORDER BY created_at) AS next_resolved,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
  FROM support_tickets
),
ResolutionTimes AS (
  SELECT *,
         DATEDIFF(MINUTE, created_at, resolved_at) AS resolution_minutes
  FROM TicketWithResolution
),
OverdueTickets AS (
  SELECT * FROM ResolutionTimes
  WHERE resolution_minutes > 60  -- assuming 60 minutes is SLA
)
-- Final output
SELECT staff_id,
       AVG(resolution_minutes) AS avg_resolution_time_min,
       COUNT(*) AS total_tickets
FROM ResolutionTimes
GROUP BY staff_id;

WITH BalanceHistory AS (
  SELECT *,
         LAG(balance) OVER (PARTITION BY account_id ORDER BY txn_date) AS prev_balance
  FROM transactions
),
AbnormalDips AS (
  SELECT *,
         ROUND(100.0 * (balance - prev_balance) / NULLIF(prev_balance, 0), 2) AS percent_change
  FROM BalanceHistory
  WHERE balance < prev_balance AND ABS(balance - prev_balance) > 1000
)
-- Summary
SELECT account_id,
       COUNT(*) AS dips_count,
       MIN(percent_change) AS worst_dip,
       MAX(txn_date) AS last_dip_date
FROM AbnormalDips
GROUP BY account_id;

WITH CallStats AS (
  SELECT *,
         RANK() OVER (PARTITION BY shift ORDER BY COUNT(*) DESC) AS rank_in_shift,
         LAG(call_end) OVER (PARTITION BY agent_id ORDER BY call_start) AS prev_call_end
  FROM calls
  GROUP BY agent_id, shift
),
CallGaps AS (
  SELECT *,
         DATEDIFF(MINUTE, prev_call_end, call_start) AS gap_minutes
  FROM CallStats
  WHERE prev_call_end IS NOT NULL
),
HighVolumeAgents AS (
  SELECT agent_id, COUNT(*) AS total_calls
  FROM calls
  GROUP BY agent_id
  HAVING COUNT(*) > 100  -- arbitrary threshold
)
SELECT * FROM HighVolumeAgents;

-- Recursive CTE to build department-unit-doctor hierarchy
WITH RECURSIVE DepartmentHierarchy AS (
  SELECT id, name, parent_id, 1 AS level
  FROM hospital_units
  WHERE parent_id IS NULL

  UNION ALL

  SELECT u.id, u.name, u.parent_id, dh.level + 1
  FROM hospital_units u
  JOIN DepartmentHierarchy dh ON u.parent_id = dh.id
),
PatientLoad AS (
  SELECT doctor_id, COUNT(*) AS patient_count
  FROM patient_cases
  GROUP BY doctor_id
),
DoctorUnitMap AS (
  SELECT d.id AS doctor_id, d.unit_id, p.patient_count
  FROM doctors d
  LEFT JOIN PatientLoad p ON d.id = p.doctor_id
)
-- Final View
CREATE VIEW DepartmentalWorkloadView AS
SELECT dh.name AS department_or_unit,
       dh.level,
       d.doctor_id,
       d.patient_count
FROM DepartmentHierarchy dh
JOIN DoctorUnitMap d ON d.unit_id = dh.id;

-- Recursive CTE to build paths
WITH RECURSIVE FlightPaths AS (
  SELECT origin, destination, 1 AS stops, 
         CONCAT(origin, ' -> ', destination) AS path,
         destination AS current
  FROM flights
  WHERE origin = 'DEL'  -- starting airport

  UNION ALL

  SELECT f.origin, f.destination, fp.stops + 1,
         CONCAT(fp.path, ' -> ', f.destination),
         f.destination
  FROM flights f
  JOIN FlightPaths fp ON f.origin = fp.current
  WHERE fp.stops < 3 AND f.destination NOT IN (fp.path)  -- avoid loops
)
SELECT * FROM FlightPaths
WHERE destination = 'NYC';


-- Recursive CTE for task dependencies
WITH RECURSIVE TaskOrder AS (
  SELECT id, task_name, depends_on_task_id, 1 AS level
  FROM tasks
  WHERE depends_on_task_id IS NULL

  UNION ALL

  SELECT t.id, t.task_name, t.depends_on_task_id, to.level + 1
  FROM tasks t
  JOIN TaskOrder to ON t.depends_on_task_id = to.id
)
-- Final output for Gantt chart
SELECT *,
       ROW_NUMBER() OVER (ORDER BY level) AS execution_order
FROM TaskOrder
ORDER BY level;
