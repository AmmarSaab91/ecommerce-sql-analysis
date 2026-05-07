-- ################################################################
-- FILE: delay-bottleneck-detection.sql
-- ################################################################

-- ==========================================================
-- Delay and Bottleneck Detection
-- Notes:
-- - Fulfillment time = delivered_at - created_at.
-- - Processing time = shipped_at - created_at.
-- - Delivery time = delivered_at - shipped_at.
-- - Cancellation and return rates are expressed as percentages.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Orders exceeding average fulfillment time
-- ----------------------------------------------------------
WITH fulfillment AS (
    SELECT
        order_id,
        delivered_at - created_at AS fulfillment_time
    FROM orders
    WHERE delivered_at IS NOT NULL
)
SELECT
    order_id,
    fulfillment_time
FROM fulfillment
WHERE fulfillment_time > (
    SELECT AVG(fulfillment_time)
    FROM fulfillment
)
ORDER BY fulfillment_time DESC
LIMIT 10;

-- ----------------------------------------------------------
-- 2) Cancellation patterns
-- ----------------------------------------------------------

-- 2.1) Cancellation rate by month
SELECT
    DATE_TRUNC('month', created_at)::date AS month,
    COUNT(*) FILTER (WHERE status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders
GROUP BY month
ORDER BY month;

-- 2.2) Cancellation rate by traffic source
SELECT
    u.traffic_source,
    COUNT(*) FILTER (WHERE o.status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE o.status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders AS o
JOIN users AS u
    ON o.user_id = u.id
GROUP BY u.traffic_source
ORDER BY cancellation_rate DESC;

-- 2.3) Cancellation rate by country
SELECT
    u.country,
    COUNT(*) FILTER (WHERE o.status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE o.status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders AS o
JOIN users AS u
    ON o.user_id = u.id
GROUP BY u.country
ORDER BY cancellation_rate DESC;

-- 2.4) Cancellation rate by gender
SELECT
    u.gender,
    COUNT(*) FILTER (WHERE o.status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE o.status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders AS o
JOIN users AS u
    ON o.user_id = u.id
GROUP BY u.gender
ORDER BY cancellation_rate DESC;

-- 2.5) Cancellation rate by order size
WITH order_sizes AS (
    SELECT
        oi.order_id,
        COUNT(*) AS number_of_items
    FROM order_items AS oi
    GROUP BY oi.order_id
)
SELECT
    os.number_of_items,
    COUNT(*) FILTER (WHERE o.status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE o.status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM order_sizes AS os
JOIN orders AS o
    ON os.order_id = o.order_id
GROUP BY os.number_of_items
ORDER BY cancellation_rate DESC, os.number_of_items DESC;

-- ----------------------------------------------------------
-- 3) Operational inefficiencies
-- ----------------------------------------------------------

-- 3.1) Average processing time
SELECT
    AVG(shipped_at - created_at) AS avg_processing_time
FROM orders
WHERE shipped_at IS NOT NULL;

-- 3.2) Average delivery time
SELECT
    AVG(delivered_at - shipped_at) AS avg_delivery_time
FROM orders
WHERE shipped_at IS NOT NULL
  AND delivered_at IS NOT NULL;

-- 3.3) Overall cancellation rate
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders;

-- 3.4) Overall return rate
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Returned') / COUNT(*),
        2
    ) AS return_rate
FROM orders;
