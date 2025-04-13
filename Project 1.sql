CREATE DATABASE PPP2;

CREATE TABLE Retail_Sales
(
  transactions_id INT PRIMARY KEY,
  sale_date DATE,
  sale_time TIME,
  customer_id INT,
  gender varchar(20),
  age INT,
  Category varchar(15),
  quantity INT,
  price_per_unit FLOAT,
  cogs FLOAT,
  Total_Sale FLOAT
  );

Select * from retail_sales
LIMIT 15

Select COUNT(*) from retail_sales

DELETE FROM  retail_sales
WHERE
quantity is null 
or 
cogs is null

SELECT * FROM  retail_sales
WHERE
quantity is null 
or 
cogs is null

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * 
FROM retail_sales
where sale_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * FROM retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
category,
sum(total_sale) as net_sale,
count(*) as total_oders
FROM retail_sales
GROUP BY 1

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
ROUND(AVG(age), 2) as avg_age
from retail_sales
WHERE Category = 'Beauty'

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale > 1000

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
Category,
gender,
COUNT (*) AS total_tans
FROM retail_sales
GROUP BY
Category,
gender
ORDER BY 1

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT
YEAR,
MONTH,
avg_sale
from
(
SELECT
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) order by avg(total_sale) desc) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
where rank = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales

select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

select 
category,
count(distinct customer_id) as unique_customers
from retail_sales
group by 1

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale
as
(
SELECT *,
CASE 
WHEN EXTRACT (HOUR FROM sale_time) < 12 then 'morning'
WHEN EXTRACT (HOUR FROM sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift 
from retail_sales
)
select
shift,
count(*) as total_orders
from hourly_sale
group by shift
