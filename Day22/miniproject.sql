
-- 1. Employee Salary Insight Dashboard
SELECT 
    e.employee_id,
    e.name,
    e.salary,
    (SELECT MAX(salary) FROM employees) AS company_max_salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary,
    (SELECT MIN(salary) FROM employees) AS company_min_salary,
    CASE 
        WHEN e.salary > (SELECT AVG(salary) FROM employees) THEN 'High'
        WHEN e.salary = (SELECT AVG(salary) FROM employees) THEN 'Medium'
        ELSE 'Low'
    END AS salary_level,
    CASE 
        WHEN e.salary > (SELECT AVG(salary) FROM employees d WHERE d.department_id = e.department_id)
        THEN 'Above Dept Avg'
        ELSE 'Below Dept Avg'
    END AS dept_comparison
FROM employees e;

-- Department-wise salary summary
SELECT d.department_id, d.department_name,
       COUNT(e.employee_id) AS employee_count,
       AVG(e.salary) AS avg_salary,
       MAX(e.salary) AS max_salary,
       MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- 2. Department Budget Analyzer

SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id;

SELECT d.dept_id, SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id
HAVING AVG(e.salary) > 50000;

SELECT dept_id, total_salary
FROM (
    SELECT dept_id, SUM(salary) AS total_salary
    FROM employees
    GROUP BY dept_id
) t
WHERE total_salary = (
    SELECT MAX(total_salary) 
    FROM (
        SELECT dept_id, SUM(salary) AS total_salary
        FROM employees
        GROUP BY dept_id
    ) x
);

-- 3. Employee Transfer Tracker

SELECT employee_id FROM employees WHERE department_id = 'IT'
INTERSECT
SELECT employee_id FROM employees WHERE department_id = 'Finance';

SELECT employee_id FROM employees WHERE department_id = 'IT'
EXCEPT
SELECT employee_id FROM employees WHERE department_id = 'Finance';

SELECT employee_id
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SELECT employee_id, 
       (SELECT COUNT(DISTINCT department_id) 
        FROM employees e2 
        WHERE e2.employee_id = e1.employee_id) AS dept_count
FROM employees e1;


-- 4. Product Category Merger Report

SELECT * FROM electronics
UNION
SELECT * FROM clothing
UNION
SELECT * FROM furniture;

SELECT * FROM electronics
UNION ALL
SELECT * FROM clothing
UNION ALL
SELECT * FROM furniture;

SELECT MAX(price), MIN(price) FROM (
    SELECT price FROM electronics
    UNION ALL
    SELECT price FROM clothing
    UNION ALL
    SELECT price FROM furniture
) ;

SELECT product_id, price,
       CASE 
           WHEN price > 10000 THEN 'Premium'
           WHEN price BETWEEN 5000 AND 10000 THEN 'Standard'
           ELSE 'Budget'
       END AS price_category
FROM products;

-- 5. Customer Purchase Comparison Tool

SELECT customer_id FROM online_customers
UNION
SELECT customer_id FROM offline_customers;

SELECT customer_id FROM online_customers
UNION ALL
SELECT customer_id FROM offline_customers;

SELECT customer_id FROM online_customers
INTERSECT
SELECT customer_id FROM offline_customers;

SELECT customer_id 
FROM purchases 
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total) FROM (
        SELECT SUM(amount) AS total
        FROM purchases
        GROUP BY customer_id
    ) x
);

-- 6. High Performer Identification System

SELECT employee_id, salary, department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
);

SELECT employee_id, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

SELECT employee_id, 
       CASE 
           WHEN performance_score >= 90 THEN 'Top'
           WHEN performance_score >= 70 THEN 'Average'
           ELSE 'Needs Improvement'
       END AS performance_level
FROM employees;

-- 7. Inventory Stock Checker

SELECT item_id, stock FROM category1
UNION
SELECT item_id, stock FROM category2;

SELECT AVG(stock) FROM inventory;

SELECT item_id, stock,
       CASE 
           WHEN stock > 100 THEN 'High'
           WHEN stock BETWEEN 50 AND 100 THEN 'Moderate'
           ELSE 'Low'
       END AS stock_status
FROM inventory;

SELECT item_id FROM warehouse1
EXCEPT
SELECT item_id FROM warehouse2;


-- 8. Employee Joiner Trend Report

SELECT * FROM employees
WHERE join_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SELECT employee_id
FROM employees
WHERE join_date < (
    SELECT AVG(join_date) FROM employees
);

SELECT MONTH(join_date) AS month, COUNT(*) AS joiners
FROM employees
GROUP BY MONTH(join_date);

SELECT employee_id, 
       CASE 
           WHEN YEAR(join_date) = YEAR(CURDATE()) THEN 'Current Year'
           ELSE 'Previous Year'
       END AS hiring_year
FROM employees;


-- 9. Department Performance Ranker

SELECT department_id, SUM(salary) AS total_salary, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

SELECT d.department_id, d.department_name, e.avg_salary,
       CASE 
           WHEN e.avg_salary > 70000 THEN 'Excellent'
           WHEN e.avg_salary > 50000 THEN 'Good'
           ELSE 'Needs Improvement'
       END AS performance_tag
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) e
JOIN departments d ON e.department_id = d.department_id
WHERE e.avg_salary > (SELECT AVG(salary) FROM employees);

-- 10. Cross-Sell Opportunity Finder

SELECT customer_id FROM category1_purchases
INTERSECT
SELECT customer_id FROM category2_purchases;

SELECT customer_id FROM category1_purchases
EXCEPT
SELECT customer_id FROM category2_purchases;

SELECT customer_id
FROM purchases
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total) FROM (
        SELECT SUM(amount) AS total
        FROM purchases
        GROUP BY customer_id
    ) 
);

SELECT customer_id FROM category1_purchases
UNION
SELECT customer_id FROM category2_purchases;


-- 11. Salary Band Distribution Analyzer

SELECT employee_id, department_id,
       CASE 
           WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'Band A'
           WHEN salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Band B'
           ELSE 'Band C'
       END AS salary_band
FROM employees e;

SELECT department_id, salary_band, COUNT(*) AS count
FROM (
    SELECT employee_id, department_id,
           CASE 
               WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'Band A'
               WHEN salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Band B'
               ELSE 'Band C'
           END AS salary_band
    FROM employees e
) 
GROUP BY department_id, salary_band
HAVING SUM(CASE WHEN salary_band = 'Band A' THEN 1 ELSE 0 END) > 3;


-- 12. Product Launch Impact Report

SELECT * FROM products
WHERE launch_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

SELECT product_id, sales FROM new_products
UNION
SELECT product_id, sales FROM existing_products;

SELECT AVG(sales) FROM products;

SELECT product_id,
       CASE 
           WHEN sales >= (SELECT AVG(sales) FROM products) THEN 'Successful'
           WHEN sales >= 0.8 * (SELECT AVG(sales) FROM products) THEN 'Neutral'
           ELSE 'Fail'
       END AS launch_outcome
FROM products;


-- 13. Supplier Consistency Checker

SELECT supplier_id FROM suppliers_q1
INTERSECT
SELECT supplier_id FROM suppliers_q2;

SELECT supplier_id FROM suppliers_q1
EXCEPT
SELECT supplier_id FROM suppliers_q2;

SELECT supplier_id,
       CASE 
           WHEN avg_delivery_time <= (SELECT AVG(avg_delivery_time) FROM suppliers) THEN 'On Time'
           ELSE 'Late'
       END AS delivery_status
FROM suppliers;


-- 14. Student Performance Dashboard

SELECT student_id, 
       CASE 
           WHEN marks >= 75 THEN 'Distinction'
           WHEN marks >= 50 THEN 'Merit'
           ELSE 'Pass'
       END AS result
FROM students;

SELECT s.student_id, s.name, c.course_name
FROM students s
JOIN courses c ON s.course_id = c.course_id;

SELECT student_id
FROM students
WHERE marks > (SELECT AVG(marks) FROM students);


-- 15. Revenue Comparison Engine

SELECT YEAR(date) AS year, MONTH(date) AS month, SUM(revenue) AS total
FROM sales
GROUP BY YEAR(date), MONTH(date);

SELECT AVG(total) FROM (
    SELECT YEAR(date) AS year, SUM(revenue) AS total
    FROM sales
    GROUP BY YEAR(date)
) x;

SELECT YEAR(date) AS year, MONTH(date) AS month,
       CASE 
           WHEN SUM(revenue) > (SELECT AVG(total) FROM (
                                   SELECT YEAR(date) AS year, SUM(revenue) AS total
                                   FROM sales
                                   GROUP BY YEAR(date)
                               ) x) THEN 'High'
           ELSE 'Low'
       END AS revenue_class
FROM sales
GROUP BY YEAR(date), MONTH(date);

-- 16. Resignation & Replacement Audit

SELECT employee_id FROM resigned
EXCEPT
SELECT employee_id FROM hired;

SELECT designation FROM resigned
INTERSECT
SELECT designation FROM hired;

SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT department_id, COUNT(*) AS resigned_count
FROM resigned
JOIN departments ON resigned.department_id = departments.department_id
GROUP BY department_id;

-- 17. Product Return & Complaint Analyzer

SELECT product_id, COUNT(*) AS return_count
FROM returns
GROUP BY product_id
ORDER BY return_count DESC
LIMIT 1;

SELECT return_id, 
       CASE 
           WHEN reason = 'Damaged' THEN 'Damaged'
           WHEN reason = 'Late' THEN 'Late'
           ELSE 'Not as Described'
       END AS reason_category
FROM returns;

SELECT o.order_id, r.return_id
FROM orders o
JOIN returns r ON o.order_id = r.order_id;

SELECT product_id
FROM returns
GROUP BY product_id
HAVING COUNT(*) > (
    SELECT AVG(return_count) FROM (
        SELECT product_id, COUNT(*) AS return_count
        FROM returns
        GROUP BY product_id
    ) x
);


-- 18. Freelancer Project Tracker

SELECT AVG(earnings) FROM freelancers;

SELECT project_id, freelancer_id, earnings
FROM projects p
WHERE earnings > (
    SELECT AVG(earnings) FROM projects WHERE freelancer_id = p.freelancer_id
);

SELECT freelancer_id,
       CASE 
           WHEN earnings >= 100000 THEN 'Top Earner'
           WHEN earnings >= 50000 THEN 'Mid Earner'
           ELSE 'Low Earner'
       END AS earning_category
FROM freelancers;

SELECT freelancer_id, COUNT(*) AS project_count
FROM projects
GROUP BY freelancer_id;

-- 19. Course Enrollment Optimizer

SELECT * FROM free_enrollments
UNION
SELECT * FROM paid_enrollments;

SELECT AVG(enrollment_count) FROM (
    SELECT course_id, COUNT(*) AS enrollment_count
    FROM enrollments
    GROUP BY course_id
) x;

SELECT c.course_id, c.course_name, cat.category_name
FROM courses c
JOIN categories cat ON c.category_id = cat.category_id;

SELECT course_id,
       CASE 
           WHEN COUNT(*) >= (SELECT AVG(enrollment_count) FROM (
                                SELECT course_id, COUNT(*) AS enrollment_count
                                FROM enrollments
                                GROUP BY course_id
                              ) x) THEN 'Popular'
           ELSE 'Regular'
       END AS popularity
FROM enrollments
GROUP BY course_id;

-- 20. Vehicle Maintenance Tracker

SELECT vehicle_id FROM vehicles
WHERE next_service_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

SELECT vehicle_id
FROM maintenance
GROUP BY vehicle_id
ORDER BY SUM(cost) DESC
LIMIT 1;

SELECT vehicle_id, 
       CASE 
           WHEN next_service_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN 'High'
           WHEN next_service_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 'Medium'
           ELSE 'Low'
       END AS urgency
FROM vehicles;

SELECT vehicle_type, SUM(cost) AS total_cost
FROM maintenance
GROUP BY vehicle_type;

