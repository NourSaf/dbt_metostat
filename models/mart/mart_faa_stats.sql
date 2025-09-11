-- unique number of departures connections
-- unique number of arrival connections
-- how many flight were planned in total (departures & arrivals)
-- how many flights were canceled in total (departures & arrivals)
-- how many flights were diverted in total (departures & arrivals)
-- how many flights actually occured in total (departures & arrivals)
-- (optional) how many unique airplanes travelled on average
-- (optional) how many unique airlines were in service on average
-- add city, country and name of the airport

WITH 
dep_flights AS (
    SELECT 
        origin AS airport_code,
        COUNT(DISTINCT dest) AS unique_to,
        COUNT(sched_dep_time) AS dep_planned,
        SUM(cancelled) as dep_cancelled,
        SUM(diverted) as dep_diverted,
        COUNT(dep_time) AS dep_n_flights
    FROM {{ref('prep_flights')}}
    GROUP BY origin
),
arr_flights AS (    
    SELECT 
        dest AS airport_code,
        COUNT(DISTINCT origin) as unique_from,
        COUNT(sched_arr_time) AS arr_planned,
        SUM(cancelled) as arr_cancelled,
        SUM(diverted) as arr_diverted,
        COUNT(dep_time) AS arr_n_flights
    FROM {{ref('prep_flights')}}
    GROUP BY dest
), 
total_stats AS (
    SELECT
        d.airport_code,
        unique_to,
        unique_from, 
        (dep_planned + arr_planned) AS total_planned,
        (dep_cancelled + arr_cancelled) AS total_cancelled,
        (dep_diverted + arr_diverted) AS total_diverted,
        (dep_n_flights + arr_n_flights) AS total_flights
    FROM dep_flights d
    JOIN arr_flights a
    USING (airport_code)
)
SELECT 
    city,
    country, 
    name,
    *
FROM total_stats ts
JOIN {{ref('prep_airports')}} p
ON ts.airport_code = p.faa