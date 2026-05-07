README: Operational and Status Analysis Queries

Overview
This README explains three SQL files used to evaluate operational performance and order outcomes in the ecommerce dataset. Together, these queries help identify where fulfillment slows down, how long each stage of the order lifecycle takes, and how orders are distributed across final statuses such as complete, cancelled, and returned.

Files covered
1. delay-bottleneck-detection.sql
2. processing_time_analysis.sql
3. status_distribution.sql

Purpose of this analysis
These queries are designed to answer three practical business questions:
- Where do delays or bottlenecks appear in the order process?
- How long does each operational stage take?
- What percentage of orders end as complete, cancelled, or returned?

--------------------------------------------------
1) delay-bottleneck-detection.sql
--------------------------------------------------
Purpose
This file focuses on delay detection and operational bottlenecks across the full order process.

What it measures
- Fulfillment time: delivered_at - created_at
- Processing time: shipped_at - created_at
- Delivery time: delivered_at - shipped_at
- Cancellation rate: percentage of orders with status = 'Cancelled'
- Return rate: percentage of orders with status = 'Returned'

What each section does
1. Orders exceeding average fulfillment time
   - Builds a CTE called fulfillment.
   - Calculates fulfillment time for delivered orders.
   - Returns the orders whose fulfillment time is above the overall average.
   - Business use: highlights unusually slow orders that may indicate operational friction.

2. Cancellation patterns
   This section studies where cancellations are more common.

   2.1 Cancellation rate by month
   - Groups orders by month.
   - Calculates cancelled orders, total orders, and cancellation percentage.
   - Business use: identifies time periods with elevated cancellation behavior.

   2.2 Cancellation rate by traffic source
   - Joins orders with users.
   - Measures whether some acquisition channels are associated with more cancellations.
   - Business use: checks traffic quality and expectation mismatch by channel.

   2.3 Cancellation rate by country
   - Groups by customer country.
   - Business use: reveals geographic patterns that may indicate shipping, payment, or product-fit issues.

   2.4 Cancellation rate by gender
   - Groups by gender.
   - Business use: supports behavioral comparison across customer segments.

   2.5 Cancellation rate by order size
   - First calculates number of items per order.
   - Then checks whether larger or smaller baskets cancel more often.
   - Business use: evaluates whether order complexity is linked to cancellations.

3. Operational inefficiencies
   3.1 Average processing time
   - Average time from order creation to shipment.
   - Business use: measures internal handling speed.

   3.2 Average delivery time
   - Average time from shipment to delivery.
   - Business use: measures logistics and carrier performance.

   3.3 Overall cancellation rate
   - Percentage of all orders that were cancelled.
   - Business use: provides a baseline KPI.

   3.4 Overall return rate
   - Percentage of all orders that were returned.
   - Business use: provides a baseline post-purchase KPI.

How to interpret the output
- High fulfillment time suggests end-to-end delay.
- High processing time suggests internal operational inefficiency.
- High delivery time suggests shipping or carrier delay.
- High cancellation rate may indicate poor traffic quality, product mismatch, long lead time, or checkout friction.
- High return rate may indicate product expectation or quality issues.

--------------------------------------------------
2) processing_time_analysis.sql
--------------------------------------------------
Purpose
This file isolates the duration of each major stage in the order lifecycle using day-level calculations.

What it measures
- Order creation to shipment time
- Shipment to delivery time
- Total fulfillment cycle time

What each section does
1. Order creation to shipment time
   - Calculates shipped_at::date - created_at::date.
   - Returns the longest cases first.
   - Business use: identifies orders that took the most time to leave the warehouse.

2. Shipment to delivery time
   - Calculates delivered_at::date - shipped_at::date.
   - Returns the longest shipping durations first.
   - Business use: identifies slow transit performance after the package left operations.

3. Total fulfillment cycle time
   - Calculates delivered_at::date - created_at::date.
   - Returns the longest full-cycle orders first.
   - Business use: captures total customer waiting time from purchase to delivery.

How to interpret the output
- A high value in section 1 points to slower processing before shipment.
- A high value in section 2 points to slower transportation after shipment.
- A high value in section 3 reflects the combined impact of both stages.

Relationship to the previous file
- processing_time_analysis.sql gives record-level time calculations.
- delay-bottleneck-detection.sql gives broader KPI-style summaries and pattern analysis.
- Together, they provide both detailed examples and aggregated operational insight.

--------------------------------------------------
3) status_distribution.sql
--------------------------------------------------
Purpose
This file summarizes the distribution of order outcomes across the orders table.

What it measures
- Completed orders percentage
- Cancelled orders percentage
- Returned orders percentage

What each section does
1. Completed orders
   - Calculates the percentage of rows where status = 'Complete'.

2. Cancelled orders
   - Calculates the percentage of rows where status = 'Cancelled'.

3. Returned orders
   - Calculates the percentage of rows where status = 'Returned'.

Business use
- This file gives a quick top-level view of how orders end.
- It is useful for dashboard KPIs, executive summaries, and benchmarking operational health.

How to interpret the output
- A higher completed percentage usually indicates healthier order execution.
- A higher cancelled percentage suggests friction before fulfillment is completed.
- A higher returned percentage suggests issues after purchase, such as product mismatch, defects, or inaccurate expectations.

Important note
Because each query is run separately, the percentages are not shown in one table. They are intended as simple individual KPI checks.

--------------------------------------------------
How the three files work together
--------------------------------------------------
These files form one operational-analysis block:

- status_distribution.sql tells you the overall outcome mix of orders.
- processing_time_analysis.sql shows how long each stage takes at the order level.
- delay-bottleneck-detection.sql explains where delays, cancellations, and inefficiencies are concentrated.

Suggested interpretation flow
1. Start with status_distribution.sql to understand the general health of order outcomes.
2. Use processing_time_analysis.sql to inspect long processing or delivery durations.
3. Use delay-bottleneck-detection.sql to determine whether delays and cancellations are linked to month, traffic source, country, gender, or order size.

Summary
These queries are useful for diagnosing operational performance in an ecommerce dataset. They help distinguish between internal processing delays, external delivery delays, and customer-level outcome issues such as cancellations and returns. Used together, they provide a structured view of fulfillment efficiency and bottleneck detection.
