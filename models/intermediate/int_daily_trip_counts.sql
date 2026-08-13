{{ config(materialized='table') }}

SELECT
    trip_date,

    COUNT(*) AS trip_count,

    SUM(fare) AS total_fare,

    SUM(trip_miles) AS total_trip_miles,

    AVG(trip_seconds) / 60.0 AS avg_trip_duration_minutes

FROM {{ ref('stg_taxi_trips') }}

WHERE trip_year IN (
    2017,
    2018,
    2019,
    2022,
    2023
)

GROUP BY trip_date