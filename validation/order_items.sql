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
