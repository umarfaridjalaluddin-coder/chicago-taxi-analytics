SELECT
    taxi_id,
    tip_earner_rank

FROM {{ ref('mart_top_100_tip_earners') }}

WHERE tip_earner_rank < 1
   OR tip_earner_rank > 100