-- ==========================================================
-- Basic RFM Classification
-- Notes:
-- - Reference date = latest completed/shipped order date in the dataset.
-- - Recency is measured in days.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Combine recency, frequency, and monetary metrics
-- ----------------------------------------------------------
WITH reference_date AS (
    SELECT
        MAX(created_at::date) AS end_date
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
),
recency AS (
    SELECT
        o.user_id,
        MAX(r.end_date) - MAX(o.created_at::date) AS recency_days
    FROM orders AS o
    CROSS JOIN reference_date AS r
    WHERE o.status IN ('Complete', 'Shipped')
    GROUP BY o.user_id
),
frequency AS (
    SELECT
        user_id,
        COUNT(*) AS frequency
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
    GROUP BY user_id
),
monetary AS (
    SELECT
        oi.user_id,
        SUM(ii.product_retail_price) AS monetary
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.user_id
)
SELECT
    r.user_id,
    r.recency_days,
    f.frequency,
    m.monetary
FROM recency AS r
JOIN frequency AS f
    ON r.user_id = f.user_id
JOIN monetary AS m
    ON r.user_id = m.user_id
ORDER BY r.user_id;

-- ----------------------------------------------------------
-- 2) Define behavioral customer groups
-- ----------------------------------------------------------
WITH reference_date AS (
    SELECT
        MAX(created_at::date) AS end_date
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
),
recency AS (
    SELECT
        o.user_id,
        MAX(r.end_date) - MAX(o.created_at::date) AS recency_days
    FROM orders AS o
    CROSS JOIN reference_date AS r
    WHERE o.status IN ('Complete', 'Shipped')
    GROUP BY o.user_id
),
frequency AS (
    SELECT
        user_id,
        COUNT(*) AS frequency
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
    GROUP BY user_id
),
monetary AS (
    SELECT
        oi.user_id,
        SUM(ii.product_retail_price) AS monetary
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.user_id
),
rfm AS (
    SELECT
        r.user_id,
        r.recency_days,
        f.frequency,
        m.monetary
    FROM recency AS r
    JOIN frequency AS f
        ON r.user_id = f.user_id
    JOIN monetary AS m
        ON r.user_id = m.user_id
),
benchmark AS (
    SELECT
        AVG(frequency) AS avg_frequency,
        AVG(monetary) AS avg_monetary,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY monetary) AS threshold_monetary
    FROM rfm
)
SELECT
    r.user_id,
    r.recency_days,
    r.frequency,
    r.monetary,
    CASE
        WHEN r.recency_days <= 30
             AND r.frequency >= b.avg_frequency
             AND r.monetary >= b.avg_monetary
            THEN 'Best Customers'
        WHEN r.recency_days <= 30
             AND r.frequency = 1
            THEN 'New Customers'
        WHEN r.recency_days > 90
             AND r.frequency >= b.avg_frequency
            THEN 'At Risk'
        WHEN r.monetary >= b.threshold_monetary
            THEN 'Big Spenders'
        ELSE 'Regular Customers'
    END AS customer_group
FROM rfm AS r
CROSS JOIN benchmark AS b
ORDER BY r.monetary DESC;
