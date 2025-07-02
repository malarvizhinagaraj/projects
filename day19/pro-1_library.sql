CREATE DATABASE library_db;
USE library_db;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    Available BOOLEAN,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    JoinDate DATE
);

-- Loans Table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Authors
INSERT INTO Authors VALUES
(1, 'J.K. Rowling'),
(2, 'George Orwell'),
(3, 'Jane Austen');

-- Books
INSERT INTO Books VALUES
(1, 'Harry Potter', 1, TRUE),
(2, '1984', 2, FALSE),
(3, 'Animal Farm', 2, FALSE),
(4, 'Pride and Prejudice', 3, TRUE),
(5, 'Emma', 3, FALSE);

-- Members
INSERT INTO Members VALUES
(1, 'Alice', '2024-01-10'),
(2, 'Bob', '2024-02-15'),
(3, 'Charlie', '2024-03-05');

-- Loans
INSERT INTO Loans VALUES
(1, 2, 1, '2025-06-01', NULL, '2025-06-15'),
(2, 3, 2, '2025-06-10', '2025-06-20', '2025-06-18'),
(3, 5, 1, '2025-06-12', NULL, '2025-06-22');


SELECT B.Title, M.Name AS BorrowedBy, L.LoanDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL;

SELECT B.Title, M.Name AS BorrowedBy, L.DueDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL AND L.DueDate < CURRENT_DATE;

SELECT M.Name, COUNT(*) AS TotalLoans
FROM Loans L
JOIN Members M ON L.MemberID = M.MemberID
GROUP BY M.Name
ORDER BY TotalLoans DESC
LIMIT 1;
