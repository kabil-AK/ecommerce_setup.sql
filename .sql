


-- the ecommerce database:
USE ecommerce;

-- Create the customers table:


CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    address VARCHAR(255)
);

-- Create the orders table


CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create the products table


CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Insert sample data into customers


INSERT INTO customers (name, email, address)
VALUES
('JD', 'jd@gmail.com', '123 Thambaram'),
('Smith', 'jane@gmail.com', '456 Tharamani'),
('Vijay', 'alice@gmail.com', '789 Vadapalani');



-- Insert sample data into products


INSERT INTO products (name, price, description)
VALUES
('T-shirt', 20.00, 'Trending T-shirt in now this generation '),
('Chain', 30.00, 'Gold chain is offerder for diwali festivel'),
('pant', 40.00, 'joker fit pant is made in tamilnadu');

-- Insert sample data into orders


INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
(1, CURDATE(), 50.00),
(2, CURDATE() - INTERVAL 10 DAY, 60.00),
(3, CURDATE() - INTERVAL 35 DAY, 45.00);

-- Retrieve all customers who have placed an order in the last 30 days.


SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- Get the total amount of all orders placed by each customer


SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Update the price of Product C to 45.00


UPDATE products
SET price = 45.00
WHERE name = 'pant';

-- Add a new column discount to the products table


ALTER TABLE products
ADD discount DECIMAL(5, 2) DEFAULT 0.00;

-- Retrieve the top 3 products with the highest price


SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- Get the names of customers who have ordered Product A



SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'T-shirt';

-- Join the orders and customers tables to retrieve the customer's name and order date for each order



SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Retrieve the orders with a total amount greater than 150.00


SELECT *
FROM orders
WHERE total_amount > 150.00;

-- Normalize the database by creating a separate table for order items and updating 
--the orders table to reference the order_items table.



CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Drop the total_amount column from the orders table



ALTER TABLE orders
DROP COLUMN total_amount;

-- Retrieve the average total of all orders


SELECT AVG(o.total_amount) AS average_order_total
FROM (
    SELECT order_id, SUM(price * quantity) AS total_amount
    FROM order_items
    GROUP BY order_id
) o;



