
-- q1:
SELECT 
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
    ,SUM(totals.visits) AS visits 
    ,SUM(totals.pageviews) AS pageviews 
    ,SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month ASC;

--q2: 
SELECT  
    trafficSource.source 
    ,SUM(totals.visits) total_visits 
    ,SUM(totals.bounces) total_no_of_bounces
    ,ROUND(SUM(totals.bounces) / SUM(totals.visits) * 100, 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY trafficSource.source
ORDER BY total_visits DESC;

--q3:
WITH revenue_month AS (
  SELECT
      'Month' AS time_type  
      ,FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,trafficSource.source 
      ,SUM(product.productRevenue)/1000000 revenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`
        ,UNNEST(hits) AS hits 
        ,UNNEST(hits.product) AS product
  WHERE product.productRevenue IS NOT NULL
  GROUP BY trafficSource.source, time_type, time
),
revenue_week AS(
  SELECT
        'Week' AS time_type  
        ,FORMAT_DATE('%Y%W', PARSE_DATE('%Y%m%d', date)) AS time
        ,trafficSource.source 
        ,SUM(product.productRevenue)/1000000 revenue
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`
          ,UNNEST(hits) AS hits 
          ,UNNEST(hits.product) AS product
    WHERE product.productRevenue IS NOT NULL
    GROUP BY trafficSource.source, time_type, time
)
SELECT * 
FROM revenue_month
UNION ALL
SELECT *
FROM revenue_week
ORDER BY time ASC;

--q4:
WITH buyers AS(
    SELECT  
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
        ,(SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId)) avg_pageviews_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
          ,UNNEST(hits) AS hits 
          ,UNNEST(hits.product) AS product
    WHERE _table_suffix BETWEEN '0601' AND '0731' 
          AND totals.transactions >= 1 
          AND productRevenue IS NOT NULL
    GROUP BY month 
),
non_buyers AS(
    SELECT  
        FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
        ,(SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId)) avg_pageviews_non_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
          ,UNNEST(hits) AS hits 
          ,UNNEST(hits.product) AS product
    WHERE _table_suffix BETWEEN '0601' AND '0731' 
          AND totals.transactions IS NULL 
          AND product.productRevenue IS NULL
    GROUP BY month 
)

SELECT  
    b.month
    ,avg_pageviews_purchase
    ,avg_pageviews_non_purchase
FROM buyers b
JOIN non_buyers nb 
ON b.month = nb.month
ORDER BY month ASC;

--q5:
SELECT  
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
    ,SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId) Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      ,UNNEST(hits) AS hits 
      ,UNNEST(hits.product) AS product
WHERE totals.transactions >= 1 
      AND product.productRevenue IS NOT NULL
GROUP BY month; 

--q6:
SELECT  
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
    ,SUM(product.productRevenue/1000000) / SUM(totals.visits) avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
      ,UNNEST(hits) AS hits 
      ,UNNEST(hits.product) AS product
WHERE totals.transactions IS NOT NULL 
      AND product.productRevenue IS NOT NULL
GROUP BY month; 

q7:
WITH buyers_of_youtube_henley AS (
  SELECT DISTINCT fullVisitorId
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
       UNNEST(hits) AS hits, 
       UNNEST(hits.product) AS product
  WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
)

SELECT 
  product.v2ProductName AS other_purchased_products, 
  SUM(product.productQuantity) AS total_quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
     UNNEST(hits) AS hits, 
     UNNEST(hits.product) AS product
WHERE fullVisitorId IN (SELECT fullVisitorId FROM buyers_of_youtube_henley)  
      AND product.v2ProductName != "YouTube Men's Vintage Henley"  
      AND product.productRevenue IS NOT NULL
      AND totals.transactions >= 1 
GROUP BY product.v2ProductName
ORDER BY total_quantity DESC;

--q8:
WITH cohort_data AS(
  SELECT 
      FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
      ,COUNT(CASE WHEN hits.eCommerceAction.action_type = '2' THEN 1 END) AS num_product_view 
      ,COUNT(CASE WHEN hits.eCommerceAction.action_type = '3' THEN 1 END) AS num_addtocart 
      ,COUNT(CASE WHEN hits.eCommerceAction.action_type = '6' AND product.productRevenue IS NOT     
              NULL THEN 1 END) AS num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
        ,UNNEST(hits) AS hits 
        ,UNNEST(hits.product) AS product
  WHERE _table_suffix BETWEEN '0101' AND '0331'
  GROUP BY month
  ORDER BY month ASC
)

SELECT
*
,ROUND((num_addtocart/num_product_view) * 100,2) add_to_cart_rate
,ROUND((num_purchase/num_product_view) * 100,2 )purchase_rate
FROM cohort_data
ORDER BY month ASC;


--Cách 1:dùng CTE
with
product_view as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase as(
  SELECT
    format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
    count(product.productSKU) as num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  and product.productRevenue is not null   
  group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
left join add_to_cart a on pv.month = a.month
left join purchase p on pv.month = p.month
order by pv.month;

--Cách 2: 
with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' and product.productRevenue is not null THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data;