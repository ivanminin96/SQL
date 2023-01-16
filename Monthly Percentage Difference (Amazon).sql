--Given a table of purchases by date, calculate the month-over-month percentage change in revenue. 
--The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.

WITH df AS
  (SELECT id,
          created_at,
          value,
          purchase_id,
          to_char(date_trunc('month', created_at)::date, 'YYYY-MM') AS month_
   FROM sf_transactions)
SELECT month_,
       round(((sum(value) / lag(sum(value), 1) OVER (ORDER BY month_)) - 1) * 100, 2) AS revenue_diff_pct
FROM df
GROUP BY month_
ORDER BY month_ ASC