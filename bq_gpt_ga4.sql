
-- Daily Active Users:
WITH DailyUsers AS (
    SELECT event_date, COUNT(DISTINCT user_pseudo_id) AS DAU
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    GROUP BY event_date
)
SELECT * FROM DailyUsers;




-- Top Traffic Sources:
WITH TrafficSources AS (
    SELECT traffic_source.source AS Source, COUNT(*) AS Visits
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    GROUP BY Source
)
SELECT * FROM TrafficSources ORDER BY Visits DESC LIMIT 10;


-- Purchase Conversions by Source:
WITH PurchaseConversions AS (
    SELECT traffic_source.source AS Source, COUNT(*) AS Conversions
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    WHERE event_name = 'purchase'
    GROUP BY Source
)
SELECT * FROM PurchaseConversions ORDER BY Conversions DESC LIMIT 10;


/*
WITH `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131` AS (
SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131` 
)
--User Engagement (Session Duration)- not working:
, UserEngagement AS (
    SELECT user_pseudo_id, AVG(session_duration) AS AvgSessionDuration
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    GROUP BY user_pseudo_id
)
SELECT * FROM UserEngagement;
*/

-- Page Views per User:
WITH PageViews AS (
    SELECT user_pseudo_id, COUNT(*) AS PageViews
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    WHERE event_name = 'page_view'
    GROUP BY user_pseudo_id
)
SELECT * FROM PageViews;

-- Ecommerce Revenue by Product:
WITH RevenueByProduct AS (
    SELECT items.item_name AS Product, SUM(ecommerce.purchase_revenue_in_usd) AS Revenue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`, UNNEST(items) AS items
    WHERE event_name = 'purchase'
    GROUP BY Product
)
SELECT * FROM RevenueByProduct ORDER BY Revenue DESC LIMIT 10;


-- New vs Returning Users:
WITH UserClassification AS (
    SELECT user_pseudo_id, 
           CASE 
               WHEN MIN(event_date) = MAX(event_date) THEN 'New' 
               ELSE 'Returning' 
           END AS UserType
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    GROUP BY user_pseudo_id
)
SELECT UserType, COUNT(*) AS Users FROM UserClassification GROUP BY UserType;


-- Top Products Viewed:
WITH TopProducts AS (
    SELECT items.item_name AS Product, COUNT(*) AS Views
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`, UNNEST(items) AS items
    WHERE event_name = 'view_item'
    GROUP BY Product
)
SELECT * FROM TopProducts ORDER BY Views DESC LIMIT 10;


-- Conversion Rate by Device Category:
WITH ConversionRate AS (
    SELECT device.category AS DeviceCategory,
           COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_pseudo_id ELSE NULL END) * 1.0 / COUNT(DISTINCT user_pseudo_id) AS ConversionRate
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    GROUP BY DeviceCategory
)
SELECT * FROM ConversionRate;

-- Average Order Value:
WITH OrderValue AS (
    SELECT AVG(ecommerce.purchase_revenue_in_usd) AS AvgOrderValue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
    WHERE event_name = 'purchase'
)
SELECT * FROM OrderValue;

