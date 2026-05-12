===================
SCHEMA SETUP README
===================

Files covered
-------------
1. distribution_centers.sql
2. users.sql
3. products.sql
4. orders.sql
5. events.sql
6. inventory_items.sql
7. order_items.sql

Overview
--------
These files prepare the raw imported tables for analysis.

They do two things:
1. Convert each column to the correct PostgreSQL data type.
2. Add primary keys and foreign keys so the tables are linked correctly.

----------------------
Why these files matter
----------------------

Without this setup step, analysis queries can become unreliable because:
- numbers may still be stored as text
- dates may not behave like timestamps
- joins may fail or be harder to validate
- relationships between tables may not be enforced

-------------------
What each file does
-------------------
distribution_centers.sql
Sets the correct data types for distribution center fields and adds the primary key.

users.sql
Prepares customer fields such as age, location, traffic source, and signup date, then adds the primary key.

products.sql
Prepares product attributes such as cost, category, price, and distribution center, then adds the primary key and the foreign key to distribution_centers.

orders.sql
Prepares order-level fields such as status and timestamps, then links each order to a user.

events.sql
Prepares website-event data such as session_id, browser, URI, event type, and event timestamp, then links events to users when user_id exists.

inventory_items.sql
Prepares inventory-level product records and links them to products and distribution centers.

order_items.sql
Prepares item-level order records and links them to orders, users, products, and inventory items.

-------------------------
Suggested execution order
-------------------------
Run the files in this order to avoid foreign-key dependency problems:

1. distribution_centers.sql
2. users.sql
3. products.sql
4. orders.sql
5. events.sql
6. inventory_items.sql
7. order_items.sql

------------
Project role
------------
This group should be treated as the data-preparation layer of the project.
All later analysis files depend on these tables having the correct data types and key relationships.
