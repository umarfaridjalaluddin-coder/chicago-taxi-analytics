SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    valid_baseline_days

FROM {{ ref('int_holiday_baseline') }}

WHERE valid_baseline_days < 0
   OR valid_baseline_days > 4