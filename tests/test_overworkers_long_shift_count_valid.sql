SELECT
    taxi_id,
    total_shifts,
    long_shift_count

FROM {{ ref('mart_top_100_overworkers') }}

WHERE long_shift_count > total_shifts