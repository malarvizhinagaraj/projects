-- Insert Customers
INSERT INTO Customers (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666');

-- Insert Products
INSERT INTO Products (ProductName, Price, Stock)
VALUES
('Laptop', 800.00, 10),
('Mouse', 20.00, 100),
('Keyboard', 35.00, 50);

-- Insert Orders
INSERT INTO Orders (CustomerID, OrderDate, Status)
VALUES
(1, '2025-06-01', 'Pending'),
(2, '2025-05-25', 'Delivered');

-- Insert OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1),  -- Alice ordered 1 Laptop
(1, 2, 2),  -- Alice ordered 2 Mouse
(2, 2, 1),  -- Bob ordered 1 Mouse
(2, 3, 1);  -- Bob ordered 1 Keyboard


SELECT o.OrderID, c.Name, o.OrderDate, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'Pending';


SELECT o.OrderID, o.OrderDate, o.Status, p.ProductName, oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 1
ORDER BY o.OrderDate DESC;


SELECT p.ProductID, p.ProductName, SUM(oi.Quantity) AS TotalOrdered
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(oi.Quantity) > 10;

-- Insert Rooms
INSERT INTO Rooms (RoomNumber, Type, Price)
VALUES
('101', 'Single', 100.00),
('102', 'Double', 150.00),
('201', 'Suite', 300.00);

-- Insert Guests
INSERT INTO Guests (Name, Email, Phone)
VALUES
('Alice', 'alice@example.com', '1112223333'),
('Bob', 'bob@example.com', '4445556666'),
('Charlie', 'charlie@example.com', '7778889999');

-- Insert Bookings
INSERT INTO Bookings (RoomID, GuestID, CheckInDate, CheckOutDate)
VALUES
(1, 1, '2025-07-05', '2025-07-08'), -- Alice
(2, 2, '2025-07-03', '2025-07-06'), -- Bob
(3, 3, '2025-07-02', '2025-07-04'), -- Charlie
(1, 2, '2025-07-10', '2025-07-12'); -- Bob again


SELECT r.RoomID, r.RoomNumber, r.Type, r.Price
FROM Rooms r
WHERE r.RoomID NOT IN (
    SELECT b.RoomID
    FROM Bookings b
    WHERE '2025-07-04' >= b.CheckInDate AND '2025-07-04' < b.CheckOutDate
);


SELECT g.GuestID, g.Name, COUNT(b.BookingID) AS BookingCount
FROM Guests g
JOIN Bookings b ON g.GuestID = b.GuestID
GROUP BY g.GuestID, g.Name
HAVING COUNT(b.BookingID) > 3;
