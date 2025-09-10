WITH 
joined_table AS (
    SELECT 
        * 
    FROM {{source('flights_data', 'airports')}} airports a
    JOIN {{source('flights_data', 'regions')}} regions r
    ON a.country = r.country
)
SELECT * FROM joined_table
