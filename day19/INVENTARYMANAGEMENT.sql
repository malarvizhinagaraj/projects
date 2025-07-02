CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) NOT NULL,
    Contact VARCHAR(50)
);
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    Price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);
CREATE TABLE Stock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- Insert Suppliers
INSERT INTO Suppliers (SupplierName, Contact)
VALUES
('FreshFarms', 'fresh@farms.com'),
('GreenGrocers', 'contact@greengrocers.com'),
('DailySupply', 'info@dailysupply.com');

-- Insert Products
INSERT INTO Products (ProductName, SupplierID, Price)
VALUES
('Apples', 1, 2.50),
('Bananas', 1, 1.20),
('Oranges', 2, 2.00),
('Tomatoes', 2, 1.80),
('Milk', 3, 1.50),
('Bread', 3, 2.00);

-- Insert Stock
INSERT INTO Stock (ProductID, Quantity)
VALUES
(1, 50),   -- Apples
(2, 10),   -- Bananas
(3, 5),    -- Oranges
(4, 40),   -- Tomatoes
(5, 3),    -- Milk
(6, 30);   -- Bread

SELECT 
    p.ProductID, p.ProductName, s.Quantity
FROM
    Products p
        JOIN
    Stock s ON p.ProductID = s.ProductID
WHERE
    s.Quantity < 10;

