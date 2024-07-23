CREATE TABLE stores
(
    store_id   SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    state      VARCHAR(25)
);

CREATE TABLE products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    model_year   VARCHAR(10),
    list_price   DECIMAL(10, 2)
);

CREATE TABLE customers
(
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(255),
    last_name   VARCHAR(255),
    state       VARCHAR(25)
);

CREATE TABLE staffs
(
    staff_id   SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name  VARCHAR(255),
    active     INT,
    store_id   INT REFERENCES stores (store_id),
    manager_id INT REFERENCES staffs (staff_id)
);

CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (customer_id),
    order_status INT,
    store_id     INT REFERENCES stores (store_id),
    staff_id     INT REFERENCES staffs (staff_id)
);

CREATE TABLE order_items
(
    order_id   INT REFERENCES orders (order_id),
    item_id    SERIAL,
    product_id INT REFERENCES products (product_id),
    quantity   INT,
    discount   DECIMAL(4, 2),
    PRIMARY KEY (order_id, item_id)
);

CREATE TABLE stocks
(
    store_id   INT REFERENCES stores (store_id),
    product_id INT REFERENCES products (product_id),
    quantity   INT
);

-- COPY stores FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/stores.csv' DELIMITER ',' CSV HEADER;
-- COPY products FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/products.csv' DELIMITER ',' CSV HEADER;
-- COPY customers FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/customers.csv' DELIMITER ',' CSV HEADER;
-- COPY staffs FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/staffs.csv' DELIMITER ',' CSV HEADER;
-- COPY orders FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/orders.csv' DELIMITER ',' CSV HEADER;
-- COPY order_items FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/order_items.csv' DELIMITER ',' CSV HEADER;
-- COPY stocks FROM '/Users/alireza/PycharmProjects/db-hw3/p2/tables/stocks.csv' DELIMITER ',' CSV HEADER;

-- 1
SELECT staffs.staff_id, first_name || ' ' || last_name AS name, COUNT(order_id) AS service_count
FROM staffs
         LEFT JOIN orders ON staffs.staff_id = orders.staff_id
GROUP BY staffs.staff_id, first_name, last_name
ORDER BY service_count DESC;

-- 2
SELECT stores.state,
       COUNT(CASE WHEN orders.order_status = 4 AND stores.state = customers.state THEN 1 END) AS order_count
FROM stores
         LEFT JOIN orders ON stores.store_id = orders.store_id
         LEFT JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY stores.state
ORDER BY stores.state;

-- 3
SELECT customer_id,
       SUM(order_items.quantity * order_items.discount * products.list_price) AS total_discount
FROM orders
         JOIN order_items ON orders.order_id = order_items.order_id
         JOIN products ON order_items.product_id = products.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT orders.order_id) > 1
ORDER BY total_discount DESC
LIMIT 3;

-- 4
SELECT product_id
FROM stocks
WHERE product_id NOT IN (SELECT product_id FROM order_items)
GROUP BY product_id
HAVING MIN(quantity) > 0
ORDER BY SUM(quantity) DESC;
