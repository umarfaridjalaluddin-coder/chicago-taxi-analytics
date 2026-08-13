WITH trips AS (

    SELECT
        trip_start_timestamp,
        fare,
        tips,
        trip_total,
        trip_seconds,
        trip_miles

    FROM {{ ref('stg_taxi_trips') }}

    WHERE trip_start_timestamp IS NOT NULL
      AND fare > 0
      AND trip_total > 0

),

aggregated AS (

    SELECT
        EXTRACT(DAYOFWEEK FROM trip_start_timestamp) AS day_of_week_number,
        FORMAT_TIMESTAMP('%A', trip_start_timestamp) AS day_of_week,
        EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day,

        COUNT(*) AS trip_count,

        ROUND(AVG(fare), 2) AS avg_fare,
        ROUND(AVG(tips), 2) AS avg_tip,
        ROUND(AVG(trip_total), 2) AS avg_trip_total,

        ROUND(
            AVG(SAFE_DIVIDE(trip_seconds, 60)),
            2
        ) AS avg_trip_minutes,

        ROUND(AVG(trip_miles), 2) AS avg_trip_miles

    FROM trips

    GROUP BY
        day_of_week_number,
        day_of_week,
        hour_of_day

)

SELECT *
FROM aggregated
