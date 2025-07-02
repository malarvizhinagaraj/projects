CREATE TABLE Tables (
    TableID INT PRIMARY KEY,
    Capacity INT
);
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TableID INT,
    ReservationDate DATE,
    ReservationTime TIME,
    NumberOfGuests INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TableID) REFERENCES Tables(TableID)
);

INSERT INTO Tables VALUES
(1, 2),
(2, 4),
(3, 4),
(4, 6),
(5, 8);

INSERT INTO Reservations (CustomerID, TableID, ReservationDate, ReservationTime, NumberOfGuests) VALUES
(101, 1, '2025-07-05', '19:00:00', 2),
(102, 2, '2025-07-05', '19:00:00', 4),
(103, 3, '2025-07-05', '20:00:00', 3),
(101, 4, '2025-07-06', '18:30:00', 5),
(101, 1, '2025-07-07', '20:00:00', 2);

SELECT * FROM Tables
WHERE TableID NOT IN (
    SELECT TableID
    FROM Reservations
    WHERE ReservationDate = '2025-07-05'
      AND ReservationTime = '19:00:00'
);

SELECT C.Name, COUNT(*) AS TotalReservations
FROM Reservations R
JOIN Customers C ON R.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.Name
HAVING COUNT(*) > 2;
