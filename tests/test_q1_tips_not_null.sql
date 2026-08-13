SELECT
    taxi_id,
    trip_start_timestamp,
    payment_type,
    fare,
    tips

FROM {{ ref('stg_taxi_trips') }}

WHERE trip_start_timestamp >= TIMESTAMP('2023-10-01')
  AND trip_start_timestamp < TIMESTAMP('2024-01-01')
  AND payment_type IN ('Credit Card', 'Mobile')
  AND fare > 0
  AND taxi_id IS NOT NULL
  AND tips IS NULL