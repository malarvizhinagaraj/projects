

-- 1. Company Payroll Analytics
SELECT department, SUM(salary) AS total_salary, AVG(salary) AS avg_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees GROUP BY department;
SELECT department, SUM(salary) AS total_salary FROM employees GROUP BY department HAVING SUM(salary) > 100000;
SELECT emp_name, salary FROM employees ORDER BY salary DESC LIMIT 3;

-- 2. School Performance Dashboard
SELECT student_id, AVG(grade) AS avg_grade FROM grades GROUP BY student_id;
SELECT class_id, AVG(grade) AS avg_class_grade FROM grades GROUP BY class_id;
SELECT class_id FROM grades GROUP BY class_id HAVING AVG(grade) < 50;
SELECT student_id, MAX(grade) AS max_grade FROM grades GROUP BY student_id ORDER BY max_grade DESC LIMIT 1;
SELECT student_id, MIN(grade) AS min_grade FROM grades GROUP BY student_id ORDER BY min_grade ASC LIMIT 1;

-- 3. E-Commerce Sales Summary
SELECT product_id, SUM(quantity * price) AS total_sales FROM order_items GROUP BY product_id;
SELECT customer_id, SUM(quantity * price) AS total_spent FROM order_items JOIN orders USING(order_id) GROUP BY customer_id;
SELECT c.customer_id FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;

-- 4. Hospital Department Metrics
SELECT department_id, COUNT(*) AS patient_count FROM patients GROUP BY department_id;
SELECT doctor_id, COUNT(*) AS appointment_count FROM appointments GROUP BY doctor_id ORDER BY appointment_count DESC;
SELECT department_id FROM patients GROUP BY department_id HAVING COUNT(*) > 100;

-- 5. Library Borrowing Trends
SELECT book_id, COUNT(*) AS loan_count FROM loans GROUP BY book_id;
SELECT book_id FROM loans GROUP BY book_id HAVING COUNT(*) > 10;
SELECT m.member_id FROM members m LEFT JOIN loans l ON m.member_id = l.member_id WHERE l.loan_id IS NULL;

-- 6. Restaurant Order Analysis
SELECT menu_item_id, SUM(quantity * price) AS revenue FROM order_details GROUP BY menu_item_id;
SELECT customer_id, SUM(quantity * price) AS total_spent FROM orders JOIN order_details USING(order_id) GROUP BY customer_id ORDER BY total_spent DESC;
SELECT mi.menu_item_id FROM menu_items mi LEFT JOIN order_details od ON mi.menu_item_id = od.menu_item_id WHERE od.menu_item_id IS NULL;

-- 7. University Course Statistics
SELECT course_id, COUNT(*) AS student_count FROM enrollments GROUP BY course_id;
SELECT course_id FROM courses LEFT JOIN enrollments ON courses.course_id = enrollments.course_id WHERE enrollments.course_id IS NULL;
SELECT course_id FROM enrollments GROUP BY course_id HAVING MIN(grade) >= 50;

-- 8. Retail Inventory & Supplier Summary
SELECT supplier_id, SUM(quantity) AS total_stock FROM purchases GROUP BY supplier_id;
SELECT product_id FROM products p LEFT JOIN purchases pu ON p.product_id = pu.product_id WHERE pu.product_id IS NULL;
SELECT supplier_id FROM products GROUP BY supplier_id ORDER BY COUNT(*) DESC LIMIT 1;

-- 9. Fitness Club Member Engagement
SELECT member_id, COUNT(*) AS attendance_count FROM attendance GROUP BY member_id;
SELECT m.member_id FROM members m LEFT JOIN attendance a ON m.member_id = a.member_id WHERE a.class_id IS NULL;
SELECT class_id, AVG(attendance_count) AS avg_attendance FROM (SELECT class_id, COUNT(*) AS attendance_count FROM attendance GROUP BY class_id) sub GROUP BY class_id ORDER BY avg_attendance DESC;

-- 10. Event Registration Reporting
SELECT event_id, COUNT(*) AS registration_count FROM registrations GROUP BY event_id;
SELECT attendee_id, COUNT(*) AS total_events FROM registrations GROUP BY attendee_id ORDER BY total_events DESC;
SELECT e.event_id FROM events e LEFT JOIN registrations r ON e.event_id = r.event_id WHERE r.event_id IS NULL;

-- 11. IT Asset Management
SELECT department_id, COUNT(*) AS asset_count FROM assets GROUP BY department_id;
SELECT employee_id FROM assets GROUP BY employee_id HAVING COUNT(*) > 2;
SELECT d.department_id FROM departments d LEFT JOIN assets a ON d.department_id = a.department_id WHERE a.asset_id IS NULL;

-- 12. Movie Rental Store Insights
SELECT movie_id, COUNT(*) AS rental_count FROM rentals GROUP BY movie_id ORDER BY rental_count DESC LIMIT 1;
SELECT movie_id, COUNT(*) AS rental_count FROM rentals GROUP BY movie_id ORDER BY rental_count ASC LIMIT 1;
SELECT customer_id FROM rentals WHERE return_date < CURRENT_DATE;
SELECT m.movie_id FROM movies m LEFT JOIN rentals r ON m.movie_id = r.movie_id WHERE r.movie_id IS NULL;

-- 13. Bank Branch & Customer Statistics
SELECT branch_id, COUNT(account_id) AS account_count, SUM(balance) AS total_balance FROM accounts GROUP BY branch_id;
SELECT c.customer_id FROM customers c LEFT JOIN transactions t ON c.customer_id = t.customer_id WHERE t.transaction_id IS NULL;
SELECT branch_id FROM customers GROUP BY branch_id ORDER BY COUNT(*) DESC LIMIT 1;
SELECT branch_id FROM customers GROUP BY branch_id ORDER BY COUNT(*) ASC LIMIT 1;

-- 14. Clinic Patient Visit Analysis
SELECT doctor_id, COUNT(*) AS visit_count FROM visits GROUP BY doctor_id;
SELECT patient_id FROM visits GROUP BY patient_id HAVING COUNT(*) = 1;
SELECT d.doctor_id FROM doctors d LEFT JOIN visits v ON d.doctor_id = v.doctor_id WHERE v.visit_id IS NULL;

-- 15. Hotel Booking Dashboard
SELECT room_id, COUNT(*) AS bookings FROM bookings GROUP BY room_id;
SELECT guest_id FROM bookings GROUP BY guest_id HAVING COUNT(*) > 1;
SELECT r.room_id FROM rooms r LEFT JOIN bookings b ON r.room_id = b.room_id WHERE b.room_id IS NULL;

-- 16. Online Learning Platform Statistics
SELECT user_id, COUNT(*) AS completions FROM completions GROUP BY user_id;
SELECT course_id FROM completions GROUP BY course_id HAVING COUNT(*) < 5;
SELECT u.user_id FROM users u LEFT JOIN completions c ON u.user_id = c.user_id WHERE c.course_id IS NULL;

-- 17. Municipal Service Requests
SELECT citizen_id, COUNT(*) AS request_count FROM requests GROUP BY citizen_id;
SELECT department_id, COUNT(*) AS dept_requests FROM requests GROUP BY department_id;
SELECT d.department_id FROM departments d LEFT JOIN requests r ON d.department_id = r.department_id WHERE r.department_id IS NULL;
SELECT citizen_id FROM requests GROUP BY citizen_id ORDER BY COUNT(*) DESC LIMIT 1;

-- 18. Warehouse Order Fulfillment
SELECT employee_id, COUNT(DISTINCT order_id) AS handled_orders FROM orders GROUP BY employee_id;
SELECT product_id FROM products WHERE stock = 0;
SELECT employee_id, COUNT(*) AS fulfilled FROM order_items GROUP BY employee_id ORDER BY fulfilled DESC LIMIT 1;

-- 19. Sales Team Performance Tracking
SELECT region_id, SUM(amount) AS total_sales FROM sales GROUP BY region_id;
SELECT salesperson_id, SUM(amount) AS total_sales FROM sales GROUP BY salesperson_id;
SELECT s.salesperson_id FROM salespeople s LEFT JOIN sales sa ON s.salesperson_id = sa.salesperson_id GROUP BY s.salesperson_id, sa.region_id HAVING SUM(sa.amount) IS NULL;
-- Note: Sales growth requires historical data with dates to compute change over time.

-- 20. Friend Referral Program
SELECT r.user_id, COUNT(*) AS total_referrals FROM referrals r GROUP BY r.user_id;
SELECT r.user_id FROM referrals r LEFT JOIN purchases p ON r.user_id = p.user_id WHERE p.purchase_id IS NULL;
SELECT r.user_id, COUNT(*) AS referred_purchases FROM referrals r JOIN purchases p ON r.referred_user_id = p.user_id GROUP BY r.user_id ORDER BY referred_purchases DESC LIMIT 1;
