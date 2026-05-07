-- ============================================================
-- DATA QUALITY ANALYSIS: PRODUCTS
-- Missing-Value Checks and Basic Cleaning Options
-- ============================================================

-- 1) Count rows with missing or blank values
SELECT
    COUNT(*) AS rows_with_missing_values
FROM products
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR cost IS NULL
    OR TRIM(cost::text) = ''
    OR category IS NULL
    OR TRIM(category) = ''
    OR name IS NULL
    OR TRIM(name) = ''
    OR brand IS NULL
    OR TRIM(brand) = ''
    OR retail_price IS NULL
    OR TRIM(retail_price::text) = ''
    OR department IS NULL
    OR TRIM(department) = ''
    OR sku IS NULL
    OR TRIM(sku) = ''
    OR distribution_center_id IS NULL
    OR TRIM(distribution_center_id::text) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM products
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('cost', cost::text),
        ('category', category),
        ('name', name),
        ('brand', brand),
        ('retail_price', retail_price::text),
        ('department', department),
        ('sku', sku),
        ('distribution_center_id', distribution_center_id::text)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';

-- 3) Count missing or blank values for selected columns
SELECT COUNT(*) AS missing_name_count
FROM products
WHERE name IS NULL OR TRIM(name) = '';

SELECT COUNT(*) AS missing_brand_count
FROM products
WHERE brand IS NULL OR TRIM(brand) = '';

-- 4) Fill missing product names using the same SKU
UPDATE products AS u
SET name = p.name
FROM products AS p
WHERE
    (u.name IS NULL OR TRIM(u.name) = '')
    AND u.sku = p.sku
    AND p.name IS NOT NULL
    AND TRIM(p.name) <> '';

-- 5) Remove rows that still have missing product names
DELETE FROM products
WHERE name IS NULL OR TRIM(name) = '';

-- 6) Fill missing brand values using the same SKU
UPDATE products AS u
SET brand = p.brand
FROM products AS p
WHERE
    (u.brand IS NULL OR TRIM(u.brand) = '')
    AND u.sku = p.sku
    AND p.brand IS NOT NULL
    AND TRIM(p.brand) <> '';

-- 7) Remove rows that still have missing brand values
DELETE FROM products
WHERE brand IS NULL OR TRIM(brand) = '';
