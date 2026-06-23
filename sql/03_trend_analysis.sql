-- Analyze average unemployment trends across German regions by year

SELECT
    year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_region_rate,
    MAX(unemployment_rate) AS highest_region_rate
FROM germany_unemployment_clean
GROUP BY year
ORDER BY year;
