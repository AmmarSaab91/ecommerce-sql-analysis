-- ============================================
-- orders table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE orders
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN user_id TYPE INTEGER USING user_id::INTEGER,
  ALTER COLUMN status TYPE VARCHAR(255) USING status::VARCHAR(255),
  ALTER COLUMN gender TYPE VARCHAR(255) USING gender::VARCHAR(255),
  ALTER COLUMN created_at TYPE TIMESTAMP(0) WITH TIME ZONE USING created_at::TIMESTAMP(0),
  ALTER COLUMN returned_at TYPE TIMESTAMP(0) WITH TIME ZONE USING returned_at::TIMESTAMP(0),
  ALTER COLUMN shipped_at TYPE TIMESTAMP(0) WITH TIME ZONE USING shipped_at::TIMESTAMP(0),
  ALTER COLUMN delivered_at TYPE TIMESTAMP(0) WITH TIME ZONE USING delivered_at::TIMESTAMP(0),
  ALTER COLUMN num_of_item TYPE INTEGER USING num_of_item::INTEGER;

-- ============================================
-- 2) add primary key and foreign key
-- ============================================
ALTER TABLE orders
  ADD CONSTRAINT pk_orders PRIMARY KEY (id),
  ADD CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
    REFERENCES users(id);
