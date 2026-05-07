-- ============================================
-- distribution_centers table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE distribution_centers
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN name TYPE VARCHAR(255) USING name::VARCHAR(255),
  ALTER COLUMN latitude TYPE DECIMAL(8,6) USING latitude::DECIMAL(8,6),
  ALTER COLUMN longitude TYPE DECIMAL(9,6) USING longitude::DECIMAL(9,6);

-- ============================================
-- 2) add primary key
-- ============================================
ALTER TABLE distribution_centers
  ADD CONSTRAINT pk_distribution_centers PRIMARY KEY (id);
