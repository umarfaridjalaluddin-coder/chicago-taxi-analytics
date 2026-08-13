{{ config(materialized='table') }}

WITH ordered_trips AS (

    SELECT
        taxi_id,
        trip_start_timestamp,
        trip_end_timestamp,
        trip_seconds,

        LAG(trip_end_timestamp) OVER (
            PARTITION BY taxi_id
            ORDER BY trip_start_timestamp, trip_end_timestamp
        ) AS prev_trip_end

    FROM {{ ref('stg_taxi_trips') }}

    WHERE trip_year = 2023
      AND taxi_id IS NOT NULL
),

trip_gaps AS (

    SELECT
        *,

        TIMESTAMP_DIFF(
            trip_start_timestamp,
            prev_trip_end,
            MINUTE
        ) AS gap_minutes

    FROM ordered_trips
),

shift_flags AS (

    SELECT
        *,

        CASE
            WHEN prev_trip_end IS NULL THEN 1
            WHEN gap_minutes >= 480 THEN 1
            ELSE 0
        END AS shift_start_flag

    FROM trip_gaps
),

assigned_shifts AS (

    SELECT
        *,

        SUM(shift_start_flag) OVER (
            PARTITION BY taxi_id
            ORDER BY trip_start_timestamp, trip_end_timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS shift_id

    FROM shift_flags
),

shift_summary AS (

    SELECT
        taxi_id,
        shift_id,

        MIN(trip_start_timestamp) AS shift_start,

        MAX(trip_end_timestamp) AS shift_end,

        TIMESTAMP_DIFF(
            MAX(trip_end_timestamp),
            MIN(trip_start_timestamp),
            MINUTE
        ) / 60.0 AS shift_duration_hours,

        COUNT(*) AS trip_count,

        SUM(
            CASE
                WHEN trip_seconds IS NULL THEN 0
                WHEN trip_seconds > 14400 THEN 0
                ELSE trip_seconds
            END
        ) / 3600.0 AS total_active_trip_hours,

        COUNTIF(gap_minutes < 0) AS overlap_trip_count,

        CASE
            WHEN MAX(trip_end_timestamp) IS NULL THEN TRUE
            ELSE FALSE
        END AS has_incomplete_end_time

    FROM assigned_shifts

    GROUP BY
        taxi_id,
        shift_id
)

SELECT
    taxi_id,
    shift_id,
    shift_start,
    shift_end,
    shift_duration_hours,
    trip_count,
    total_active_trip_hours,
    overlap_trip_count,
    has_incomplete_end_time

FROM shift_summary