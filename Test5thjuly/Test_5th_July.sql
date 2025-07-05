-- 1. Employee Management System
 CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);


INSERT INTO Departments (DeptID, DeptName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

INSERT INTO Employees (EmpID, EmpName, Salary, DeptID) VALUES
(101, 'Alice', 50000, 1),
(102, 'Bob', 60000, 2),
(103, 'Charlie', 55000, 3);


UPDATE Employees
SET DeptID = 2, Salary = 62000
WHERE EmpID = 101;


DELETE FROM Employees
WHERE EmpID = 103;


DELETE FROM Employees
WHERE EmpID = 103;


SELECT e.EmpID, e.EmpName, e.Salary, d.DeptName
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;


SELECT d.DeptName, AVG(e.Salary) AS AvgSalary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptName;



START TRANSACTION;

UPDATE Employees SET Salary = Salary + 2000 WHERE DeptID = 1;
SAVEPOINT AfterHRUpdate;

UPDATE Employees SET Salary = Salary + 3000 WHERE DeptID = 2;
SAVEPOINT AfterFinanceUpdate;

-- If you need to undo the Finance update:
ROLLBACK TO AfterHRUpdate;

-- Finalize the transaction:
COMMIT;



CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50) NOT NULL
);

-- 2. Student Course Registration System
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Students (StudentID, StudentName) VALUES
(1, 'Ananya'),
(2, 'Rahul'),
(3, 'Meera');

INSERT INTO Courses (CourseID, CourseName) VALUES
(101, 'Mathematics'),
(102, 'Physics'),
(103, 'Computer Science');

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1001, 1, 101, '2025-07-05'),
(1002, 2, 102, '2025-07-05'),
(1003, 1, 103, '2025-07-05');

SELECT s.StudentName, c.CourseName, e.EnrollmentDate
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;
SELECT DISTINCT StudentID FROM Enrollments;
SELECT * FROM Enrollments
WHERE EnrollmentDate BETWEEN '2025-07-01' AND '2025-07-10';
SELECT * FROM Courses
WHERE CourseName LIKE 'Comp%';
SELECT * FROM Enrollments
WHERE StudentID = 1;
SELECT c.CourseName, COUNT(e.StudentID) AS NumberOfStudents
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY c.CourseName;
START TRANSACTION;
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES (1004, 3, 102, '2025-07-05');
ROLLBACK;
COMMIT;

-- 3. Online Shopping Platform Database
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) CHECK (Price > 0),
    Stock INT CHECK (Stock >= 0)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers (CustomerID, CustomerName, Email) VALUES
(1, 'Aditi', 'aditi@gmail.com'),
(2, 'Ravi', 'ravi@yahoo.com');

INSERT INTO Products (ProductID, ProductName, Price, Stock) VALUES
(101, 'Laptop', 70000, 10),
(102, 'Headphones', 1500, 25),
(103, 'Mouse', 500, 50);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(201, 1, '2025-07-05'),
(202, 2, '2025-07-05');

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity) VALUES
(301, 201, 101, 1),
(302, 201, 103, 2),
(303, 202, 102, 1);


SELECT c.CustomerName, o.OrderID, o.OrderDate, p.ProductName, oi.Quantity, p.Price
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID;


SELECT o.OrderID, c.CustomerName, SUM(p.Price * oi.Quantity) AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY o.OrderID, c.CustomerName;


SELECT * FROM Products
WHERE Price BETWEEN 1000 AND 8000;

SELECT * FROM Products
WHERE Stock IS NOT NULL AND Stock > 0;

-- Orders with items
SELECT o.OrderID, oi.ProductID, oi.Quantity
FROM Orders o
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID

UNION

-- Orders without items
SELECT o.OrderID, oi.ProductID, oi.Quantity
FROM Orders o
RIGHT JOIN OrderItems oi ON o.OrderID = oi.OrderID;

SELECT ProductID, ProductName
FROM Products
WHERE ProductID = (
    SELECT ProductID
    FROM OrderItems
    GROUP BY ProductID
    ORDER BY SUM(Quantity) DESC
    LIMIT 1
);

-- 4. Library Management System
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(50),
    TotalCopies INT CHECK (TotalCopies >= 0)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(50) NOT NULL
);

CREATE TABLE BorrowRecords (
    RecordID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    BorrowDate DATE NOT NULL,
    DueDate DATE CHECK (DueDate >= BorrowDate),
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert Members
INSERT INTO Members (MemberID, MemberName) VALUES
(1, 'Neha'),
(2, 'Aarav');

-- Insert Books
INSERT INTO Books (BookID, Title, Author, TotalCopies) VALUES
(101, 'Data Structures', 'Narasimha Karumanchi', 3),
(102, 'Operating Systems', 'Galvin', 2);

-- Insert Borrow Records
INSERT INTO BorrowRecords (RecordID, BookID, MemberID, BorrowDate, DueDate, ReturnDate) VALUES
(1001, 101, 1, '2025-07-05', '2025-07-20', NULL),
(1002, 102, 2, '2025-07-05', '2025-07-22', NULL);

-- Update Return Status when a book is returned
UPDATE BorrowRecords
SET ReturnDate = '2025-07-15'
WHERE RecordID = 1001;

SELECT m.MemberName, b.Title, br.BorrowDate, br.DueDate, br.ReturnDate
FROM BorrowRecords br
JOIN Members m ON br.MemberID = m.MemberID
JOIN Books b ON br.BookID = b.BookID;


SELECT 
    b.BookID,
    b.Title,
    b.TotalCopies,
    COUNT(br.RecordID) AS BorrowedCopies,
    CASE 
        WHEN b.TotalCopies > COUNT(br.RecordID) THEN 'Available'
        ELSE 'Borrowed'
    END AS Status
FROM Books b
LEFT JOIN BorrowRecords br ON b.BookID = br.BookID AND br.ReturnDate IS NULL
GROUP BY b.BookID, b.Title, b.TotalCopies;

SELECT m.MemberName, COUNT(br.BookID) AS BooksBorrowed
FROM Members m
LEFT JOIN BorrowRecords br ON m.MemberID = br.MemberID AND br.ReturnDate IS NULL
GROUP BY m.MemberName;

SELECT BookID, Title
FROM Books
WHERE BookID = (
    SELECT BookID
    FROM BorrowRecords
    GROUP BY BookID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 5. Sales and Inventory System
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Category VARCHAR(30),
    Price DECIMAL(10, 2) CHECK (Price > 0),
    Stock INT CHECK (Stock >= 0)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE NOT NULL
);

CREATE TABLE SalesItems (
    SaleItemID INT PRIMARY KEY,
    SaleID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Products
INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'T-Shirt', 'Clothing', 500, 100),
(2, 'Jeans', 'Clothing', 1200, 50),
(3, 'Headphones', 'Electronics', 1500, 30);

-- Insert a Sale
INSERT INTO Sales (SaleID, SaleDate) VALUES
(101, '2025-07-05');

-- Insert Sale Items
INSERT INTO SalesItems (SaleItemID, SaleID, ProductID, Quantity) VALUES
(201, 101, 1, 2),
(202, 101, 3, 1);

-- Update Stock after Sale
UPDATE Products
SET Stock = Stock - 2
WHERE ProductID = 1;

UPDATE Products
SET Stock = Stock - 1
WHERE ProductID = 3;

SELECT * FROM Products
ORDER BY Price DESC, Category ASC;
SELECT p.Category, p.ProductName, SUM(si.Quantity) AS TotalQuantitySold
FROM SalesItems si
JOIN Products p ON si.ProductID = p.ProductID
GROUP BY p.Category, p.ProductName;
SELECT p.Category, SUM(si.Quantity * p.Price) AS TotalSales
FROM SalesItems si
JOIN Products p ON si.ProductID = p.ProductID
GROUP BY p.Category
HAVING SUM(si.Quantity * p.Price) > 100000;
START TRANSACTION;

INSERT INTO Sales (SaleID, SaleDate) VALUES
(102, '2025-07-05');

INSERT INTO SalesItems (SaleItemID, SaleID, ProductID, Quantity) VALUES
(203, 102, 2, 1),
(204, 102, 3, 2);

-- Update stock
UPDATE Products SET Stock = Stock - 1 WHERE ProductID = 2;
UPDATE Products SET Stock = Stock - 2 WHERE ProductID = 3;

-- If any issue (e.g., stock went negative), you can rollback:
-- ROLLBACK;

-- If everything is correct:
COMMIT;


-- 6. Banking and Account System
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    Balance DECIMAL(15, 2) CHECK (Balance >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE NOT NULL,
    Amount DECIMAL(15, 2),
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('Deposit', 'Withdrawal')),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Insert Customers
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'Priya'),
(2, 'Rohan');

-- Insert Accounts
INSERT INTO Accounts (AccountID, CustomerID, Balance) VALUES
(101, 1, 50000),
(102, 2, 30000);

-- Deposit Transaction
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) VALUES
(1001, 101, '2025-07-05', 10000, 'Deposit');

UPDATE Accounts
SET Balance = Balance + 10000
WHERE AccountID = 101;

-- Withdrawal Transaction
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) VALUES
(1002, 102, '2025-07-05', 5000, 'Withdrawal');

UPDATE Accounts
SET Balance = Balance - 5000
WHERE AccountID = 102;

SELECT c.CustomerID, c.CustomerName, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Balance = (
    SELECT MAX(Balance) FROM Accounts
);

START TRANSACTION;

-- Deduct from sender (Rohan)
UPDATE Accounts
SET Balance = Balance - 5000
WHERE AccountID = 102;

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) VALUES
(1003, 102, '2025-07-05', 5000, 'Withdrawal');

-- Add to receiver (Priya)
UPDATE Accounts
SET Balance = Balance + 5000
WHERE AccountID = 101;

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType) VALUES
(1004, 101, '2025-07-05', 5000, 'Deposit');

-- If any issue (e.g., negative balance), rollback:
-- ROLLBACK;

-- If successful:
COMMIT;


-- 7. Hospital Patient Record System
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(50)
);

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50) NOT NULL,
    Age INT
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE NOT NULL,
    Status VARCHAR(15) CHECK (Status IN ('Upcoming', 'Completed', 'Cancelled')),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert Doctors
INSERT INTO Doctors (DoctorID, DoctorName, Specialty) VALUES
(1, 'Dr. Mehta', 'Cardiology'),
(2, 'Dr. Sharma', 'Neurology');

-- Insert Patients
INSERT INTO Patients (PatientID, PatientName, Age) VALUES
(101, 'Anjali', 30),
(102, 'Ravi', 45);

-- Insert Appointments
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, Status) VALUES
(1001, 101, 1, '2025-07-10', 'Upcoming'),
(1002, 102, 2, '2025-07-05', 'Completed');

SELECT a.AppointmentID, p.PatientName, d.DoctorName, d.Specialty, a.AppointmentDate, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

SELECT * FROM Appointments
WHERE DoctorID = 1;
SELECT * FROM Appointments
WHERE AppointmentDate BETWEEN '2025-07-01' AND '2025-07-15';
SELECT * FROM Patients
WHERE PatientName LIKE 'A%';
SELECT 
    AppointmentID,
    PatientID,
    DoctorID,
    AppointmentDate,
    Status,
    CASE 
        WHEN AppointmentDate > CURRENT_DATE THEN 'Upcoming'
        WHEN AppointmentDate = CURRENT_DATE THEN 'Today'
        ELSE 'Past'
    END AS DynamicStatus
FROM Appointments;
START TRANSACTION;

UPDATE Appointments
SET Status = 'Cancelled'
WHERE DoctorID = 1 AND AppointmentDate BETWEEN '2025-07-10' AND '2025-07-15';

-- If any mistake occurs:
-- ROLLBACK;

-- If correct:
COMMIT;


CREATE TABLE Plans (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50) NOT NULL,
    Fee DECIMAL(10, 2) CHECK (Fee > 0)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(50) NOT NULL,
    PlanID INT,
    RegistrationDate DATE,
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID),
    UNIQUE (MemberID, PlanID) -- prevent duplicate memberships for same member in same plan
);

-- Gym Membership System
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    MemberID INT,
    ClassName VARCHAR(50),
    BookingDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert Plans
INSERT INTO Plans (PlanID, PlanName, Fee) VALUES
(1, 'Basic', 1500),
(2, 'Premium', 3000),
(3, 'Yoga Only', 1000);

-- Insert Members
INSERT INTO Members (MemberID, MemberName, PlanID, RegistrationDate) VALUES
(101, 'Sneha', 2, '2025-07-05'),
(102, 'Aman', 1, '2025-07-05'),
(103, 'Rahul', NULL, NULL); -- incomplete registration

-- Insert Bookings
INSERT INTO Bookings (BookingID, MemberID, ClassName, BookingDate) VALUES
(201, 101, 'Zumba', '2025-07-06'),
(202, 102, 'HIIT', '2025-07-06');

SELECT p.PlanName, COUNT(m.MemberID) AS MemberCount
FROM Plans p
LEFT JOIN Members m ON p.PlanID = m.PlanID
GROUP BY p.PlanName;

SELECT * FROM Members
WHERE MemberName LIKE 'S%';

SELECT * FROM Members
WHERE PlanID IS NULL OR RegistrationDate IS NULL;

SELECT MemberID, MemberName, PlanID
FROM Members
WHERE PlanID = (
    SELECT PlanID FROM Plans
    ORDER BY Fee DESC
    LIMIT 1
);

SELECT m.MemberName, p.Fee
FROM Members m
JOIN Plans p ON m.PlanID = p.PlanID
WHERE p.Fee = (
    SELECT MAX(Fee) FROM Plans
);


-- 9. Restaurant Order Management System
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) CHECK (Price > 0)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ItemID INT,
    Quantity INT CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- Insert Customers
INSERT INTO Customers (CustomerID, CustomerName, Contact) VALUES
(1, 'Meera', '9876543210'),
(2, 'Arjun', '9123456780');

-- Insert Menu Items
INSERT INTO MenuItems (ItemID, ItemName, Price) VALUES
(101, 'Paneer Butter Masala', 250),
(102, 'Butter Naan', 40),
(103, 'Masala Dosa', 80);

-- Insert Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(201, 1, '2025-07-05'),
(202, 2, '2025-07-05');

-- Insert Order Details
INSERT INTO OrderDetails (OrderDetailID, OrderID, ItemID, Quantity) VALUES
(301, 201, 101, 2),
(302, 201, 102, 4),
(303, 202, 103, 3),
(304, 202, 102, 2);


SELECT o.OrderID, c.CustomerName, m.ItemName, od.Quantity, m.Price, (od.Quantity * m.Price) AS TotalPrice
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID;

SELECT o.OrderID, c.CustomerName, SUM(m.Price * od.Quantity) AS TotalBill
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID
GROUP BY o.OrderID, c.CustomerName;
SELECT c.CustomerName, SUM(m.Price * od.Quantity) AS TotalSpent
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID
GROUP BY c.CustomerName
HAVING SUM(m.Price * od.Quantity) > 500;
START TRANSACTION;

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(203, 1, '2025-07-05');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ItemID, Quantity) VALUES
(305, 203, 101, 1),
(306, 203, 102, 2);

COMMIT;

START TRANSACTION;

-- Delete order details first due to foreign key constraint
DELETE FROM OrderDetails WHERE OrderID = 203;

-- Then delete the order
DELETE FROM Orders WHERE OrderID = 203;

COMMIT;

-- 10. Hotel Booking System

-- Hotel Booking System: Manage Rooms, Customers, Bookings

-- 1️⃣ Drop tables if they exist (for re-runs during practice)
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Rooms;

-- 2️⃣ Create Tables
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomType VARCHAR(30),
    PricePerNight DECIMAL(10, 2),
    AvailabilityStatus VARCHAR(15) CHECK (AvailabilityStatus IN ('Available', 'Booked'))
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    RoomID INT,
    CustomerID INT,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 3️⃣ Insert Sample Data into Rooms
INSERT INTO Rooms (RoomID, RoomType, PricePerNight, AvailabilityStatus) VALUES
(1, 'Single', 1500, 'Available'),
(2, 'Double', 2500, 'Available'),
(3, 'Suite', 5000, 'Available');

-- Insert Sample Data into Customers
INSERT INTO Customers (CustomerID, CustomerName, Contact) VALUES
(101, 'Kavya', '9876543210'),
(102, 'Manav', '9123456780');

-- 4️⃣ Insert Booking and Update Room Availability
INSERT INTO Bookings (BookingID, RoomID, CustomerID, CheckInDate, CheckOutDate) VALUES
(201, 2, 101, '2025-07-10', '2025-07-12');

UPDATE Rooms
SET AvailabilityStatus = 'Booked'
WHERE RoomID = 2;

-- 5️⃣ Filter Bookings within a Date Range using BETWEEN
SELECT * FROM Bookings
WHERE CheckInDate BETWEEN '2025-07-01' AND '2025-07-15';

-- 6️⃣ Check Rooms Currently Booked using Subquery
SELECT * FROM Rooms
WHERE RoomID IN (
    SELECT RoomID FROM Bookings
    WHERE CURRENT_DATE BETWEEN CheckInDate AND CheckOutDate
);

-- 7️⃣ Check Available Rooms
SELECT * FROM Rooms
WHERE AvailabilityStatus = 'Available';

-- 8️⃣ Get Full Booking Details Sorted by Check-In Date
SELECT b.BookingID, c.CustomerName, r.RoomType, b.CheckInDate, b.CheckOutDate
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Rooms r ON b.RoomID = r.RoomID
ORDER BY b.CheckInDate ASC;

-- 11. University Grading System
-- University Grading System: Store Scores, Classify Grades, Generate Report Cards

-- 1️⃣ Drop tables if they exist (for reruns during practice)
DROP TABLE IF EXISTS Marks;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Students;

-- 2️⃣ Create Tables

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL
);

CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL
);

CREATE TABLE Marks (
    MarkID INT PRIMARY KEY,
    StudentID INT,
    SubjectID INT,
    MarksObtained INT CHECK (MarksObtained BETWEEN 0 AND 100),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- 3️⃣ Insert Sample Data

-- Students
INSERT INTO Students (StudentID, StudentName) VALUES
(1, 'Ananya'),
(2, 'Rohan'),
(3, 'Meera');

-- Subjects
INSERT INTO Subjects (SubjectID, SubjectName) VALUES
(101, 'Mathematics'),
(102, 'Physics'),
(103, 'Chemistry');

-- Marks
INSERT INTO Marks (MarkID, StudentID, SubjectID, MarksObtained) VALUES
(1001, 1, 101, 95),
(1002, 1, 102, 88),
(1003, 1, 103, 92),
(1004, 2, 101, 78),
(1005, 2, 102, 85),
(1006, 2, 103, 80),
(1007, 3, 101, 65),
(1008, 3, 102, 70),
(1009, 3, 103, 60);

-- 4️⃣ Use CASE to Convert Marks to Grades

SELECT 
    m.MarkID,
    s.StudentName,
    sub.SubjectName,
    m.MarksObtained,
    CASE
        WHEN m.MarksObtained >= 90 THEN 'A+'
        WHEN m.MarksObtained >= 80 THEN 'A'
        WHEN m.MarksObtained >= 70 THEN 'B'
        WHEN m.MarksObtained >= 60 THEN 'C'
        ELSE 'D'
    END AS Grade
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID;

-- Use AVG() to Get GPA per Student

SELECT 
    s.StudentID,
    s.StudentName,
    AVG(m.MarksObtained) AS GPA
FROM Students s
JOIN Marks m ON s.StudentID = m.StudentID
GROUP BY s.StudentID, s.StudentName;

-- 6️⃣ Use JOIN to Generate Full Report Cards

SELECT 
    s.StudentName,
    sub.SubjectName,
    m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
ORDER BY s.StudentName, sub.SubjectName;

-- Use HAVING to Show Top-Performing Students (GPA >= 85)

SELECT 
    s.StudentID,
    s.StudentName,
    AVG(m.MarksObtained) AS GPA
FROM Students s
JOIN Marks m ON s.StudentID = m.StudentID
GROUP BY s.StudentID, s.StudentName
HAVING AVG(m.MarksObtained) >= 85;

-- 8️. Use Subqueries to Find Top Scorer in Each Subject

SELECT 
    sub.SubjectName,
    s.StudentName,
    m.MarksObtained
FROM Marks m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Subjects sub ON m.SubjectID = sub.SubjectID
WHERE m.MarksObtained = (
    SELECT MAX(MarksObtained)
    FROM Marks
    WHERE SubjectID = sub.SubjectID
);

-- 12. Donation and NGO System
-- Drop tables if they exist (for clean reruns during practice)
DROP TABLE IF EXISTS Donations;
DROP TABLE IF EXISTS Donors;
DROP TABLE IF EXISTS Campaigns;

-- Create Tables

CREATE TABLE Donors (
    DonorID INT PRIMARY KEY,
    DonorName VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

CREATE TABLE Campaigns (
    CampaignID INT PRIMARY KEY,
    CampaignName VARCHAR(50) NOT NULL,
    GoalAmount DECIMAL(12, 2)
);

CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    DonorID INT,
    CampaignID INT,
    DonationDate DATE NOT NULL,
    Amount DECIMAL(12, 2) CHECK (Amount > 0),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID),
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID)
);

-- Insert Sample Data

-- Insert Donors
INSERT INTO Donors (DonorID, DonorName, Contact) VALUES
(1, 'Arav', '9876543210'),
(2, 'Divya', '9123456780'),
(3, 'Neha', '9012345678');

-- Insert Campaigns
INSERT INTO Campaigns (CampaignID, CampaignName, GoalAmount) VALUES
(101, 'Child Education', 500000),
(102, 'Healthcare Support', 300000);

-- Insert Donations
INSERT INTO Donations (DonationID, DonorID, CampaignID, DonationDate, Amount) VALUES
(1001, 1, 101, '2025-07-05', 5000),
(1002, 2, 102, '2025-07-05', 20000),
(1003, 1, 102, '2025-07-06', 15000),
(1004, 3, 101, '2025-07-06', 3000);

-- Update a Donation Record
UPDATE Donations
SET Amount = 18000
WHERE DonationID = 1003;

--  Delete a Donation Record (e.g., if added by mistake)
DELETE FROM Donations
WHERE DonationID = 1004;

--  Use SUM() and GROUP BY to Show Total Donations Per Donor
SELECT d.DonorName, SUM(do.Amount) AS TotalDonated
FROM Donors d
JOIN Donations do ON d.DonorID = do.DonorID
GROUP BY d.DonorName;

--  Use SUM() and GROUP BY to Show Total Donations Per Campaign
SELECT c.CampaignName, SUM(do.Amount) AS TotalReceived
FROM Campaigns c
JOIN Donations do ON c.CampaignID = do.CampaignID
GROUP BY c.CampaignName;

--  Use CASE WHEN to Tag Donations as Small/Medium/Large
SELECT 
    DonationID,
    DonorID,
    CampaignID,
    Amount,
    CASE 
        WHEN Amount < 5000 THEN 'Small'
        WHEN Amount BETWEEN 5000 AND 15000 THEN 'Medium'
        ELSE 'Large'
    END AS DonationSize
FROM Donations;

--  Use Subquery to Find the Most Generous Donor (highest total donation)
SELECT d.DonorName, SUM(do.Amount) AS TotalDonated
FROM Donors d
JOIN Donations do ON d.DonorID = do.DonorID
GROUP BY d.DonorName
HAVING SUM(do.Amount) = (
    SELECT MAX(TotalDonation) FROM (
        SELECT SUM(Amount) AS TotalDonation
        FROM Donations
        GROUP BY DonorID
    ) AS DonationTotals
);


-- 13. Event Registration System
--  Drop tables if they exist for clean reruns
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS Events;

--  Create Tables

CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(50) NOT NULL,
    EventDate DATE NOT NULL
);

CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(50) NOT NULL,
    City VARCHAR(30)
);

CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY,
    EventID INT,
    ParticipantID INT,
    RegistrationDate DATE NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
    CONSTRAINT UniqueRegistration UNIQUE (EventID, ParticipantID) -- prevent duplicate registration
);

--  Insert Sample Data

-- Events
INSERT INTO Events (EventID, EventName, EventDate) VALUES
(1, 'Tech Conference', '2025-08-15'),
(2, 'Art Workshop', '2025-08-20'),
(3, 'Music Fest', '2025-09-01');

-- Participants
INSERT INTO Participants (ParticipantID, ParticipantName, City) VALUES
(101, 'Aditi', 'Mumbai'),
(102, 'Ravi', 'Delhi'),
(103, 'Sneha', 'Bangalore'),
(104, 'Karan', 'Delhi');

-- Registrations
INSERT INTO Registrations (RegistrationID, EventID, ParticipantID, RegistrationDate) VALUES
(1001, 1, 101, '2025-07-05'),
(1002, 1, 102, '2025-07-05'),
(1003, 2, 103, '2025-07-06'),
(1004, 3, 104, '2025-07-06'),
(1005, 3, 101, '2025-07-07');

--  Use JOINs to List Participants per Event

SELECT 
    e.EventName,
    p.ParticipantName,
    p.City,
    r.RegistrationDate
FROM Registrations r
JOIN Events e ON r.EventID = e.EventID
JOIN Participants p ON r.ParticipantID = p.ParticipantID
ORDER BY e.EventName, p.ParticipantName;

--  Use DISTINCT to Show All Cities Participants Are From

SELECT DISTINCT City
FROM Participants
WHERE City IS NOT NULL;

--  Use Subquery to List Most Popular Events (with maximum participants)

SELECT e.EventName, COUNT(r.ParticipantID) AS TotalParticipants
FROM Events e
JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.EventName
HAVING COUNT(r.ParticipantID) = (
    SELECT MAX(EventCount) FROM (
        SELECT COUNT(ParticipantID) AS EventCount
        FROM Registrations
        GROUP BY EventID
    ) AS EventCounts
);


-- 14. Transport & Ticket Booking System

--  Drop tables if they exist for clean reruns
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Seats;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Routes;

--  Create Tables

CREATE TABLE Routes (
    RouteID INT PRIMARY KEY,
    RouteName VARCHAR(50) NOT NULL,
    DepartureTime TIME NOT NULL,
    ArrivalTime TIME NOT NULL
);

CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    PassengerName VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

CREATE TABLE Seats (
    SeatID INT PRIMARY KEY,
    RouteID INT,
    SeatNumber INT CHECK (SeatNumber > 0 AND SeatNumber <= 50),
    PassengerID INT,
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    PassengerID INT,
    RouteID INT,
    SeatID INT,
    BookingDate DATE NOT NULL,
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);

--  Insert Sample Data

-- Routes
INSERT INTO Routes (RouteID, RouteName, DepartureTime, ArrivalTime) VALUES
(1, 'City A to City B', '08:00:00', '12:00:00'),
(2, 'City B to City C', '14:00:00', '18:00:00');

-- Passengers
INSERT INTO Passengers (PassengerID, PassengerName, Contact) VALUES
(101, 'Anil', '9876543210'),
(102, 'Riya', '9123456780'),
(103, 'Vikas', '9012345678');

-- Seats
INSERT INTO Seats (SeatID, RouteID, SeatNumber, PassengerID) VALUES
(201, 1, 1, 101),
(202, 1, 2, NULL),
(203, 1, 3, 102),
(204, 2, 1, NULL),
(205, 2, 2, 103);

-- Tickets
INSERT INTO Tickets (TicketID, PassengerID, RouteID, SeatID, BookingDate) VALUES
(301, 101, 1, 201, '2025-07-05'),
(302, 102, 1, 203, '2025-07-05'),
(303, 103, 2, 205, '2025-07-06');

--  Use IS NULL to Show Available Seats
SELECT SeatID, RouteID, SeatNumber
FROM Seats
WHERE PassengerID IS NULL;

--  Use BETWEEN to Find Bookings in a Time Range
SELECT t.TicketID, p.PassengerName, r.RouteName, t.BookingDate
FROM Tickets t
JOIN Passengers p ON t.PassengerID = p.PassengerID
JOIN Routes r ON t.RouteID = r.RouteID
WHERE t.BookingDate BETWEEN '2025-07-01' AND '2025-07-10';

--  Use CASE to Show Seat Status (Booked/Available)
SELECT 
    s.SeatID,
    s.RouteID,
    s.SeatNumber,
    CASE 
        WHEN s.PassengerID IS NOT NULL THEN 'Booked'
        ELSE 'Available'
    END AS SeatStatus
FROM Seats s;

-- View Full Booking Details with Joins
SELECT 
    t.TicketID,
    p.PassengerName,
    r.RouteName,
    s.SeatNumber,
    t.BookingDate
FROM Tickets t
JOIN Passengers p ON t.PassengerID = p.PassengerID
JOIN Routes r ON t.RouteID = r.RouteID
JOIN Seats s ON t.SeatID = s.SeatID
ORDER BY t.BookingDate;


-- 15. Retail Customer Loyalty Tracker

-- Drop tables if they exist for clean reruns
DROP TABLE IF EXISTS Rewards;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Customers;

-- Create Tables

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    Contact VARCHAR(15)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    TransactionDate DATE NOT NULL,
    Amount DECIMAL(10, 2) CHECK (Amount > 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Rewards (
    RewardID INT PRIMARY KEY,
    CustomerID INT UNIQUE,
    Points INT DEFAULT 0,
    LoyaltyTier VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--  Insert Sample Data

-- Customers
INSERT INTO Customers (CustomerID, CustomerName, Contact) VALUES
(1, 'Priya', '9876543210'),
(2, 'Aman', '9123456780'),
(3, 'Sara', '9012345678');

-- Transactions
INSERT INTO Transactions (TransactionID, CustomerID, TransactionDate, Amount) VALUES
(1001, 1, '2025-07-05', 1500),
(1002, 2, '2025-07-05', 3000),
(1003, 1, '2025-07-06', 500),
(1004, 3, '2025-07-06', 4500);

-- Rewards Initialization
INSERT INTO Rewards (RewardID, CustomerID, Points, LoyaltyTier) VALUES
(201, 1, 0, NULL),
(202, 2, 0, NULL),
(203, 3, 0, NULL);

--  Use SUM() for Total Spend Per Customer
SELECT c.CustomerName, SUM(t.Amount) AS TotalSpend
FROM Customers c
JOIN Transactions t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerName;

--  Use CASE to Assign Loyalty Tier Based on Total Spend
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(t.Amount) AS TotalSpend,
    CASE
        WHEN SUM(t.Amount) >= 4000 THEN 'Gold'
        WHEN SUM(t.Amount) >= 2000 THEN 'Silver'
        ELSE 'Bronze'
    END AS LoyaltyTier
FROM Customers c
JOIN Transactions t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

--  Update Rewards Points on Repeat Purchases
-- Add 1 point for every 100 spent in each transaction

UPDATE Rewards
SET Points = Points + (
    SELECT SUM(FLOOR(t.Amount / 100))
    FROM Transactions t
    WHERE t.CustomerID = Rewards.CustomerID
)
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID FROM Transactions
);

-- Update Loyalty Tier in Rewards Table
UPDATE Rewards
SET LoyaltyTier = (
    SELECT CASE
        WHEN SUM(t.Amount) >= 4000 THEN 'Gold'
        WHEN SUM(t.Amount) >= 2000 THEN 'Silver'
        ELSE 'Bronze'
    END
    FROM Transactions t
    WHERE t.CustomerID = Rewards.CustomerID
)
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID FROM Transactions
);

-- View Final Rewards Table
SELECT * FROM Rewards;

-- 16. Attendance Management System: Track Daily Attendance

-- Drop tables if they exist for clean reruns
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Employees;

-- Create Tables

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Department VARCHAR(30)
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    EmployeeID INT,
    AttendanceDate DATE NOT NULL,
    CheckInTime TIME NOT NULL,
    CheckOutTime TIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

--  Insert Sample Data

-- Employees
INSERT INTO Employees (EmployeeID, EmployeeName, Department) VALUES
(1, 'Rohit', 'IT'),
(2, 'Sneha', 'HR'),
(3, 'Aditya', 'Finance');

-- Attendance
INSERT INTO Attendance (AttendanceID, EmployeeID, AttendanceDate, CheckInTime, CheckOutTime) VALUES
(101, 1, '2025-07-05', '08:55:00', '17:00:00'),
(102, 2, '2025-07-05', '09:15:00', '17:05:00'),
(103, 3, '2025-07-05', '09:05:00', '16:55:00'),
(104, 1, '2025-07-06', '08:50:00', '17:10:00'),
(105, 2, '2025-07-06', '09:20:00', '17:00:00'),
(106, 3, '2025-07-06', '09:00:00', '16:50:00');

--  Use BETWEEN to Find Late Check-ins (after 9:00 AM but before 9:30 AM)

SELECT 
    a.AttendanceID,
    e.EmployeeName,
    a.AttendanceDate,
    a.CheckInTime
FROM Attendance a
JOIN Employees e ON a.EmployeeID = e.EmployeeID
WHERE a.CheckInTime BETWEEN '09:01:00' AND '09:30:00';

--  Use Subquery to Find the Most Punctual Employee (earliest average check-in time)

SELECT e.EmployeeName, AVG(TIME_TO_SEC(a.CheckInTime)) AS AvgCheckInSeconds
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeName
HAVING AVG(TIME_TO_SEC(a.CheckInTime)) = (
    SELECT MIN(AvgCheckIn) FROM (
        SELECT AVG(TIME_TO_SEC(CheckInTime)) AS AvgCheckIn
        FROM Attendance
        GROUP BY EmployeeID
    ) AS AvgTimes
);

--  Use Transactions to Record Daily Bulk Entries

START TRANSACTION;

INSERT INTO Attendance (AttendanceID, EmployeeID, AttendanceDate, CheckInTime, CheckOutTime) VALUES
(107, 1, '2025-07-07', '08:52:00', '17:05:00'),
(108, 2, '2025-07-07', '09:10:00', '17:02:00'),
(109, 3, '2025-07-07', '09:03:00', '16:58:00');

COMMIT;



-- 17. Movie Ticket Booking System (Entertainment)


DROP TABLE IF EXISTS Tickets, Shows, Movies, Customers;

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieName VARCHAR(50),
    Genre VARCHAR(30)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Contact VARCHAR(15)
);

CREATE TABLE Shows (
    ShowID INT PRIMARY KEY,
    MovieID INT,
    ShowTime DATETIME,
    AvailableSeats INT CHECK (AvailableSeats >= 0),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    ShowID INT,
    CustomerID INT,
    SeatNo INT,
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert Data
INSERT INTO Movies VALUES (1, 'Inception', 'Sci-Fi'), (2, 'Titanic', 'Romance');
INSERT INTO Customers VALUES (1, 'Arjun', '9876543210'), (2, 'Megha', '9123456780');
INSERT INTO Shows VALUES (1, 1, '2025-07-10 18:00:00', 100), (2, 2, '2025-07-11 20:00:00', 80);

-- Insert Ticket (Booking)
START TRANSACTION;
INSERT INTO Tickets VALUES (1, 1, 1, 10);
UPDATE Shows SET AvailableSeats = AvailableSeats - 1 WHERE ShowID = 1;

-- Simulate overbooking rollback:
-- ROLLBACK;

COMMIT;

-- JOINs for Full Booking Info
SELECT t.TicketID, c.CustomerName, m.MovieName, s.ShowTime, t.SeatNo
FROM Tickets t
JOIN Customers c ON t.CustomerID = c.CustomerID
JOIN Shows s ON t.ShowID = s.ShowID
JOIN Movies m ON s.MovieID = m.MovieID;

-- GROUP BY to Show Most Watched Movie
SELECT m.MovieName, COUNT(t.TicketID) AS TotalBookings
FROM Movies m
JOIN Shows s ON m.MovieID = s.MovieID
JOIN Tickets t ON s.ShowID = t.ShowID
GROUP BY m.MovieName
ORDER BY TotalBookings DESC;



-- 18. Freelance Project Tracker (Freelancing)


DROP TABLE IF EXISTS Payments, Projects, Freelancers;

CREATE TABLE Freelancers (
    FreelancerID INT PRIMARY KEY,
    FreelancerName VARCHAR(50),
    Skill VARCHAR(30)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    FreelancerID INT,
    ProjectName VARCHAR(50),
    Status VARCHAR(15),
    FOREIGN KEY (FreelancerID) REFERENCES Freelancers(FreelancerID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    ProjectID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Insert Data
INSERT INTO Freelancers VALUES (1, 'Priya', 'Web Dev'), (2, 'Kunal', 'Design');
INSERT INTO Projects VALUES (1, 1, 'Website Build', 'Pending'), (2, 2, 'Logo Design', 'Completed');
INSERT INTO Payments VALUES (1, 2, 5000, '2025-07-05');

-- Use CASE for Project Status
SELECT ProjectID, ProjectName,
    CASE Status
        WHEN 'Pending' THEN 'In Progress'
        WHEN 'Completed' THEN 'Done'
        ELSE 'Unknown'
    END AS ProjectStatus
FROM Projects;

-- SUM() to Track Earnings per Freelancer
SELECT f.FreelancerName, SUM(p.Amount) AS TotalEarnings
FROM Freelancers f
JOIN Projects pr ON f.FreelancerID = pr.FreelancerID
JOIN Payments p ON pr.ProjectID = p.ProjectID
GROUP BY f.FreelancerName;

-- Subquery to Find Most Paid Freelancer
SELECT f.FreelancerName, SUM(p.Amount) AS TotalEarnings
FROM Freelancers f
JOIN Projects pr ON f.FreelancerID = pr.FreelancerID
JOIN Payments p ON pr.ProjectID = p.ProjectID
GROUP BY f.FreelancerName
HAVING SUM(p.Amount) = (
    SELECT MAX(TotalPaid) FROM (
        SELECT SUM(p.Amount) AS TotalPaid
        FROM Projects pr
        JOIN Payments p ON pr.ProjectID = p.ProjectID
        GROUP BY pr.FreelancerID
    ) AS PaymentSummary
);


-- 19. Clinic and Medical Record System (Healthcare)


DROP TABLE IF EXISTS Prescriptions, Visits, Patients, Doctors;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Contact VARCHAR(15)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    Specialization VARCHAR(30)
);

CREATE TABLE Visits (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    VisitDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY,
    VisitID INT,
    Medicine VARCHAR(50),
    Dosage VARCHAR(30),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

-- Insert Data
INSERT INTO Patients VALUES (1, 'Rahul', '9876543210'), (2, 'Anika', '9123456780');
INSERT INTO Doctors VALUES (1, 'Dr. Sharma', 'Cardiology'), (2, 'Dr. Mehta', 'Dermatology');
INSERT INTO Visits VALUES (1, 1, 1, '2025-07-05'), (2, 2, 2, '2025-07-06');

-- Transaction: Multiple Prescriptions
START TRANSACTION;
INSERT INTO Prescriptions VALUES (1, 1, 'Medicine A', '2x daily');
INSERT INTO Prescriptions VALUES (2, 1, 'Medicine B', '1x daily');
COMMIT;

-- JOIN, GROUP BY, ORDER BY
SELECT p.PatientName, d.DoctorName, v.VisitDate, pr.Medicine
FROM Prescriptions pr
JOIN Visits v ON pr.VisitID = v.VisitID
JOIN Patients p ON v.PatientID = p.PatientID
JOIN Doctors d ON v.DoctorID = d.DoctorID
ORDER BY v.VisitDate;

-- IS NULL: List Patients without Follow-up
SELECT p.PatientName
FROM Patients p
LEFT JOIN Visits v ON p.PatientID = v.PatientID
WHERE v.VisitID IS NULL;


-- 20. Warehouse Product Movement System (Logistics)

DROP TABLE IF EXISTS StockLevels, Outward, Inward, Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50)
);

CREATE TABLE Inward (
    InwardID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    InwardDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Outward (
    OutwardID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    OutwardDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE StockLevels (
    ProductID INT PRIMARY KEY,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Data
INSERT INTO Products VALUES (1, 'Laptop'), (2, 'Monitor');

-- Transaction: Large Delivery
START TRANSACTION;
INSERT INTO Inward VALUES (1, 1, 50, '2025-07-05'), (2, 2, 30, '2025-07-05');
UPDATE StockLevels SET Quantity = Quantity + 50 WHERE ProductID = 1;
UPDATE StockLevels SET Quantity = Quantity + 30 WHERE ProductID = 2;
COMMIT;

-- UPDATE Stock After Movement (Outward)
INSERT INTO Outward VALUES (1, 1, 5, '2025-07-06');
UPDATE StockLevels SET Quantity = Quantity - 5 WHERE ProductID = 1;

-- GROUP BY: Warehouse-Level Stock Reports
SELECT p.ProductName, s.Quantity AS CurrentStock
FROM Products p
JOIN StockLevels s ON p.ProductID = s.ProductID
ORDER BY p.ProductName;

-- Subquery: List Most Moved Products
SELECT p.ProductName, SUM(movement.TotalMoved) AS TotalMovement
FROM Products p
JOIN (
    SELECT ProductID, SUM(Quantity) AS TotalMoved FROM Inward GROUP BY ProductID
    UNION ALL
    SELECT ProductID, SUM(Quantity) FROM Outward GROUP BY ProductID
) movement ON p.ProductID = movement.ProductID
GROUP BY p.ProductName
ORDER BY TotalMovement DESC;
