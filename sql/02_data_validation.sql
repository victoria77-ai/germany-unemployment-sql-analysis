-- Validate the cleaned Germany unemployment dataset

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT region_code) AS total_regions,
    MIN(year) AS first_year,
    MAX(year) AS latest_year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_unemployment_rate,
    MAX(unemployment_rate) AS highest_unemployment_rate
FROM germany_unemployment_clean;
