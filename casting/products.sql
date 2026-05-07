-- ============================================
-- products table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE products
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN cost TYPE DECIMAL(10,2) USING cost::DECIMAL(10,2),
  ALTER COLUMN category TYPE VARCHAR(255) USING category::VARCHAR(255),
  ALTER COLUMN name TYPE VARCHAR(255) USING name::VARCHAR(255),
  ALTER COLUMN brand TYPE VARCHAR(255) USING brand::VARCHAR(255),
  ALTER COLUMN retail_price TYPE DECIMAL(10,2) USING retail_price::DECIMAL(10,2),
  ALTER COLUMN department TYPE VARCHAR(255) USING department::VARCHAR(255),
  ALTER COLUMN sku TYPE VARCHAR(255) USING sku::VARCHAR(255),
  ALTER COLUMN distribution_center_id TYPE INTEGER USING distribution_center_id::INTEGER;

-- ============================================
-- 2) add primary key and foreign key
-- ============================================
ALTER TABLE products
  ADD CONSTRAINT pk_products PRIMARY KEY (id),
  ADD CONSTRAINT fk_products_distribution_center FOREIGN KEY (distribution_center_id)
    REFERENCES distribution_centers(id);
