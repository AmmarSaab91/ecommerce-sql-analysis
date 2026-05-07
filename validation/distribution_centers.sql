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
