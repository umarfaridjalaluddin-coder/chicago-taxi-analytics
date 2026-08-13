SELECT
    COUNT(*) AS row_count

FROM {{ ref('mart_top_100_overworkers') }}

HAVING COUNT(*) != 100