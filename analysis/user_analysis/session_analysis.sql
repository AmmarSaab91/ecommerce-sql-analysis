-- ==========================================================
-- Session Analysis
-- Notes:
-- - Session duration is measured in minutes.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Top 10 longest sessions by user and session
-- ----------------------------------------------------------
SELECT
    user_id,
    session_id,
    EXTRACT(EPOCH FROM (MAX(created_at) - MIN(created_at))) / 60.0 AS session_duration_minute
FROM events
WHERE user_id IS NOT NULL
GROUP BY user_id, session_id
ORDER BY session_duration_minute DESC
LIMIT 10;

-- ----------------------------------------------------------
-- 2) Longest and shortest identified sessions
-- ----------------------------------------------------------
WITH session_duration AS (
    SELECT
        session_id,
        user_id,
        EXTRACT(EPOCH FROM (MAX(created_at) - MIN(created_at))) / 60.0 AS session_dur_min
    FROM events
    WHERE user_id IS NOT NULL
    GROUP BY session_id, user_id
),
longest AS (
    SELECT
        MAX(session_dur_min) AS max_dur
    FROM session_duration
),
shortest AS (
    SELECT
        MIN(session_dur_min) AS min_dur
    FROM session_duration
)
SELECT
    s.user_id,
    s.session_id,
    l.max_dur AS session_dur_min
FROM session_duration AS s
CROSS JOIN longest AS l
WHERE s.session_dur_min = l.max_dur

UNION ALL

SELECT
    s.user_id,
    s.session_id,
    sh.min_dur AS session_dur_min
FROM session_duration AS s
CROSS JOIN shortest AS sh
WHERE s.session_dur_min = sh.min_dur;

-- ----------------------------------------------------------
-- 3) Average session duration across all sessions
-- ----------------------------------------------------------
WITH sessions AS (
    SELECT
        session_id,
        EXTRACT(EPOCH FROM (MAX(created_at) - MIN(created_at))) / 60.0 AS session_dur_min
    FROM events
    GROUP BY session_id
)
SELECT
    AVG(session_dur_min) AS average_session_min
FROM sessions;

-- ----------------------------------------------------------
-- 4) Events-per-session distribution
-- ----------------------------------------------------------
WITH per_session AS (
    SELECT
        session_id,
        COUNT(*) AS events_per_session
    FROM events
    GROUP BY session_id
),
session_count AS (
    SELECT
        events_per_session,
        COUNT(*) AS session_count
    FROM per_session
    GROUP BY events_per_session
)
SELECT
    events_per_session,
    session_count,
    ROUND(session_count * 100.0 / SUM(session_count) OVER (), 2)::TEXT || '%' AS percentage
FROM session_count
ORDER BY session_count DESC;
