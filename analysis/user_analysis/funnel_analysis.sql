-- ==========================================================
-- Funnel Analysis
-- ==========================================================

-- ----------------------------------------------------------
-- 0) Event types present
-- ----------------------------------------------------------
SELECT DISTINCT event_type
FROM events
ORDER BY event_type;


-- ----------------------------------------------------------
-- 1) How common is each event_type (sessions_with_event)
--    Useful to choose a realistic funnel entry stage.
-- ----------------------------------------------------------
WITH totals AS (
  SELECT COUNT(DISTINCT session_id) AS total_sessions
  FROM events
)
SELECT
  e.event_type,
  COUNT(DISTINCT e.session_id) AS sessions_with_event,
  TO_CHAR(
    ROUND(100.0 * COUNT(DISTINCT e.session_id) / t.total_sessions, 2),
    'FM999990.00'
  ) || '%' AS pct_of_all_sessions
FROM events e
CROSS JOIN totals t
GROUP BY e.event_type, t.total_sessions
ORDER BY sessions_with_event DESC;


-- ----------------------------------------------------------
-- 2) Does 'cart' behave like a true funnel step?
--    Metric: % of cart sessions where product < cart < purchase
-- ----------------------------------------------------------

-- 2A) All sessions
WITH session_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')  AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')     AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase') AS purchase_pos
  FROM events
  GROUP BY session_id
),
cart_sessions AS (
  SELECT *
  FROM session_pos
  WHERE cart_pos IS NOT NULL
)
SELECT
  COUNT(*) AS cart_sessions,
  COUNT(*) FILTER (
    WHERE product_pos IS NOT NULL
      AND purchase_pos IS NOT NULL
      AND product_pos < cart_pos
      AND cart_pos < purchase_pos
  ) AS cart_sessions_in_order,
  TO_CHAR(
    ROUND(
      100.0 * COUNT(*) FILTER (
        WHERE product_pos IS NOT NULL
          AND purchase_pos IS NOT NULL
          AND product_pos < cart_pos
          AND cart_pos < purchase_pos
      ) / NULLIF(COUNT(*), 0),
      2
    ),
    'FM999990.00'
  ) || '%' AS pct_cart_in_order
FROM cart_sessions;


-- 2B) Identified sessions only (user_id IS NOT NULL)
--     WARNING: This subset can be biased toward purchase journeys.
WITH session_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')  AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')     AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase') AS purchase_pos
  FROM events
  WHERE user_id IS NOT NULL
  GROUP BY session_id
),
cart_sessions AS (
  SELECT *
  FROM session_pos
  WHERE cart_pos IS NOT NULL
)
SELECT
  COUNT(*) AS cart_sessions,
  COUNT(*) FILTER (
    WHERE product_pos IS NOT NULL
      AND purchase_pos IS NOT NULL
      AND product_pos < cart_pos
      AND cart_pos < purchase_pos
  ) AS cart_sessions_in_order,
  TO_CHAR(
    ROUND(
      100.0 * COUNT(*) FILTER (
        WHERE product_pos IS NOT NULL
          AND purchase_pos IS NOT NULL
          AND product_pos < cart_pos
          AND cart_pos < purchase_pos
      ) / NULLIF(COUNT(*), 0),
      2
    ),
    'FM999990.00'
  ) || '%' AS pct_cart_in_order
FROM cart_sessions;


-- ----------------------------------------------------------
-- 3) Stage-to-stage conversion (order-based)
--    Recommended funnels in this dataset:
--      A) product -> cart -> purchase  (broad, covers all sessions)
--      B) department -> product -> cart -> purchase (higher-intent segment)
-- ----------------------------------------------------------

-- 3A) product -> cart -> purchase
WITH stage_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')  AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')     AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase') AS purchase_pos
  FROM events
  GROUP BY session_id
),
flags AS (
  SELECT
    session_id,
    (product_pos IS NOT NULL) AS reached_product,
    (product_pos IS NOT NULL AND cart_pos IS NOT NULL AND product_pos < cart_pos) AS reached_cart,
    (product_pos IS NOT NULL AND cart_pos IS NOT NULL AND purchase_pos IS NOT NULL
      AND product_pos < cart_pos AND cart_pos < purchase_pos) AS reached_purchase
  FROM stage_pos
),
counts AS (
  SELECT
    COUNT(*) FILTER (WHERE reached_product)  AS product_sessions,
    COUNT(*) FILTER (WHERE reached_cart)     AS cart_sessions,
    COUNT(*) FILTER (WHERE reached_purchase) AS purchase_sessions
  FROM flags
)
SELECT
  product_sessions,
  cart_sessions,
  purchase_sessions,
  TO_CHAR(ROUND(100.0 * cart_sessions     / NULLIF(product_sessions, 0), 2), 'FM999990.00') || '%' AS product_to_cart,
  TO_CHAR(ROUND(100.0 * purchase_sessions / NULLIF(cart_sessions, 0), 2),    'FM999990.00') || '%' AS cart_to_purchase,
  TO_CHAR(ROUND(100.0 * purchase_sessions / NULLIF(product_sessions, 0), 2), 'FM999990.00') || '%' AS product_to_purchase
FROM counts;


-- 3B) department -> product -> cart -> purchase
WITH stage_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'department') AS department_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')    AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')       AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase')   AS purchase_pos
  FROM events
  GROUP BY session_id
),
flags AS (
  SELECT
    session_id,
    (department_pos IS NOT NULL) AS reached_department,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND department_pos < product_pos) AS reached_product,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND cart_pos IS NOT NULL
      AND department_pos < product_pos AND product_pos < cart_pos) AS reached_cart,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND cart_pos IS NOT NULL AND purchase_pos IS NOT NULL
      AND department_pos < product_pos AND product_pos < cart_pos AND cart_pos < purchase_pos) AS reached_purchase
  FROM stage_pos
),
counts AS (
  SELECT
    COUNT(*) FILTER (WHERE reached_department) AS department_sessions,
    COUNT(*) FILTER (WHERE reached_product)    AS product_sessions,
    COUNT(*) FILTER (WHERE reached_cart)       AS cart_sessions,
    COUNT(*) FILTER (WHERE reached_purchase)   AS purchase_sessions
  FROM flags
)
SELECT
  department_sessions,
  product_sessions,
  cart_sessions,
  purchase_sessions,
  TO_CHAR(ROUND(100.0 * product_sessions  / NULLIF(department_sessions, 0), 2), 'FM999990.00') || '%' AS department_to_product,
  TO_CHAR(ROUND(100.0 * cart_sessions     / NULLIF(product_sessions, 0), 2),    'FM999990.00') || '%' AS product_to_cart,
  TO_CHAR(ROUND(100.0 * purchase_sessions / NULLIF(cart_sessions, 0), 2),       'FM999990.00') || '%' AS cart_to_purchase,
  TO_CHAR(ROUND(100.0 * purchase_sessions / NULLIF(department_sessions, 0), 2), 'FM999990.00') || '%' AS department_to_purchase
FROM counts;


-- ----------------------------------------------------------
-- 4) Drop-off per step (order-based)
--    Drop-off A->B = 100% - conversion(A->B)
-- ----------------------------------------------------------

-- 4A) Drop-off for product -> cart -> purchase
WITH stage_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')  AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')     AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase') AS purchase_pos
  FROM events
  GROUP BY session_id
),
flags AS (
  SELECT
    session_id,
    (product_pos IS NOT NULL) AS reached_product,
    (product_pos IS NOT NULL AND cart_pos IS NOT NULL AND product_pos < cart_pos) AS reached_cart,
    (product_pos IS NOT NULL AND cart_pos IS NOT NULL AND purchase_pos IS NOT NULL
      AND product_pos < cart_pos AND cart_pos < purchase_pos) AS reached_purchase
  FROM stage_pos
),
counts AS (
  SELECT
    COUNT(*) FILTER (WHERE reached_product)  AS product_sessions,
    COUNT(*) FILTER (WHERE reached_cart)     AS cart_sessions,
    COUNT(*) FILTER (WHERE reached_purchase) AS purchase_sessions
  FROM flags
)
SELECT
  TO_CHAR(ROUND(100.0 * (1 - (cart_sessions::numeric     / NULLIF(product_sessions, 0))), 2), 'FM999990.00') || '%' AS drop_off_product_to_cart,
  TO_CHAR(ROUND(100.0 * (1 - (purchase_sessions::numeric / NULLIF(cart_sessions, 0))), 2),    'FM999990.00') || '%' AS drop_off_cart_to_purchase,
  TO_CHAR(ROUND(100.0 * (1 - (purchase_sessions::numeric / NULLIF(product_sessions, 0))), 2), 'FM999990.00') || '%' AS drop_off_product_to_purchase
FROM counts;


-- 4B) Drop-off for department -> product -> cart -> purchase
WITH stage_pos AS (
  SELECT
    session_id,
    MIN(sequence_number) FILTER (WHERE event_type = 'department') AS department_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'product')    AS product_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'cart')       AS cart_pos,
    MIN(sequence_number) FILTER (WHERE event_type = 'purchase')   AS purchase_pos
  FROM events
  GROUP BY session_id
),
flags AS (
  SELECT
    session_id,
    (department_pos IS NOT NULL) AS reached_department,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND department_pos < product_pos) AS reached_product,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND cart_pos IS NOT NULL
      AND department_pos < product_pos AND product_pos < cart_pos) AS reached_cart,
    (department_pos IS NOT NULL AND product_pos IS NOT NULL AND cart_pos IS NOT NULL AND purchase_pos IS NOT NULL
      AND department_pos < product_pos AND product_pos < cart_pos AND cart_pos < purchase_pos) AS reached_purchase
  FROM stage_pos
),
counts AS (
  SELECT
    COUNT(*) FILTER (WHERE reached_department) AS department_sessions,
    COUNT(*) FILTER (WHERE reached_product)    AS product_sessions,
    COUNT(*) FILTER (WHERE reached_cart)       AS cart_sessions,
    COUNT(*) FILTER (WHERE reached_purchase)   AS purchase_sessions
  FROM flags
)
SELECT
  TO_CHAR(ROUND(100.0 * (1 - (product_sessions::numeric  / NULLIF(department_sessions, 0))), 2), 'FM999990.00') || '%' AS drop_off_department_to_product,
  TO_CHAR(ROUND(100.0 * (1 - (cart_sessions::numeric     / NULLIF(product_sessions, 0))), 2),    'FM999990.00') || '%' AS drop_off_product_to_cart,
  TO_CHAR(ROUND(100.0 * (1 - (purchase_sessions::numeric / NULLIF(cart_sessions, 0))), 2),       'FM999990.00') || '%' AS drop_off_cart_to_purchase,
  TO_CHAR(ROUND(100.0 * (1 - (purchase_sessions::numeric / NULLIF(department_sessions, 0))), 2), 'FM999990.00') || '%' AS drop_off_department_to_purchase
FROM counts;
