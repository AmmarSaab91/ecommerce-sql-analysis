-- ==========================================================
-- Profitability Analysis
-- Notes:
-- - Markup = profit / cost.
-- - Profit margin = profit / retail_price.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Product-level profit margin and markup
-- ----------------------------------------------------------
WITH profits AS (
    SELECT
        cost,
        retail_price,
        retail_price - cost AS profit
    FROM products
)
SELECT
    cost::TEXT || '€' AS cost,
    profit::TEXT || '€' AS profit,
    retail_price::TEXT || '€' AS retail_price,
    ROUND(100.0 * profit / cost, 2)::TEXT || '%' AS markup,
    ROUND(100.0 * profit / retail_price, 2)::TEXT || '%' AS profit_margin
FROM profits
LIMIT 10;

-- ----------------------------------------------------------
-- 2) Top 10 most profitable products
-- ----------------------------------------------------------
WITH product_profit AS (
    SELECT
        oi.product_id,
        ii.product_name,
        SUM(ii.product_retail_price) AS revenue,
        SUM(ii.cost) AS total_cost,
        SUM(ii.product_retail_price - ii.cost) AS profit
    FROM order_items AS oi
    JOIN inventory_items AS ii
        ON oi.inventory_item_id = ii.id
    WHERE oi.status IN ('Complete', 'Shipped')
    GROUP BY oi.product_id, ii.product_name
)
SELECT
    product_id,
    product_name,
    revenue::TEXT || '€' AS revenue,
    total_cost::TEXT || '€' AS total_cost,
    profit::TEXT || '€' AS profit
FROM product_profit
ORDER BY profit DESC
LIMIT 10;

-- ----------------------------------------------------------
-- 3) Lowest-margin products
-- ----------------------------------------------------------
WITH profits AS (
    SELECT
        name,
        cost,
        retail_price,
        retail_price - cost AS profit,
        ROUND(100.0 * (retail_price - cost) / retail_price, 2) AS profit_margin
    FROM products
)
SELECT
    name,
    cost::TEXT || '€' AS cost,
    profit::TEXT || '€' AS profit,
    retail_price::TEXT || '€' AS retail_price,
    profit_margin::TEXT || '%' AS profit_margin
FROM profits
ORDER BY profit_margin ASC
LIMIT 10;

-- ----------------------------------------------------------
-- 4) Category-level profitability
-- ----------------------------------------------------------
WITH profits AS (
    SELECT
        category,
        SUM(cost) AS cost,
        SUM(retail_price) AS retail_price,
        SUM(retail_price - cost) AS profit,
        ROUND(100.0 * SUM(retail_price - cost) / SUM(retail_price), 2) AS profit_margin
    FROM products
    GROUP BY category
)
SELECT
    category,
    cost::TEXT || '€' AS cost,
    profit::TEXT || '€' AS profit,
    retail_price::TEXT || '€' AS retail_price,
    profit_margin::TEXT || '%' AS profit_margin
FROM profits
ORDER BY profit_margin DESC
LIMIT 10;
