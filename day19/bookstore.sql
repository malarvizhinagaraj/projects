-- Insert Books
INSERT INTO Books (Title, Author, Price)
VALUES
('The Alchemist', 'Paulo Coelho', 15.00),
('1984', 'George Orwell', 12.00),
('Clean Code', 'Robert C. Martin', 30.00);

-- Insert Customers
INSERT INTO Customers (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666'),
('Charlie', 'charlie@example.com', '7778889999');

-- Insert Sales Transactions
INSERT INTO Sales (BookID, CustomerID, SaleDate, Quantity)
VALUES
(1, 1, '2025-06-10', 2),  -- Alice bought 2 copies of The Alchemist
(2, 1, '2025-06-11', 1),  -- Alice bought 1984
(3, 2, '2025-06-12', 1),  -- Bob bought Clean Code
(1, 2, '2025-06-12', 1),  -- Bob bought The Alchemist
(1, 3, '2025-06-13', 2);  -- Charlie bought 2 copies of The Alchemist


SELECT b.BookID, b.Title, SUM(s.Quantity) AS TotalSold
FROM Books b
JOIN Sales s ON b.BookID = s.BookID
GROUP BY b.BookID, b.Title
ORDER BY TotalSold DESC;


SELECT c.CustomerID, c.Name, SUM(s.Quantity) AS TotalPurchased
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING SUM(s.Quantity) > 3;


CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    Author VARCHAR(100),
    Price DECIMAL(8,2) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    CustomerID INT,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
