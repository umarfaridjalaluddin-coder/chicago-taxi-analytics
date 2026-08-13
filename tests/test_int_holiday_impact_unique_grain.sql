SELECT
    holiday_name,
    holiday_year,
    date_type,
    analysis_date,
    COUNT(*) AS row_count

FROM {{ ref('int_holiday_impact') }}

GROUP BY
    holiday_name,
    holiday_year,
    date_type,
    analysis_date

HAVING COUNT(*) > 1