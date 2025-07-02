CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactEmail VARCHAR(100)
 );

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    CategoryID INT,
    SupplierID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home Appliances');

INSERT INTO Suppliers VALUES
(1, 'TechWorld', 'sales@techworld.com'),
(2, 'FashionHub', 'info@fashionhub.com'),
(3, 'HomeMakers', 'support@homemakers.com');

SELECT P.ProductName, P.Price, C.CategoryName
FROM Products P
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Electronics';

SELECT ProductName, Price
FROM Products
WHERE Price BETWEEN 100 AND 500;

SELECT P.ProductName, P.Price, S.SupplierName
FROM Products P
JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE S.SupplierName = 'FashionHub';

SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 5;
