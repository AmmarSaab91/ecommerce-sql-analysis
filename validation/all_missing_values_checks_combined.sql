-- ============================================================
-- DATA QUALITY ANALYSIS: DISTRIBUTION_CENTERS
-- Missing-Value Checks
-- ============================================================

-- 1) Count rows with missing or blank values in key columns
SELECT
    COUNT(*) AS rows_with_missing_values
FROM distribution_centers
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR name IS NULL
    OR TRIM(name) = ''
    OR latitude IS NULL
    OR TRIM(latitude::text) = ''
    OR longitude IS NULL
    OR TRIM(longitude::text) = '';

-- 2) Display rows that contain missing or blank values
SELECT
    *
FROM distribution_centers
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR name IS NULL
    OR TRIM(name) = ''
    OR latitude IS NULL
    OR TRIM(latitude::text) = ''
    OR longitude IS NULL
    OR TRIM(longitude::text) = '';

-- ============================================================
-- DATA QUALITY ANALYSIS: EVENTS
-- Missing-Value Checks
-- ============================================================

-- Note:
-- user_id may be NULL for anonymous sessions.
-- Keep it in this broad review if you want a full missing-value scan.

-- 1) Count rows with missing or blank values
SELECT
    COUNT(*) AS rows_with_missing_values
FROM events
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR user_id IS NULL
    OR TRIM(user_id::text) = ''
    OR sequence_number IS NULL
    OR TRIM(sequence_number::text) = ''
    OR session_id IS NULL
    OR TRIM(session_id) = ''
    OR created_at IS NULL
    OR TRIM(created_at::text) = ''
    OR ip_address IS NULL
    OR TRIM(ip_address) = ''
    OR city IS NULL
    OR TRIM(city) = ''
    OR state IS NULL
    OR TRIM(state) = ''
    OR postal_code IS NULL
    OR TRIM(postal_code) = ''
    OR browser IS NULL
    OR TRIM(browser) = ''
    OR traffic_source IS NULL
    OR TRIM(traffic_source) = ''
    OR uri IS NULL
    OR TRIM(uri) = ''
    OR event_type IS NULL
    OR TRIM(event_type) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM events
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('user_id', user_id::text),
        ('sequence_number', sequence_number::text),
        ('session_id', session_id),
        ('created_at', created_at::text),
        ('ip_address', ip_address),
        ('city', city),
        ('state', state),
        ('postal_code', postal_code),
        ('browser', browser),
        ('traffic_source', traffic_source),
        ('uri', uri),
        ('event_type', event_type)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';

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

-- ============================================================
-- DATA QUALITY ANALYSIS: ORDER_ITEMS
-- Missing-Value Checks
-- ============================================================

-- Note:
-- shipped_at, delivered_at, and returned_at can be NULL depending on item status.

-- 1) Count rows with missing or blank values
SELECT
    COUNT(*) AS rows_with_missing_values
FROM order_items
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR order_id IS NULL
    OR TRIM(order_id::text) = ''
    OR user_id IS NULL
    OR TRIM(user_id::text) = ''
    OR product_id IS NULL
    OR TRIM(product_id::text) = ''
    OR inventory_item_id IS NULL
    OR TRIM(inventory_item_id::text) = ''
    OR status IS NULL
    OR TRIM(status) = ''
    OR created_at IS NULL
    OR TRIM(created_at::text) = ''
    OR shipped_at IS NULL
    OR TRIM(shipped_at::text) = ''
    OR delivered_at IS NULL
    OR TRIM(delivered_at::text) = ''
    OR returned_at IS NULL
    OR TRIM(returned_at::text) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM order_items
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('order_id', order_id::text),
        ('user_id', user_id::text),
        ('product_id', product_id::text),
        ('inventory_item_id', inventory_item_id::text),
        ('status', status),
        ('created_at', created_at::text),
        ('shipped_at', shipped_at::text),
        ('delivered_at', delivered_at::text),
        ('returned_at', returned_at::text)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';

-- 3) Count missing or blank values for selected lifecycle columns
SELECT COUNT(*) AS missing_delivered_at_count
FROM order_items
WHERE delivered_at IS NULL OR TRIM(delivered_at::text) = '';

SELECT COUNT(*) AS missing_shipped_at_count
FROM order_items
WHERE shipped_at IS NULL OR TRIM(shipped_at::text) = '';

SELECT COUNT(*) AS missing_returned_at_count
FROM order_items
WHERE returned_at IS NULL OR TRIM(returned_at::text) = '';

-- ============================================================
-- DATA QUALITY ANALYSIS: ORDERS
-- Missing-Value Checks
-- ============================================================

-- Note:
-- returned_at, shipped_at, and delivered_at can be NULL depending on order status.
-- Review them carefully before treating them as data-quality errors.

-- 1) Count rows with missing or blank values
SELECT
    COUNT(*) AS rows_with_missing_values
FROM orders
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR user_id IS NULL
    OR TRIM(user_id::text) = ''
    OR status IS NULL
    OR TRIM(status) = ''
    OR gender IS NULL
    OR TRIM(gender) = ''
    OR created_at IS NULL
    OR TRIM(created_at::text) = ''
    OR returned_at IS NULL
    OR TRIM(returned_at::text) = ''
    OR shipped_at IS NULL
    OR TRIM(shipped_at::text) = ''
    OR delivered_at IS NULL
    OR TRIM(delivered_at::text) = ''
    OR num_of_item IS NULL
    OR TRIM(num_of_item::text) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM orders
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('user_id', user_id::text),
        ('status', status),
        ('gender', gender),
        ('created_at', created_at::text),
        ('returned_at', returned_at::text),
        ('shipped_at', shipped_at::text),
        ('delivered_at', delivered_at::text),
        ('num_of_item', num_of_item::text)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';

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

-- ============================================================
-- DATA QUALITY ANALYSIS: USERS
-- Missing-Value Checks
-- ============================================================

-- 1) Count rows with missing or blank values
SELECT
    COUNT(*) AS rows_with_missing_values
FROM users
WHERE
    id IS NULL
    OR TRIM(id::text) = ''
    OR first_name IS NULL
    OR TRIM(first_name) = ''
    OR last_name IS NULL
    OR TRIM(last_name) = ''
    OR email IS NULL
    OR TRIM(email) = ''
    OR age IS NULL
    OR TRIM(age::text) = ''
    OR gender IS NULL
    OR TRIM(gender) = ''
    OR state IS NULL
    OR TRIM(state) = ''
    OR street_address IS NULL
    OR TRIM(street_address) = ''
    OR postal_code IS NULL
    OR TRIM(postal_code) = ''
    OR city IS NULL
    OR TRIM(city) = ''
    OR country IS NULL
    OR TRIM(country) = ''
    OR latitude IS NULL
    OR TRIM(latitude::text) = ''
    OR longitude IS NULL
    OR TRIM(longitude::text) = ''
    OR traffic_source IS NULL
    OR TRIM(traffic_source) = ''
    OR created_at IS NULL
    OR TRIM(created_at::text) = '';

-- 2) Identify columns that contain missing or blank values
SELECT DISTINCT
    v.column_name
FROM users
CROSS JOIN LATERAL (
    VALUES
        ('id', id::text),
        ('first_name', first_name),
        ('last_name', last_name),
        ('email', email),
        ('age', age::text),
        ('gender', gender),
        ('state', state),
        ('street_address', street_address),
        ('postal_code', postal_code),
        ('city', city),
        ('country', country),
        ('latitude', latitude::text),
        ('longitude', longitude::text),
        ('traffic_source', traffic_source),
        ('created_at', created_at::text)
) AS v(column_name, column_value)
WHERE
    column_value IS NULL
    OR TRIM(column_value) = '';
