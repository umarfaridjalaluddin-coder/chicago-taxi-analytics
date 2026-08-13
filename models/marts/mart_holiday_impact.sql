{{ config(materialized='table') }}

WITH valid_holiday_impact AS (

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

    FROM {{ ref('int_holiday_impact') }}

    WHERE valid_baseline_days >= 2
      AND holiday_trip_count IS NOT NULL
),

holiday_summary AS (

    SELECT
        holiday_name,
        date_type,

        COUNT(DISTINCT holiday_year) AS years_observed,

        AVG(impact_pct) AS avg_impact_pct,

        APPROX_QUANTILES(
            impact_pct,
            2
        )[OFFSET(1)] AS median_impact_pct,

        COUNTIF(impact_pct > 0) AS positive_impact_years,

        COUNTIF(impact_pct < 0) AS negative_impact_years,

        COUNTIF(impact_pct = 0) AS no_change_years

    FROM valid_holiday_impact

    GROUP BY
        holiday_name,
        date_type
)

SELECT
    holiday_name,
    date_type,
    years_observed,
    avg_impact_pct,
    median_impact_pct,
    positive_impact_years,
    negative_impact_years,
    no_change_years

FROM holiday_summary

ORDER BY
    avg_impact_pct ASC,
    holiday_name,
    date_type