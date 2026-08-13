SELECT
    COUNT(*) AS row_count

FROM {{ ref('mart_top_100_tip_earners') }}

HAVING COUNT(*) != 100