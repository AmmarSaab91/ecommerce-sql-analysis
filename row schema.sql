DROP  TABLE IF EXISTS distribution_centers CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS inventory_items CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE "distribution_centers"(
    "id" TEXT,
    "name" TEXT,
    "latitude" TEXT,
    "longitude" TEXT
);
CREATE TABLE "users"(
    "id" TEXT,
    "first_name" TEXT,
    "last_name" TEXT,
    "email" TEXT,
    "age" TEXT,
    "gender" TEXT,
    "state" TEXT,
    "street_address" TEXT,
    "postal_code" TEXT,
    "city" TEXT,
    "country" TEXT,
    "latitude" TEXT,
    "longitude" TEXT,
    "traffic_source" TEXT,
    "created_at" TEXT
);
CREATE TABLE "products"(
    "id" TEXT,
    "cost" TEXT,
    "category" TEXT,
    "name" TEXT,
    "brand" TEXT,
    "retail_price" TEXT,
    "department" TEXT,
    "sku" TEXT,
    "distribution_center_id" TEXT
);
CREATE TABLE "orders"(
    "id" TEXT,
    "user_id" TEXT,
    "status" TEXT,
    "gender" TEXT,
    "created_at" TEXT,
    "returned_at" TEXT,
    "shipped_at" TEXT,
    "delivered_at" TEXT,
    "num_of_item" TEXT
);
CREATE TABLE "events"(
    "id" TEXT,
    "user_id" TEXT,
    "sequence_number" TEXT,
    "session_id" TEXT,
    "created_at" TEXT,
    "ip_address" TEXT,
    "city" TEXT,
    "state" TEXT,
    "postal_code" TEXT,
    "browser" TEXT,
    "traffic_source" TEXT,
    "uri" TEXT,
    "event_type" TEXT
);
CREATE TABLE "inventory_items"(
    "id" TEXT,
    "product_id" TEXT,
    "created_at" TEXT,
    "sold_at" TEXT,
    "cost" TEXT,
    "product_category" TEXT,
    "product_name" TEXT,
    "product_brand" TEXT,
    "product_retail_price" TEXT,
    "product_department" TEXT,
    "product_sku" TEXT,
    "product_distribution_center_id" TEXT
);
CREATE TABLE "order_items"(
    "id" TEXT,
    "order_id" TEXT,
    "user_id" TEXT,
    "product_id" TEXT,
    "inventory_item_id" TEXT,
    "status" TEXT,
    "created_at" TEXT,
    "shipped_at" TEXT,
    "delivered_at" TEXT,
    "returned_at" TEXT,
    "sale_price" TEXT
);
