{{ config(materialized='table') }}

WITH tip_summary AS (

    SELECT
        taxi_id,

        SUM(tips) AS total_tips,

        COUNT(*) AS trip_count,

        AVG(tips) AS avg_tip_per_trip,

        SUM(fare) AS total_fare,

        SAFE_DIVIDE(
            SUM(tips),
            SUM(fare)
        ) * 100 AS tip_percentage

    FROM {{ ref('stg_taxi_trips') }}

    WHERE trip_start_timestamp >= TIMESTAMP('2023-10-01')
      AND trip_start_timestamp < TIMESTAMP('2024-01-01')
      AND payment_type IN ('Credit Card', 'Mobile')
      AND fare > 0
      AND taxi_id IS NOT NULL

    GROUP BY taxi_id
),

ranked_taxis AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            ORDER BY
                total_tips DESC,
                taxi_id
        ) AS tip_earner_rank

    FROM tip_summary
)

SELECT
    tip_earner_rank,
    taxi_id,
    total_tips,
    trip_count,
    avg_tip_per_trip,
    total_fare,
    tip_percentage

FROM ranked_taxis

WHERE tip_earner_rank <= 100

ORDER BY tip_earner_rank