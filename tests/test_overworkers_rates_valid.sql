SELECT
    taxi_id,
    long_shift_rate,
    overlap_rate

FROM {{ ref('mart_top_100_overworkers') }}

WHERE long_shift_rate < 0
   OR long_shift_rate > 1
   OR overlap_rate < 0
   OR overlap_rate > 1