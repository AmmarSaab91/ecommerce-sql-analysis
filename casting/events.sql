-- ============================================
-- events table setup
-- ============================================

-- ============================================
-- 1) cast columns to appropriate data types
-- ============================================
ALTER TABLE events
  ALTER COLUMN id TYPE INTEGER USING id::INTEGER,
  ALTER COLUMN user_id TYPE INTEGER USING NULLIF(TRIM(user_id::TEXT), '')::INTEGER,
  ALTER COLUMN sequence_number TYPE INTEGER USING sequence_number::INTEGER,
  ALTER COLUMN session_id TYPE UUID USING session_id::UUID,
  ALTER COLUMN created_at TYPE TIMESTAMP(0) WITH TIME ZONE USING created_at::TIMESTAMP(0),
  ALTER COLUMN ip_address TYPE INET USING ip_address::INET,
  ALTER COLUMN city TYPE VARCHAR(255) USING city::VARCHAR(255),
  ALTER COLUMN state TYPE VARCHAR(255) USING state::VARCHAR(255),
  ALTER COLUMN postal_code TYPE VARCHAR(255) USING postal_code::VARCHAR(255),
  ALTER COLUMN browser TYPE VARCHAR(255) USING browser::VARCHAR(255),
  ALTER COLUMN traffic_source TYPE VARCHAR(255) USING traffic_source::VARCHAR(255),
  ALTER COLUMN uri TYPE VARCHAR(255) USING uri::VARCHAR(255),
  ALTER COLUMN event_type TYPE VARCHAR(255) USING event_type::VARCHAR(255);

-- ============================================
-- 2) add primary key and foreign key
-- ============================================
ALTER TABLE events
  ADD CONSTRAINT pk_events PRIMARY KEY (id),
  ADD CONSTRAINT fk_events_user FOREIGN KEY (user_id)
    REFERENCES users(id);
