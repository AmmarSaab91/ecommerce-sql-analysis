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
