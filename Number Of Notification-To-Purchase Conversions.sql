-- Find push-notifications 'Collect your gift!' that converted into a purchase.
-- The time between push-event and purchase-event must be less than 5 hours.
-- Calculate number of purchases.

SELECT COUNT(DISTINCT *) AS num_purchases
FROM
  (SELECT JSONExtractString(ea.event_json, 'device_id') AS device_id,
          JSONExtractString(t.event_json, 'value') AS value,
          JSONExtractString(t.event_json, 'profile_id') AS profile_id,
          ea.event_datetime,
          toDateTime(ea.event_timestamp) AS push_datetime_,
          toDateTime(t.event_timestamp) AS order_date_time
   FROM mobile.events_all ea
   LEFT JOIN mobile.events_all t ON JSONExtractString(t.event_json, 'device_id') = JSONExtractString(ea.event_json, 'device_id')
   AND t.event_name = 'order_step_success'
   WHERE ea.event_name = 'push_open'
     AND JSONExtractString(ea.event_json, 'title') = 'Collect your gift!'
     AND t.event_timestamp > ea.event_timestamp
     AND date_diff('hour', toDateTime(ea.event_timestamp), toDateTime(t.event_timestamp)) < 5)