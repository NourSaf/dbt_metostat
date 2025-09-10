{{ config(materialized='view') }}
WITH 
month_filter AS 
(SELECT
    *
    FROM {{ source('flights_data', 'flights') }}
    WHERE DATE_PART('month', flight_date) = 1
    )
SELECT * FROM month_filter