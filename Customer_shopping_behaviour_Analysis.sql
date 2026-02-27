create database customer_behavior;
USE customer_behavior;
SHOW TABLES;
select * from customer;
---------------------------------------------------------------------------------------------
Q1. What is the total revenue generted by male vs . felame customers?
select gender, SUM(purchase_amount) As total_revenue
from customer
Group by gender;
--------------------------------------------------------------------------------------------
Q2. which customer used a discount but still spend more then the average purches amount?
select customer_id,gender, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >=(select avg(purchase_amount) from customer)
---------------------------------------------------------------------------------------------
Q3.which are the top 5 product with the hightest average review rating?
select 
	item_purchased,
    avg(review_rating) AS avg_rating
from customer
where review_rating is not null 
Group by item_purchased
order by avg_rating desc
limit 5 ;
-----------------------------------------------------------------------------------------------
Q4.compare the average Purchase Amount between Standdard and Express Shipping.
select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in ('Standard' , 'Express')
group by shipping_type;
--------------------------------------------------------------------------------------------
Q5. Do subcribed customer spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
select subscription_status,
    count(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount),2)AS avg_spend,
    ROUND(AVG(purchase_amount),2)AS total_revenue
from customer
Group by subscription_status
order by total_revenue,avg_spend DESC;   
------------------------------------------------------------------------------------------
Q6. Which 5 product have the highest percentage of purchase with discounts applied?
 select item_purchased,
        ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
        from customer
        group by item_purchased
        order by discount_rate DESC 
        LIMIT 5;
 -------------------------------------------------------------------------------------       
-Q7.Segment customer into New, Returning ,and loyal  based on their total number of
 pervious purcheses, and show the count of each segment
 
with customer_type as (
select customer_id, previous_purchases,
case
    when previous_purchases = 1 then 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer)

select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;
----------------------------------------------------------------------------------------
Q8. What are the top 3 most purchesed porduct within each category?
select * from customer;
------
select category
from customer;
------
select distinct category
from customer;
-------------------------
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;
---------------------------------------------------------------------------------------------
Q9. Are customer who are repeat buyers (more than 5 previous
purchases) also likely to subscribe ?

select subscription_status,
count(customer_id) as repeat_buyers
from customer 
where previous_purchases > 5
group by subscription_status;
---------------------------------------------------------------------------------------------
Q10. What is the revenue contribution of each age group?
select age_group,
    sum(purchase_amount) AS total_revenue
from customer
group by age_group
order by total_revenue desc;
