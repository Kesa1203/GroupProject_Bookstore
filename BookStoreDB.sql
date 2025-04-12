CREATE DATABASE BookStore;

USE BookStore;
-- 1. Independent Tables
-- These tables have no foreign key dependencies and need to be created first.

-- Table: book_language
-- Purpose: Stores the possible languages of books.
-- Why: Designed to normalize the database by avoiding repetitive language entries in the 'book' table.
-- Editable: You can add more languages by inserting new rows or expand the VARCHAR size if more detailed language identifiers are needed.
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language VARCHAR(50) NOT NULL
);

-- Table: publisher
-- Purpose: Stores information about publishers.
-- Why: Separates publisher details from the 'book' table to ensure modularity.
-- Editable: You can increase the VARCHAR size for longer publisher names or add additional fields (e.g., address, contact information).
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: author
-- Purpose: Stores information about authors.
-- Why: Enables the many-to-many relationship between authors and books (via the book_author table).
-- Editable: Add fields like 'bio' or 'date_of_birth' for richer author data.
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: country
-- Purpose: Stores the countries where addresses are located.
-- Why: Avoids repeating country names in the 'address' table, reducing redundancy.
-- Editable: Add fields for country codes or region identifiers if needed.
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Table: address_status
-- Purpose: Stores the status of customer addresses (e.g., current, old).
-- Why: Helps manage and track multiple addresses for a customer.
-- Editable: Add additional statuses as needed for specialized use cases.
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: order_status
-- Purpose: Lists the possible statuses for an order (e.g., pending, shipped).
-- Why: Ensures consistency in status tracking across orders.
-- Editable: You can add more statuses depending on business workflows.
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: shipping_method
-- Purpose: Lists available shipping methods (e.g., standard, express).
-- Why: Centralizes and normalizes shipping options for reuse across multiple orders.
-- Editable: Add or modify methods based on operational needs.
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL
);

-- 2. Dependent Tables
-- These tables have foreign key references to independent tables.

-- Table: book
-- Purpose: Stores information about books available in the store.
-- Why: Foreign keys (language_id, publisher_id) ensure data integrity for language and publisher fields.
-- Editable: You can add additional columns (e.g., genre, ISBN) or adjust the DECIMAL precision for price.
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Table: address
-- Purpose: Stores customer address details.
-- Why: Separates address management into a dedicated table, with foreign keys for status and country.
-- Editable: Add fields for additional address details (e.g., state, landmark).
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    status_id INT,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20),
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Table: customer
-- Purpose: Stores customer information.
-- Why: Centralizes customer data for streamlined order tracking.
-- Editable: Add columns for phone number or loyalty points as needed.
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- 3. Tables with Foreign Key Dependencies
-- These tables depend on both independent and dependent tables.

-- Table: customer_address
-- Purpose: Links customers to their addresses.
-- Why: Allows for a customer to have multiple addresses without duplicating customer or address data.
-- Editable: Add additional foreign keys if more relationships are needed.
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Table: cust_order
-- Purpose: Stores details about customer orders.
-- Why: Tracks orders by linking customers, shipping methods, and order statuses.
-- Editable: Add fields like 'payment_method' or 'total_price' as needed.
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    shipping_method_id INT,
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Table: book_author
-- Purpose: Manages the many-to-many relationship between books and authors.
-- Why: Ensures flexibility in assigning multiple authors to a single book and vice versa.
-- Editable: Add additional metadata (e.g., role: co-author, editor) if needed.
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- 4. Highly Dependent Tables
-- These tables reference other dependent tables I personally like to call them codependent.

-- Table: order_line
-- Purpose: Links orders to the books they contain, including quantity.
-- Why: Tracks the details of books included in each order.
-- Editable: Add fields for discounts or special instructions.
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
-- Purpose: Tracks changes to the status of an order over time.
-- Why: Provides historical data for auditing and customer service.
-- Editable: Add fields for additional tracking details (e.g., updated_by_user_id).
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    change_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);


--Populating the Database for testing purposes:

USE BookStore;
-- Insert data into book_language
-- Purpose: Adds sample languages for books.
-- Why: Reflects real-world multilingual book offerings and normalizes data by keeping language-specific details in a separate table.
-- Editable: Add or modify entries to include more languages as per the bookstore's requirements.
INSERT INTO book_language (language) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Japanese');

-- Insert data into publisher
-- Purpose: Adds sample publishers commonly associated with books.
-- Why: Represents real-world publishing houses to test the database's ability to manage publisher-specific data.
-- Editable: Expand this list with more publishers or add fictional ones for additional testing purposes.
INSERT INTO publisher (name) VALUES
('Penguin Random House'),
('HarperCollins'),
('Simon & Schuster'),
('Macmillan'),
('Oxford University Press');

-- Insert data into book
-- Purpose: Adds sample book records.
-- Why: Covers a diverse range of books in different languages and published by various publishers to test data relationships.
-- Editable: Add more books, update prices, or change publisher/language IDs based on testing needs.
INSERT INTO book (title, language_id, publisher_id, price) VALUES
('The Great Gatsby', 1, 1, 12.99),
('Don Quixote', 2, 2, 15.50),
('Les Misérables', 3, 3, 18.75),
('Faust', 4, 4, 20.00),
('Norwegian Wood', 5, 5, 22.00);

-- Insert data into author
-- Purpose: Adds sample author records.
-- Why: Reflects real-world authors commonly associated with the sample books to test the many-to-many relationship.
-- Editable: Include additional authors or fictional ones to expand the testing dataset.
INSERT INTO author (name) VALUES
('F. Scott Fitzgerald'),
('Miguel de Cervantes'),
('Victor Hugo'),
('Johann Wolfgang von Goethe'),
('Haruki Murakami');

-- Insert data into book_author
-- Purpose: Maps authors to books (many-to-many relationship).
-- Why: Tests the handling of real-world scenarios where a book can have multiple authors or an author can write multiple books.
-- Editable: Modify relationships to test edge cases (e.g., multiple authors per book).
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert data into customer
-- Purpose: Adds sample customer records.
-- Why: Reflects typical customer data to simulate customer behavior and email uniqueness constraints.
-- Editable: Add more customers or introduce fictional email formats for broader testing.
INSERT INTO customer (name, email) VALUES
('Alice Smith', 'alice.smith@example.com'),
('Bob Jones', 'bob.jones@example.com'),
('Charlie Lee', 'charlie.lee@example.com'),
('David Brown', 'david.brown@example.com'),
('Eve White', 'eve.white@example.com');

-- Insert data into country
-- Purpose: Adds sample country records for address management.
-- Why: Reflects real-world geographic data for international customer testing.
-- Editable: Expand the list of countries to simulate worldwide bookstore operations.
INSERT INTO country (country_name) VALUES
('South Africa'),
('United States'),
('United Kingdom'),
('Canada'),
('Germany');

-- Insert data into address_status
-- Purpose: Adds sample address statuses.
-- Why: Tests address management with different statuses (e.g., current, billing) common in real-world systems.
-- Editable: Add more statuses based on specific business rules (e.g., "Archived").
INSERT INTO address_status (status_name) VALUES
('Current'),
('Old'),
('Temporary'),
('Billing'),
('Shipping');

-- Insert data into address
-- Purpose: Adds sample addresses for customers.
-- Why: Simulates real-world address data linked to countries and statuses for comprehensive testing.
-- Editable: Modify entries to test edge cases, such as missing postal codes or longer city names.
INSERT INTO address (country_id, status_id, street, city, postal_code) VALUES
(1, 1, '123 Main St', 'Johannesburg', '2000'),
(2, 2, '456 Elm St', 'New York', '10001'),
(3, 3, '789 Oak St', 'London', 'SW1A 1AA'),
(4, 4, '101 Pine St', 'Toronto', 'M4B 1B3'),
(5, 5, '202 Birch St', 'Berlin', '10115');

-- Insert data into customer_address
-- Purpose: Maps customers to their addresses.
-- Why: Tests the handling of multiple addresses per customer and cross-table relationships.
-- Editable: Add more mappings or simulate edge cases with missing links.
INSERT INTO customer_address (customer_id, address_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert data into shipping_method
-- Purpose: Adds sample shipping methods.
-- Why: Tests real-world scenarios where multiple shipping options are available for orders.
-- Editable: Add or modify shipping methods to simulate business changes (e.g., "International Shipping").
INSERT INTO shipping_method (method_name) VALUES
('Standard Shipping'),
('Express Shipping'),
('Overnight Shipping'),
('Pickup'),
('Drone Delivery');

-- Insert data into order_status
-- Purpose: Adds sample order statuses.
-- Why: Reflects the different stages of an order's lifecycle for testing workflows.
-- Editable: Add more statuses or modify existing ones to match operational requirements.
INSERT INTO order_status (status_name) VALUES
('Pending'),
('Shipped'),
('Delivered'),
('Cancelled'),
('Returned');

-- Insert data into cust_order
-- Purpose: Adds sample customer orders.
-- Why: Tests the linkage between customers, shipping methods, and order statuses.
-- Editable: Add more orders or adjust dates to simulate business operations (e.g., weekend sales).
INSERT INTO cust_order (customer_id, order_date, shipping_method_id, status_id) VALUES
(1, '2025-04-01', 1, 1),
(2, '2025-04-02', 2, 2),
(3, '2025-04-03', 3, 3),
(4, '2025-04-04', 4, 4),
(5, '2025-04-05', 5, 5);

-- Insert data into order_line
-- Purpose: Adds sample order lines linking orders to books.
-- Why: Simulates real-world scenarios where orders contain multiple books with specific quantities.
-- Editable: Add additional entries to test bulk orders or high quantities.
INSERT INTO order_line (order_id, book_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3),
(4, 4, 1),
(5, 5, 2);

-- Insert data into order_history
-- Purpose: Tracks sample changes to order statuses over time.
-- Why: Provides historical data for auditing and customer service scenarios.
-- Editable: Add more entries or modify dates for detailed lifecycle testing.
INSERT INTO order_history (order_id, status_id, change_date) VALUES
(1, 1, '2025-04-01'),
(2, 2, '2025-04-02'),
(3, 3, '2025-04-03'),
(4, 4, '2025-04-04'),
(5, 5, '2025-04-05');































-- BookStore Database SQL Script
-- Created by: Emmanuel Nyakoe
-- Date: 2025-04-12

-- =============================================
-- USER MANAGEMENT SYSTEM
-- =============================================

-- Administrator account with full privileges
CREATE USER 'admin_user'@'%' IDENTIFIED BY 'Admin@Secure123';
GRANT ALL PRIVILEGES ON BookStore.* TO 'admin_user'@'%';

-- Read-only user account for reporting
CREATE USER 'report_user'@'%' IDENTIFIED BY 'ReadOnly@456';
GRANT SELECT ON BookStore.* TO 'report_user'@'%';

-- Application user with limited write access
CREATE USER 'app_user'@'%' IDENTIFIED BY 'AppAccess@789';
GRANT SELECT, INSERT, UPDATE ON BookStore.* TO 'app_user'@'%';

FLUSH PRIVILEGES;

-- =============================================
-- DATABASE VALIDATION QUERIES
-- =============================================

-- 1. Book-Author Relationship Validation
SELECT b.title AS book_title, a.name AS author_name
FROM book AS b
JOIN book_author AS ba ON b.book_id = ba.book_id
JOIN author AS a ON ba.author_id = a.author_id;

-- 2. Customer Order Tracking
SELECT o.order_id, o.order_date, c.name AS customer_name, 
       sm.method_name AS shipping_method, os.status_name AS order_status
FROM cust_order AS o
JOIN customer AS c ON o.customer_id = c.customer_id
JOIN shipping_method AS sm ON o.shipping_method_id = sm.shipping_method_id
JOIN order_status AS os ON o.status_id = os.status_id;

-- 3. Sales Analysis by Order Status
SELECT os.status_name, SUM(ol.quantity) AS total_books, 
       SUM(b.price * ol.quantity) AS total_value
FROM order_line AS ol
JOIN cust_order AS o ON ol.order_id = o.order_id
JOIN order_status AS os ON o.status_id = os.status_id
JOIN book AS b ON ol.book_id = b.book_id
GROUP BY os.status_name;

-- 4. Customer Address Verification
SELECT c.name AS customer_name, a.street, a.city, 
       a.postal_code, co.country_name, ast.status_name AS address_status
FROM customer AS c
JOIN customer_address AS ca ON c.customer_id = ca.customer_id
JOIN address AS a ON ca.address_id = a.address_id
JOIN country AS co ON a.country_id = co.country_id
JOIN address_status AS ast ON ca.status_id = ast.status_id;

-- 5. Order History Audit
SELECT o.order_id, h.change_date, os.status_name, 
       TIMESTAMPDIFF(HOUR, o.order_date, h.change_date) AS hours_in_status
FROM order_history AS h
JOIN cust_order AS o ON h.order_id = o.order_id
JOIN order_status AS os ON h.status_id = os.status_id
ORDER BY h.order_id, h.change_date;

-- 6. Financial Reporting
SELECT 
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(ol.quantity) AS total_books_sold,
    SUM(b.price * ol.quantity) AS gross_revenue,
    SUM(sm.cost) AS total_shipping_costs
FROM cust_order AS o
JOIN order_line AS ol ON o.order_id = ol.order_id
JOIN book AS b ON ol.book_id = b.book_id
JOIN shipping_method AS sm ON o.shipping_method_id = sm.shipping_method_id;

-- 7. Shipping Method Analysis
SELECT 
    sm.method_name,
    COUNT(o.order_id) AS order_count,
    AVG(TIMESTAMPDIFF(HOUR, o.order_date, 
        (SELECT MAX(change_date) FROM order_history WHERE order_id = o.order_id))) AS avg_processing_hours
FROM cust_order AS o
JOIN shipping_method AS sm ON o.shipping_method_id = sm.shipping_method_id
GROUP BY sm.method_name
ORDER BY order_count DESC;




































































