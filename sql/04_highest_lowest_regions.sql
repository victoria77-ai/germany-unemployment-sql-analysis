-- Top 10 German regions with the highest unemployment rate in 2025

SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate DESC
LIMIT 10;


-- Top 10 German regions with the lowest unemployment rate in 2025

SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate ASC
LIMIT 10;
