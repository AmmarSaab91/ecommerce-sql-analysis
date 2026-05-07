-- ==========================================================
-- Status Distribution
-- Notes:
-- - Percentages are based on all rows in the orders table.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Completed orders
-- ----------------------------------------------------------
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Complete') / COUNT(*),
        2
    )::TEXT || '%' AS completed_orders_pct
FROM orders;

-- ----------------------------------------------------------
-- 2) Cancelled orders
-- ----------------------------------------------------------
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Cancelled') / COUNT(*),
        2
    )::TEXT || '%' AS cancelled_orders_pct
FROM orders;

-- ----------------------------------------------------------
-- 3) Returned orders
-- ----------------------------------------------------------
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Returned') / COUNT(*),
        2
    )::TEXT || '%' AS returned_orders_pct
FROM orders;
