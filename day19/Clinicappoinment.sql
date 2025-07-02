CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100) NOT NULL
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Missed') DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert Patients
INSERT INTO Patients (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666'),
('Charlie', 'charlie@example.com', '7778889999');

-- Insert Doctors
INSERT INTO Doctors (Name, Specialty)
VALUES
('Dr. Smith', 'Cardiology'),
('Dr. Lee', 'Dermatology'),
('Dr. Patel', 'Pediatrics');

-- Insert Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
VALUES
(1, 1, '2025-07-01', 'Completed'),   -- Alice with Dr. Smith
(2, 1, '2025-07-02', 'Missed'),      -- Bob with Dr. Smith
(3, 2, '2025-07-03', 'Completed'),   -- Charlie with Dr. Lee
(1, 2, '2025-07-04', 'Missed'),      -- Alice with Dr. Lee
(2, 3, '2025-07-05', 'Completed'),   -- Bob with Dr. Patel
(3, 1, '2025-07-06', 'Scheduled');   -- Charlie with Dr. Smith

SELECT d.DoctorID, d.Name, d.Specialty, COUNT(a.AppointmentID) AS AppointmentCount
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
WHERE a.AppointmentDate BETWEEN '2025-07-01' AND '2025-07-07'
GROUP BY d.DoctorID, d.Name, d.Specialty
ORDER BY AppointmentCount DESC;


SELECT DISTINCT p.PatientID, p.Name, p.Email, p.Phone
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.Status = 'Missed';
