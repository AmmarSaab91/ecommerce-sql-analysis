COMMERCIAL PERFORMANCE README

Files covered:
- order_level_kpi.sql
- profitability_analysis.sql
- revenue_metrics.sql

Overview
This set of SQL queries evaluates commercial performance from three complementary angles:
1) order efficiency and customer value,
2) product and category profitability,
3) revenue size, trend, and distribution.

Together, these scripts help answer three business questions:
- How much value does each order and each customer generate?
- Which products or categories are most and least profitable?
- How is revenue distributed across time, categories, and countries?

--------------------------------------------------
1. order_level_kpi.sql
--------------------------------------------------
Purpose
This file measures core order-level KPIs using completed and shipped order items.

What it contains
1) Average Order Value (AOV)
- Calculates total product retail revenue divided by the number of distinct orders.
- This shows the average revenue generated per order.
- Business use: helps evaluate basket value and order quality.

2) Top customers by revenue
- Aggregates revenue by user_id.
- Returns the top 10 customers with the highest total revenue contribution.
- Business use: identifies the most valuable customers by sales volume.

How to interpret it
- Higher AOV usually means stronger order value, though it should be interpreted alongside order count and customer mix.
- Top-customer output helps identify concentration risk and high-value customer segments.

--------------------------------------------------
2. profitability_analysis.sql
--------------------------------------------------
Purpose
This file focuses on profit generation rather than revenue alone.
It compares selling price with product cost to evaluate markup, profit margin, and total profit.

What it contains
1) Product-level profit margin and markup
- Computes profit as retail_price - cost.
- Computes markup as profit divided by cost.
- Computes profit margin as profit divided by retail_price.
- Business use: shows how efficiently each product turns cost into profit.

2) Top 10 most profitable products
- Uses completed and shipped order items.
- Aggregates revenue, total cost, and total profit by product.
- Business use: identifies the products contributing the most absolute profit.

3) Lowest-margin products
- Ranks products by profit margin ascending.
- Business use: reveals products that sell with weak margin performance and may need pricing or sourcing review.

4) Category-level profitability
- Aggregates cost, retail price, profit, and profit margin by category.
- Business use: compares categories to see where profit efficiency is strongest.

How to interpret it
- High revenue does not always mean high profit.
- Markup and margin should be read separately: markup is cost-based, margin is selling-price-based.
- Product-level and category-level profitability together give both detailed and strategic views.

--------------------------------------------------
3. revenue_metrics.sql
--------------------------------------------------
Purpose
This file measures revenue from multiple perspectives: total, trend over time, category, and geography.

What it contains
1) Total gross and net revenue
- Gross revenue includes completed, shipped, and returned items because they generated sales activity at some point.
- Net revenue excludes returned items by counting only rows where returned_at is NULL.
- Business use: distinguishes sales volume from retained revenue.

2) Revenue trend by month
- Aggregates monthly revenue from completed and shipped orders.
- Uses LAG to compare each month with the previous month inside the same year.
- Labels each month as Increased, Decreased, No change, or No previous month.
- Business use: supports seasonality and growth-trend analysis.

3) Revenue by product category
- Aggregates revenue by product_category.
- Business use: shows which categories generate the most sales.

4) Revenue by country
- Joins users to attribute revenue to customer country.
- Business use: identifies the strongest markets geographically.

How to interpret it
- Gross revenue is useful for activity volume, while net revenue is more realistic for retained sales.
- Monthly trends help show momentum, not just totals.
- Category and country breakdowns show where revenue concentration exists.

--------------------------------------------------
How these three files work together
--------------------------------------------------
These files should be read as one performance-analysis workflow:

- order_level_kpi.sql explains order value and top customer contribution.
- profitability_analysis.sql explains whether sales are actually profitable.
- revenue_metrics.sql explains total revenue size, its movement over time, and where it comes from.

Recommended interpretation order:
1) Start with revenue_metrics.sql to understand total revenue and trend.
2) Use order_level_kpi.sql to understand order value and customer contribution.
3) Use profitability_analysis.sql to confirm whether revenue growth translates into profit.

--------------------------------------------------
Important modeling notes
--------------------------------------------------
- Revenue in these scripts is based on product retail price.
- Profitability calculations compare retail price against product cost.
- Several outputs format numbers as text with € or % for presentation, which is good for reporting but less suitable for downstream numerical processing.
- Completed and shipped statuses are treated as revenue-contributing states in most queries.

--------------------------------------------------
Suggested project framing
--------------------------------------------------
You can describe this SQL set as:

"A commercial performance analysis that combines revenue measurement, order-level KPIs, and profitability analysis to evaluate not only how much the business sells, but also how efficiently those sales convert into customer value and profit."

