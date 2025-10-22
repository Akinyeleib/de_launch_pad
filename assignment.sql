-- 1. Count the total number of customers who joined in 2023.
SELECT * FROM CUSTOMERS WHERE DATE_PART ('YEAR', join_date) = '2025';

-- 2. For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.
WITH
    Report AS (
        SELECT customer_id, SUM(total_amount) AS Total
        FROM orders
        GROUP BY
            customer_id
    )
SELECT c.customer_id, full_name, Total
FROM CUSTOMERS c
    JOIN Report r ON c.customer_id = r.customer_id
ORDER BY Total DESC;

-- 3. Return the top 5 customers by total_revenue with their rank.
WITH
    Report AS (
        SELECT customer_id, SUM(total_amount) AS Total
        FROM orders
        GROUP BY
            customer_id
    )
SELECT customer_id, Total
FROM Report
ORDER BY Total DESC
limit 5;

-- 4. Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically.
WITH
    Report AS (
        SELECT
            TO_CHAR (order_date, 'Month') AS Month_Name,
            DATE_PART ('Month', order_date) AS Month_Index,
            DATE_PART ('YEAR', order_date) AS Year,
            total_amount AS amount
        FROM orders
    )
SELECT Month_Name, Year, SUM(amount) AS Revenue
FROM REPORT
GROUP BY
    Month_Name,
    Month_Index,
    Year
ORDER BY Month_Index;

-- 5. Find customers with no orders in the last 60 days relative to 2023-12-31 (i.e., consider last active date up to 2023-12-31). Return customer_id, full_name, last_order_date.
WITH
    Report AS (
        SELECT customer_id
        FROM orders
        WHERE
            ORDER_DATE <= DATE '2023-12-31' - INTERVAL '6 months'
        ORDER BY ORDER_DATE
    )
SELECT customer_id
FROM orders EXCEPT
SELECT customer_id
FROM Report

-- 6. Calculate average order value (AOV) for each customer: return customer_id, full_name, aov (average total_amount of their orders). Exclude customers with no orders.
WITH
    Report AS (
        SELECT customer_id, AVG(total_amount) AS average_amount
        FROM orders
        GROUP BY
            customer_id
    )
SELECT r.customer_id, full_name, average_amount AS aov
FROM Report r
    LEFT JOIN CUSTOMERS c ON c.customer_id = r.customer_id
ORDER BY r.customer_id

-- 7. For all customers who have at least one order, compute customer_id, full_name, total_revenue, spend_rank where spend_rank is a dense rank, highest spender = rank 1.
WITH
    Report AS (
        SELECT customer_id, SUM(total_amount) AS total_revenue
        FROM orders
        GROUP BY
            customer_id
    )
SELECT
    r.customer_id,
    full_name,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS spend_rank
FROM Report r
    LEFT JOIN CUSTOMERS c ON c.customer_id = r.customer_id
ORDER BY r.customer_id;

-- 8. List customers who placed more than 1 order and show customer_id, full_name, order_count, first_order_date, last_order_date.
WITH
    Report AS (
        SELECT
            customer_id,
            COUNT(order_id) AS order_count,
            MIN(order_date) AS first_order_date,
            MAX(order_date) AS last_order_date
        FROM orders
        GROUP BY
            customer_id
        HAVING
            COUNT(order_id) > 1
    )
SELECT
    r.customer_id,
    full_name,
    order_count,
    first_order_date,
    last_order_date
FROM Report r
    JOIN CUSTOMERS c ON c.customer_id = r.customer_id
ORDER BY order_count DESC;

-- 9. Compute total loyalty points per customer. Include customers with 0 points.
SELECT c.customer_id, SUM(points_earned) AS total_points_earned
FROM loyalty_points l
    JOIN CUSTOMERS c ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id
ORDER BY total_points_earned DESC;

-- 10. Assign loyalty tiers based on total points:
--     - Bronze: < 100
--     - Silver: 100–499
--     - Gold: >= 500
--     Output: tier, tier_count, tier_total_points
WITH
    Report AS (
        SELECT
            customer_id,
            SUM(points_earned) AS total_points_earned
        FROM loyalty_points
        GROUP BY
            customer_id
    ),
    Grouped AS (
        SELECT
            total_points_earned,
            CASE
                WHEN total_points_earned < 100 THEN 'Bronze'
                WHEN total_points_earned < 500 THEN 'Silver'
                WHEN total_points_earned >= 500 THEN 'Gold'
            END AS loyalty_tiers
        FROM Report
    )
SELECT
    loyalty_tiers AS tier,
    COUNT(loyalty_tiers) AS tier_count,
    SUM(total_points_earned) AS tier_total_points
FROM Grouped
GROUP BY
    loyalty_tiers;

-- 11. Identify customers who spent more than ₦50,000 in total but have less than 200 loyalty points. Return customer_id, full_name, total_spend, total_points.
WITH
    Report AS (
        SELECT
            o.customer_id,
            SUM(total_amount) AS Total,
            SUM(points_earned) AS total_loyalty_points
        FROM orders o
            JOIN loyalty_points l ON l.customer_id = o.customer_id
        GROUP BY
            o.customer_id
    )
SELECT
    c.customer_id,
    full_name,
    Total AS total_spend,
    total_loyalty_points AS total_points
FROM CUSTOMERS c
    JOIN Report r ON c.customer_id = r.customer_id
WHERE
    Total > 50000
    AND total_loyalty_points < 200
ORDER BY Total DESC;

-- 12. Flag customers as churn_risk if they have no orders in the last 90 days (relative to 2023-12-31) AND are in the Bronze tier. Return customer_id, full_name, last_order_date, total_points.

