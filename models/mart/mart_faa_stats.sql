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
    p.city,
    p.country, 
    p.name,
    ts.airport_code,
    ts.unique_to,
    ts.unique_from,
    ts.total_planned,
    ts.total_cancelled,
    ts.total_diverted,
    ts.total_flights
FROM total_stats ts
JOIN {{ref('prep_airports')}} p
ON ts.airport_code = p.faa