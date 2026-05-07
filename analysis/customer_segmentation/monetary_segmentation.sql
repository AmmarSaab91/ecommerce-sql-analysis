-- ==========================================================
-- Monetary Segmentation
-- Notes:
-- - Revenue and profit are calculated from completed and shipped items.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Highest-value customers
-- ----------------------------------------------------------
WITH customer_value AS (
    SELECT
        oi.user_id,
        SUM(ii.product_retail_price) AS customer_revenue,
        SUM(ii.product_retail_price - ii.cost) AS customer_profit
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.user_id
)
(
    SELECT
        user_id,
        customer_revenue AS value,
        'highest_revenue_customer' AS metric
    FROM customer_value
    ORDER BY customer_revenue DESC
    LIMIT 1
)
UNION ALL
(
    SELECT
        user_id,
        customer_profit AS value,
        'highest_profit_customer' AS metric
    FROM customer_value
    ORDER BY customer_profit DESC
    LIMIT 1
);

-- ----------------------------------------------------------
-- 2) Lowest-value customers
-- ----------------------------------------------------------
WITH customer_value AS (
    SELECT
        oi.user_id,
        SUM(ii.product_retail_price) AS customer_revenue,
        SUM(ii.product_retail_price - ii.cost) AS customer_profit
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.user_id
)
(
    SELECT
        user_id,
        customer_revenue AS value,
        'lowest_revenue_customer' AS metric
    FROM customer_value
    ORDER BY customer_revenue ASC
    LIMIT 1
)
UNION ALL
(
    SELECT
        user_id,
        customer_profit AS value,
        'lowest_profit_customer' AS metric
    FROM customer_value
    ORDER BY customer_profit ASC
    LIMIT 1
);

-- ----------------------------------------------------------
-- 3A) Revenue concentration based on top customers
-- ----------------------------------------------------------
WITH top_customers AS (
    SELECT
        oi.user_id,
        SUM(ii.product_retail_price) AS customer_revenue
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.user_id
    ORDER BY SUM(ii.product_retail_price) DESC
    LIMIT 10
),
total_revenue AS (
    SELECT
        SUM(ii.product_retail_price) AS total_revenue
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
)
SELECT
    ROUND(SUM(tc.customer_revenue) / MAX(tr.total_revenue) * 100, 2)::TEXT || '%' AS revenue_concentration
FROM top_customers AS tc
CROSS JOIN total_revenue AS tr;

-- ----------------------------------------------------------
-- 3B) Revenue concentration based on top product categories
-- ----------------------------------------------------------
WITH top_categories AS (
    SELECT
        ii.product_category,
        SUM(ii.product_retail_price) AS category_revenue
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY ii.product_category
    ORDER BY SUM(ii.product_retail_price) DESC
    LIMIT 5
),
total_revenue AS (
    SELECT
        SUM(ii.product_retail_price) AS total_revenue
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
)
SELECT
    ROUND(SUM(tc.category_revenue) / MAX(tr.total_revenue) * 100, 2)::TEXT || '%' AS revenue_concentration
FROM top_categories AS tc
CROSS JOIN total_revenue AS tr;
