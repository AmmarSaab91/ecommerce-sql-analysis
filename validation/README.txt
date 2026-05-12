==================================
DATA QUALITY MISSING-VALUES README
==================================

Files covered
-------------
1. distribution_centers.sql
2. events.sql
3. inventory_items.sql
4. order_items.sql
5. orders.sql
6. products.sql
7. users.sql

Overview
--------
These SQL files are simple data-quality checks focused on missing or blank values
across the core ecommerce tables.

------------
What they do
------------
- count rows that contain missing or blank values
- identify which columns contain missing or blank values
- in some files, provide simple fill/drop options for selected text fields

---------------
Important notes
---------------
- Some NULL values are business-valid, not data errors.
  Examples:
  - events.user_id can be NULL for anonymous visitors
  - inventory_items.sold_at can be NULL if the item is not sold yet
  - orders/order_items returned_at, shipped_at, and delivered_at can be NULL
    depending on order status

- products.sql and inventory_items.sql include basic cleanup examples
  for missing product names and brands. Review them before running deletes.

----------
How to use
----------
Run these files before deeper analysis such as revenue reporting, customer
segmentation, funnel analysis, or operational KPI tracking.

If the counts return 0 and the column-list queries return no rows, the table
likely has no missing-value issue in the reviewed fields.

-------
Summary
-------
This SQL set performs simple missing-value checks across the main ecommerce
tables so the dataset can be reviewed and cleaned before business analysis.
