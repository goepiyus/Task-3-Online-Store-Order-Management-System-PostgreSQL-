-- Create tables 
CREATE TABLE Customers(
CUSTOMER_ID int Primary Key,
NAME text,
EMAIL varchar(255),
PHONE numeric,
ADDRESS varchar(255)
);

CREATE TABLE Products(
PRODUCT_ID int Primary Key,
PRODUCT_NAME text,
CATEGORY text,
PRICE numeric,
STOCK numeric
);

CREATE TABLE Orders(
ORDER_ID int Primary Key,
CUSTOMER_ID int,
Foreign Key (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
PRODUCT_ID int,
Foreign Key (PRODUCT_ID) REFERENCES Products(PRODUCT_ID),
QUANTITY int,
ORDER_DATE date
);

-- Data Creation:
INSERT INTO Customers (CUSTOMER_ID, NAME, EMAIL, PHONE, ADDRESS) VALUES
(1, 'Amit Sharma', 'amit.sharma@example.com', 9876543210, 'Delhi'),
(2, 'Priya Verma', 'priya.verma@example.com', 9898123456, 'Mumbai'),
(3, 'Rahul Singh', 'rahul.singh@example.com', 9123456780, 'Bengaluru'),
(4, 'Sneha Iyer', 'sneha.iyer@example.com', 9988776655, 'Chennai'),
(5, 'Arjun Patel', 'arjun.patel@example.com', 9012345678, 'Ahmedabad'),
(6, 'Neha Gupta', 'neha.gupta@example.com', 9765432109, 'Kolkata'),
(7, 'Rohit Kumar', 'rohit.kumar@example.com', 9456123789, 'Lucknow'),
(8, 'Kavya Reddy', 'kavya.reddy@example.com', 9345126789, 'Hyderabad'),
(9, 'Vikram Chauhan', 'vikram.chauhan@example.com', 9823456712, 'Jaipur'),
(10, 'Anita Desai', 'anita.desai@example.com', 9812345567, 'Pune');


INSERT INTO Products (PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
(1, 'Samsung Galaxy M34', 'Mobile', 16999, 50),
(2, 'Apple iPhone 14', 'Mobile', 71999, 30),
(3, 'Dell Inspiron 3511', 'Laptop', 52999, 20),
(4, 'HP Pavilion 14', 'Laptop', 59999, 15),
(5, 'Boat Airdopes 161', 'Earbuds', 1299, 200),
(6, 'Sony WH-CH720N', 'Headphones', 8990, 40),
(7, 'LG 55-inch Smart TV', 'Television', 52990, 10),
(8, 'Samsung Microwave Oven', 'Home Appliance', 10490, 25),
(9, 'Mi Smart Band 7', 'Wearable', 4999, 100),
(10, 'Canon EOS 1500D', 'Camera', 36990, 12);

INSERT INTO Orders (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 1, 1, '2024-01-15'),
(2, 2, 5, 2, '2024-01-20'),
(3, 3, 3, 1, '2024-02-02'),
(4, 4, 2, 1, '2024-02-10'),
(5, 5, 9, 3, '2024-03-01'),
(6, 6, 7, 1, '2024-03-05'),
(7, 7, 4, 1, '2024-03-15'),
(8, 8, 6, 2, '2024-04-01'),
(9, 9, 8, 1, '2024-04-10'),
(10, 10, 10, 1, '2024-04-20');

-- Order Management
--a, Retrieve all orders placed by a specific customer
SELECT o.ORDER_ID, o.PRODUCT_ID, o.Quantity, c.CUSTOMER_ID, c.NAME
FROM Orders o JOIN Customers c
ON o.CUSTOMER_ID=C.CUSTOMER_ID;

--b,Find products that are out of stock
SELECT * FROM Products WHERE STOCK = 0;

--c,Calculate the total revenue generated per product
SELECT p.PRODUCT_ID,p.PRODUCT_NAME, o.QUANTITY,
SUM(p.PRICE * o.QUANTITY) as REVENUE FROM
Products p JOIN Orders o ON
p.PRODUCT_ID=o.PRODUCT_ID GROUP BY p.PRODUCT_ID,
p.PRODUCT_NAME, o.QUANTITY ORDER BY REVENUE DESC;

--d, Retrieve the top 5 customers by total purchase amountS
SELECT c.CUSTOMER_ID,c.NAME AS CUSTOMER_NAME,
SUM(p.PRICE * o.QUANTITY) AS TOTAL_PURCHASE_AMOUNT FROM Customers c
JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAMEs
ORDER BY TOTAL_PURCHASE_AMOUNT DESC LIMIT 5;

--e, Find customers who placed orders in at least two different product categories
SELECT c.CUSTOMER_ID,c.NAME AS CUSTOMER_NAME,COUNT(DISTINCT p.CATEGORY) AS CATEGORY_COUNT
FROM Customers c JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID,c.NAME
HAVING COUNT(DISTINCT p.CATEGORY) >= 2;

--Analytics
--a, Find the month with the highest total sales
SELECT TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS ORDER_MONTH,
SUM(p.PRICE * o.QUANTITY) AS TOTAL_SALES FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY TO_CHAR(o.ORDER_DATE, 'YYYY-MM')
ORDER BY TOTAL_SALES DESC
LIMIT 1;

-- b, Identify products with no orders in the last 6 months
SELECT p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY, p.PRICE, p.STOCK
FROM Products p WHERE p.PRODUCT_ID NOT IN 
(SELECT DISTINCT o.PRODUCT_ID FROM Orders o
WHERE o.ORDER_DATE >= CURRENT_DATE - INTERVAL '6 months');

-- c, Retrieve customers who have never placed an order
SELECT c.CUSTOMER_ID, c.NAME FROM Customers c WHERE c.CUSTOMER_ID
NOT IN (SELECT DISTINCT o.CUSTOMER_ID FROM Orders o);

-- d, Calculate the average order value across all orders
SELECT o.ORDER_ID, SUM(o.QUANTITY * p.PRICE) AS ORDER_VALUE
FROM Orders o JOIN Products p ON o.PRODUCT_ID=p.PRODUCT_ID GROUP BY o.ORDER_ID;