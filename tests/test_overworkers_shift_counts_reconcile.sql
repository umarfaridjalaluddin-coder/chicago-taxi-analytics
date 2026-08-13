SELECT
    taxi_id,
    total_shifts,
    long_shift_count,
    non_long_shift_count

FROM {{ ref('mart_top_100_overworkers') }}

WHERE non_long_shift_count != total_shifts - long_shift_count