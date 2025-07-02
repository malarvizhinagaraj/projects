CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);
CREATE TABLE Trips (
    TripID INT PRIMARY KEY,
    Destination VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Price DECIMAL(10,2)
);
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TripID INT,
    BookingDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TripID) REFERENCES Trips(TripID)
);
INSERT INTO Customers VALUES
(1, 'Alice Johnson', 'alice@example.com'),
(2, 'Bob Smith', 'bob@example.com'),
(3, 'Charlie Brown', 'charlie@example.com');
INSERT INTO Trips VALUES
(101, 'Paris', '2025-08-01', '2025-08-10', 1500.00),
(102, 'New York', '2025-09-05', '2025-09-12', 1200.00),
(103, 'Tokyo', '2025-10-15', '2025-10-25', 1800.00),
(104, 'Sydney', '2025-11-01', '2025-11-10', 1700.00),
(105, 'Rio de Janeiro', '2025-12-05', '2025-12-15', 1600.00);
INSERT INTO Bookings (CustomerID, TripID, BookingDate) VALUES
(1, 101, '2025-06-15'),
(2, 102, '2025-06-20'),
(1, 103, '2025-07-01'),
(3, 101, '2025-07-05'),
(2, 104, '2025-07-10');

SELECT T.TripID, T.Destination, T.StartDate, T.EndDate, T.Price, B.BookingDate
FROM Bookings B
JOIN Trips T ON B.TripID = T.TripID
WHERE B.CustomerID = 1;

SELECT T.TripID, T.Destination, T.StartDate, T.EndDate, T.Price
FROM Trips T
LEFT JOIN Bookings B ON T.TripID = B.TripID
WHERE B.TripID IS NULL;
