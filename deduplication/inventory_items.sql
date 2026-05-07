-- ============================================================
-- DATA QUALITY ANALYSIS: INVENTORY ITEMS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM inventory_items;

-- 2) Check for duplicate inventory records
SELECT
    product_id,
    product_sku,
    created_at,
    cost,
    COUNT(*) AS duplicate_count
FROM inventory_items
GROUP BY
    product_id,
    product_sku,
    created_at,
    cost
HAVING COUNT(*) > 1;
