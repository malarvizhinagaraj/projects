CREATE DATABASE IF NOT EXISTS day_27;
USE day_27;
 DROP table Fact_sales;
 DROP table dim_time;
 DROP table dim_customer;
 drop table dim_product;
 drop table Dim_location ;



CREATE TABLE Dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100)
);

CREATE TABLE Dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    age_group VARCHAR (50)
);

CREATE TABLE Dim_time (
    time_id INT PRIMARY KEY,
    date DATE,
    month VARCHAR(50),
    year INT,
    quarter VARCHAR(10)
);

CREATE TABLE Dim_location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);


CREATE TABLE Fact_sales (
    sales_id INT PRIMARY KEY, 
    product_id INT, 
    customer_id INT ,
    time_id INT,
    location_id INT,
    revenue DECIMAL (50,2),
    quantity_sold INT,
    FOREIGN KEY (product_id) REFERENCES Dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES Dim_customer(customer_id),
    FOREIGN KEY (time_id) REFERENCES Dim_time(time_id),
    FOREIGN KEY (location_id) REFERENCES Dim_location(location_id)
);


INSERT INTO Dim_product VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Office Chair', 'Furniture'),
(4, 'Book - SQL Mastery', 'Books'),
(5, 'Air Conditioner', 'Appliances');

INSERT INTO Dim_customer VALUES
(101, 'Alice Johnson', 'New York', '25-34'),
(102, 'Bob Smith', 'Los Angeles', '35-44'),
(103, 'Cathy Brown', 'Chicago', '18-24'),
(104, 'David Lee', 'Houston', '45-54'),
(105, 'Eva Green', 'Phoenix', '25-34');

INSERT INTO Dim_time VALUES
(1001, '2024-01-15', 'January', 2024, 'Q1'),
(1002, '2024-03-30', 'March', 2024, 'Q1'),
(1003, '2024-05-10', 'May', 2024, 'Q2'),
(1004, '2024-08-20', 'August', 2024, 'Q3'),
(1005, '2024-11-05', 'November', 2024, 'Q4');

INSERT INTO Dim_location VALUES
(201, 'New York', 'East', 'USA'),
(202, 'Los Angeles', 'West', 'USA'),
(203, 'Chicago', 'Midwest', 'USA'),
(204, 'Houston', 'South', 'USA'),
(205, 'San Francisco', 'West', 'USA');


INSERT INTO Fact_sales VALUES
(1, 1, 101, 1001, 201, 1200.00, 1),
(2, 2, 102, 1002, 202, 250.00, 2),
(3, 3, 103, 1003, 203, 900.00, 1),
(4, 4, 104, 1004, 204, 180.00, 1),
(5, 5, 105, 1005, 205, 150.00, 1);

-- Write a query to calculate total revenue by product category using star schema.
SELECT sum(revenue) as Total_revenue, dmp.category as product_category  
FROM Fact_sales as fs 
JOIN Dim_product dmp ON fs.product_id = dmp.product_id
GROUP BY dmp.category;

-- Create a report that shows sales by region (from Dim_Location)
SELECT sum(fs.quantity_sold ) as Total_Sales, region as Regions 
FROM Fact_sales fs
JOIN Dim_location dml 
ON  fs.location_id= dml.location_id
GROUP BY dml.region;

-- Write a query that joins all dimension tables with the fact table.
SELECT 
fs.sales_id,
dmp.product_name,
dmp.category,
dmc.name as customer_name,
dmc.location as customer_location,
dmc.age_group,
dmt.date,
dmt.month,
dmt.quarter,
dml.city,
dml.region,
dml.country,
fs.revenue,
fs.quantity_sold
FROM
Fact_sales fs
JOIN 
DIM_product dmp ON fs.product_id=dmp.product_id
JOIN 
Dim_customer dmc ON fs.customer_id=dmc.customer_id
JOIN 
Dim_Time dmt ON fs.time_id = dmt.time_id
JOIN 
Dim_Location dml ON fs.location_id = dml.location_id;

-- Sub-table for product categories
CREATE TABLE Category_Details (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE Dim_Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category_Details(category_id)
);

-- ✅ Snowflake Schema Setup
CREATE TABLE Category_Details (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE Dim_Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category_Details(category_id)
);

CREATE TABLE Dim_Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    age_group VARCHAR(50)
);

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    date DATE,
    month VARCHAR(20),
    year INT,
    quarter VARCHAR(10)
);

CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Fact_Sales (
    sales_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    time_id INT,
    location_id INT,
    revenue DECIMAL(10,2),
    quantity_sold INT,
    FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id),
    FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
    FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

-- ✅ Sample Data Inserts
INSERT INTO Category_Details VALUES
(1, 'Electronics'), (2, 'Furniture'), (3, 'Books'), (4, 'Appliances');

INSERT INTO Dim_Product VALUES
(1, 'Laptop', 1),
(2, 'Smartphone', 1),
(3, 'Office Chair', 2),
(4, 'SQL Book', 3),
(5, 'Air Conditioner', 4);

INSERT INTO Dim_Customer VALUES
(101, 'Alice Johnson', 'New York', '25-34'),
(102, 'Bob Smith', 'Los Angeles', '35-44'),
(103, 'Cathy Brown', 'Chicago', '18-24'),
(104, 'David Lee', 'Houston', '45-54'),
(105, 'Eva Green', 'Phoenix', '25-34');

INSERT INTO Dim_Time VALUES
(1001, '2024-01-15', 'January', 2024, 'Q1'),
(1002, '2024-03-30', 'March', 2024, 'Q1'),
(1003, '2024-05-10', 'May', 2024, 'Q2'),
(1004, '2024-08-20', 'August', 2024, 'Q3'),
(1005, '2024-11-05', 'November', 2024, 'Q4');

INSERT INTO Dim_Location VALUES
(201, 'New York', 'East', 'USA'),
(202, 'Los Angeles', 'West', 'USA'),
(203, 'Chicago', 'Midwest', 'USA'),
(204, 'Houston', 'South', 'USA'),
(205, 'San Francisco', 'West', 'USA');

INSERT INTO Fact_Sales VALUES
(1, 1, 101, 1001, 201, 1200.00, 1),
(2, 2, 102, 1002, 202, 250.00, 2),
(3, 3, 103, 1003, 203, 900.00, 1),
(4, 4, 104, 1004, 204, 180.00, 1),
(5, 5, 105, 1005, 205, 150.00, 1);

-- Total Revenue per Product Category (Snowflake Schema)
SELECT cd.category_name, SUM(fs.revenue) AS total_revenue
FROM Fact_Sales fs
JOIN Dim_Product dp ON fs.product_id = dp.product_id
JOIN Category_Details cd ON dp.category_id = cd.category_id
GROUP BY cd.category_name;

-- Count Sales per Customer Location
SELECT dc.location AS customer_location, COUNT(fs.sales_id) AS number_of_sales
FROM Fact_Sales fs
JOIN Dim_Customer dc ON fs.customer_id = dc.customer_id
GROUP BY dc.location;

-- Total Sales by Month and Year
SELECT dt.year, dt.month, SUM(fs.revenue) AS monthly_sales
FROM Fact_Sales fs
JOIN Dim_Time dt ON fs.time_id = dt.time_id
GROUP BY dt.year, dt.month
HAVING SUM(fs.revenue) > 10000;

--  Number of Orders per Product
SELECT dp.product_name, COUNT(fs.sales_id) AS order_count
FROM Fact_Sales fs
JOIN Dim_Product dp ON fs.product_id = dp.product_id
GROUP BY dp.product_name;

-- Average Sale Amount per Customer
SELECT dc.name AS customer_name, AVG(fs.revenue) AS avg_spent
FROM Fact_Sales fs
JOIN Dim_Customer dc ON fs.customer_id = dc.customer_id
GROUP BY dc.name;

-- Max, Min, Avg Order per Category
SELECT cd.category_name, MAX(fs.revenue) AS max_order, MIN(fs.revenue) AS min_order, AVG(fs.revenue) AS avg_order
FROM Fact_Sales fs
JOIN Dim_Product dp ON fs.product_id = dp.product_id
JOIN Category_Details cd ON dp.category_id = cd.category_id
GROUP BY cd.category_name;

--  Monthly Performance Report
SELECT dt.year, dt.month, COUNT(fs.sales_id) AS total_orders, SUM(fs.revenue) AS total_revenue
FROM Fact_Sales fs
JOIN Dim_Time dt ON fs.time_id = dt.time_id
GROUP BY dt.year, dt.month
ORDER BY dt.year, dt.month;

--  Top 5 Customers by Spend
SELECT dc.name AS customer_name, SUM(fs.revenue) AS total_spent
FROM Fact_Sales fs
JOIN Dim_Customer dc ON fs.customer_id = dc.customer_id
GROUP BY dc.name
ORDER BY total_spent DESC
LIMIT 5;

--  Revenue Decline using LAG()
SELECT year, month, total_revenue,
       total_revenue - LAG(total_revenue) OVER (ORDER BY year, month) AS revenue_change
FROM (
    SELECT dt.year, dt.month, SUM(fs.revenue) AS total_revenue
    FROM Fact_Sales fs
    JOIN Dim_Time dt ON fs.time_id = dt.time_id
    GROUP BY dt.year, dt.month
) AS monthly_revenue;

-- Customer Retention Trend by Month
SELECT dt.month, COUNT(DISTINCT fs.customer_id) AS unique_customers
FROM Fact_Sales fs
JOIN Dim_Time dt ON fs.time_id = dt.time_id
GROUP BY dt.month
ORDER BY dt.month;

--  Seasonal Trends in Product Category Sales
SELECT dt.month, cd.category_name, SUM(fs.revenue) AS monthly_category_sales
FROM Fact_Sales fs
JOIN Dim_Product dp ON fs.product_id = dp.product_id
JOIN Category_Details cd ON dp.category_id = cd.category_id
JOIN Dim_Time dt ON fs.time_id = dt.time_id
GROUP BY dt.month, cd.category_name
ORDER BY dt.month, monthly_category_sales DESC;


