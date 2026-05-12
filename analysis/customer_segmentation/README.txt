=====================
CUSTOMER SEGMENTATION
=====================

Overview
--------
This README explains the customer segmentation queries included in this project:

1. recency.sql
2. frequency_analysis.sql
3. monetary_segmentation.sql
4. basic_rfm_classification.sql

Together, these files analyze customer behavior from three classic segmentation dimensions:
- Recency: How recently a customer purchased
- Frequency: How often a customer purchased
- Monetary: How much value a customer generated

The final file, basic_rfm_classification.sql, combines those three dimensions into simple business-facing customer groups.

-------------------
1) RECENCY ANALYSIS
-------------------
File: recency.sql

Purpose:
Measures how recently each customer placed an order relative to the latest order date in the dataset.

How the query works:
- It finds the latest order date in the orders table.
- It finds each customer's last order date.
- It subtracts the customer's last order date from the dataset's latest order date.
- The result is recency_days.

Sections in the file:
- Most recent customers:
  Returns the 10 customers with the smallest recency value.
  These are the customers who ordered closest to the end of the dataset.

- Inactive customer detection:
  Returns the 10 customers with the largest recency value.
  These are the customers whose last recorded order happened furthest from the end of the dataset.

How to interpret it:
- Small recency_days = recent customer
- Large recency_days = historically inactive customer

Important note:
This file calculates recency from all orders in the orders table, not only completed or shipped orders.
So its logic is broader than the RFM query, which filters to completed/shipped activity.

---------------------
2) FREQUENCY ANALYSIS
---------------------
File: frequency_analysis.sql

Purpose:
Measures how often customers purchased, using completed and shipped orders only.

How the query works:
- It groups orders by user_id.
- It counts how many completed/shipped orders each customer has.

Sections in the file:
- One-time vs. repeat customers:
  Classifies customers into two groups:
  * one_time_customer
  * repeat_customer

- Purchase frequency distribution:
  Shows how many customers made 1 purchase, 2 purchases, 3 purchases, and so on.

How to interpret it:
- Higher purchase_count = stronger repeat behavior
- A large one-time customer share may indicate weak retention
- A healthy repeat share can suggest loyalty or product-market fit

Important note:
This file uses completed and shipped orders only.
That makes the frequency metric closer to realized customer buying behavior.

------------------------
3) MONETARY SEGMENTATION
------------------------
File: monetary_segmentation.sql

Purpose:
Measures customer value by revenue and profit, and checks whether value is concentrated in a small group of customers or categories.

How the query works:
- It joins order_items with inventory_items.
- It filters to completed and shipped order items.
- It calculates:
  * customer_revenue = sum of product_retail_price
  * customer_profit = sum of product_retail_price - cost

Sections in the file:
- Highest-value customers:
  Identifies:
  * the customer with the highest revenue
  * the customer with the highest profit

- Lowest-value customers:
  Identifies:
  * the customer with the lowest revenue
  * the customer with the lowest profit

- Revenue concentration based on top customers:
  Measures how much of total revenue comes from the top 10 customers.

- Revenue concentration based on top product categories:
  Measures how much of total revenue comes from the top 5 product categories.

How to interpret it:
- High revenue customer = strong sales contribution
- High profit customer = strong margin contribution
- High concentration = business depends heavily on a small group of customers or categories

Important note:
Revenue and profit are calculated at the order-item level, then aggregated to the customer or category level.

---------------------------
4) BASIC RFM CLASSIFICATION
---------------------------
File: basic_rfm_classification.sql

Purpose:
Combines recency, frequency, and monetary metrics into a simple customer segmentation model.

How the query works:
- Reference date:
  Uses the latest completed/shipped order date in the dataset.

- Recency:
  For each customer, calculates the number of days between the reference date and the customer's latest completed/shipped order.

- Frequency:
  Counts the number of completed/shipped orders per customer.

- Monetary:
  Sums customer revenue from completed/shipped order items.

The file has two parts:

Part 1: Combine raw RFM metrics
- Returns one row per customer with:
  * user_id
  * recency_days
  * frequency
  * monetary

Part 2: Define behavioral customer groups
- Builds an rfm table from the three metrics.
- Builds a benchmark table using:
  * average frequency
  * average monetary value
  * 95th percentile monetary threshold
- Applies business rules to assign a customer_group.

Customer groups in the query:
- Best Customers
  recency_days <= 30
  AND frequency >= average frequency
  AND monetary >= average monetary

- New Customers
  recency_days <= 30
  AND frequency = 1

- At Risk
  recency_days > 90
  AND frequency >= average frequency

- Big Spenders
  monetary >= 95th percentile threshold

- Regular Customers
  everyone else

How to interpret it:
- Best Customers = recent, frequent, high-value customers
- New Customers = recently acquired customers with only one purchase so far
- At Risk = previously active customers who have not purchased recently
- Big Spenders = very high-value customers, even if they do not meet other rules first
- Regular Customers = customers outside the main priority groups

Important note about rule order:
Because the segmentation uses CASE logic, the first matching rule wins.
That means some high-value customers may be labeled as Best Customers or At Risk before they reach the Big Spenders label.

-------------------------------
HOW THE FOUR FILES FIT TOGETHER
-------------------------------
Recommended reading order:
1. recency.sql
2. frequency_analysis.sql
3. monetary_segmentation.sql
4. basic_rfm_classification.sql

Why this order works:
- Recency explains freshness/inactivity
- Frequency explains repeat behavior
- Monetary explains customer value
- RFM combines the three into business segments

---------------------------------------
BUSINESS QUESTIONS THESE QUERIES ANSWER
---------------------------------------
- Who bought most recently?
- Which customers appear historically inactive?
- Are customers mostly one-time or repeat buyers?
- How many purchases do customers usually make?
- Which customers generate the most revenue or profit?
- Is revenue concentrated in a small number of customers or product categories?
- Which customers should be treated as best, new, at risk, or high-value?

-------------------------
FINAL INTERPRETATION NOTE
-------------------------
These queries produce historical segmentation based on the data available in the dataset.
They do not prove whether a customer is active today in real life.
Instead, they describe behavior relative to the observation window stored in the database.

