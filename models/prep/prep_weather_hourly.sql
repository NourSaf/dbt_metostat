WITH 
hourly_data AS (
    SELECT * 
    FROM {{ref('staging_weather_hourly')}}
), 
add_time_features AS (
    SELECT  
        *, 
        timestamp::DATE AS date,
        timestamp::TIME AS time,
        TO_CHAR(timestamp,'HH24:MI') AS hour,
        TO_CHAR(timestamp, 'FMmonth') AS month_name,
        TO_CHAR(timestamp::DATE, 'day') AS weekday,
        DATE_PART('day', timestamp) AS date_day,
        DATE_PART('month', timestamp) AS date_month,
        DATE_PART('year', timestamp) AS date_year,
        DATE_PART('week', timestamp) AS cw
    FROM hourly_data
),
date_case AS (
    SELECT 
        * ,
        (CASE
            WHEN hour BETWEEN '00:00' AND '08:00' THEN 'Night'
            WHEN hour BETWEEN '08:00' AND '16:00' THEN 'Day'
            ELSE 'Evening'
            END
        ) AS day_part
    FROM add_time_features
)
SELECT * FROM date_case