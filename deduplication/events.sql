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
