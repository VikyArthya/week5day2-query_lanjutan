-- Tabel untuk menyimpan data pelanggan
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    status_login BOOLEAN NOT NULL
);

-- Tabel untuk menyimpan data driver
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    total_orders INT DEFAULT 0
);

-- Tabel untuk menyimpan data order
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    driver_id INT REFERENCES drivers(driver_id),
    order_date TIMESTAMP NOT NULL,
    region VARCHAR(100) NOT NULL
);

INSERT INTO customers (name, email, status_login) VALUES 
('Budi', 'budi@example.com', TRUE),
('Ani', 'ani@example.com', FALSE),
('Citra', 'citra@example.com', TRUE),
('Dedi', 'dedi@example.com', TRUE),
('Eka', 'eka@example.com', FALSE);

INSERT INTO drivers (name, total_orders) VALUES 
('Fikri', 30),
('Gina', 45),
('Hendri', 50),
('Indra', 20),
('Joko', 60);

INSERT INTO orders (customer_id, driver_id, order_date, region) VALUES 
(1, 1, '2024-10-01 08:30:00', 'Jakarta Barat'),
(2, 2, '2024-10-01 09:15:00', 'Jakarta Pusat'),
(3, 3, '2024-10-01 15:00:00', 'Jakarta Timur'),
(4, 1, '2024-10-02 11:45:00', 'Jakarta Barat'),
(1, 5, '2024-10-02 20:00:00', 'Jakarta Selatan'),
(3, 4, '2024-10-03 18:30:00', 'Jakarta Timur'),
(5, 3, '2024-10-03 13:00:00', 'Jakarta Pusat'),
(2, 2, '2024-10-04 09:45:00', 'Jakarta Barat'),
(3, 5, '2024-10-04 12:00:00', 'Jakarta Selatan'),
(4, 1, '2024-10-05 21:30:00', 'Jakarta Barat'),
(1, 4, '2024-11-01 08:30:00', 'Jakarta Timur'),
(5, 2, '2024-11-02 10:30:00', 'Jakarta Pusat'),
(2, 3, '2024-11-02 15:45:00', 'Jakarta Barat'),
(3, 1, '2024-11-03 20:00:00', 'Jakarta Selatan'),
(4, 5, '2024-11-04 17:30:00', 'Jakarta Selatan'),
(1, 2, '2024-11-05 08:15:00', 'Jakarta Timur'),
(5, 4, '2024-11-05 14:00:00', 'Jakarta Barat'),
(2, 3, '2024-11-06 09:00:00', 'Jakarta Pusat'),
(3, 5, '2024-11-06 16:30:00', 'Jakarta Timur'),
(4, 2, '2024-11-07 11:45:00', 'Jakarta Barat');

//melihat total order setiap bulan
SELECT TO_CHAR(order_date, 'YYYY-MM') AS bulan, COUNT(*) AS total_order
FROM orders
GROUP BY bulan
ORDER BY bulan;

//Melihat customer yang sering order tiap bulan
SELECT TO_CHAR(order_date, 'YYYY-MM') AS bulan, customers.name, COUNT(orders.order_id) AS jumlah_order
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY bulan, customers.name
ORDER BY bulan, jumlah_order DESC;

//Melihat daerah yang banyak ordernya
SELECT region, COUNT(*) AS total_order
FROM orders
GROUP BY region
ORDER BY total_order DESC;

//Melihat pukul berapa saja order yang ramai dan sepi
SELECT EXTRACT(HOUR FROM order_date) AS jam, COUNT(*) AS total_order
FROM orders
GROUP BY jam
ORDER BY total_order DESC;

//Melihat jumlah customer yang masih login dan logout
SELECT 
    COUNT(*) FILTER (WHERE status_login = TRUE) AS total_login,
    COUNT(*) FILTER (WHERE status_login = FALSE) AS total_logout
FROM customers;

//Melihat driver yang rajin mengambil order setiap bulan
SELECT TO_CHAR(order_date, 'YYYY-MM') AS bulan, drivers.name, COUNT(orders.order_id) AS jumlah_order
FROM orders
JOIN drivers ON orders.driver_id = drivers.driver_id
GROUP BY bulan, drivers.name
ORDER BY bulan, jumlah_order DESC;
