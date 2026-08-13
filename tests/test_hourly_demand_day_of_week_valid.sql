SELECT *
FROM {{ ref('mart_hourly_demand') }}
WHERE day_of_week_number NOT BETWEEN 1 AND 7
