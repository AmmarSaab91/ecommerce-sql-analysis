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
