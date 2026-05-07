-- ==========================================================
-- Revenue Metrics
-- Notes:
-- - Gross revenue includes returned items because they were sold at some point.
-- - Net revenue excludes returned items.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Total gross and net revenue
-- ----------------------------------------------------------
SELECT
    SUM(ii.product_retail_price)::TEXT || '€' AS total_gross_revenue,
    SUM(
        CASE
            WHEN oi.returned_at IS NULL THEN ii.product_retail_price
            ELSE 0
        END
    )::TEXT || '€' AS total_net_revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
WHERE oi.status IN ('Complete', 'Shipped', 'Returned');

-- ----------------------------------------------------------
-- 2) Revenue trend by month
-- ----------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM oi.created_at)::INT AS year,
        EXTRACT(MONTH FROM oi.created_at)::INT AS month,
        SUM(ii.product_retail_price) AS revenue
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY
        EXTRACT(YEAR FROM oi.created_at),
        EXTRACT(MONTH FROM oi.created_at)
),
comparison AS (
    SELECT
        year,
        month,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY year
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    year,
    month,
    revenue::TEXT || '€' AS revenue,
    previous_month_revenue::TEXT || '€' AS previous_month_revenue,
    CASE
        WHEN previous_month_revenue IS NULL THEN 'No previous month'
        WHEN revenue > previous_month_revenue THEN 'Increased'
        WHEN revenue < previous_month_revenue THEN 'Decreased'
        ELSE 'No change'
    END AS trend
FROM comparison
ORDER BY year, month;

-- ----------------------------------------------------------
-- 3) Revenue by product category
-- ----------------------------------------------------------
SELECT
    ii.product_category,
    SUM(ii.product_retail_price)::TEXT || '€' AS revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
WHERE oi.status IN ('Complete', 'Shipped')
GROUP BY ii.product_category
ORDER BY SUM(ii.product_retail_price) DESC;

-- ----------------------------------------------------------
-- 4) Revenue by country
-- ----------------------------------------------------------
SELECT
    u.country,
    SUM(ii.product_retail_price)::TEXT || '€' AS revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
JOIN users AS u
    ON oi.user_id = u.id
WHERE oi.status IN ('Complete', 'Shipped')
GROUP BY u.country
ORDER BY SUM(ii.product_retail_price) DESC;
