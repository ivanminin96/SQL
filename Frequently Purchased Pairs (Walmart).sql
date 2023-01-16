--Assume you are given the following tables on Walmart transactions and products.
--Find the number of unique product combinations that are bought together (purchased in the same transaction).

--For example, if I find two transactions where apples and bananas are bought, and another transaction where bananas and soy milk are bought, 
--my output would be 2 to represent the 2 unique combinations.

WITH transactions_list AS
  (SELECT t.transaction_id,
          t.product_id,
          p.product_name,
          t.user_id,
          t.transaction_date
   FROM transactions t
   INNER JOIN products p ON p.product_id = t.product_id)
SELECT product1,
       product2,
       count(DISTINCT transaction_id) AS frequency
FROM
  (SELECT t1.transaction_date,
          t1.transaction_id,
          t1.product_id AS product1,
          t2.product_id AS product2
   FROM transactions_list t1
   INNER JOIN transactions t2 ON t2.transaction_id = t1.transaction_id
   WHERE t1.product_id > t2.product_id) df
GROUP BY product1,
         product2
ORDER BY count(DISTINCT transaction_id) DESC