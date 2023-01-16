--Assume you are given the tables below containing information on Snapchat users, their ages, and their time spent sending and opening snaps.
--Write a query to obtain a breakdown of the time spent sending vs. opening snaps (as a percentage of total time spent on these activities) for each age group.
--Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2 decimal places.

WITH snaps_statistics AS
  (SELECT ab.age_bucket,
          SUM(CASE
                  WHEN a.activity_type = 'send' THEN a.time_spent
                  ELSE 0
              END) AS send_timespent,
          SUM(CASE
                  WHEN a.activity_type = 'open' THEN a.time_spent
                  ELSE 0
              END) AS open_timespent,
          SUM(a.time_spent) AS total_timespent
   FROM activities a
   INNER JOIN age_breakdown ab ON a.user_id = ab.user_id
   WHERE a.activity_type IN ('send','open')
   GROUP BY ab.age_bucket)
SELECT age_bucket,
       ROUND(100 * send_timespent / total_timespent, 2) AS send_prc,
       ROUND(100 * open_timespent / total_timespent, 2) AS open_prc
FROM snaps_statistics