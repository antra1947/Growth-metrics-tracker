USE test_db;
SHOW TABLES;

SELECT * FROM orders LIMIT 10;
select ship_mode from orders;

-- find top 10 highest revenue generating products
select product_id ,sum(sale_price) as sales
from orders
group by product_id
order by sales desc
limit 10;

-- find top 5 highest selling products in each region
select distinct region from orders;

select product_id ,sum(sale_price) as sales;

WITH product_sales AS (
    SELECT 
        region,
        product_id,
        SUM(sale_price) AS sales
    FROM orders
    GROUP BY region, product_id
)

SELECT *
FROM (
    SELECT 
        region,
        product_id,
        sales,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY sales DESC) AS `rank`
    FROM product_sales
) AS ranked
WHERE `rank` <= 5;

-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
select year(order_date) from orders;

select distinct year(order_date) AS order_year
FROM orders
ORDER BY order_year;

select year(order_date) as order_year, month(order_date) as order_month,
sum(sale_price) as sales
FROM orders
group by year(order_date),month(order_date)
order by year(order_date),month(order_date);

with cte as(
select year(order_date) as order_year, month(order_date) as order_month,
sum(sale_price) as sales
FROM orders
group by year(order_date),month(order_date)
-- order by year(order_date),month(order_date) 
)
select order_month,order_year,
case when order_year=2022 then sales else 0 end as sales_2022,
case when order_year=2023 then sales else 0 end as sales_2023
from cte
order by order_month;

-- Final querry
with cte as(
select year(order_date) as order_year, month(order_date) as order_month,
sum(sale_price) as sales
FROM orders
group by year(order_date),month(order_date)
-- order by year(order_date),month(order_date) 
)
select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;


-- for each category which month had highest sales
select category,format(order_date,'yyyymm') as order_year_month,
sum(sale_price) as sales
from orders
group by category,format(order_date,'yyyymm')
order by category,format(order_date,'yyyymm')
;


-- final querry
with cte as(
select category,format(order_date,'yyyymm') as order_year_month,
sum(sale_price) as sales
from orders
group by category,format(order_date,'yyyymm')
-- order by category,format(order_date,'yyyymm')
)
select * from(
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1
;
-- which subcategory had highest growth by profit in 2023 compare to 2022
with cte as(
	select 
		sub_category,
		year(order_date) as order_year,
		sum(sale_price) as sales
	from orders
	group by sub_category,year(order_date)
),
cte2 as(
	select 
		sub_category,
		sum(case when order_year=2022 then sales else 0 end) as sales_2022,
		sum(case when order_year=2023 then sales else 0 end) as sales_2023
	from cte
	group by sub_category
)
select 
	sub_category,
    sales_2022,
    sales_2023,
	ROUND((sales_2023 - sales_2022) * 100.0 / NULLIF(sales_2022, 0), 2) AS growth_percent
from cte2
order by (sales_2023-sales_2022)*100/sales_2022 desc
limit 1



SELECT VERSION();
