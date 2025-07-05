-- ✅ 1–5: Subqueries in SELECT Clause

-- 1. Employee salary vs highest salary
SELECT name, salary, (SELECT MAX(salary) FROM employees) AS highest_salary FROM employees;

-- 2. Employee salary and total number of employees
SELECT name, salary, (SELECT COUNT(*) FROM employees) AS total_employees FROM employees;

-- 3. Salary vs minimum in their department
SELECT e.name, e.salary, 
       (SELECT MIN(salary) FROM employees WHERE department_id = e.department_id) AS min_dept_salary
FROM employees e;

-- 4. Product price vs max price
SELECT name, price, (SELECT MAX(price) FROM products) AS highest_price FROM products;

-- 5. Employee bonus as 10% of max salary
SELECT name, salary, 0.10 * (SELECT MAX(salary) FROM employees) AS bonus FROM employees;

-- ✅ 6–10: Subqueries in FROM Clause

-- 6. Departments where avg salary > ₹10,000
SELECT dept_id FROM (
    SELECT department_id AS dept_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 10000;

-- 7. Department-wise avg salaries > company-wide avg
SELECT dept_id, avg_salary FROM (
    SELECT department_id AS dept_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id
) AS dept_avg
WHERE avg_salary > (SELECT AVG(salary) FROM employees);

-- 8. Top 3 salaried employees
SELECT name, department_id FROM (
    SELECT name, salary, department_id FROM employees ORDER BY salary DESC LIMIT 3
) AS top_emps;

-- 9. Total salary by departments with >5 employees
SELECT department_id, SUM(salary) AS total_salary FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;

-- 10. Temp table with salary ranges per department
SELECT department_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS avg_salary
FROM employees GROUP BY department_id;

-- ✅ 11–15: Subqueries in WHERE Clause

-- 11. Employees earning more than average
SELECT name, salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 12. Products priced above average
SELECT name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 13. Employees in departments with >3 employees
SELECT name FROM employees
WHERE department_id IN (
    SELECT department_id FROM employees GROUP BY department_id HAVING COUNT(*) > 3
);

-- 14. Customers with more orders than average
SELECT customer_id FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count) FROM (
        SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id
    ) AS cust_orders
);

-- 15. Products with quantity below global minimum
SELECT name, quantity FROM products
WHERE quantity < (SELECT MIN(quantity) FROM products);

-- ✅ 16–20: Correlated vs. Non-Correlated Subqueries

-- 16. Earn more than average in their department (correlated)
SELECT name, salary FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e1.department_id
);

-- 17. Highest paid in their department
SELECT name, salary FROM employees e
WHERE salary = (
    SELECT MAX(salary) FROM employees WHERE department_id = e.department_id
);

-- 18. Departments with employee earning > ₹50,000
SELECT DISTINCT department_id FROM employees
WHERE salary > 50000;

-- 19. Employees with higher salary than all team members
SELECT name FROM employees e1
WHERE salary > ALL (
    SELECT salary FROM employees e2
    WHERE e1.department_id = e2.department_id AND e1.id <> e2.id
);

-- 20. Earn less than max salary of any department
SELECT name FROM employees
WHERE salary < ANY (
    SELECT MAX(salary) FROM employees GROUP BY department_id
);

-- ✅ 21–25: UNION & UNION ALL

-- 21. Unique customer names from online and store orders
SELECT customer_name FROM online_orders
UNION
SELECT customer_name FROM store_orders;

-- 22. All customer names with duplicates
SELECT customer_name FROM online_orders
UNION ALL
SELECT customer_name FROM store_orders;

-- 23. Combine employee names
SELECT name FROM full_time_employees
UNION
SELECT name FROM contract_employees;

-- 24. Product names from electronics and furniture
SELECT name FROM electronics
UNION
SELECT name FROM furniture;

-- 25. City names from customers and suppliers (with and without duplicates)
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;

-- ✅ 26–30: INTERSECT & EXCEPT

-- 26. Employees in both IT (101) and Finance (102)
SELECT id FROM employees WHERE department_id = 101
INTERSECT
SELECT id FROM employees WHERE department_id = 102;

-- 27. Employees in IT but not HR (103)
SELECT id FROM employees WHERE department_id = 101
EXCEPT
SELECT id FROM employees WHERE department_id = 103;

-- 28. Products in both wholesale and retail
SELECT product_id FROM wholesale
INTERSECT
SELECT product_id FROM retail;

-- 29. Customers who only ordered online
SELECT customer_name FROM online_orders
EXCEPT
SELECT customer_name FROM store_orders;

-- 30. Employees not resigned
SELECT id FROM current_employees
EXCEPT
SELECT id FROM resigned_employees;

-- ✅ 31–35: JOIN + GROUP BY + Aggregation

-- 31. Total salary per department
SELECT d.name AS department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.name;

-- 32. Number of employees in each department
SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id;

-- 33. Avg salary per department
SELECT d.name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.id
GROUP BY d.name;

-- 34. Departments with salary bill > ₹1,00,000
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 100000;

-- 35. Employees hired per year
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS hires
FROM employees
GROUP BY hire_year;

-- ✅ 36–40: JOIN + Subquery + Aggregation

-- 36. Departments with avg salary > company avg
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- 37. Highest paid employee per department
SELECT d.name AS department, e.name AS employee, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE (e.department_id, e.salary) IN (
    SELECT department_id, MAX(salary) FROM employees GROUP BY department_id
);

-- 38. Departments with below avg employee count
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) < (
    SELECT AVG(dept_count) FROM (
        SELECT COUNT(*) AS dept_count FROM employees GROUP BY department_id
    ) AS dept_sizes
);

-- 39. Departments and count of employees > ₹50,000
SELECT department_id, COUNT(*) AS high_earners
FROM employees
WHERE salary > 50000
GROUP BY department_id;

-- 40. Employees earning more than department average
SELECT name, salary FROM employees e
WHERE salary > (
    SELECT AVG(salary) FROM employees WHERE department_id = e.department_id
);

-- ✅ 41–45: CASE WHEN – Conditional Aggregation

-- 41. Classify salaries
SELECT name, salary,
       CASE
           WHEN salary >= 70000 THEN 'High'
           WHEN salary >= 40000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_level
FROM employees;

-- 42. Product stock status
SELECT name, quantity,
       CASE
           WHEN quantity < 10 THEN 'Low'
           WHEN quantity BETWEEN 10 AND 50 THEN 'Moderate'
           ELSE 'High'
       END AS stock_status
FROM products;

-- 43. Dept-wise salary category counts
SELECT department_id,
       SUM(CASE WHEN salary >= 70000 THEN 1 ELSE 0 END) AS high,
       SUM(CASE WHEN salary BETWEEN 40000 AND 69999 THEN 1 ELSE 0 END) AS medium,
       SUM(CASE WHEN salary < 40000 THEN 1 ELSE 0 END) AS low
FROM employees
GROUP BY department_id;

-- 44. Employee remarks based on joining year
SELECT name, hire_date,
       CASE
           WHEN YEAR(hire_date) >= YEAR(CURDATE()) - 1 THEN 'New Joiner'
           WHEN YEAR(hire_date) >= YEAR(CURDATE()) - 5 THEN 'Mid-Level'
           ELSE 'Senior'
       END AS remarks
FROM employees;

-- 45. Salary grade
SELECT name, salary,
       CASE
           WHEN salary >= 80000 THEN 'A'
           WHEN salary >= 50000 THEN 'B'
           ELSE 'C'
       END AS grade
FROM employees;

-- ✅ 46–50: Date Functions

-- 46. Joined in last 6 months
SELECT name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 47. Tenure > 2 years
SELECT name, hire_date
FROM employees
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 2;

-- 48. Months since joining
SELECT name, TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) AS months_since_joining
FROM employees;

-- 49. Count of employees joined per year
SELECT YEAR(hire_date) AS join_year, COUNT(*) AS count
FROM employees
GROUP BY join_year;

-- 50. Employees with birthdays this month
SELECT name, hire_date
FROM employees
WHERE MONTH(hire_date) = MONTH(CURDATE());
