-- ==========================================================
-- Order-Level KPI Analysis
-- Notes:
-- - Based on completed and shipped order items.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Average order value (AOV)
-- ----------------------------------------------------------
SELECT
    SUM(ii.product_retail_price) / COUNT(DISTINCT oi.order_id) AS aov
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
WHERE oi.status IN ('Complete', 'Shipped');

-- ----------------------------------------------------------
-- 2) Top customers by revenue
-- ----------------------------------------------------------
SELECT
    oi.user_id,
    SUM(ii.product_retail_price) AS revenue
FROM order_items AS oi
JOIN inventory_items AS ii
    ON oi.inventory_item_id = ii.id
WHERE oi.status IN ('Complete', 'Shipped')
GROUP BY oi.user_id
ORDER BY revenue DESC
LIMIT 10;
