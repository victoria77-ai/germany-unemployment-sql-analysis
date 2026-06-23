# SQL Analysis of Regional Unemployment Trends in Germany

## Project Overview
This project analyzes regional unemployment trends in Germany using SQL. The goal is to explore how unemployment rates changed across German regions between 2016 and 2025, identify regions with the highest and lowest unemployment rates, and compare regional labor market performance over time.

The dataset is based on Eurostat unemployment-rate data. It includes annual unemployment rates for people aged 15 to 74, covering total sex, all ISCED 2011 education levels, and values measured as percentages.

## Business Problem
Regional unemployment differences are important for policymakers, employers, recruiters, and labor market analysts. This project uses SQL to answer the following questions:
1. How has unemployment changed across German regions over time?
2. Which German regions had the highest unemployment rates?
3. Which German regions had the lowest unemployment rates?
4. Which regions improved the most between 2016 and 2025?
5. Which regions experienced worsening unemployment trends?

## Tools Used
- **PostgreSQL** (Database Engine)
- **Supabase** (Cloud Database Platform)
- **SQL** (Data Cleaning, Validation, and Analysis)
- **GitHub** (Version Control and Portfolio Hosting)

## Dataset Description
The original dataset contains annual unemployment-rate observations by country or region. The unemployment rate is measured as a percentage. For this project, I focused only on German regions by filtering region codes beginning with `DE`.

### Data Preparation
The original CSV file was imported into Supabase as a raw table named `regional_unemployment_raw`. The raw table contained a combined country/region field such as `DE: Germany` or `DEA3: Münster`.

To make the data easier to analyze, I created a cleaned SQL view named `germany_unemployment_clean`. This cleaned view separates region codes and region names, converts year and unemployment values into numeric formats, removes rows with missing unemployment values, and filters the dataset to German regions only.

## Cleaning SQL

```sql
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

Cleaning Steps Performed
 Extracted the region code from the combined ⁠country_or_region⁠ field.
 Extracted the region name from the combined ⁠country_or_region⁠ field.
 Converted the ⁠year⁠ column into an integer format.
 Converted ⁠observation_value⁠ into a numeric data type.
 Renamed ⁠observation_value⁠ to ⁠unemployment_rate⁠ for readability.
 Removed rows with missing unemployment values.
 Filtered the dataset explicitly to German regions (⁠DE%⁠).
 Retained observation flags for data-quality review.
Data Validation
After cleaning the dataset, I validated the Germany-focused view to ensure structural and numeric integrity.

Metric                                            Result
Total Rows                                          530
Total German Regions                                 55
First Year                                          2016
Latest Year                                         2025
Average Unemployment Rate                            3.64%
Lowest Unemployment Rate                              1.8%
Highest Unemployment Rate                             7.8%

Validation Query
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT region_code) AS total_regions,
    MIN(year) AS first_year,
    MAX(year) AS latest_year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_unemployment_rate,
    MAX(unemployment_rate) AS highest_unemployment_rate
FROM germany_unemployment_clean;

Analysis Queries
1. Average Unemployment Trend by Year
SELECT
    year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_region_rate,
    MAX(unemployment_rate) AS highest_region_rate
FROM germany_unemployment_clean
GROUP BY year
ORDER BY year;

2. Highest Unemployment Regions in 2025
SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate DESC
LIMIT 10;

3. Lowest Unemployment Regions in 2025
SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate ASC
LIMIT 10;

4. Regions with the Biggest Improvement (2016 to 2025)
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

5. Regions Worsening Over Time (2016 to 2025)
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

Initial Findings
 The cleaned Germany dataset contains 530 unemployment observations across 55 distinct German regions from 2016 to 2025.
 The average regional unemployment rate during this 10-year span was 3.64%.
 Structural variations are clear: the lowest recorded historical regional rate dropped to 1.8%, while the peak economic disparity hit an upper ceiling of 7.8%.
Skills Demonstrated
 Database view architecture & design
 String manipulation and parsing (⁠SPLIT_PART⁠, ⁠TRIM⁠)
 Data filtering & type-casting handles (⁠::INT⁠, ⁠::NUMERIC⁠)
 Advanced aggregation mechanics & groupings
 Self-joins for longitudinal time-series data comparisons
 Empirical data validation testing

Project Files
sql/01_create_clean_view.sql            Houses primary data cleaning and view generation script
sql/02_data_validation.sql              Validates records, unique contraints, and metrics check
sql/03_trend_analysis.sql               Aggregates mean metric tracking by calendar year boundaries
sql/04_highest_lowest_regions.sql      Identifies absolute geographic extremes in labour performance
sql/05_change_over_time.sql            Calculates structural movement shifts spanning 2016-2025

Conclusion
This project demonstrates how SQL can be effectively used to clean, structure, validate, and analyze real-world labor market data. By focusing granularly on regional German infrastructure, the project provides actionable employment insight relevant for localized macroeconomic profiling, recruitment tracking, and business expansion decision-making.                          
