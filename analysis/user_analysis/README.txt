USER BEHAVIOR & ACQUISITION README
==================================

Files covered
-------------
1. funnel_analysis.sql
2. session_analysis.sql
3. traffic_source_performence.sql


Overview
--------
These three SQL files work together to evaluate how users move through the website, how they behave inside sessions, and which acquisition channels generate the strongest commercial results.

Together, they answer three business questions:

1. How do users progress through the shopping journey?
2. How engaged are users during each visit/session?
3. Which traffic sources bring the most valuable users?


1) funnel_analysis.sql
----------------------
Purpose:
This file measures how users move through key website events and whether they follow a realistic conversion path.

What it analyzes:
- The event types that exist in the events table
- How common each event type is across sessions
- Whether cart behaves like a true funnel step
- Conversion between funnel stages
- Drop-off between funnel stages

Main logic:
A. Event inventory
   The file starts by listing distinct event types so you can see the available behavioral stages.

B. Funnel-entry validation
   It measures how many sessions contain each event_type and what share of all sessions that represents.
   This helps you choose a realistic funnel starting point.

C. Cart-sequence validation
   It checks whether sessions with a cart event follow the logical order:
   product -> cart -> purchase

   This is done in two ways:
   - all sessions
   - identified sessions only (where user_id is not null)

   This helps confirm whether 'cart' should be treated as a valid intermediate funnel step.

D. Stage-to-stage conversion
   The file calculates conversion for two funnel models:

   1. product -> cart -> purchase
   2. department -> product -> cart -> purchase

   For each model, it counts how many sessions reached each stage and then calculates:
   - stage conversion rate
   - overall funnel completion rate

E. Drop-off analysis
   It then converts those same stage counts into drop-off rates, showing where users are lost between stages.

Why it matters:
- Identifies the weakest point in the customer journey
- Shows whether users are abandoning before cart or before purchase
- Helps explain whether the site has browsing friction, product-page friction, or checkout friction

How to interpret it:
- High product-to-cart drop-off may suggest weak product pages, low purchase intent, or pricing friction
- High cart-to-purchase drop-off may suggest checkout friction, delivery cost issues, or weak purchase commitment
- If cart does not frequently appear in the correct event order, it may not be a reliable funnel stage in this dataset


2) session_analysis.sql
-----------------------
Purpose:
This file evaluates session-level engagement and browsing intensity.

What it analyzes:
- Longest identified sessions
- Longest and shortest identified sessions
- Average session duration
- Distribution of number of events per session

Main logic:
A. Top 10 longest sessions
   Measures session duration in minutes using:
   max(created_at) - min(created_at)

   This identifies the longest known user sessions.

B. Longest and shortest identified sessions
   Builds a session-duration table and returns the sessions that match:
   - maximum duration
   - minimum duration

   This highlights the extremes of user engagement.

C. Average session duration
   Calculates the average duration across all sessions, not only identified ones.

D. Events-per-session distribution
   Counts how many events occur inside each session, then groups sessions by that count.
   It also calculates the percentage share of sessions for each event-count bucket.

Why it matters:
- Measures whether user visits are brief or engaged
- Helps distinguish shallow browsing from deep exploration
- Reveals the spread of session complexity across the platform

How to interpret it:
- Very short sessions may indicate weak landing relevance, accidental visits, or fast exits
- Long sessions may indicate strong interest, comparison behavior, or difficulty finding what the user wants
- A high share of low-event sessions can indicate low engagement
- A broader events-per-session distribution can suggest richer browsing behavior


3) traffic_source_performence.sql
---------------------------------
Purpose:
This file connects acquisition channels to financial and conversion outcomes.

What it analyzes:
- Gross and net revenue by traffic source
- Conversion rate by traffic source
- Average order value (AOV) by traffic source
- Best-performing traffic source by net revenue

Important notes used in the file:
- Gross revenue includes returned items because they were sold at some point
- Net revenue excludes returned items
- product_retail_price from inventory_items is used as the price proxy

Main logic:
A. Revenue by traffic source
   Joins order_items, inventory_items, and users to calculate:
   - gross revenue
   - net revenue

   This shows which acquisition channels drive the largest revenue volume.

B. Conversion rate by traffic source
   Compares:
   - total users from each traffic source
   - converted users from each traffic source

   A converted user is defined here as a user with at least one complete order.

C. AOV by traffic source
   Calculates gross and net average order value for each traffic source.
   This shows whether some channels bring bigger-spending customers, not just more customers.

D. Top acquisition channel
   Returns the single best traffic source by net revenue.

Why it matters:
- Separates traffic quantity from traffic quality
- Helps evaluate channel efficiency
- Shows whether a source is good at generating:
  - more users
  - more conversions
  - higher-value orders
  - more net commercial impact

How to interpret it:
- A source with high traffic but low conversion may be good for awareness but weak for purchase intent
- A source with lower traffic but high AOV may bring more valuable customers
- A source with high gross revenue but weaker net revenue may be associated with more returns
- The highest net-revenue channel is often the strongest acquisition performer from a business perspective


How the three files fit together
--------------------------------
These files should be read as one analysis set:

1. funnel_analysis.sql
   Explains how users move through the purchase journey.

2. session_analysis.sql
   Explains how users behave during each visit.

3. traffic_source_performence.sql
   Explains which acquisition channels generate the best business results.

Combined, they support a full user-behavior and acquisition story:
- Funnel analysis shows where users drop off
- Session analysis shows how deeply users engage
- Traffic source analysis shows where the highest-value traffic comes from


Suggested project framing
-------------------------
You can present this group as:

"User Behavior and Acquisition Performance Analysis"

or

"Website Journey, Session Engagement, and Traffic Source Performance"


Suggested summary sentence for a portfolio/project
--------------------------------------------------
This analysis set examines user behavior from three angles: funnel progression, session-level engagement, and acquisition-channel performance. It helps identify where users drop off in the journey, how intensely they interact with the site, and which traffic sources generate the strongest commercial outcomes.
