SELECT
    taxi_id,
    overworker_rank

FROM {{ ref('mart_top_100_overworkers') }}

WHERE overworker_rank < 1
   OR overworker_rank > 100