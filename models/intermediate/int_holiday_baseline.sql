{{ config(materialized='table') }}

WITH baseline_candidates AS (

    SELECT
        holiday_name,
        holiday_year,
        date_type,
        analysis_date,
        offset_days,

        DATE_ADD(
            analysis_date,
            INTERVAL offset_days DAY
        ) AS candidate_date

    FROM {{ ref('int_holiday_analysis_dates') }}

    CROSS JOIN UNNEST([-14, -7, 7, 14]) AS offset_days
),

holiday_dates AS (

    SELECT
        actual_holiday_date AS holiday_date
    FROM {{ ref('holidays') }}

    UNION DISTINCT

    SELECT
        observed_holiday_date AS holiday_date
    FROM {{ ref('holidays') }}
    WHERE has_separate_observed_date = TRUE
),

valid_baseline_candidates AS (

    SELECT
        bc.*

    FROM baseline_candidates bc

    WHERE NOT EXISTS (
        SELECT 1
        FROM holiday_dates h
        WHERE h.holiday_date = bc.candidate_date
    )
),

baseline_with_counts AS (

    SELECT
        vbc.holiday_name,
        vbc.holiday_year,
        vbc.date_type,
        vbc.analysis_date,
        vbc.offset_days,
        vbc.candidate_date,
        dtc.trip_count

    FROM valid_baseline_candidates vbc

    LEFT JOIN {{ ref('int_daily_trip_counts') }} dtc
        ON vbc.candidate_date = dtc.trip_date
),

baseline_summary AS (

    SELECT
        holiday_name,
        holiday_year,
        date_type,
        analysis_date,

        COUNT(trip_count) AS valid_baseline_days,

        AVG(trip_count) AS baseline_trip_count

    FROM baseline_with_counts

    GROUP BY
        holiday_name,
        holiday_year,
        date_type,
        analysis_date
)

SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    valid_baseline_days,
    baseline_trip_count

FROM baseline_summary