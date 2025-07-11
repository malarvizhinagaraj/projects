
-- ✅ 1. Employee Access Control System

CREATE OR REPLACE VIEW PublicEmployeeView AS
SELECT emp_id, emp_name, department FROM Employees;

DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(100))
BEGIN
  SELECT * FROM Employees WHERE department = dept_name;
END //
DELIMITER ;

CREATE TABLE EmployeeAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  action_type VARCHAR(20)
);

CREATE TRIGGER LogNewEmployee AFTER INSERT ON Employees
FOR EACH ROW
INSERT INTO EmployeeAudit(emp_id, action_type)
VALUES (NEW.emp_id, 'INSERT');

CREATE FUNCTION CountEmployeesInDept(dept_name VARCHAR(100))
RETURNS INT DETERMINISTIC
RETURN (SELECT COUNT(*) FROM Employees WHERE department = dept_name);


-- ✅ 2. Sales Reporting & Summary System

CREATE OR REPLACE VIEW MonthlySalesSummary AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(amount) AS total_sales
FROM Sales GROUP BY month;

DELIMITER //
CREATE FUNCTION GetTotalSalesForProduct(prod_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(amount) INTO total FROM Sales WHERE product_id = prod_id;
  RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Top10Customers()
BEGIN
  SELECT customer_id, SUM(amount) AS total
  FROM Sales GROUP BY customer_id
  ORDER BY total DESC LIMIT 10;
END //
DELIMITER ;

CREATE TABLE SalesLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  sale_id INT,
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogSale AFTER INSERT ON Sales
FOR EACH ROW
INSERT INTO SalesLog(sale_id) VALUES (NEW.sale_id);

-- ✅ 3. Use Case Placeholder
-- SQL logic for use case 3 would be here

-- ✅ 4. Use Case Placeholder
-- SQL logic for use case 4 would be here

-- ✅ 5. Use Case Placeholder
-- SQL logic for use case 5 would be here

-- ✅ 6. Use Case Placeholder
-- SQL logic for use case 6 would be here

-- ✅ 7. Use Case Placeholder
-- SQL logic for use case 7 would be here

-- ✅ 8. Use Case Placeholder
-- SQL logic for use case 8 would be here

-- ✅ 9. Use Case Placeholder
-- SQL logic for use case 9 would be here

-- ✅ 10. Use Case Placeholder
-- SQL logic for use case 10 would be here

-- ✅ 11. Use Case Placeholder
-- SQL logic for use case 11 would be here

-- ✅ 12. Use Case Placeholder
-- SQL logic for use case 12 would be here

-- ✅ 13. Use Case Placeholder
-- SQL logic for use case 13 would be here

-- ✅ 14. Use Case Placeholder
-- SQL logic for use case 14 would be here

-- ✅ 15. Use Case Placeholder
-- SQL logic for use case 15 would be here

-- ✅ 16. Use Case Placeholder
-- SQL logic for use case 16 would be here

-- ✅ 17. Use Case Placeholder
-- SQL logic for use case 17 would be here

-- ✅ 18. Use Case Placeholder
-- SQL logic for use case 18 would be here

-- ✅ 19. Use Case Placeholder
-- SQL logic for use case 19 would be here

-- ✅ 20. Use Case Placeholder
-- SQL logic for use case 20 would be here


-- ✅ 7. Online Exam Result Generator

CREATE OR REPLACE VIEW ResultSummaryView AS
SELECT student_id, exam_id, score, grade
FROM ExamResults;

DELIMITER //
CREATE PROCEDURE AssignGrade(IN student INT, IN exam INT, IN marks INT)
BEGIN
  DECLARE g CHAR(2);
  SET g = GetGrade(marks);
  UPDATE ExamResults SET score = marks, grade = g
  WHERE student_id = student AND exam_id = exam;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetGrade(score INT) RETURNS CHAR(2)
DETERMINISTIC
BEGIN
  RETURN CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 75 THEN 'B'
    WHEN score >= 60 THEN 'C'
    WHEN score >= 40 THEN 'D'
    ELSE 'F'
  END;
END //
DELIMITER ;

CREATE TABLE ScoreAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT,
  exam_id INT,
  old_score INT,
  new_score INT,
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER PreventUpdateAfterPublish
BEFORE UPDATE ON ExamResults
FOR EACH ROW
BEGIN
  IF OLD.published = 1 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Scores cannot be updated after publishing';
  END IF;
END;

CREATE TRIGGER LogScoreChange
AFTER UPDATE ON ExamResults
FOR EACH ROW
INSERT INTO ScoreAudit(student_id, exam_id, old_score, new_score)
VALUES (OLD.student_id, OLD.exam_id, OLD.score, NEW.score);


-- ✅ 8. Customer Loyalty Program

CREATE OR REPLACE VIEW LoyaltySummaryView AS
SELECT customer_id, points, GetLoyaltyLevel(points) AS level
FROM LoyaltyPoints;

DELIMITER //
CREATE FUNCTION GetLoyaltyLevel(p INT) RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  RETURN CASE
    WHEN p >= 1000 THEN 'Gold'
    WHEN p >= 500 THEN 'Silver'
    ELSE 'Bronze'
  END;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdatePoints(IN cust_id INT, IN added_points INT)
BEGIN
  UPDATE LoyaltyPoints SET points = points + added_points
  WHERE customer_id = cust_id;
END //
DELIMITER ;

CREATE TABLE LoyaltyLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  points_added INT,
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogLoyaltyUpdate
AFTER UPDATE ON LoyaltyPoints
FOR EACH ROW
INSERT INTO LoyaltyLog(customer_id, points_added)
VALUES (NEW.customer_id, NEW.points - OLD.points);


-- ✅ 9. User Registration and Role Manager

CREATE OR REPLACE VIEW AdminView AS SELECT user_id, username, email, role FROM Users WHERE role = 'admin';
CREATE OR REPLACE VIEW ManagerView AS SELECT user_id, username, department FROM Users WHERE role = 'manager';
CREATE OR REPLACE VIEW EmployeeView AS SELECT user_id, username FROM Users WHERE role = 'employee';

DELIMITER //
CREATE PROCEDURE AssignRole(IN uid INT, IN new_role VARCHAR(20))
BEGIN
  UPDATE Users SET role = new_role WHERE user_id = uid;
  INSERT INTO RoleAudit(user_id, new_role) VALUES (uid, new_role);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION IsAdmin(uid INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  RETURN EXISTS(SELECT 1 FROM Users WHERE user_id = uid AND role = 'admin');
END //
DELIMITER ;

CREATE TABLE RoleAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  new_role VARCHAR(20),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER InsertDefaultSettings
AFTER INSERT ON Users
FOR EACH ROW
INSERT INTO UserSettings(user_id, setting) VALUES (NEW.user_id, 'default');


-- ✅ 10. E-Commerce Product Search & Filter Engine

CREATE OR REPLACE VIEW AvailableProductsView AS
SELECT product_id, name, category, price
FROM Products
WHERE stock > 0;

DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN price - (price * discount / 100);
//

DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN cat VARCHAR(100), IN min_price DECIMAL(10,2), IN max_price DECIMAL(10,2))
BEGIN
  SELECT * FROM Products
  WHERE category = cat AND price BETWEEN min_price AND max_price AND stock > 0;
END //
DELIMITER ;

CREATE TABLE ProductLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  change_type VARCHAR(50),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
INSERT INTO ProductLog(product_id, change_type)
VALUES (NEW.product_id, 'UPDATE');


-- ✅ 11. Doctor Appointment and Notification Tracker

CREATE OR REPLACE VIEW DoctorScheduleView AS
SELECT doctor_id, schedule_time FROM Appointments;

DELIMITER //
CREATE PROCEDURE BookAppointment(IN pat_id INT, IN doc_id INT, IN time_slot DATETIME)
BEGIN
  INSERT INTO Appointments(patient_id, doctor_id, schedule_time)
  VALUES (pat_id, doc_id, time_slot);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION NextAvailableSlot(doc_id INT) RETURNS DATETIME
DETERMINISTIC
RETURN (
  SELECT MIN(schedule_time)
  FROM Appointments
  WHERE doctor_id = doc_id AND schedule_time > NOW()
);
//

CREATE TABLE AppointmentLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT,
  action VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER NotifyDoctorOnBooking
AFTER INSERT ON Appointments
FOR EACH ROW
INSERT INTO AppointmentLog(appointment_id, action)
VALUES (NEW.appointment_id, 'BOOKED');


-- ✅ 12. NGO Donation and Campaign Summary

CREATE OR REPLACE VIEW CampaignDonationView AS
SELECT campaign_id, SUM(amount) AS total_donations
FROM Donations GROUP BY campaign_id;

DELIMITER //
CREATE PROCEDURE RegisterDonation(IN donor_id INT, IN campaign_id INT, IN amt DECIMAL(10,2))
BEGIN
  INSERT INTO Donations(donor_id, campaign_id, amount)
  VALUES (donor_id, campaign_id, amt);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION DonorTotal(donor_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN (SELECT SUM(amount) FROM Donations WHERE donor_id = donor_id);
//

CREATE TABLE DonationAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  donor_id INT,
  campaign_id INT,
  amount DECIMAL(10,2),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogDonation
AFTER INSERT ON Donations
FOR EACH ROW
INSERT INTO DonationAudit(donor_id, campaign_id, amount)
VALUES (NEW.donor_id, NEW.campaign_id, NEW.amount);


-- ✅ 13. Restaurant Table Reservation System

CREATE OR REPLACE VIEW AvailableTablesView AS
SELECT table_id, time_slot FROM Tables
WHERE is_reserved = 0;

DELIMITER //
CREATE PROCEDURE ReserveTable(IN tid INT, IN slot DATETIME)
BEGIN
  UPDATE Tables SET is_reserved = 1, time_slot = slot WHERE table_id = tid;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION IsAvailable(tid INT, slot DATETIME) RETURNS BOOLEAN
DETERMINISTIC
RETURN NOT EXISTS (
  SELECT 1 FROM Tables WHERE table_id = tid AND time_slot = slot AND is_reserved = 1
);
//

CREATE TABLE Reservation_Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  table_id INT,
  status VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogTableReservation
AFTER UPDATE ON Tables
FOR EACH ROW
INSERT INTO Reservation_Audit(table_id, status)
VALUES (NEW.table_id, 'RESERVED');


-- ✅ 14. Service Center Workflow Automation

CREATE OR REPLACE VIEW ServiceRequestView AS
SELECT request_id, status FROM ServiceRequests;

DELIMITER //
CREATE PROCEDURE AssignTechnician(IN req_id INT, IN tech_id INT)
BEGIN
  UPDATE ServiceRequests SET technician_id = tech_id WHERE request_id = req_id;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TimeSinceRequest(req_id INT) RETURNS INT
DETERMINISTIC
RETURN TIMESTAMPDIFF(HOUR, (SELECT request_time FROM ServiceRequests WHERE request_id = req_id), NOW());
//

CREATE TABLE Service_Audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT,
  status VARCHAR(20),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogServiceCompletion
AFTER UPDATE ON ServiceRequests
FOR EACH ROW
  IF NEW.status = 'Closed' THEN
    INSERT INTO Service_Audit(request_id, status)
    VALUES (NEW.request_id, 'Closed');
  END IF;
