SELECT
    holiday_name,
    date_type,
    years_observed,
    positive_impact_years,
    negative_impact_years,
    no_change_years

FROM {{ ref('mart_holiday_impact') }}

WHERE positive_impact_years
    + negative_impact_years
    + no_change_years
    != years_observed