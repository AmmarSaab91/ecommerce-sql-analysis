-- ==========================================================
-- Recency Analysis
-- Notes:
-- - Reference date = latest order date in the dataset.
-- - Recency is measured in days at the customer level.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Most recent customers
-- ----------------------------------------------------------
WITH reference_date AS (
    SELECT
        MAX(created_at::DATE) AS max_order_date
    FROM orders
),
customer_recency AS (
    SELECT
        user_id,
        MAX(created_at::DATE) AS last_order_date
    FROM orders
    GROUP BY user_id
)
SELECT
    c.user_id,
    c.last_order_date,
    rf.max_order_date - c.last_order_date AS recency_days
FROM customer_recency AS c
CROSS JOIN reference_date AS rf
ORDER BY recency_days ASC
LIMIT 10;

-- ----------------------------------------------------------
-- 2) Inactive customer detection
-- ----------------------------------------------------------
WITH reference_date AS (
    SELECT
        MAX(created_at::DATE) AS max_order_date
    FROM orders
),
customer_recency AS (
    SELECT
        user_id,
        MAX(created_at::DATE) AS last_order_date
    FROM orders
    GROUP BY user_id
)
SELECT
    c.user_id,
    c.last_order_date,
    rf.max_order_date - c.last_order_date AS recency_days
FROM customer_recency AS c
CROSS JOIN reference_date AS rf
ORDER BY recency_days DESC
LIMIT 10;
