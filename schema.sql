DROP TABLE IF EXISTS events CASCADE ;
DROP TABLE IF EXISTS inventory_items CASCADE ;
DROP TABLE IF EXISTS order_items CASCADE ;
DROP TABLE IF EXISTS orders CASCADE ;
DROP TABLE IF EXISTS products CASCADE ;
DROP TABLE IF EXISTS distribution_centers CASCADE ;
DROP TABLE IF EXISTS users CASCADE ;
CREATE TABLE "distribution_centers"(
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "latitude" DECIMAL(8, 6) NOT NULL,
    "longitude" DECIMAL(9, 6) NOT NULL
);
CREATE TABLE "users"(
    "id" SERIAL PRIMARY KEY,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" CHAR(1) NOT NULL,
    "state" VARCHAR(255) NOT NULL,
    "street_address" VARCHAR(255) NOT NULL,
    "postal_code" VARCHAR(255) NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "country" VARCHAR(255) NOT NULL,
    "latitude" DECIMAL(8, 6) NOT NULL,
    "longitude" DECIMAL(9, 6) NOT NULL,
    "traffic_source" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
CREATE TABLE "products"(
    "id" SERIAL PRIMARY KEY,
    "cost" DECIMAL(8, 2) NOT NULL,
    "category" VARCHAR(255) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "brand" VARCHAR(255) NOT NULL,
    "retail_price" DECIMAL(8, 2) NOT NULL,
    "department" VARCHAR(255) NOT NULL,
    "sku" VARCHAR(255) NOT NULL,
    "distribution_center_id" INTEGER REFERENCES distribution_centers(id) NOT NULL
);
CREATE TABLE "orders"(
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES users(id) NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "gender" CHAR(1) NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "returned_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "shipped_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "delivered_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "num_of_item" INTEGER NOT NULL
);
CREATE TABLE "events"(
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES users(id) NOT NULL,
    "sequence_number" INTEGER NOT NULL,
    "session_id" UUID,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "ip_address" VARCHAR(255) NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "state" VARCHAR(255) NOT NULL,
    "postal_code" VARCHAR(225) NOT NULL,
    "browser" VARCHAR(255) NOT NULL,
    "traffic_source" VARCHAR(255) NOT NULL,
    "uri" VARCHAR(255) NOT NULL,
    "event_type" VARCHAR(255) NOT NULL
);
CREATE TABLE "inventory_items"(
    "id" SERIAL PRIMARY KEY,
    "product_id" INTEGER REFERENCES products(id) NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "sold_at" TIME(0) WITHOUT TIME ZONE NOT NULL,
    "cost" DECIMAL(8, 2) NULL,
    "product_category" VARCHAR(255) NOT NULL,
    "product_name" VARCHAR(255) NOT NULL,
    "product_brand" VARCHAR(255) NOT NULL,
    "product_retail_price" DECIMAL(8, 2) NOT NULL,
    "product_department" VARCHAR(255) NOT NULL,
    "product_sku" VARCHAR(255) NOT NULL,
    "product_distribution_center_id" INTEGER  REFERENCES distribution_centers(id) NOT NULL
);
CREATE TABLE "order_items"(
    "id" SERIAL PRIMARY KEY,
    "order_id" INTEGER REFERENCES orders(id) NOT NULL,
    "user_id" INTEGER REFERENCES users(id) NOT NULL,
    "product_id" INTEGER REFERENCES products(id) NOT NULL,
    "inventory_item_id" INTEGER REFERENCES inventory_items(id) NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "shipped_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "delivered_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "returned_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "sale_price" INTERGER NOT NULL
);
