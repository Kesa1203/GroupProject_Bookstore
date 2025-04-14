📚 BookStore Database Project
🌟 Project Overview
The BookStore Database is a relational database designed to efficiently manage and store operational data for a bookstore. This database enables the storage, retrieval, and analysis of essential information, such as books, authors, customers, orders, and shipping details. It is an end-to-end solution for managing complex data while ensuring robust security, scalability, and usability.

🔑 Key Features
✔ Comprehensive schema design to support bookstore operations.
✔ Many-to-many relationships between books and authors.
✔ Customer and address management with support for multiple address statuses.
✔ Order and shipping tracking with detailed history.
✔ Role-based access control for enhanced security.

🛠 Technologies Used
🔹 MySQL: For database design, querying, and management.
🔹 Draw.io: For visualizing database schema and relationships (optional).

📋 Prerequisites
Before starting this project, you should have:

A basic understanding of relational database concepts.

Experience with SQL commands for creating and managing tables.

Familiarity with user roles and permissions in MySQL.

🗃 Project Structure
Tables Included:
📖 book: Stores details about the books in the store.
✍ book_author: Manages the many-to-many relationship between books and authors.
👨‍🎨 author: Stores information about authors.
🌍 book_language: Lists possible languages for books.
🏢 publisher: Contains information about book publishers.
👥 customer: Stores customer data.
🏠 customer_address: Links customers to their addresses.
🔄 address_status: Tracks the status of each address.
📍 address: Stores address information for customers and orders.
🗺 country: Lists countries where addresses are located.
🛒 cust_order: Stores order information placed by customers.
📦 order_line: Links orders to the books they include.
🚚 shipping_method: Lists shipping methods available for orders.
⏳ order_history: Tracks order status changes over time.
✅ order_status: Lists possible statuses for an order.

🔗 Schema Diagram: View Here

⚙ Installation and Setup
Step 1: Clone the Repository
Download or clone the repository containing the SQL scripts:

git clone https://github.com/Kesa1203/GroupProject_Bookstore.git
cd BookStoreDatabase

Step 2: Set Up the Database
1️⃣ Create the Database:
CREATE DATABASE BookStore;
USE BookStore;

2️⃣ Create Tables: Use the script create_tables.sql to create tables in the correct order.
-- Provided SQL script to create all tables
3️⃣ Insert Sample Data: Populate the database with sample data using populate_tables.sql.
-- Provided SQL script for inserting sample data

Step 3: Manage User Permissions
Run the following script to configure database users:

CREATE USER 'admin_user'@'%' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON BookStore.* TO 'admin_user'@'%';

CREATE USER 'regular_user'@'%' IDENTIFIED BY 'userpassword';
GRANT SELECT ON BookStore.* TO 'regular_user'@'%';
FLUSH PRIVILEGES;

🔍 Testing and Queries
Example Queries:
📜 Retrieve all books and authors:

SELECT b.title AS book_title, a.name AS author_name
FROM book AS b
JOIN book_author AS ba ON b.book_id = ba.book_id
JOIN author AS a ON ba.author_id = a.author_id;

💰 Total revenue from all orders:

SELECT SUM(b.price * ol.quantity) AS total_revenue
FROM order_line AS ol
JOIN book AS b ON ol.book_id = b.book_id;

🔎 Additional queries are provided in the test_queries.sql script for detailed analysis and testing.

🎯 Expected Outcomes
By completing this project, we will gain:
✅ Practical experience in designing and implementing a relational database.
✅ Strong SQL skills for creating, managing, and querying data.
✅ Insights into database security and user access management.

🤝 Contributing
If you'd like to contribute, feel free to fork the repository and submit pull requests. Contributions are welcome in the form of:
🔹 Performance optimizations.
🔹 Additional features or tables.
🔹 Enhanced queries for reporting.

📜 License
This project is open-source and available under the MIT License.

📩 Contact
For questions or feedback, feel free to reach out:

👤 Project Owners:

Dominik Kean
📧 ilsaoltactaiocht@gmail.com
🔗 GitHub

Sylvester Kesa
📧 kesasylvesterlee@gmail.com
🔗 GitHub

Emmanuel Nyaoke
📧 emmanuelnyakoe13@gmail.com
🔗 GitHub
