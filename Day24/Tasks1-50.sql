CREATE DAtABASE days_24;
USE days_24;
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10,2)
);

INSERT INTO Employees (emp_id, emp_name, dept_id, salary) VALUES
(1, 'John', 101, 55000),
(2, 'Alice', 102, 60000),
(3, 'Bob', 101, 52000),
(4, 'Charlie', 103, 75000),
(5, 'David', 102, 58000),
(6, 'Eva', 101, 67000),
(7, 'Frank', 104, 62000),
(8, 'Grace', 105, 69000),
(9, 'Hannah', 103, 71000),
(10, 'Ian', 101, 56000),
(11, 'Jack', 102, 63000),
(12, 'Kelly', 104, 54000),
(13, 'Laura', 105, 57000),
(14, 'Mike', 103, 64000),
(15, 'John', 101, 59000);	

CREATE INDEX inx_emp_name ON employees(emp_name);

SELECT * FROM employees WHERE emp_name='John';

EXPLAIN SELECT * FROM employees WHERE emp_name='John'; 

CREATE INDEX inx_dep_salary ON Employees(emp_id,salary); 


-- D. Clustered vs. Non-Clustered Index Tasks (Tasks 31–35)
CREATE TABLE products(product_id INT PRIMARY KEY,product_name VARCHAR(50),price DECIMAL(10,2))ENGINE=INNODB;

CREATE INDEX inx_product_name ON products(product_name);

INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'Laptop Bag', 1200.00),
(2, 'Wireless Mouse', 799.00),
(3, 'Gaming Laptop', 75000.00),
(4, 'Office Laptop', 55000.00),
(5, 'HD Monitor', 9000.00),
(6, 'Laptop Stand', 1500.00),
(7, 'USB Hub', 500.00),
(8, 'Mechanical Keyboard', 4500.00),
(9, 'Laptop Sleeve', 999.00),
(10, 'Bluetooth Speaker', 2000.00);
 
EXPLAIN SELECT * FROM products WHERE product_name='%lap%';

DROP INDEX inx_product_name ON products;
-- 🧱 E. Normalization Tasks (1NF, 2NF, 3NF) (Tasks 36–40)
CREATE TABLE SalesData (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(15),
    product1_name VARCHAR(100),
    product1_price DECIMAL(10,2),
    product2_name VARCHAR(100),
    product2_price DECIMAL(10,2),
    product3_name VARCHAR(100),
    product3_price DECIMAL(10,2)
);

CREATE TABLE SalesData_1NF (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(15),
    product_name VARCHAR(100),
    product_price DECIMAL(10,2)
   
);

CREATE TABLE products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(15)
);

CREATE TABLE OrderItems (
    order_id INT,
    product_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(15)
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Customers VALUES (1, 'Alice', '1234567890');

INSERT INTO Products VALUES
(101, 'Laptop', 75000.00),
(102, 'Mouse', 799.00),
(103, 'Keyboard', 1500.00);

INSERT INTO Orders VALUES (201, '2025-07-10', 1);

INSERT INTO OrderItems VALUES
(201, 101),
(201, 102),
(201, 103);

-- F. Denormalization Tasks (Tasks 41–45)

CREATE TABLE orders_flat(
order_id INT ,
order_date DATE,
customer_name VARCHAR(100),
customer_phone VARCHAR(15),
product_name VARCHAR(100),
product_price DECIMAL(10,2),
quantity INT );
DROP TABLE orders_flat;


INSERT INTO Orders_Flat VALUES 
(101, '2025-07-10', 'Alice', '1234567890', 'Laptop', 75000.00, 1),
(101, '2025-07-10', 'Alice', '1234567890', 'Mouse', 800.00, 2),
(102, '2025-07-11', 'Bob', '9876543210', 'Keyboard', 1500.00, 1),
(102, '2025-07-11', 'Bob', '9876543210', 'Laptop', 75000.00, 1),
(103, '2025-07-12', 'Alice', '1234567890', 'Monitor', 12000.00, 1);


SELECT * FROM orders_Flat WHERE order_id ='101';

/* Denormalized tables perform better for simple, read-only use cases like dashboards or exports, but are risky for data consistency.

Normalized databases are slightly more complex to query but scale better, are safer, and reduce redundancy.*/

-- G. Real-world Performance Scenarios (Tasks 46–50)
SELECT * FROM customers
JOIN orders;
