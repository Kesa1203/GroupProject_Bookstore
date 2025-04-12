CREATE DATABASE BookStore;

USE BookStore;

-- 1. Independent Tables
-- Table: book_language
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language VARCHAR(50) NOT NULL
);

-- Table: publisher
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: author
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Table: address_status
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: order_status
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: shipping_method
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL
);

-- 2. Dependent Tables
-- Table: book
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
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- 3. Tables with Foreign Key Dependencies
-- Table: customer_address
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Table: cust_order
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
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- 4. Highly Dependent Tables
-- Table: order_line
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    change_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);


--Then populating the Database:

USE BookStore;

-- Insert data into book_language
INSERT INTO book_language (language) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Japanese');

-- Insert data into publisher
INSERT INTO publisher (name) VALUES
('Penguin Random House'),
('HarperCollins'),
('Simon & Schuster'),
('Macmillan'),
('Oxford University Press');

-- Insert data into book
INSERT INTO book (title, language_id, publisher_id, price) VALUES
('The Great Gatsby', 1, 1, 12.99),
('Don Quixote', 2, 2, 15.50),
('Les Misérables', 3, 3, 18.75),
('Faust', 4, 4, 20.00),
('Norwegian Wood', 5, 5, 22.00);

-- Insert data into author
INSERT INTO author (name) VALUES
('F. Scott Fitzgerald'),
('Miguel de Cervantes'),
('Victor Hugo'),
('Johann Wolfgang von Goethe'),
('Haruki Murakami');

-- Insert data into book_author
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert data into customer
INSERT INTO customer (name, email) VALUES
('Alice Smith', 'alice.smith@example.com'),
('Bob Jones', 'bob.jones@example.com'),
('Charlie Lee', 'charlie.lee@example.com'),
('David Brown', 'david.brown@example.com'),
('Eve White', 'eve.white@example.com');

-- Insert data into country
INSERT INTO country (country_name) VALUES
('South Africa'),
('United States'),
('United Kingdom'),
('Canada'),
('Germany');

-- Insert data into address_status
INSERT INTO address_status (status_name) VALUES
('Current'),
('Old'),
('Temporary'),
('Billing'),
('Shipping');

-- Insert data into address
INSERT INTO address (country_id, status_id, street, city, postal_code) VALUES
(1, 1, '123 Main St', 'Johannesburg', '2000'),
(2, 2, '456 Elm St', 'New York', '10001'),
(3, 3, '789 Oak St', 'London', 'SW1A 1AA'),
(4, 4, '101 Pine St', 'Toronto', 'M4B 1B3'),
(5, 5, '202 Birch St', 'Berlin', '10115');

-- Insert data into customer_address
INSERT INTO customer_address (customer_id, address_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert data into shipping_method
INSERT INTO shipping_method (method_name) VALUES
('Standard Shipping'),
('Express Shipping'),
('Overnight Shipping'),
('Pickup'),
('Drone Delivery');

-- Insert data into order_status
INSERT INTO order_status (status_name) VALUES
('Pending'),
('Shipped'),
('Delivered'),
('Cancelled'),
('Returned');

-- Insert data into cust_order
INSERT INTO cust_order (customer_id, order_date, shipping_method_id, status_id) VALUES
(1, '2025-04-01', 1, 1),
(2, '2025-04-02', 2, 2),
(3, '2025-04-03', 3, 3),
(4, '2025-04-04', 4, 4),
(5, '2025-04-05', 5, 5);

-- Insert data into order_line
INSERT INTO order_line (order_id, book_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3),
(4, 4, 1),
(5, 5, 2);

-- Insert data into order_history
INSERT INTO order_history (order_id, status_id, change_date) VALUES
(1, 1, '2025-04-01'),
(2, 2, '2025-04-02'),
(3, 3, '2025-04-03'),
(4, 4, '2025-04-04'),
(5, 5, '2025-04-05');




































































































