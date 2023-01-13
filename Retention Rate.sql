WITH user_cohorts AS
  (SELECT id_client,
          Datefromparts(Year(first_purchase_date), Month(first_purchase_date), 1) AS cohort_month
   FROM clients
   WHERE website = 1),
     
	 df AS
  (SELECT Datefromparts(Year(purchase_date), Month(purchase_date), 1) AS order_month,
          o.id AS order_id,
          o.id_client,
          o.sum,
          o.origin,
          CASE
              WHEN Datefromparts(Year(purchase_date), Month(purchase_date), 1) = cohort_month THEN 1
              ELSE 0
          END AS new_client,
          uc.cohort_month,
          Datediff(MONTH, cohort_month, Datefromparts(Year(purchase_date), Month(purchase_date), 1)) AS period
   FROM orders o
   LEFT JOIN user_cohorts uc ON uc.id_client = o.id_client
   WHERE o.status <> 6
     AND website = 1
     AND purchase_date >= '2020-01-01')

SELECT cohort_month,
       order_month,
       period,
       Count(DISTINCT id_client) AS retention,
       Cast(Count(DISTINCT id_client) AS FLOAT) / Max(Count(DISTINCT id_client)) OVER (PARTITION BY cohort_month) AS retention_rate
FROM df GROUP  BY cohort_month,
                  order_month,
                  period
ORDER  BY cohort_month DESC,
          order_month ASC