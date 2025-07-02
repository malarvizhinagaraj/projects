CREATE TABLE Events (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    EventName VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(100) NOT NULL
);

CREATE TABLE Attendees (
    AttendeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY AUTO_INCREMENT,
    EventID INT,
    AttendeeID INT,
    RegistrationDate DATE NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (AttendeeID) REFERENCES Attendees(AttendeeID)
);


-- Insert Events
INSERT INTO Events (EventName, EventDate, Location)
VALUES
('Tech Conference 2025', '2025-08-10', 'Hall A'),
('AI Workshop', '2025-08-15', 'Lab 2'),
('Music Festival', '2025-08-20', 'Open Grounds');

-- Insert Attendees
INSERT INTO Attendees (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666'),
('Charlie', 'charlie@example.com', '7778889999');

-- Insert Registrations
INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate)
VALUES
(1, 1, '2025-07-01'),  -- Alice registers for Tech Conference
(1, 2, '2025-07-02'),  -- Bob registers for Tech Conference
(2, 1, '2025-07-03'),  -- Alice registers for AI Workshop
(2, 3, '2025-07-04'),  -- Charlie registers for AI Workshop
(3, 1, '2025-07-05');  -- Alice registers for Music Festival


SELECT e.EventID, e.EventName, COUNT(r.AttendeeID) AS AttendeeCount
FROM Events e
JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.EventID, e.EventName
HAVING COUNT(r.AttendeeID) > 100;


SELECT a.AttendeeID, a.Name, COUNT(r.EventID) AS EventCount
FROM Attendees a
JOIN Registrations r ON a.AttendeeID = r.AttendeeID
GROUP BY a.AttendeeID, a.Name
HAVING COUNT(r.EventID) > 1;
