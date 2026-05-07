-- ==========================================================
-- Frequency Analysis
-- Notes:
-- - Frequency is based on completed and shipped orders only.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) One-time vs. repeat customers
-- ----------------------------------------------------------
WITH customer_purchases AS (
    SELECT
        user_id,
        COUNT(*) AS purchase_count
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
    GROUP BY user_id
)
SELECT
    CASE
        WHEN purchase_count = 1 THEN 'one_time_customer'
        ELSE 'repeat_customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_purchases
GROUP BY customer_type;

-- ----------------------------------------------------------
-- 2) Purchase frequency distribution
-- ----------------------------------------------------------
WITH purchase_counts AS (
    SELECT
        user_id,
        COUNT(*) AS purchase_count
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
    GROUP BY user_id
)
SELECT
    purchase_count,
    COUNT(*) AS customer_count
FROM purchase_counts
GROUP BY purchase_count
ORDER BY purchase_count;
