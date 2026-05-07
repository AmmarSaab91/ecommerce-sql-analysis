-- ============================================
-- users table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE users
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN first_name TYPE VARCHAR(255) USING first_name::VARCHAR(255),
  ALTER COLUMN last_name TYPE VARCHAR(255) USING last_name::VARCHAR(255),
  ALTER COLUMN email TYPE VARCHAR(255) USING email::VARCHAR(255),
  ALTER COLUMN age TYPE INTEGER USING age::INTEGER,
  ALTER COLUMN gender TYPE VARCHAR(255) USING gender::VARCHAR(255),
  ALTER COLUMN state TYPE VARCHAR(255) USING state::VARCHAR(255),
  ALTER COLUMN street_address TYPE VARCHAR(255) USING street_address::VARCHAR(255),
  ALTER COLUMN postal_code TYPE VARCHAR(255) USING postal_code::VARCHAR(255),
  ALTER COLUMN city TYPE VARCHAR(255) USING city::VARCHAR(255),
  ALTER COLUMN country TYPE VARCHAR(255) USING country::VARCHAR(255),
  ALTER COLUMN latitude TYPE DECIMAL(8,6) USING latitude::DECIMAL(8,6),
  ALTER COLUMN longitude TYPE DECIMAL(9,6) USING longitude::DECIMAL(9,6),
  ALTER COLUMN traffic_source TYPE VARCHAR(255) USING traffic_source::VARCHAR(255),
  ALTER COLUMN created_at TYPE TIMESTAMP(0) WITH TIME ZONE USING created_at::TIMESTAMP(0);

-- ============================================
-- 2) add primary key
-- ============================================
ALTER TABLE users
  ADD CONSTRAINT pk_users PRIMARY KEY (id);
