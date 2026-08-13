SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    valid_baseline_days,
    baseline_trip_count

FROM {{ ref('int_holiday_baseline') }}

WHERE valid_baseline_days > 0
  AND (
      baseline_trip_count IS NULL
      OR baseline_trip_count < 0
  )