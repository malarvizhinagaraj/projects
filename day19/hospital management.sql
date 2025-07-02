CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    AssignedDoctorID INT NULL
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Specialization VARCHAR(100)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

INSERT INTO Doctors VALUES
(1, 'Dr. Smith', 'Cardiology'),
(2, 'Dr. Alice', 'Neurology'),
(3, 'Dr. Khan', 'Pediatrics');


INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(101, 1, '2025-07-01', 'Chest pain'),
(102, 2, '2025-07-02', 'Headache'),
(103, 3, '2025-07-03', 'Fever'),
(101, 1, '2025-07-10', 'Follow-up'),
(102, 2, '2025-07-15', 'MRI Review');

SELECT * FROM Patients
WHERE AssignedDoctorID IS NULL;


