--Find the customer with the highest daily total order cost between 2019-02-01 to 2019-05-01. 
--If customer had more than one order on a certain day, sum the order costs on daily basis. Output customer's first name, total cost of their items, and the date.

SELECT first_name,
       total_order_cost,
       order_date
FROM
  (SELECT order_date,
          sum(total_order_cost) AS total_order_cost,
          cust_id
   FROM orders
   WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
   GROUP BY order_date,
            cust_id) d
INNER JOIN customers c ON c.id = d.cust_id
ORDER BY 2 DESC
LIMIT 1