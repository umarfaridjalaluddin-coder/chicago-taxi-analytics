SELECT
    taxi_id AS taxi_id,
    trip_start_timestamp AS trip_start_timestamp,
    trip_end_timestamp AS trip_end_timestamp,

    DATE(trip_start_timestamp) AS trip_date,
    EXTRACT(YEAR FROM trip_start_timestamp) AS trip_year,
    DATE_TRUNC(
        DATE(trip_start_timestamp),
        MONTH
    ) AS trip_month,

    trip_seconds AS trip_seconds,
    trip_miles AS trip_miles,
    fare AS fare,
    tips AS tips,

    TRIM(payment_type) AS payment_type,

    trip_total AS trip_total,
    tolls AS tolls,
    extras AS extras,
    company AS company,

    pickup_community_area AS pickup_community_area,
    dropoff_community_area AS dropoff_community_area,

    pickup_latitude AS pickup_centroid_latitude,
    pickup_longitude AS pickup_centroid_longitude,
    dropoff_latitude AS dropoff_centroid_latitude,
    dropoff_longitude AS dropoff_centroid_longitude

FROM {{ source('chicago_taxi', 'taxi_trips') }}