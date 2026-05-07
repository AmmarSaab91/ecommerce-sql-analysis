-- ============================================================
-- DATA QUALITY ANALYSIS: INVENTORY_ITEMS
-- Missing-Value Checks and Basic Cleaning Options
-- ============================================================

-- Note:
-- sold_at may be NULL when an item has not been sold yet.
-- This file separates broad missing-value review from simple fill/drop options
-- for product_name and product_brand.

-- 1) Count rows with missing or blank values across the reviewed columns
SELECT
    COUNT(*) AS rows_with_missing_values
FROM inventory_items
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR product_id IS NULL
    OR TRIM(product_id::text) = ''
    OR created_at IS NULL
    OR TRIM(created_at::text) = ''
    OR sold_at IS NULL
    OR TRIM(sold_at::text) = ''
    OR cost IS NULL
    OR TRIM(cost::text) = ''
    OR product_category IS NULL
    OR TRIM(product_category) = ''
    OR product_name IS NULL
    OR TRIM(product_name) = ''
    OR product_brand IS NULL
    OR TRIM(product_brand) = ''
    OR product_retail_price IS NULL
    OR TRIM(product_retail_price::text) = ''
    OR product_department IS NULL
    OR TRIM(product_department) = ''
    OR product_sku IS NULL
    OR TRIM(product_sku) = ''
    OR product_distribution_center_id IS NULL
    OR TRIM(product_distribution_center_id::text) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM inventory_items
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('product_id', product_id::text),
        ('created_at', created_at::text),
        ('sold_at', sold_at::text),
        ('cost', cost::text),
        ('product_category', product_category),
        ('product_name', product_name),
        ('product_brand', product_brand),
        ('product_retail_price', product_retail_price::text),
        ('product_department', product_department),
        ('product_sku', product_sku),
        ('product_distribution_center_id', product_distribution_center_id::text)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';

-- 3) Count missing or blank values for selected columns
SELECT COUNT(*) AS missing_product_name_count
FROM inventory_items
WHERE product_name IS NULL OR TRIM(product_name) = '';

SELECT COUNT(*) AS missing_sold_at_count
FROM inventory_items
WHERE sold_at IS NULL OR TRIM(sold_at::text) = '';

SELECT COUNT(*) AS missing_product_brand_count
FROM inventory_items
WHERE product_brand IS NULL OR TRIM(product_brand) = '';

-- 4) Fill missing product_name values using the same SKU
UPDATE inventory_items AS i
SET product_name = v.product_name
FROM (
    SELECT DISTINCT ON (product_sku)
        product_sku,
        product_name
    FROM inventory_items
    WHERE
        product_name IS NOT NULL
        AND TRIM(product_name) <> ''
    ORDER BY product_sku, product_name
) AS v
WHERE
    i.product_sku = v.product_sku
    AND (i.product_name IS NULL OR TRIM(i.product_name) = '');

-- 5) Remove rows that still have missing product_name values
DELETE FROM inventory_items
WHERE product_name IS NULL OR TRIM(product_name) = '';

-- 6) Fill missing product_brand values using the same product_name
UPDATE inventory_items AS i
SET product_brand = v.product_brand
FROM (
    SELECT DISTINCT ON (product_name)
        product_name,
        product_brand
    FROM inventory_items
    WHERE
        product_brand IS NOT NULL
        AND TRIM(product_brand) <> ''
    ORDER BY product_name, product_brand
) AS v
WHERE
    i.product_name = v.product_name
    AND (i.product_brand IS NULL OR TRIM(i.product_brand) = '');

-- 7) Remove rows that still have missing product_brand values
DELETE FROM inventory_items
WHERE product_brand IS NULL OR TRIM(product_brand) = '';

-- 8) Business note for sold_at
-- A NULL sold_at value can simply mean the product has not been sold yet.
