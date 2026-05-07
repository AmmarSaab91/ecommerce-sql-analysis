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
