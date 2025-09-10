WITH 
joined_table AS (
    SELECT 
        * 
    FROM {{ source('flights_data', 'airports') }}  a
    JOIN {{ source('flights_data', 'regions') }}  r
    USING(country)
)
SELECT * FROM joined_table
