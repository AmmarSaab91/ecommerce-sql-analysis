E-Commerce SQL Analytics Project
Overview
This project is a complete SQL analysis workflow built on an e-commerce dataset.
It covers the full process from database setup and data cleaning to business analysis and customer segmentation.
The work is organized into clear stages:
Schema setup
Data quality checks
Customer segmentation
Revenue and profitability analysis
User behavior and acquisition analysis
Operational and order-status analysis
The project is designed for PostgreSQL and focuses on turning raw transactional and behavioral data into business insights.
---
Project Objectives
The main goals of this project are:
prepare the raw dataset for analysis
validate table structure and relationships
detect and handle common data quality issues
analyze revenue, profitability, and order performance
evaluate user behavior across sessions and conversion funnels
segment customers based on recency, frequency, and monetary value
examine operational performance such as processing time, delays, and status distribution
---
Dataset Structure
The project uses seven main tables:
`distribution_centers`  
Contains warehouse or distribution center information.
`users`  
Contains customer profile and acquisition details such as country, city, and traffic source.
`products`  
Contains product-level information such as category, brand, department, retail price, and cost.
`orders`  
Contains order-level records with timestamps and order status.
`events`  
Contains user activity and behavioral events such as product views, cart actions, and purchases.
`inventory_items`  
Contains item-level inventory and sale information.
`order_items`  
Links orders, products, users, and inventory items at the line-item level.
---
Project Structure
1) Schema Setup:
These files prepare the database schema by casting columns to the correct data types and adding primary keys and foreign keys.
Files:
`distribution_centers.sql`
`users.sql`
`products.sql`
`orders.sql`
`events.sql`
`inventory_items.sql`
`order_items.sql`
Purpose:
standardize column data types
enforce relational integrity
make the dataset ready for analysis
---
2) Data Quality Checks:
This stage checks the raw data for two major issues:
A. Duplicate checks:
These files detect duplicate IDs, duplicate business keys, or repeated records in each table.
B. Missing value checks:
These files detect missing fields, identify affected columns, and in some cases apply simple filling or cleanup logic.
Files used for data quality:
`distribution_centers.sql`
`users.sql`
`products.sql`
`orders.sql`
`events.sql`
`inventory_items.sql`
`order_items.sql`
Purpose:
make the data more reliable
reduce errors in later analysis
understand which tables need cleanup before reporting
---
3) Customer Segmentation:
This group focuses on customer behavior at the customer level.
Files:
`recency.sql`
`frequency_analysis.sql`
`monetary_segmentation.sql`
`basic_rfm_classification.sql`
What this section measures:
Recency: how recently a customer placed an order relative to the latest date in the dataset
Frequency: how often a customer ordered
Monetary value: how much revenue a customer generated
RFM classification: simple segmentation using recency, frequency, and monetary dimensions
Purpose:
identify active vs inactive customers
detect repeat customers
separate high-value and low-value customers
build a foundation for customer segmentation
---
4) Revenue, Profitability, and Order-Level Performance:
This group measures the commercial side of the business.
Files:
`revenue_metrics.sql`
`profitability_analysis.sql`
`order_level_kpi.sql`
What this section measures:
gross revenue and net revenue
monthly revenue trend
revenue by category and country
average order value (AOV)
revenue per customer
product-level profit
markup and profit margin
category-level profitability
Purpose:
understand business performance
identify top revenue drivers
compare revenue with profitability
highlight the most valuable products and customers
---
5) User Behavior and Acquisition Analysis:
This group studies how users behave on the website and which traffic sources perform best.
Files:
`funnel_analysis.sql`
`session_analysis.sql`
`traffic_source_performence.sql`
What this section measures:
progression through key funnel stages
stage-to-stage conversion rates
funnel drop-off points
session duration
events per session
revenue by traffic source
conversion rate by traffic source
average order value by traffic source
Purpose:
understand user engagement
identify where users drop off before purchase
compare the quality of acquisition channels
connect behavioral data with business outcomes
---
6) Operational and Order-Status Analysis:
This group focuses on process efficiency and delivery-related behavior.
Files:
`delay-bottleneck-detection.sql`
`processing_time_analysis.sql`
`status_distribution.sql`
What this section measures:
order status distribution
order processing time
shipping and delivery timing
bottlenecks in the order lifecycle
patterns behind delayed or problematic orders
Purpose:
detect operational inefficiencies
find stages where orders slow down
understand fulfillment performance
support better logistics and service decisions
---
Suggested Workflow
A good order for running the project is:
Run the schema setup files
Run data quality checks
Review duplicates and missing values
Run customer segmentation analysis
Run revenue and profitability analysis
Run user behavior and acquisition analysis
Run operational analysis
This order helps ensure that business analysis is performed on cleaner and better-structured data.
---
SQL Skills Demonstrated
This project demonstrates practical SQL skills such as:
joins across multiple tables
aggregate functions
grouping and filtering
common table expressions (CTEs)
conditional logic with `CASE`
date and timestamp calculations
conversion and formatting with `TO_CHAR`
funnel logic using event sequences
customer segmentation logic
data cleaning and validation queries
---
Business Questions Answered
Examples of business questions covered in this project:
Which customers are most valuable?
Which customers are least active?
Which traffic source brings the best results?
Where do users drop off in the funnel?
What is the average order value?
Which products or categories are most profitable?
How long does order processing take?
What order statuses are most common?
Are there duplicates or missing values that affect analysis?
---
Notes
The project uses historical data, so metrics such as recency are interpreted relative to the dataset period, not the real current date.
Some files focus on data preparation, while others focus on business reporting.
The project is intended as a portfolio-style SQL case study that combines data engineering, data quality, and business analytics in one workflow.
---
Conclusion
This project shows how SQL can be used to move from raw relational data to structured business insights.
It combines:
database preparation
data quality validation
descriptive analysis
customer segmentation
behavioral analysis
operational reporting
As a full project, it demonstrates not only SQL query writing but also analytical thinking, business interpretation, and structured project organization.
AUTHOR
Ammar Saab
