
-- 1. E-Commerce Product Catalog System


-- 1. Create Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Create Brands Table
CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Create Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- 4. Create Indexes for Performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_price ON products(price);

-- 5. Insert Sample Data into Categories
INSERT INTO categories (name) VALUES 
('Electronics'), 
('Apparel'), 
('Home Appliances');

-- 6. Insert Sample Data into Brands
INSERT INTO brands (name) VALUES 
('Apple'), 
('Samsung'), 
('Nike');

-- 7. Insert Sample Data into Products
INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id)
VALUES 
('iPhone 14', 'Latest iPhone model', 999.99, 50, 'iphone14.jpg', 1, 1),
('Galaxy S22', 'Flagship Samsung phone', 849.00, 70, 'galaxys22.jpg', 1, 2),
('Nike Air Max', 'Running shoes', 120.00, 200, 'nikeair.jpg', 2, 3);


-- A. Get products by category (e.g., Electronics)
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE c.name = 'Electronics';

-- B. Get products by brand (e.g., Nike)
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE b.name = 'Nike';


-- C. Get products with low stock (stock < 10)
SELECT p.name, p.stock
FROM products
WHERE stock < 10;



-- 2. SHOPPING CART SYSTEM

-- 1. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Carts Table
CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3. Products Table (reusing from catalog)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- 4. Cart Items Table
CREATE TABLE cart_items (
    cart_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY (cart_id, product_id), -- Composite PK
    FOREIGN KEY (cart_id) REFERENCES carts(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- Insert Users
INSERT INTO users (name, email) VALUES 
('Alice', 'alice@example.com'), 
('Bob', 'bob@example.com');

-- Insert Products
INSERT INTO products (name, description, price, stock) VALUES 
('iPhone 14', 'Latest model', 999.99, 100),
('Nike Shoes', 'Sportswear', 120.00, 200),
('Laptop', '15-inch display', 1500.00, 50);

-- Insert Carts (1 for each user)
INSERT INTO carts (user_id) VALUES (1), (2);

-- Insert Cart Items (e.g., Alice adds 2 iPhones and 1 Laptop)
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 2),  -- Alice's cart, 2 iPhones
(1, 3, 1);  -- Alice's cart, 1 Laptop


-- 2.Cart Queries

-- A. View cart items with product details for a specific user
SELECT u.name AS user_name, p.name AS product_name, ci.quantity, p.price, (ci.quantity * p.price) AS total_price
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id
WHERE u.id = 1;  -- Replace with desired user_id

-- B. Calculate total cart value for a user
SELECT u.name AS user_name, SUM(ci.quantity * p.price) AS cart_total
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id
WHERE u.id = 1
GROUP BY u.name;



-- C. Add an item to cart (or increase quantity if exists)
-- [This assumes you're checking for existence in app logic]
INSERT INTO cart_items (cart_id, product_id, quantity)
VALUES (1, 2, 1);  -- Alice adds 1 Nike Shoe

-- D. Update quantity of an item
UPDATE cart_items
SET quantity = 3
WHERE cart_id = 1 AND product_id = 1;  -- Set iPhone quantity to 3

-- E. Remove an item from the cart
DELETE FROM cart_items
WHERE cart_id = 1 AND product_id = 3;  -- Remove Laptop from Alice’s cart



-- 3. ORDER MANAGEMENT SYSTEM


-- Users Table (shared)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Products Table (shared)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    stock INT DEFAULT 0
);

-- Orders Table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status ENUM('Placed', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Placed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Order Items Table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

--  Sample Query: Get order history with total per user
SELECT 
    u.name AS user_name,
    o.id AS order_id,
    o.status,
    o.created_at,
    SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, u.name, o.status, o.created_at;


--  4. INVENTORY TRACKING SYSTEM


-- Suppliers Table
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Inventory Logs Table
CREATE TABLE inventory_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    supplier_id INT,
    action ENUM('IN', 'OUT') NOT NULL,
    qty INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

---update stock on inventory log insert
DELIMITER $$
CREATE TRIGGER trg_update_stock
AFTER INSERT ON inventory_logs
FOR EACH ROW
BEGIN
    IF NEW.action = 'IN' THEN
        UPDATE products SET stock = stock + NEW.qty WHERE id = NEW.product_id;
    ELSEIF NEW.action = 'OUT' THEN
        UPDATE products SET stock = stock - NEW.qty WHERE id = NEW.product_id;
    END IF;
END $$
DELIMITER ;

--  Check current stock status with reorder logic
SELECT 
    p.id, 
    p.name, 
    p.stock,
    CASE 
        WHEN p.stock < 10 THEN 'Reorder Needed'
        ELSE 'Stock OK'
    END AS stock_status
FROM products p;

-- 5. PRODUCT REVIEW AND RATING SYSTEM

-- Reviews Table
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE (user_id, product_id)  -- Prevent duplicate reviews
);
-- Average rating per product
SELECT 
    p.name AS product_name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.id) AS total_reviews
FROM reviews r
JOIN products p ON r.product_id = p.id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC
LIMIT 10;


-- 6. EMPLOYEE TIMESHEET TRACKER

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dept VARCHAR(100)
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE timesheets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    project_id INT,
    hours DECIMAL(5,2),
    date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);



-- 7. LEAVE MANAGEMENT SYSTEM

CREATE TABLE leave_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50)
);

CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    leave_type_id INT,
    from_date DATE,
    to_date DATE,
    status ENUM('Pending', 'Approved', 'Rejected'),
    FOREIGN KEY (emp_id) REFERENCES employees(id),
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id)
);


-- 8. SALES CRM TRACKER

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE leads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    source VARCHAR(100)
);

CREATE TABLE deals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT,
    user_id INT,
    stage ENUM('Prospect', 'Qualified', 'Negotiation', 'Closed'),
    amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



-- 9. APPOINTMENT SCHEDULER

CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    service_id INT,
    appointment_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);



-- 10. PROJECT MANAGEMENT TRACKER

CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    name VARCHAR(200),
    status ENUM('Pending', 'In Progress', 'Completed'),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

CREATE TABLE task_assignments (
    task_id INT,
    user_id INT,
    PRIMARY KEY (task_id, user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);





-- 11. COURSE ENROLLMENT SYSTEM

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    instructor VARCHAR(100)
);

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE enrollments (
    course_id INT,
    student_id INT,
    enroll_date DATE,
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (student_id) REFERENCES students(id)
);




-- 12. ONLINE EXAM SYSTEM

CREATE TABLE exams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT,
    text TEXT,
    correct_option VARCHAR(10),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

CREATE TABLE student_answers (
    student_id INT,
    question_id INT,
    selected_option VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


-- 13. LIBRARY MANAGEMENT SYSTEM

CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    author VARCHAR(100)
);

CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE borrows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);



-- 14. HOSPITAL PATIENT TRACKER

CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dob DATE
);

CREATE TABLE doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE visits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    visit_time DATETIME,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- 15. HEALTH RECORDS SYSTEM

CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE medications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE prescription_details (
    prescription_id INT,
    medication_id INT,
    dosage VARCHAR(50),
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id),
    FOREIGN KEY (medication_id) REFERENCES medications(id)
);


-- 16. EXPENSE TRACKER

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE expenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    category_id INT,
    amount DECIMAL(10,2),
    date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);



-- 17. INVOICE GENERATOR

CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE invoices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    date DATE,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE invoice_items (
    invoice_id INT,
    description VARCHAR(200),
    quantity INT,
    rate DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);



-- 18. BANK ACCOUNT TRANSACTIONS

CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    balance DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    type ENUM('Deposit', 'Withdraw'),
    amount DECIMAL(10,2),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);




-- 19. LOAN REPAYMENT TRACKER

CREATE TABLE loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    principal DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE payments (
    loan_id INT,
    amount DECIMAL(10,2),
    paid_on DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(id)
);




-- 20. SALARY MANAGEMENT SYSTEM

CREATE TABLE salaries (
    emp_id INT,
    month DATE,
    base DECIMAL(10,2),
    bonus DECIMAL(10,2),
    PRIMARY KEY (emp_id, month),
    FOREIGN KEY (emp_id) REFERENCES employees(id)
);

CREATE TABLE deductions (
    emp_id INT,
    month DATE,
    reason VARCHAR(100),
    amount DECIMAL(10,2),
    FOREIGN KEY (emp_id, month) REFERENCES salaries(emp_id, month)
);




-- 21. BLOG MANAGEMENT SYSTEM

CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(150),
    content TEXT,
    published_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    comment_text TEXT,
    commented_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



-- 22. VOTING SYSTEM
CREATE TABLE polls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question TEXT
);

CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    poll_id INT,
    option_text VARCHAR(255),
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

CREATE TABLE votes (
    user_id INT,
    option_id INT,
    voted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, option_id),
    FOREIGN KEY (option_id) REFERENCES options(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


-- 23. MESSAGING SYSTEM

CREATE TABLE conversations (
    id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    message_text TEXT,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);




-- 24. ATTENDANCE TRACKER

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE attendance (
    student_id INT,
    course_id INT,
    date DATE,
    status ENUM('Present', 'Absent'),
    PRIMARY KEY (student_id, course_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);



-- 25. PRODUCT WISHLIST SYSTEM
CREATE TABLE wishlist (
    user_id INT,
    product_id INT,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);



-- 26. DONATION MANAGEMENT SYSTEM

CREATE TABLE donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE causes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100)
);

CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT,
    cause_id INT,
    amount DECIMAL(10,2),
    donated_at DATE,
    FOREIGN KEY (donor_id) REFERENCES donors(id),
    FOREIGN KEY (cause_id) REFERENCES causes(id)
);

-- 27. NOTIFICATION SYSTEM

CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT,
    status ENUM('Unread', 'Read') DEFAULT 'Unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);




-- 28. COURSE PROGRESS TRACKER

CREATE TABLE lessons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE progress (
    student_id INT,
    lesson_id INT,
    completed_at DATE,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);




-- 29. RECRUITMENT PORTAL DATABASE

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    company VARCHAR(100)
);

CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE applications (
    job_id INT,
    candidate_id INT,
    status ENUM('Applied', 'Interviewing', 'Rejected', 'Hired'),
    applied_at DATE,
    PRIMARY KEY (job_id, candidate_id),
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);




-- 30. HOTEL ROOM BOOKING SYSTEM

CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(10),
    type VARCHAR(50)
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT,
    guest_id INT,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (guest_id) REFERENCES guests(id)
);


-- 31. MOVIE DATABASE

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    release_year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    score DECIMAL(3,1),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);




-- 32. ONLINE FORUM SYSTEM

CREATE TABLE threads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    thread_id INT,
    user_id INT,
    content TEXT,
    parent_post_id INT,
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES threads(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);




-- 33. ASSET MANAGEMENT SYSTEM

CREATE TABLE assets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE assignments (
    asset_id INT,
    user_id INT,
    assigned_date DATE,
    returned_date DATE,
    PRIMARY KEY (asset_id, user_id, assigned_date),
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



-- 34. SPORTS TOURNAMENT TRACKER

CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE matches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    FOREIGN KEY (team1_id) REFERENCES teams(id),
    FOREIGN KEY (team2_id) REFERENCES teams(id)
);

CREATE TABLE scores (
    match_id INT,
    team_id INT,
    score INT,
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);
 


-- 35. SURVEY COLLECTION SYSTEM

CREATE TABLE surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100)
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_id INT,
    question_text TEXT,
    FOREIGN KEY (survey_id) REFERENCES surveys(id)
);

CREATE TABLE responses (
    user_id INT,
    question_id INT,
    answer_text TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);




-- 36. IT SUPPORT TICKET SYSTEM

CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    issue TEXT,
    status ENUM('Open', 'In Progress', 'Resolved'),
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE support_staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE assignments (
    ticket_id INT,
    staff_id INT,
    PRIMARY KEY (ticket_id, staff_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (staff_id) REFERENCES support_staff(id)
);



-- 37. FOOD DELIVERY TRACKER

CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE delivery_agents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    user_id INT,
    placed_at DATETIME,
    delivered_at DATETIME,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE deliveries (
    order_id INT,
    agent_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(id)
);




-- 38. QR CODE ENTRY LOG SYSTEM

CREATE TABLE locations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE entry_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    location_id INT,
    entry_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);



-- 39. FITNESS TRACKER DATABASE

CREATE TABLE workouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    type VARCHAR(50)
);

CREATE TABLE workout_logs (
    user_id INT,
    workout_id INT,
    duration INT, -- minutes
    log_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (workout_id) REFERENCES workouts(id)
);




-- 40. FREELANCE PROJECT MANAGEMENT

CREATE TABLE freelancers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    skill VARCHAR(100)
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100),
    title VARCHAR(200)
);

CREATE TABLE proposals (
    freelancer_id INT,
    project_id INT,
    bid_amount DECIMAL(10,2),
    status ENUM('Pending', 'Accepted', 'Rejected'),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);




-- 41. RESTAURANT RESERVATION SYSTEM

CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number VARCHAR(10),
    capacity INT
);

CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    table_id INT,
    date DATE,
    time_slot TIME,
    FOREIGN KEY (guest_id) REFERENCES guests(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);


-- 42. VEHICLE RENTAL SYSTEM

CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50),
    plate_number VARCHAR(20) UNIQUE
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE rentals (
    vehicle_id INT,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (vehicle_id, customer_id, start_date),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- 43. PRODUCT RETURN MANAGEMENT

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT
);

CREATE TABLE returns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected'),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- 44. COURSE FEEDBACK SYSTEM

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100)
);

CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    rating DECIMAL(2,1),
    comments TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);


-- 45. JOB SCHEDULING SYSTEM

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    frequency VARCHAR(50)
);

CREATE TABLE job_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    run_time DATETIME,
    status ENUM('Success', 'Failure'),
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);


-- 46. MULTI-TENANT SAAS DATABASE

CREATE TABLE tenants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    tenant_id INT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT,
    content TEXT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);


-- 47. COMPLAINT MANAGEMENT SYSTEM

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    department_id INT,
    status ENUM('Open', 'In Progress', 'Resolved'),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE responses (
    complaint_id INT,
    responder_id INT,
    message TEXT,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id)
);

-- 48. INVENTORY EXPIRY TRACKER

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE batches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    expiry_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- 49. PAYMENT SUBSCRIPTION TRACKER

CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_name VARCHAR(100),
    start_date DATE,
    renewal_cycle VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 50. EVENT MANAGEMENT SYSTEM

CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    max_capacity INT
);

CREATE TABLE attendees (
    event_id INT,
    user_id INT,
    registered_at DATETIME,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);



