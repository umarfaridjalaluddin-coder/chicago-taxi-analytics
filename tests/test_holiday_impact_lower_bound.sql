SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    holiday_trip_count,
    baseline_trip_count,
    impact_pct

FROM {{ ref('int_holiday_impact') }}

WHERE valid_baseline_days >= 2
  AND holiday_trip_count IS NOT NULL
  AND baseline_trip_count > 0
  AND impact_pct < -100