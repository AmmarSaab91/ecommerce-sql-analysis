-- ============================================
-- inventory_items table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE inventory_items
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN product_id TYPE INTEGER USING product_id::INTEGER,
  ALTER COLUMN created_at TYPE TIMESTAMP(0) WITH TIME ZONE USING created_at::TIMESTAMP(0),
  ALTER COLUMN sold_at TYPE TIMESTAMP(0) WITH TIME ZONE USING sold_at::TIMESTAMP(0),
  ALTER COLUMN cost TYPE DECIMAL(10,2) USING cost::DECIMAL(10,2),
  ALTER COLUMN product_category TYPE VARCHAR(255) USING product_category::VARCHAR(255),
  ALTER COLUMN product_name TYPE VARCHAR(255) USING product_name::VARCHAR(255),
  ALTER COLUMN product_brand TYPE VARCHAR(255) USING product_brand::VARCHAR(255),
  ALTER COLUMN product_retail_price TYPE DECIMAL(10,2) USING product_retail_price::DECIMAL(10,2),
  ALTER COLUMN product_department TYPE VARCHAR(255) USING product_department::VARCHAR(255),
  ALTER COLUMN product_sku TYPE VARCHAR(255) USING product_sku::VARCHAR(255),
  ALTER COLUMN product_distribution_center_id TYPE INTEGER USING product_distribution_center_id::INTEGER;

-- ============================================
-- 2) add primary key and foreign keys
-- ============================================
ALTER TABLE inventory_items
  ADD CONSTRAINT pk_inventory_items PRIMARY KEY (id),
  ADD CONSTRAINT fk_inventory_items_product FOREIGN KEY (product_id)
    REFERENCES products(id),
  ADD CONSTRAINT fk_inventory_items_distribution_center FOREIGN KEY (product_distribution_center_id)
    REFERENCES distribution_centers(id);
