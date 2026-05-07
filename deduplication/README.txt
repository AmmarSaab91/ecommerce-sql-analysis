DATA QUALITY DUPLICATE CHECKS README
===================================

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
These SQL files are simple data-quality checks focused on duplicate detection.

Their purpose is to help verify whether the main tables contain:
- duplicate primary-key values
- duplicate business records
- repeated rows that may distort analysis results

Why these checks matter
-----------------------
Before building KPIs, segmentation, funnel analysis, or profitability analysis, it is important to confirm that the source tables are clean.

Duplicate rows can:
- inflate counts
- overstate revenue
- distort customer behavior metrics
- break joins and consistency checks

What each file does
-------------------
1. distribution_centers.sql
   Checks for duplicate distribution-center IDs and duplicate center records based on name and coordinates.

2. events.sql
   Checks for duplicate event IDs and repeated session sequence positions inside the same session.

3. inventory_items.sql
   Checks for duplicate inventory-item IDs and repeated inventory records based on product, SKU, creation time, and cost.

4. order_items.sql
   Checks for duplicate order-item IDs and repeated order-item records.

5. orders.sql
   Performs the most complete duplicate analysis:
   - duplicate order IDs
   - duplicate business records
   - total extra duplicate rows
   - full duplicate-row listing
   - two optional deduplication approaches

6. products.sql
   Checks for duplicate product IDs, duplicate SKUs, and repeated product records.

7. users.sql
   Checks for duplicate user IDs and repeated customer records across the main profile fields.

How to use these files
----------------------
Run these checks before starting business analysis.

If all duplicate counts return 0 and the grouped duplicate queries return no rows, the table is likely clean for duplicate-related issues.

If duplicates appear:
- inspect the grouped duplicate query first
- decide whether duplicates are valid or true data problems
- use the deletion logic carefully and only after backup/review

Important note
--------------
The delete statements in orders.sql are examples for deduplication.
They should be reviewed carefully before running on a production or final project database.

Suggested project framing
-------------------------
You can describe this set as:

"Initial data-quality validation focused on duplicate detection across the core ecommerce tables."

Summary sentence
----------------
This SQL set performs duplicate checks across the main ecommerce tables to validate data quality before deeper analysis such as customer segmentation, funnel tracking, revenue analysis, and operational reporting.
