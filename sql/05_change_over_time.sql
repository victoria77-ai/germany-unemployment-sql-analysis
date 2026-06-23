-- German regions with the biggest unemployment improvement between 2016 and 2025

SELECT
    start_data.region_code,
    start_data.region_name,
    start_data.unemployment_rate AS unemployment_2016,
    end_data.unemployment_rate AS unemployment_2025,
    ROUND(start_data.unemployment_rate - end_data.unemployment_rate, 2) AS improvement_percentage_points
FROM germany_unemployment_clean AS start_data
JOIN germany_unemployment_clean AS end_data
    ON start_data.region_code = end_data.region_code
WHERE start_data.year = 2016
  AND end_data.year = 2025
ORDER BY improvement_percentage_points DESC
LIMIT 10;


-- German regions where unemployment increased between 2016 and 2025

SELECT
    start_data.region_code,
    start_data.region_name,
    start_data.unemployment_rate AS unemployment_2016,
    end_data.unemployment_rate AS unemployment_2025,
    ROUND(end_data.unemployment_rate - start_data.unemployment_rate, 2) AS increase_percentage_points
FROM germany_unemployment_clean AS start_data
JOIN germany_unemployment_clean AS end_data
    ON start_data.region_code = end_data.region_code
WHERE start_data.year = 2016
  AND end_data.year = 2025
  AND end_data.unemployment_rate > start_data.unemployment_rate
ORDER BY increase_percentage_points DESC;
