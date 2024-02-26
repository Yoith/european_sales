SELECT * FROM euro_sales.europe_sales;

ALTER TABLE europe_sales
CHANGE COLUMN `item type` item_type VARCHAR(255);

ALTER TABLE europe_sales
CHANGE COLUMN `Sales Channel` sales_channel VARCHAR(255);

ALTER TABLE europe_sales
CHANGE COLUMN `region` region VARCHAR(255),
CHANGE COLUMN `country` country VARCHAR(255),
CHANGE COLUMN `order priority` order_priority VARCHAR(255),
CHANGE COLUMN `order id` order_id INT,
CHANGE COLUMN `units sold` units_sold INT,
CHANGE COLUMN `unit price` unit_price FLOAT,
CHANGE COLUMN `unit cost` unit_cost FLOAT,
CHANGE COLUMN `total revenue` total_revenue FLOAT,
CHANGE COLUMN `total cost` total_cost FLOAT,
CHANGE COLUMN `total profit` total_profit FLOAT;

-- EUROPEAN SALES BY PRODUCT

-- 1. What type of products are the best-selling, in units, from highest to lowest?

SELECT item_type, SUM(units_sold) AS total_units_sold
FROM europe_sales
GROUP BY item_type
ORDER BY total_units_sold DESC
LIMIT 6;

-- 2. The type of product with the highest unit sold in Spain.

SELECT item_type, SUM(units_sold) AS total_units_sold
FROM europe_sales
GROUP BY item_type
ORDER BY total_units_sold DESC
LIMIT 6;

-- 2. The type of product with the highest unit sold in Germany.

SELECT item_type, SUM(units_sold) AS total_units_sold
FROM europe_sales
WHERE country = "Spain"
GROUP BY item_type
ORDER BY total_units_sold DESC
LIMIT 1;

-- 4. The type of product with the highest unit sold in Germany.

SELECT item_type, SUM(units_sold) AS total_units_sold
FROM europe_sales
WHERE country = "Germany"
GROUP BY item_type
ORDER BY total_units_sold DESC
LIMIT 1;

-- 5. Total quantity of units sold, in all Europe, through an online and offline channel.

SELECT sales_channel, SUM(units_sold) AS total_units_sold
FROM europe_sales
WHERE sales_channel IN ('Online', 'Offline')
GROUP BY sales_channel;

-- 6. Calculate the top 5 countries with products prioritized as critical that have the the lowest profits.

SELECT country, ROUND(SUM(total_profit), 2) AS total_profit
FROM europe_sales
WHERE order_priority = 'C'
GROUP BY country
ORDER BY total_profit ASC
LIMIT 5;

-- 7. Calculate the profit by units sold, according to the type of product.

SELECT item_type, ROUND(SUM(total_profit) / SUM(units_sold), 2) AS profit_by_units_sold
FROM europe_sales
GROUP BY item_type
ORDER BY profit_by_units_sold DESC;

-- 8. Calculate the cost and revenue per type of product and order it from highest to 
-- lowest revenue obtained.

SELECT item_type, ROUND(SUM(total_revenue), 2) AS total_revenue, 
ROUND(SUM(total_cost), 2) AS total_cost
FROM europe_sales
GROUP BY item_type
ORDER BY total_revenue DESC;

-- 9. Find all the information about the order with the highest profit for the product 'baby food', prioritized as critical, through an online sales channel.

SELECT *
FROM europe_sales
WHERE item_type = 'baby food' AND order_priority = 'C' AND sales_channel = "Online" 
ORDER BY total_profit DESC
LIMIT 1;

-- 10. Calculate the average total cost and compare it with the total cost of Spain and Germany.

SELECT ROUND(SUM(CASE WHEN country = 'Spain' THEN total_cost ELSE 0 END), 2) AS total_cost_spain,
ROUND(SUM(CASE WHEN country = 'Germany' THEN total_cost ELSE 0 END), 2) AS total_cost_germany,
ROUND(AVG(total_cost), 2) AS avg_total_cost
FROM europe_sales;

-- 11. Compare the total quantity of units sold in Spain and Germany, through an online and offline channel. Then calculate the difference between them.

SELECT sales_channel,
SUM(CASE WHEN country = 'Spain' THEN units_sold ELSE 0 END) AS units_sold_spain,
SUM(CASE WHEN country = 'Germany' THEN units_sold ELSE 0 END) AS units_sold_germany,
SUM(CASE WHEN country = 'Spain' THEN units_sold ELSE 0 END) - SUM(CASE WHEN country = 'Germany' THEN units_sold ELSE 0 END) AS difference
FROM europe_sales
WHERE country IN ('Spain', 'Germany') AND sales_channel IN ('Online', 'Offline')
GROUP BY sales_channel;

-- 12. For each type of product, calculate which country has the highest total cost.

SELECT europe_sales.item_type, europe_sales.country AS country, subquery.max_cost AS highest_cost
FROM europe_sales
JOIN (
SELECT item_type, MAX(total_cost) AS max_cost
FROM europe_sales
GROUP BY item_type
) AS subquery ON europe_sales.item_type = subquery.item_type AND europe_sales.total_cost = subquery.max_cost
ORDER BY highest_cost DESC;
