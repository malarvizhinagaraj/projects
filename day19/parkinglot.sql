CREATE TABLE Lots (
    LotID INT PRIMARY KEY AUTO_INCREMENT,
    LotName VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    OwnerName VARCHAR(100) NOT NULL
);

CREATE TABLE ParkingRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    LotID INT,
    VehicleID INT,
    EntryTime DATETIME NOT NULL,
    ExitTime DATETIME,
    FOREIGN KEY (LotID) REFERENCES Lots(LotID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);


-- Insert Lots
INSERT INTO Lots (LotName, Capacity)
VALUES
('Lot A', 2),
('Lot B', 3);

-- Insert Vehicles
INSERT INTO Vehicles (LicensePlate, OwnerName)
VALUES
('ABC123', 'Alice'),
('XYZ789', 'Bob'),
('LMN456', 'Charlie');

-- Insert ParkingRecords
INSERT INTO ParkingRecords (LotID, VehicleID, EntryTime, ExitTime)
VALUES
(1, 1, '2025-07-01 08:00:00', NULL),             -- Alice currently parked
(1, 2, '2025-07-01 09:00:00', '2025-07-01 11:00:00'), -- Bob exited
(2, 3, '2025-07-01 10:00:00', NULL);


SELECT v.VehicleID, v.LicensePlate, v.OwnerName, p.EntryTime, l.LotName
FROM Vehicles v
JOIN ParkingRecords p ON v.VehicleID = p.VehicleID
JOIN Lots l ON p.LotID = l.LotID
WHERE p.ExitTime IS NULL;

SELECT l.LotID, l.LotName, l.Capacity, COUNT(p.RecordID) AS CurrentlyParked
FROM Lots l
JOIN ParkingRecords p ON l.LotID = p.LotID
WHERE p.ExitTime IS NULL
GROUP BY l.LotID, l.LotName, l.Capacity
HAVING COUNT(p.RecordID) >= l.Capacity;
