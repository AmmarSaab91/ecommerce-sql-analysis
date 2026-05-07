-- ============================================================
-- DATA QUALITY ANALYSIS: DISTRIBUTION CENTERS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM distribution_centers;

-- 2) Check for duplicate business records
SELECT
    name,
    latitude,
    longitude,
    COUNT(*) AS duplicate_count
FROM distribution_centers
GROUP BY
    name,
    latitude,
    longitude
HAVING COUNT(*) > 1;

-- ============================================================
-- DATA QUALITY ANALYSIS: EVENTS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM events;

-- 2) Check for duplicate session sequence records
SELECT
    session_id,
    sequence_number,
    COUNT(*) AS duplicate_count
FROM events
GROUP BY
    session_id,
    sequence_number
HAVING COUNT(*) > 1;

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

-- ============================================================
-- DATA QUALITY ANALYSIS: ORDERS
-- Duplicate Detection and Deduplication Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM orders;

-- 2) Check for duplicate business records
SELECT
    COUNT(*) AS duplicate_count,
    user_id,
    status,
    gender,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item
FROM orders
GROUP BY
    user_id,
    status,
    gender,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item
HAVING COUNT(*) > 1;

-- 3) Count the number of duplicate rows beyond the first valid row
SELECT
    SUM(cnt - 1) AS extra_duplicate_rows
FROM (
    SELECT
        COUNT(*) AS cnt
    FROM orders
    GROUP BY
        user_id,
        status,
        gender,
        created_at,
        returned_at,
        shipped_at,
        delivered_at,
        num_of_item
    HAVING COUNT(*) > 1
) AS t;

-- 4) Display all duplicate business records
SELECT
    user_id,
    status,
    gender,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item,
    cnt
FROM (
    SELECT
        user_id,
        status,
        gender,
        created_at,
        returned_at,
        shipped_at,
        delivered_at,
        num_of_item,
        COUNT(*) OVER (
            PARTITION BY
                user_id,
                status,
                gender,
                created_at,
                returned_at,
                shipped_at,
                delivered_at,
                num_of_item
        ) AS cnt
    FROM orders
) AS t
WHERE cnt > 1;

-- 5) Deduplication option using GROUP BY and MAX(id)
DELETE FROM orders
WHERE id NOT IN (
    SELECT MAX(id)
    FROM orders
    GROUP BY
        user_id,
        status,
        gender,
        created_at,
        returned_at,
        shipped_at,
        delivered_at,
        num_of_item
);

-- 6) Deduplication option using ROW_NUMBER()
DELETE FROM orders
WHERE id IN (
    SELECT id
    FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (
                PARTITION BY
                    user_id,
                    status,
                    gender,
                    created_at,
                    returned_at,
                    shipped_at,
                    delivered_at,
                    num_of_item
                ORDER BY id
            ) AS rn
        FROM orders
    ) AS t
    WHERE rn > 1
);

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

-- ============================================================
-- DATA QUALITY ANALYSIS: USERS
-- Duplicate Detection Checks
-- ============================================================

-- 1) Check for duplicate primary-key values
SELECT
    COUNT(id) - COUNT(DISTINCT id) AS duplicate_id_count
FROM users;

-- 2) Check for duplicate customer records
SELECT
    COUNT(*) AS duplicate_count,
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    latitude,
    longitude,
    traffic_source,
    created_at
FROM users
GROUP BY
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    latitude,
    longitude,
    traffic_source,
    created_at
HAVING COUNT(*) > 1;
