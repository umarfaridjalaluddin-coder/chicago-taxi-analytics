SELECT *
FROM {{ ref('mart_hourly_demand') }}
WHERE hour_of_day NOT BETWEEN 0 AND 23
