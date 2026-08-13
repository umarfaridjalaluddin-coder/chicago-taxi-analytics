SELECT
    taxi_id,
    shift_id,
    COUNT(*) AS row_count

FROM {{ ref('int_taxi_shifts') }}

GROUP BY
    taxi_id,
    shift_id

HAVING COUNT(*) > 1