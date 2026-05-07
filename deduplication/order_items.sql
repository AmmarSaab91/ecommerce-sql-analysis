-- ============================================================
-- DATA QUALITY ANALYSIS: ORDER ITEMS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_id_count
FROM order_items;

-- 2) Check for duplicate order-item records
SELECT
    order_id,
    product_id,
    inventory_item_id,
    created_at,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY
    order_id,
    product_id,
    inventory_item_id,
    created_at
HAVING COUNT(*) > 1;
