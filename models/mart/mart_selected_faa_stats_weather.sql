WITH 
flights_dep AS (
    SELECT
        p.flight_date,
        p.origin AS airport_code,
        COUNT(DISTINCT p.dest) AS total_flights_dep,
        COUNT(sched_dep_time) AS planned_dep,
        SUM(cancelled) AS cancelled_dep,
        SUM(diverted) AS total_diverted_dep
    FROM prep_flights p
    WHERE p.origin IN ('JFK', 'LAX', 'MIA')
    GROUP BY p.flight_date, p.origin
),
flights_arr AS (
    SELECT
        p.flight_date,
        p.dest AS airport_code,
        COUNT(DISTINCT p.origin) AS total_flights_arr,
        COUNT(sched_arr_time) AS planned_arr,
        SUM(cancelled) AS cancelled_arr,
        SUM(diverted) AS total_diverted_arr
    FROM prep_flights p
    WHERE p.dest IN ('JFK', 'LAX', 'MIA')
    GROUP BY p.flight_date, p.dest
)
SELECT
    dp.airport_code,
    dp.flight_date,
    dp.total_flights_dep,
    ar.total_flights_arr,
    (dp.planned_dep + ar.planned_arr) AS total_planned,
    (dp.cancelled_dep + cancelled_arr) AS total_cancelled,
    (total_diverted_dep + total_diverted_arr) AS total_diverted
FROM flights_dep dp
JOIN flights_arr ar
USING (flight_date, airport_code)
ORDER BY total_flights_dep