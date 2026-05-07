-- ==========================================================
-- Processing Time Analysis
-- Notes:
-- - Durations are measured in days.
-- ==========================================================

-- ----------------------------------------------------------
-- 1) Order creation to shipment time
-- ----------------------------------------------------------
SELECT
    id,
    created_at::DATE AS created_date,
    shipped_at::DATE AS shipped_date,
    shipped_at::DATE - created_at::DATE AS order_creation_to_shipment_days
FROM orders
WHERE shipped_at IS NOT NULL
ORDER BY order_creation_to_shipment_days DESC
LIMIT 10;

-- ----------------------------------------------------------
-- 2) Shipment to delivery time
-- ----------------------------------------------------------
SELECT
    id,
    shipped_at::DATE AS shipped_date,
    delivered_at::DATE AS delivered_date,
    delivered_at::DATE - shipped_at::DATE AS shipment_to_delivery_days
FROM orders
WHERE shipped_at IS NOT NULL
  AND delivered_at IS NOT NULL
ORDER BY shipment_to_delivery_days DESC
LIMIT 10;

-- ----------------------------------------------------------
-- 3) Total fulfillment cycle time
-- ----------------------------------------------------------
SELECT
    id,
    created_at::DATE AS created_date,
    delivered_at::DATE AS delivered_date,
    delivered_at::DATE - created_at::DATE AS total_fulfillment_cycle_days
FROM orders
WHERE delivered_at IS NOT NULL
ORDER BY total_fulfillment_cycle_days DESC
LIMIT 10;
