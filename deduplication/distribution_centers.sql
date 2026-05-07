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
