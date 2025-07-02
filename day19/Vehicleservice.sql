CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    Model VARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    ServiceName VARCHAR(100) NOT NULL,
    Price DECIMAL(8,2) NOT NULL
);

CREATE TABLE ServiceRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    ServiceID INT,
    ServiceDate DATE NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);



-- Insert Customers
INSERT INTO Customers (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666');

-- Insert Vehicles
INSERT INTO Vehicles (CustomerID, LicensePlate, Model)
VALUES
(1, 'ABC123', 'Toyota Corolla'),
(2, 'XYZ789', 'Honda Civic');

-- Insert Services
INSERT INTO Services (ServiceName, Price)
VALUES
('Oil Change', 50.00),
('Tire Rotation', 30.00),
('Brake Inspection', 40.00);

-- Insert ServiceRecords
INSERT INTO ServiceRecords (VehicleID, ServiceID, ServiceDate)
VALUES
(1, 1, '2025-06-10'), -- Alice's vehicle serviced
(1, 2, '2025-06-20'),
(2, 1, '2025-05-25'),
(2, 3, '2025-06-05');


SELECT DISTINCT v.VehicleID, v.LicensePlate, v.Model, sr.ServiceDate
FROM Vehicles v
JOIN ServiceRecords sr ON v.VehicleID = sr.VehicleID
WHERE sr.ServiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);


SELECT c.CustomerID, c.Name, COUNT(sr.RecordID) AS ServiceCount
FROM Customers c
JOIN Vehicles v ON c.CustomerID = v.CustomerID
JOIN ServiceRecords sr ON v.VehicleID = sr.VehicleID
WHERE YEAR(sr.ServiceDate) = 2025
GROUP BY c.CustomerID, c.Name
HAVING COUNT(sr.RecordID) > 2;
