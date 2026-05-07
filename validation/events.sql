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
