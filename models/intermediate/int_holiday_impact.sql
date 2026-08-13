{{ config(materialized='table') }}

WITH holiday_impact AS (

    SELECT
        hb.holiday_name,
        hb.holiday_year,
        hb.date_type,
        hb.analysis_date,
        hb.valid_baseline_days,

        dtc.trip_count AS holiday_trip_count,

        hb.baseline_trip_count,

        dtc.trip_count
            - hb.baseline_trip_count
            AS trip_difference,

        SAFE_DIVIDE(
            dtc.trip_count - hb.baseline_trip_count,
            hb.baseline_trip_count
        ) * 100 AS impact_pct

    FROM {{ ref('int_holiday_baseline') }} hb

    LEFT JOIN {{ ref('int_daily_trip_counts') }} dtc
        ON hb.analysis_date = dtc.trip_date
)

SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    valid_baseline_days,
    holiday_trip_count,
    baseline_trip_count,
    trip_difference,
    impact_pct

FROM holiday_impact