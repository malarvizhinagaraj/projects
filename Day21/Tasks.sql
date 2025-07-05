
SELECT COUNT(*) AS total_employees FROM employees;

-- 2
SELECT COUNT(*) AS it_employees FROM employees WHERE department = 'IT';

-- 3
SELECT SUM(salary) AS total_salary FROM employees;

-- 4
SELECT SUM(salary) AS hr_total_salary FROM employees WHERE department = 'HR';

-- 5
SELECT AVG(salary) AS avg_salary FROM employees;

-- 6
SELECT AVG(salary) AS marketing_avg_salary FROM employees WHERE department = 'Marketing';

-- 7
SELECT MIN(salary) AS min_salary FROM employees;

-- 8
SELECT MAX(salary) AS max_salary FROM employees;

-- 9
SELECT MIN(hire_date) AS earliest_hire FROM employees;

-- 10
SELECT MAX(hire_date) AS latest_hire FROM employees;


-- 11
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department;

-- 12
SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department;

-- 13
SELECT department, COUNT(*) AS num_employees FROM employees GROUP BY department;

-- 14
SELECT department, COUNT(*) AS num_employees FROM employees GROUP BY department HAVING COUNT(*) > 2;

-- 15
SELECT department, MIN(salary) AS min_salary FROM employees GROUP BY department;

-- 16
SELECT department, MAX(salary) AS max_salary FROM employees GROUP BY department;

-- 17
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS num_employees FROM employees GROUP BY YEAR(hire_date);

-- 18
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department HAVING SUM(salary) > 100000;

-- 19
SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department HAVING AVG(salary) > 60000;

-- 20
SELECT YEAR(hire_date) AS year, COUNT(*) AS hires FROM employees GROUP BY YEAR(hire_date);



-- 21
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department HAVING SUM(salary) < 120000;

-- 22
SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department HAVING AVG(salary) < 55000;

-- 23
SELECT department, COUNT(*) AS emp_count, SUM(salary) AS total_salary FROM employees GROUP BY department HAVING COUNT(*) > 3 AND SUM(salary) > 150000;

-- 24
SELECT department, MAX(salary) AS max_salary FROM employees GROUP BY department HAVING MAX(salary) >= 70000;

-- 25
SELECT department, MIN(salary) AS min_salary FROM employees GROUP BY department HAVING MIN(salary) > 50000;


-- 26
SELECT MAX(salary) AS highest_salary FROM employees WHERE hire_date > '2020-01-01';

-- 27
SELECT COUNT(*) AS below_avg_count FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

-- 28
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department WITH ROLLUP;

-- 29
SELECT department FROM employees GROUP BY department ORDER BY COUNT(*) DESC LIMIT 1;

-- 30
SELECT department FROM employees GROUP BY department ORDER BY SUM(salary) ASC LIMIT 1;

-- 31
SELECT e.emp_name, d.department_name FROM employees e INNER JOIN departments d ON e.department = d.department_id;

-- 32
SELECT e.emp_name, d.department_name FROM employees e LEFT JOIN departments d ON e.department = d.department_id;

-- 33
SELECT d.department_name, e.emp_name FROM employees e RIGHT JOIN departments d ON e.department = d.department_id;

-- 34
SELECT department_name FROM departments d LEFT JOIN employees e ON d.department_id = e.department;

-- 35
SELECT d.department_name, COUNT(*) AS employee_count FROM employees e JOIN departments d ON e.department = d.department_id GROUP BY d.department_name;


-- 36
SELECT e.emp_name, d.department_name, s.amount FROM employees e
JOIN departments d ON e.department = d.department_id
JOIN salaries s ON e.emp_id = s.employee_id
WHERE s.date_paid = (SELECT MAX(date_paid) FROM salaries s2 WHERE s2.employee_id = e.emp_id);

-- 37
SELECT d.department_name, s.amount FROM salaries s
JOIN employees e ON s.employee_id = e.emp_id
JOIN departments d ON e.department = d.department_id;

-- 38
SELECT e.emp_name FROM employees e LEFT JOIN salaries s ON e.emp_id = s.employee_id WHERE s.employee_id IS NULL;

-- 39
SELECT d.department_name, SUM(s.amount) AS total_paid FROM salaries s
JOIN employees e ON s.employee_id = e.emp_id
JOIN departments d ON e.department = d.department_id GROUP BY d.department_name;

-- 40
SELECT d.department_name, AVG(s.amount) AS avg_paid FROM salaries s
JOIN employees e ON s.employee_id = e.emp_id
JOIN departments d ON e.department = d.department_id GROUP BY d.department_name;

/* -----------------------------
   Self Joins
------------------------------*/
-- 41
SELECT e.emp_name AS employee, m.emp_name AS manager FROM employees e JOIN employees m ON e.manager_id = m.emp_id;

-- 42
SELECT DISTINCT m.emp_name AS manager FROM employees e JOIN employees m ON e.manager_id = m.emp_id;

-- 43
SELECT e1.emp_name AS employee1, e2.emp_name AS employee2 FROM employees e1 JOIN employees e2 ON e1.manager_id = e2.manager_id WHERE e1.emp_id != e2.emp_id;

-- 44
SELECT m.emp_name AS manager, COUNT(e.emp_id) AS reportee_count FROM employees e JOIN employees m ON e.manager_id = m.emp_id GROUP BY m.emp_name;

-- 45
SELECT e.emp_name FROM employees e JOIN employees m ON e.manager_id = m.emp_id WHERE m.department = 'IT';

/* -----------------------------
   Combining Aggregates and Joins
------------------------------*/
-- 46
SELECT d.department_name, MAX(s.amount) AS highest_salary FROM salaries s
JOIN employees e ON s.employee_id = e.emp_id
JOIN departments d ON e.department = d.department_id GROUP BY d.department_name;

-- 47
SELECT e.emp_name FROM employees e
JOIN (SELECT department, AVG(salary) AS dept_avg FROM employees GROUP BY department) a
ON e.department = a.department WHERE e.salary > a.dept_avg;

-- 48
SELECT d.department_name, SUM(s.amount) AS total_salary FROM salaries s
JOIN employees e ON s.employee_id = e.emp_id
JOIN departments d ON e.department = d.department_id
WHERE e.hire_date < '2020-01-01' GROUP BY d.department_name;

-- 49
SELECT department FROM employees GROUP BY department HAVING MIN(salary) > 50000;

-- 50
SELECT m.emp_name AS manager, COUNT(e.emp_id) AS team_size FROM employees e JOIN employees m ON e.manager_id = m.emp_id GROUP BY m.emp_name ORDER BY team_size DESC LIMIT 1;
