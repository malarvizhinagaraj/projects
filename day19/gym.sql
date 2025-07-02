-- Insert Membership Types
INSERT INTO MembershipTypes (TypeName, DurationMonths, Price)
VALUES 
('Monthly', 1, 50.00),
('Quarterly', 3, 140.00),
('Yearly', 12, 500.00);

-- Insert Members
INSERT INTO Members (Name, Email, Phone)
VALUES 
('Alice', 'alice@example.com', '1234567890'),
('Bob', 'bob@example.com', '0987654321'),
('Charlie', 'charlie@example.com', '5556667777');

-- Insert Payments
INSERT INTO Payments (MemberID, MembershipTypeID, PaymentDate, Amount)
VALUES 
(1, 1, '2025-05-15', 50.00), -- Alice
(2, 2, '2025-03-10', 140.00), -- Bob
(3, 1, '2025-04-25', 50.00);  -- Charlie


SELECT m.MemberID, m.Name, p.PaymentDate, mt.DurationMonths,
       DATE_ADD(p.PaymentDate, INTERVAL mt.DurationMonths MONTH) AS ExpiryDate
FROM Members m
JOIN Payments p ON m.MemberID = p.MemberID
JOIN MembershipTypes mt ON p.MembershipTypeID = mt.MembershipTypeID
WHERE DATE_ADD(p.PaymentDate, INTERVAL mt.DurationMonths MONTH) < CURDATE();


SELECT m.MemberID, m.Name, MAX(p.PaymentDate) AS LastPaymentDate
FROM Members m
LEFT JOIN Payments p ON m.MemberID = p.MemberID
GROUP BY m.MemberID, m.Name
HAVING LastPaymentDate IS NULL OR LastPaymentDate < DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
