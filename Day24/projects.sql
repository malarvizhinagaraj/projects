-- 1. Employee Performance Analyzer
Create database emp_de;
use emp_de;

-- 1. Create Tables
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    performance_score INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Salaries (
    employee_id INT PRIMARY KEY,
    salary DECIMAL(10, 2),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- 2. Insert Data
INSERT INTO Departments VALUES (1, 'HR'), (2, 'IT'), (3, 'Finance');

INSERT INTO Employees VALUES 
(101, 'Alice', 1, 85),
(102, 'Bob', 2, 90),
(103, 'Charlie', 2, 75),
(104, 'Diana', 3, 95);

INSERT INTO Salaries VALUES
(101, 55000.00),
(102, 70000.00),
(103, 60000.00),
(104, 80000.00);

-- 3. Retrieve and sort high-performing employees
SELECT e.employee_id, e.name, e.performance_score, s.salary
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
WHERE e.performance_score >= 85
ORDER BY e.performance_score DESC;

-- 4. Department-wise average salary
SELECT d.department_name, AVG(s.salary) AS avg_salary
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 5. Classify salaries as High, Medium, Low
SELECT e.name, s.salary,
CASE 
    WHEN s.salary >= 75000 THEN 'High'
    WHEN s.salary >= 60000 THEN 'Medium'
    ELSE 'Low'
END AS Salary_Category
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id;

-- 6. Update salaries with transaction safety
START TRANSACTION;

UPDATE Salaries SET salary = salary * 1.05 WHERE salary < 65000;

-- Check if rows were updated, if not rollback
SET @row_count = ROW_COUNT();

IF @row_count = 0 THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;

-- Table Setup
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    order_date DATE
);

CREATE TABLE Refunds (
    refund_id INT PRIMARY KEY,
    order_id INT,
    refund_amount DECIMAL(10,2),
    refund_reason VARCHAR(100),
    refund_date DATE
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount_paid DECIMAL(10,2),
    payment_date DATE
);

-- Sample Inserts
INSERT INTO Orders VALUES (1, 101, 500.00, 'Completed', '2025-07-01');
INSERT INTO Payments VALUES (1, 1, 500.00, '2025-07-01');

-- Transaction: Cancel & Refund
START TRANSACTION;
DELETE FROM Orders WHERE order_id = 1;
INSERT INTO Refunds VALUES (1, 1, 500.00, 'Product Defect', CURRENT_DATE);
COMMIT;

-- Check refund eligibility (e.g., completed orders only)
SELECT * FROM Orders
WHERE order_id = 2
  AND status = 'Completed';

-- Refund summary with JOIN
SELECT R.refund_id, O.customer_id, R.refund_amount, R.refund_reason
FROM Refunds R
JOIN Orders O ON R.order_id = O.order_id;

-- CASE to categorize reasons
SELECT refund_reason,
       CASE
           WHEN refund_reason LIKE '%Defect%' THEN 'Product Issue'
           WHEN refund_reason LIKE '%Delay%' THEN 'Logistics Issue'
           ELSE 'Other'
       END AS category
FROM Refunds;

-- Table Setup
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

CREATE TABLE Inward (
    product_id INT,
    quantity INT,
    movement_date DATE
);

CREATE TABLE Outward (
    product_id INT,
    quantity INT,
    movement_date DATE
);

CREATE TABLE StockLevels (
    product_id INT PRIMARY KEY,
    current_stock INT
);

-- Sample Inserts
INSERT INTO Products VALUES (1, 'Laptop'), (2, 'Mouse');
INSERT INTO Inward VALUES (1, 50, '2025-07-01'), (2, 100, '2025-07-01');
INSERT INTO Outward VALUES (1, 20, '2025-07-02'), (2, 120, '2025-07-03');

-- Net Stock Calculation
SELECT P.product_name,
       COALESCE(SUM(I.quantity), 0) - COALESCE(SUM(O.quantity), 0) AS net_stock
FROM Products P
LEFT JOIN Inward I ON P.product_id = I.product_id
LEFT JOIN Outward O ON P.product_id = O.product_id
GROUP BY P.product_name;

-- JOIN with movement history
SELECT P.product_name, I.quantity AS InQty, O.quantity AS OutQty
FROM Products P
LEFT JOIN Inward I ON P.product_id = I.product_id
LEFT JOIN Outward O ON P.product_id = O.product_id;

-- HAVING: Negative stock check
SELECT P.product_name,
       SUM(I.quantity) - SUM(O.quantity) AS net_stock
FROM Products P
JOIN Inward I ON P.product_id = I.product_id
JOIN Outward O ON P.product_id = O.product_id
GROUP BY P.product_name
HAVING SUM(I.quantity) - SUM(O.quantity) < 0;

-- Rollback transaction example
START TRANSACTION;
UPDATE StockLevels
SET current_stock = current_stock - 150
WHERE product_id = 2;

-- Check consistency (simulate)
SELECT current_stock FROM StockLevels WHERE product_id = 2;

-- IF inconsistency found
ROLLBACK;

-- Table Setup
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50)
);

CREATE TABLE Marks (
    student_id INT,
    subject_id INT,
    mark INT CHECK (mark BETWEEN 0 AND 100)
);

-- Sample Inserts
INSERT INTO Students VALUES (1, 'Alice'), (2, 'Bob');
INSERT INTO Subjects VALUES (1, 'Math'), (2, 'Science');
INSERT INTO Marks VALUES (1,1,90), (1,2,85), (2,1,78), (2,2,82);

-- Total Marks with JOIN
SELECT S.student_id, S.student_name, SUM(M.mark) AS total_marks
FROM Students S
JOIN Marks M ON S.student_id = M.student_id
GROUP BY S.student_id, S.student_name;

-- Ranking (If supported)
SELECT student_id, total_marks,
       RANK() OVER (ORDER BY total_marks DESC) AS rank
FROM (
    SELECT student_id, SUM(mark) AS total_marks
    FROM Marks
    GROUP BY student_id
) AS scores;

-- Grading with CASE
SELECT student_id, subject_id, mark,
       CASE
           WHEN mark >= 90 THEN 'A'
           WHEN mark >= 75 THEN 'B'
           WHEN mark >= 60 THEN 'C'
           WHEN mark >= 40 THEN 'D'
           ELSE 'F'
       END AS grade
FROM Marks;

-- Table Setup
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    purchase_date DATE
);

CREATE TABLE Points (
    point_id INT PRIMARY KEY,
    customer_id INT,
    points_earned INT,
    transaction_id INT
);

-- Sample Inserts
INSERT INTO Customers VALUES (1, 'John'), (2, 'Mary');
INSERT INTO Purchases VALUES (1, 1, 1200, '2025-07-01'), (2, 2, 800, '2025-07-02');

-- Points with transaction
INSERT INTO Points VALUES (1, 1, 120, 1), (2, 2, 80, 2);

-- Total Spending
SELECT customer_id, SUM(amount) AS total_spent
FROM Purchases
GROUP BY customer_id;

-- Loyalty Level with CASE
SELECT customer_id,
       SUM(amount) AS total_spent,
       CASE
           WHEN SUM(amount) >= 1000 THEN 'Gold'
           WHEN SUM(amount) >= 500 THEN 'Silver'
           ELSE 'Bronze'
       END AS loyalty_level
FROM Purchases
GROUP BY customer_id;

-- Top Spender This Month
SELECT customer_id, SUM(amount) AS monthly_total
FROM Purchases
WHERE MONTH(purchase_date) = MONTH(CURRENT_DATE)
GROUP BY customer_id
ORDER BY monthly_total DESC
LIMIT 1;

-- 11. University Course Capacity Tracker
CREATE TABLE CourseCapacities (
    course_id INT PRIMARY KEY,
    max_students INT CHECK (max_students > 0)
);

SELECT c.course_id, COUNT(e.student_id) AS enrolled
FROM Enrollments e
JOIN CourseCapacities c ON e.course_id = c.course_id
GROUP BY c.course_id
HAVING COUNT(e.student_id) <= c.max_students;

-- 12. Hotel Room Reservation and Cancellation
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(20)
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    room_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

SELECT * FROM Bookings
WHERE start_date BETWEEN '2024-07-01' AND '2024-07-31';

SELECT * FROM Bookings b1
WHERE EXISTS (
  SELECT 1 FROM Bookings b2
  WHERE b1.room_id = b2.room_id AND b1.booking_id <> b2.booking_id
  AND b1.start_date < b2.end_date AND b1.end_date > b2.start_date
);

BEGIN;
DELETE FROM Bookings WHERE booking_id = 1;
ROLLBACK;

-- 13. Doctor Specialty Filter System
SELECT * FROM Doctors WHERE specialty LIKE '%Cardio%';

SELECT doctor_id, COUNT(*) AS patient_count
FROM Appointments
GROUP BY doctor_id
HAVING COUNT(*) > 10;

BEGIN;
UPDATE Doctors SET availability = 'Yes' WHERE doctor_id = 1;
COMMIT;

-- 14. Complaint and Ticketing System
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    user_id INT,
    created_at DATE
);

CREATE TABLE Responses (
    response_id INT PRIMARY KEY,
    ticket_id INT,
    message TEXT,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

SELECT *
FROM Tickets t
JOIN Responses r ON t.ticket_id = r.ticket_id;

SELECT *
FROM Tickets
WHERE created_at BETWEEN '2024-01-01' AND '2024-06-30'
ORDER BY created_at DESC;

BEGIN;
INSERT INTO Responses VALUES (1, 1, 'Resolved');
COMMIT;

SELECT ticket_id,
CASE
  WHEN EXISTS (SELECT 1 FROM Responses r WHERE r.ticket_id = t.ticket_id) THEN 'Resolved'
  ELSE 'Pending'
END AS status
FROM Tickets t;

-- 15. Transport Route and Booking Analyzer
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    origin VARCHAR(50),
    destination VARCHAR(50)
);

CREATE TABLE Buses (
    bus_id INT PRIMARY KEY,
    route_id INT,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

CREATE TABLE BusBookings (
    booking_id INT PRIMARY KEY,
    bus_id INT,
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id)
);

SELECT route_id, COUNT(*) AS bookings
FROM Buses b
JOIN BusBookings bb ON b.bus_id = bb.bus_id
GROUP BY route_id;

SELECT route_id
FROM Buses b
JOIN BusBookings bb ON b.bus_id = bb.bus_id
GROUP BY route_id
ORDER BY COUNT(*) DESC
LIMIT 1;

BEGIN;
DELETE FROM BusBookings WHERE booking_id = 99;
ROLLBACK;

-- 16. Sales Incentive Processor
CREATE TABLE Salespeople (
    salesperson_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    salesperson_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (salesperson_id) REFERENCES Salespeople(salesperson_id)
);

CREATE TABLE Bonuses (
    salesperson_id INT,
    bonus_amount DECIMAL(10,2)
);

SELECT salesperson_id,
CASE
  WHEN SUM(amount) > 10000 THEN 1000
  WHEN SUM(amount) > 5000 THEN 500
  ELSE 100
END AS bonus_amount
FROM Sales
GROUP BY salesperson_id;

BEGIN;
INSERT INTO Bonuses SELECT salesperson_id, 500 FROM Sales GROUP BY salesperson_id;
ROLLBACK;

-- 17. Insurance Claim Verification System
CREATE TABLE Claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    amount DECIMAL(10,2) CHECK (amount <= 100000),
    document_uploaded BOOLEAN
);

SELECT * FROM Claims WHERE document_uploaded IS NULL;

SELECT policy_id, AVG(amount) AS avg_claim
FROM Claims
GROUP BY policy_id;

-- 18. Daily Sales Comparison Report
SELECT p.product_id, p.product_name,
       SUM(CASE WHEN order_date = CURRENT_DATE THEN quantity ELSE 0 END) AS today_sales,
       SUM(CASE WHEN order_date = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY) THEN quantity ELSE 0 END) AS yesterday_sales,
       CASE
         WHEN SUM(CASE WHEN order_date = CURRENT_DATE THEN quantity ELSE 0 END) > 
              SUM(CASE WHEN order_date = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY) THEN quantity ELSE 0 END)
         THEN 'Increase'
         WHEN SUM(CASE WHEN order_date = CURRENT_DATE THEN quantity ELSE 0 END) < 
              SUM(CASE WHEN order_date = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY) THEN quantity ELSE 0 END)
         THEN 'Decrease'
         ELSE 'No Change'
       END AS trend
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name
ORDER BY trend;

-- 19. Multi-Store Product Consistency Checker
SELECT * FROM StoreA
UNION
SELECT * FROM StoreB;

SELECT * FROM StoreA
INTERSECT
SELECT * FROM StoreB;

SELECT * FROM StoreA
EXCEPT
SELECT * FROM StoreB;

-- Assume updating inconsistent record
BEGIN;
UPDATE StoreA SET price = 20 WHERE product_id = 101;
COMMIT;

-- 20. Online Examination Result Portal
CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Exams (
    exam_id INT PRIMARY KEY,
    subject VARCHAR(50)
);

CREATE TABLE Results (
    candidate_id INT,
    exam_id INT,
    score INT,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

SELECT c.name, e.subject, r.score
FROM Results r
JOIN Candidates c ON r.candidate_id = c.candidate_id
JOIN Exams e ON r.exam_id = e.exam_id;

SELECT candidate_id, PERCENT_RANK() OVER (ORDER BY score) AS percentile
FROM Results;

SELECT candidate_id, score,
CASE
    WHEN score >= 40 THEN 'Pass'
    ELSE 'Fail'
END AS status
FROM Results
ORDER BY score DESC;

