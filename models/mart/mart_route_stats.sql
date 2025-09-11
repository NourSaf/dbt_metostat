WITH
route_stats AS (
    SELECT
        origin AS origin_airport,
        dest AS dest_airport,
        COUNT(*) AS total_flights,
        COUNT(DISTINCT airline) As unique_airlines,
        COUNT(DISTINCT tail_number) As unique_airplanes,
        ROUND(AVG(actual_elapsed_time),2) AS avg_elapsed_time,
        ROUND(AVG(arr_delay),2) AS avg_arr_delay,
        MAX(arr_delay) AS max_delay,
        MIN(arr_delay) AS min_delay,
        SUM(cancelled) AS total_cancelled,
        SUM(diverted) AS total_diverted
    FROM {{ref('prep_flights')}}
    GROUP by origin, dest
)
SELECT
    r.origin_airport,
    ar.city AS origin_city,
    ar.country AS origin_country,
    ar.name AS origin_airport_name,
    r.dest_airport,
    ar2.city AS dest_city,
    ar2.country AS dest_country,
    ar2.name AS dest_airport_name,
    r.total_flights,
    r.unique_airlines,
    r.unique_airplanes,
    r.avg_elapsed_time,
    r.avg_arr_delay,
    r.max_delay,
    r.min_delay,
    r.total_cancelled,
    r.total_diverted
FROM route_stats r
LEFT JOIN {{ref('prep_airports')}} ar
    ON r.origin_airport = ar.faa
LEFT JOIN {{('prep_airports')}} ar2
    ON r.dest_airport = ar2.faa