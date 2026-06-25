# SQL Analysis of Regional Unemployment Trends in Germany

## Project Overview

This project analyzes regional unemployment trends in Germany using SQL. The goal is to explore how unemployment rates changed across German regions between 2016 and 2025, identify regions with the highest and lowest unemployment rates, and compare regional labor market performance over time.

The dataset is based on Eurostat unemployment-rate data. It includes annual unemployment rates for people aged 15 to 74, covering total sex, all ISCED 2011 education levels, and values measured as percentages [1].

## Business Problem

Regional unemployment differences are important for policymakers, employers, recruiters, and labor market analysts. This project uses SQL to answer the following questions:

1. How has unemployment changed across German regions over time?
2. Which German regions had the highest unemployment rates?
3. Which German regions had the lowest unemployment rates?
4. Which regions improved the most between 2016 and 2025?
5. Which regions experienced worsening unemployment trends?

## Tools Used

- **PostgreSQL** - Database engine
- **Supabase** - Cloud database platform
- **SQL** - Data cleaning, validation, and analysis
- **GitHub** - Portfolio hosting and documentation

## Dataset Description

The original dataset contains annual unemployment-rate observations by country or region. The unemployment rate is measured as a percentage.

For this project, I focused only on German regions by filtering region codes beginning with `DE`.

The raw dataset includes fields related to:

- Frequency
- Education level
- Sex
- Age group
- Unit of measurement
- Country or region
- Year
- Observation value
- Observation flag

The dataset also includes observation flags such as `b: break in time series`, which are useful for reviewing data quality [1].

## Data Preparation

The original CSV file was imported into Supabase as a raw table named:

`regional_unemployment_raw`

The raw table contained a combined country/region field such as:

`DE: Germany`

or:

`DEA3: Münster`

To make the data easier to analyze, I created a cleaned SQL view named:

`germany_unemployment_clean`

This cleaned view separates region codes and region names, converts year and unemployment values into numeric formats, removes rows with missing unemployment values, and filters the dataset to German regions only.

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
```

## Cleaning Steps Performed

- Extracted the region code from the combined `country_or_region` field.
- Extracted the region name from the combined `country_or_region` field.
- Converted the `year` column into an integer format.
- Converted `observation_value` into a numeric data type.
- Renamed `observation_value` to `unemployment_rate` for readability.
- Removed rows with missing unemployment values.
- Filtered the dataset to German regions only using `ILIKE 'DE%'`.
- Retained observation flags for data-quality review.

## Data Validation

After cleaning the dataset, I validated the Germany-focused view to check the number of rows, number of regions, available years, and unemployment-rate range.

| Metric | Result |
|---|---:|
| Total Rows | 530 |
| Total German Regions | 55 |
| First Year | 2016 |
| Latest Year | 2025 |
| Average Unemployment Rate | 3.64% |
| Lowest Unemployment Rate | 1.8% |
| Highest Unemployment Rate | 7.8% |

## Validation Query

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT region_code) AS total_regions,
    MIN(year) AS first_year,
    MAX(year) AS latest_year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_unemployment_rate,
    MAX(unemployment_rate) AS highest_unemployment_rate
FROM germany_unemployment_clean;
```

## Analysis Queries

### 1. Average Unemployment Trend by Year

This query calculates the average unemployment rate across German regions for each year. It also shows the lowest and highest regional unemployment rate in each year.

```sql
SELECT
    year,
    ROUND(AVG(unemployment_rate), 2) AS avg_unemployment_rate,
    MIN(unemployment_rate) AS lowest_region_rate,
    MAX(unemployment_rate) AS highest_region_rate
FROM germany_unemployment_clean
GROUP BY year
ORDER BY year;
```

### 2. Highest Unemployment Regions in 2025

This query identifies the German regions with the highest unemployment rates in the latest available year.

```sql
SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate DESC
LIMIT 10;
```

### 3. Lowest Unemployment Regions in 2025

This query identifies the German regions with the lowest unemployment rates in the latest available year.

```sql
SELECT
    region_code,
    region_name,
    unemployment_rate
FROM germany_unemployment_clean
WHERE year = 2025
ORDER BY unemployment_rate ASC
LIMIT 10;
```

### 4. Regions with the Biggest Improvement from 2016 to 2025

This query compares unemployment rates in 2016 and 2025 to identify regions where unemployment decreased the most.

```sql
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
```

### 5. Regions Where Unemployment Increased from 2016 to 2025

This query identifies regions where unemployment was higher in 2025 than in 2016.

```sql
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
```

## Initial Findings

- The cleaned Germany dataset contains **530 unemployment observations** across **55 German regions** from **2016 to 2025**.
- The average unemployment rate across all German regional observations was **3.64%**.
- The lowest unemployment rate recorded in the cleaned Germany dataset was **1.8%**.
- The highest unemployment rate recorded in the cleaned Germany dataset was **7.8%**.
- Observation flags were retained to support data-quality review.

## Skills Demonstrated

This project demonstrates the following SQL and data-analysis skills:

- Importing CSV data into a cloud PostgreSQL database
- Creating SQL views
- Cleaning raw data for analysis
- String manipulation using `SPLIT_PART` and `TRIM`
- Data type conversion using `::INT` and `::NUMERIC`
- Filtering rows using `WHERE`
- Handling missing values
- Aggregating data using `COUNT`, `AVG`, `MIN`, and `MAX`
- Grouping results using `GROUP BY`
- Sorting results using `ORDER BY`
- Comparing values over time using self-joins
- Performing data validation checks
- Translating SQL results into business insights

## Project Files

| File | Description |
|---|---|
| `sql/01_create_clean_view.sql` | Creates the cleaned Germany unemployment view |
| `sql/02_data_validation.sql` | Validates row count, regions, years, and unemployment values |
| `sql/03_trend_analysis.sql` | Analyzes unemployment trends by year |
| `sql/04_highest_lowest_regions.sql` | Finds highest and lowest unemployment regions |
| `sql/05_change_over_time.sql` | Compares unemployment changes from 2016 to 2025 |

## Conclusion

This project demonstrates how SQL can be used to clean, structure, validate, and analyze real-world labor market data.

By focusing on German regional unemployment trends, the analysis provides insight into regional labor market differences and shows how SQL can support data-driven decision-making.

## Future Improvements

Possible future improvements include:

- Creating a Power BI or Tableau dashboard.
- Adding charts to visualize unemployment trends over time.
- Comparing Germany with other European countries.
- Performing deeper analysis of rows with observation flags.
- Adding year-over-year percentage change calculations.

## Data Source

Eurostat unemployment-rate dataset: annual unemployment rates by region, age group 15-74, total sex, all ISCED 2011 education levels, measured as percentages [1].                      
