-- ============================================
-- order_items table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE order_items
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN order_id TYPE INTEGER USING order_id::INTEGER,
  ALTER COLUMN user_id TYPE INTEGER USING user_id::INTEGER,
  ALTER COLUMN product_id TYPE INTEGER USING product_id::INTEGER,
  ALTER COLUMN inventory_item_id TYPE INTEGER USING inventory_item_id::INTEGER,
  ALTER COLUMN status TYPE VARCHAR(255) USING status::VARCHAR(255),
  ALTER COLUMN created_at TYPE TIMESTAMP(0) WITH TIME ZONE USING created_at::TIMESTAMP(0),
  ALTER COLUMN shipped_at TYPE TIMESTAMP(0) WITH TIME ZONE USING shipped_at::TIMESTAMP(0),
  ALTER COLUMN delivered_at TYPE TIMESTAMP(0) WITH TIME ZONE USING delivered_at::TIMESTAMP(0),
  ALTER COLUMN returned_at TYPE TIMESTAMP(0) WITH TIME ZONE USING returned_at::TIMESTAMP(0),
  ALTER COLUMN sale_price TYPE DECIMAL(10,2) USING sale_price::DECIMAL(10,2);

-- ============================================
-- 2) add primary key and foreign keys
-- ============================================
ALTER TABLE order_items
  ADD CONSTRAINT pk_order_items PRIMARY KEY (id),
  ADD CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
    REFERENCES orders(id),
  ADD CONSTRAINT fk_order_items_user FOREIGN KEY (user_id)
    REFERENCES users(id),
  ADD CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
    REFERENCES products(id),
  ADD CONSTRAINT fk_order_items_inventory_item FOREIGN KEY (inventory_item_id)
    REFERENCES inventory_items(id);
