WITH trips AS (

    SELECT
        pickup_community_area,
        fare,
        tips,
        trip_total,
        trip_miles

    FROM {{ ref('stg_taxi_trips') }}

    WHERE pickup_community_area IS NOT NULL
      AND fare > 0
      AND trip_total > 0

),

aggregated AS (

    SELECT
        pickup_community_area,

        COUNT(*) AS trip_count,

        ROUND(SUM(fare), 2) AS total_fare,
        ROUND(SUM(tips), 2) AS total_tips,
        ROUND(SUM(trip_total), 2) AS total_trip_revenue,

        ROUND(AVG(fare), 2) AS avg_fare,
        ROUND(AVG(tips), 2) AS avg_tip,
        ROUND(AVG(trip_total), 2) AS avg_trip_total,
        ROUND(AVG(trip_miles), 2) AS avg_trip_miles

    FROM trips

    GROUP BY pickup_community_area

),

ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY trip_count DESC
        ) AS demand_rank,

        ROW_NUMBER() OVER (
            ORDER BY total_trip_revenue DESC
        ) AS revenue_rank

    FROM aggregated

)

SELECT
    r.pickup_community_area,
    c.community_area_name,

    r.trip_count,
    r.total_fare,
    r.total_tips,
    r.total_trip_revenue,

    r.avg_fare,
    r.avg_tip,
    r.avg_trip_total,
    r.avg_trip_miles,

    r.demand_rank,
    r.revenue_rank

FROM ranked AS r

LEFT JOIN {{ ref('community_areas') }} AS c
    ON r.pickup_community_area = c.community_area_number
