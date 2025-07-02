CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT
);
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Rentals (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    MovieID INT,
    RentalDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

INSERT INTO Movies VALUES
(1, 'Inception', 'Sci-Fi', 2010),
(2, 'Titanic', 'Romance', 1997),
(3, 'The Matrix', 'Sci-Fi', 1999),
(4, 'The Godfather', 'Crime', 1972),
(5, 'Forrest Gump', 'Drama', 1994);

INSERT INTO Customers VALUES
(101, 'Alice Johnson', 'alice@example.com'),
(102, 'Bob Smith', 'bob@example.com'),
(103, 'Charlie Brown', 'charlie@example.com');

INSERT INTO Rentals (CustomerID, MovieID, RentalDate, ReturnDate, DueDate) VALUES
(101, 1, '2025-06-20', NULL, '2025-06-25'),
(102, 2, '2025-06-15', '2025-06-20', '2025-06-19'),
(103, 3, '2025-06-18', NULL, '2025-06-22'),
(101, 3, '2025-06-22', '2025-06-25', '2025-06-24'),
(102, 1, '2025-06-10', '2025-06-14', '2025-06-13'),
(103, 4, '2025-06-21', NULL, '2025-06-26');

SELECT R.RentalID, C.Name AS CustomerName, M.Title, R.DueDate
FROM Rentals R
JOIN Customers C ON R.CustomerID = C.CustomerID
JOIN Movies M ON R.MovieID = M.MovieID
WHERE R.ReturnDate IS NULL AND R.DueDate < CURRENT_DATE;

SELECT DISTINCT C.Name, C.Email
FROM Rentals R
JOIN Customers C ON R.CustomerID = C.CustomerID
JOIN Movies M ON R.MovieID = M.MovieID
WHERE M.Genre = 'Sci-Fi';

SELECT M.Title, COUNT(*) AS TimesRented
FROM Rentals R
JOIN Movies M ON R.MovieID = M.MovieID
GROUP BY M.MovieID, M.Title
ORDER BY TimesRented DESC
LIMIT 3;


