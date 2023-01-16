--Assume you are given the table below containing information on user transactions for particular products. 
--Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.
--Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

SELECT to_char(date_trunc('year', transaction_date), 'YYYY') AS year_,
       product_id,
       sum(spend) AS curr_year_spend,
       lag(sum(spend)) OVER (
			PARTITION BY product_id 
			ORDER BY to_char(date_trunc('year', transaction_date), 'YYYY')) AS prev_year_spend,
       round(((sum(spend) / lag(sum(spend)) OVER (
		                             PARTITION BY product_id 
		                             ORDER BY to_char(date_trunc('year', transaction_date), 'YYYY'))) - 1) * 100, 2) AS yoy_rate
FROM user_transactions
GROUP BY 1, 2
ORDER BY 1 ASC
