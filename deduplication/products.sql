-- ============================================================
-- DATA QUALITY ANALYSIS: PRODUCTS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM products;

-- 2) Check for duplicate SKU values
SELECT
    COUNT(sku) - COUNT(DISTINCT sku) AS duplicate_sku_count
FROM products;

-- 3) Check for duplicate product records
SELECT
    name,
    brand,
    cost,
    category,
    retail_price,
    department,
    sku,
    distribution_center_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY
    name,
    brand,
    cost,
    category,
    retail_price,
    department,
    sku,
    distribution_center_id
HAVING COUNT(*) > 1;
