{{ config(materialized='table') }}

WITH analysis_dates AS (

    SELECT
        holiday_name,
        holiday_year,
        'actual' AS date_type,
        actual_holiday_date AS analysis_date
    FROM {{ ref('holidays') }}

    UNION ALL

    SELECT
        holiday_name,
        holiday_year,
        'observed' AS date_type,
        observed_holiday_date AS analysis_date
    FROM {{ ref('holidays') }}
    WHERE has_separate_observed_date = TRUE
)

SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date

FROM analysis_dates