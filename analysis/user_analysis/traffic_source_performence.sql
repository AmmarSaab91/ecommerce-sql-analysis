-- ==========================================================
-- Traffic Source Performance Analysis
-- Notes:
-- - Gross revenue includes returned items because they were sold at some point.
-- - Net revenue excludes returned items.
-- - Revenue and AOV use inventory_items.product_retail_price as a price proxy.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Revenue by traffic source
-- ----------------------------------------------------------
SELECT
    u.traffic_source,
    TO_CHAR(
        ROUND(SUM(ii.product_retail_price), 2),
        'FM999999990.00'
    ) || ' €' AS gross_revenue,
    TO_CHAR(
        ROUND(
            SUM(
                CASE
                    WHEN oi.returned_at IS NULL THEN ii.product_retail_price
                    ELSE 0
                END
            ),
            2
        ),
        'FM999999990.00'
    ) || ' €' AS net_revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
JOIN users AS u
    ON oi.user_id = u.id
WHERE oi.status IN ('Complete', 'Shipped', 'Returned')
GROUP BY u.traffic_source
ORDER BY SUM(ii.product_retail_price) DESC;

-- ----------------------------------------------------------
-- 2) Conversion rate per traffic source
-- ----------------------------------------------------------
WITH converted_users AS (
    SELECT
        u.traffic_source,
        COUNT(DISTINCT u.id) AS converted_users
    FROM users AS u
    JOIN order_items AS oi
        ON oi.user_id = u.id
    WHERE oi.status = 'Complete'
    GROUP BY u.traffic_source
),
total_users AS (
    SELECT
        traffic_source,
        COUNT(DISTINCT id) AS total_users
    FROM users
    GROUP BY traffic_source
)
SELECT
    t.traffic_source,
    t.total_users,
    COALESCE(c.converted_users, 0) AS converted_users,
    TO_CHAR(
        ROUND(100.0 * COALESCE(c.converted_users, 0) / t.total_users, 2),
        'FM999990.00'
    ) || '%' AS conversion_rate
FROM total_users AS t
LEFT JOIN converted_users AS c
    ON t.traffic_source = c.traffic_source
ORDER BY ROUND(100.0 * COALESCE(c.converted_users, 0) / t.total_users, 2) DESC;

-- ----------------------------------------------------------
-- 3) Average order value (AOV) by traffic source
-- ----------------------------------------------------------
SELECT
    u.traffic_source,
    TO_CHAR(
        ROUND(
            SUM(ii.product_retail_price) / COUNT(DISTINCT oi.order_id),
            2
        ),
        'FM999999990.00'
    ) || ' €' AS aov_gross_revenue,
    TO_CHAR(
        ROUND(
            SUM(
                CASE
                    WHEN oi.returned_at IS NULL THEN ii.product_retail_price
                    ELSE 0
                END
            ) / COUNT(
                DISTINCT CASE
                    WHEN oi.returned_at IS NULL THEN oi.order_id
                END
            ),
            2
        ),
        'FM999999990.00'
    ) || ' €' AS aov_net_revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
JOIN users AS u
    ON oi.user_id = u.id
WHERE oi.status IN ('Complete', 'Shipped', 'Returned')
GROUP BY u.traffic_source
ORDER BY SUM(ii.product_retail_price) / COUNT(DISTINCT oi.order_id) DESC;

-- ----------------------------------------------------------
-- 4) Highest-performing acquisition channel by net revenue
-- ----------------------------------------------------------
SELECT
    u.traffic_source,
    TO_CHAR(
        SUM(ii.product_retail_price),
        'FM999999990.00'
    ) || ' €' AS net_revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
JOIN users AS u
    ON oi.user_id = u.id
WHERE oi.status IN ('Complete', 'Shipped')
GROUP BY u.traffic_source
ORDER BY SUM(ii.product_retail_price) DESC
LIMIT 1;
