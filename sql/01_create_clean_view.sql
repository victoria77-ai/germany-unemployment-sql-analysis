-- Create a cleaned Germany-only unemployment view

CREATE OR REPLACE VIEW germany_unemployment_clean AS
SELECT
    SPLIT_PART(country_or_region, ':', 1) AS region_code,
    TRIM(SPLIT_PART(country_or_region, ':', 2)) AS region_name,
    year::INT AS year,
    observation_value::NUMERIC AS unemployment_rate,
    observation_flag,
    unit
FROM regional_unemployment_raw
WHERE observation_value IS NOT NULL
  AND country_or_region ILIKE 'DE%';
