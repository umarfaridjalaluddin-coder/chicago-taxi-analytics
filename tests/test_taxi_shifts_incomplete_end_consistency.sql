SELECT
    taxi_id,
    shift_id,
    shift_start,
    shift_end,
    shift_duration_hours,
    has_incomplete_end_time

FROM {{ ref('int_taxi_shifts') }}

WHERE has_incomplete_end_time = FALSE
  AND (
      shift_end IS NULL
      OR shift_duration_hours IS NULL
  )