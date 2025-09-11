WITH 
flights_dep AS (
    SELECT
        p.flight_date,
        p.origin AS airport_code,
        COUNT(DISTINCT p.dest) AS total_flights_dep
    FROM prep_flights p
    WHERE p.origin IN ('JFK', 'LAX', 'MIA')
    GROUP BY p.flight_date, p.origin
),
flights_arr AS (
    SELECT
        p.flight_date,
        p.dest AS airport_code,
        COUNT(DISTINCT p.origin) AS total_flights_arr
    FROM prep_flights p
    WHERE p.dest IN ('JFK', 'LAX', 'MIA')
    GROUP BY p.flight_date, p.dest
)
SELECT *
FROM flights_dep 
JOIN flights_arr
USING (flight_date, airport_code)
ORDER BY total_flights_dep

-- for the selected airports total number of departures 

SELECT * FROM prep_flights;