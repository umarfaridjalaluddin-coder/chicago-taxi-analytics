{{ config(materialized='table') }}

WITH taxi_summary AS (

    SELECT
        taxi_id,

        COUNT(*) AS total_shifts,

        COUNTIF(
            has_incomplete_end_time = FALSE
            AND shift_duration_hours >= 12
        ) AS long_shift_count,

        SUM(
            CASE
                WHEN has_incomplete_end_time = FALSE
                THEN shift_duration_hours
            END
        ) AS total_shift_hours,

        AVG(
            CASE
                WHEN has_incomplete_end_time = FALSE
                THEN shift_duration_hours
            END
        ) AS avg_shift_hours,

        MAX(
            CASE
                WHEN has_incomplete_end_time = FALSE
                THEN shift_duration_hours
            END
        ) AS max_shift_hours,

        SUM(total_active_trip_hours) AS total_active_trip_hours,

        SUM(trip_count) AS total_trips,

        SUM(overlap_trip_count) AS total_overlap_trips,

        COUNTIF(
            has_incomplete_end_time = TRUE
        ) AS incomplete_shift_count

    FROM {{ ref('int_taxi_shifts') }}

    GROUP BY taxi_id
),

taxi_metrics AS (

    SELECT
        *,

        SAFE_DIVIDE(
            long_shift_count,
            total_shifts
        ) AS long_shift_rate,

        total_shifts - long_shift_count
            AS non_long_shift_count,

        SAFE_DIVIDE(
            total_overlap_trips,
            total_trips
        ) AS overlap_rate

    FROM taxi_summary
),

ranked_taxis AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY
                long_shift_count DESC,
                long_shift_rate DESC,
                total_shift_hours DESC,
                taxi_id
        ) AS overworker_rank

    FROM taxi_metrics
)

SELECT
    overworker_rank,
    taxi_id,
    total_shifts,
    long_shift_count,
    non_long_shift_count,
    long_shift_rate,
    total_shift_hours,
    avg_shift_hours,
    max_shift_hours,
    total_active_trip_hours,
    total_trips,
    total_overlap_trips,
    overlap_rate,
    incomplete_shift_count

FROM ranked_taxis

WHERE overworker_rank <= 100

ORDER BY overworker_rank