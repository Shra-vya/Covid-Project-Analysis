# Covid-Project-Analysis
COVID-19 Data Analysis | SQL (CTE, Window Functions) | Tableau Dashboard | Healthcare Analytics

## Executive Summary

This project analyzes global COVID-19 data to identify trends in infection rates, death percentages, and vaccination progress across countries and continents.

The business problem focuses on understanding which regions are most impacted and how the spread evolves over time to support data-driven public health decisions.

The solution involved cleaning and transforming raw data using PostgreSQL and building interactive dashboards in Tableau, enabling quick comparison across regions and time periods.

The analysis highlighted high-risk regions and peak infection periods, improving the ability to monitor trends efficiently compared to manual analysis.

Next steps include incorporating real-time data updates and deeper demographic-level insights.

## Business Problem

Organizations and policymakers need a clear understanding of:

1) Which countries and continents are most affected
2) How infection and death rates evolve over time
3) The progress and impact of vaccination efforts

Without structured analysis, raw data makes it difficult to:

1) Identify high-risk regions
2) Track trends efficiently
3) Make timely decisions

This project addresses these challenges by transforming raw COVID-19 data into actionable insights.

## Methodology
1) Cleaned and prepared raw CSV data using Google Sheets
2) Imported and transformed data in PostgreSQL

Performed:
1) Joins between datasets
2) Aggregations (SUM, MAX)
3) CTEs for structured queries
4) Window functions for rolling vaccination totals

Built interactive dashboards in Tableau including:
1) KPI summary (cases, deaths, %)
2) Continent-level comparisons
3) Geographic infection map
4) Time-series trends

## Skills
SQL (Joins, Aggregations, CTEs, Window Functions)
Data Cleaning (handling nulls, formatting)
Data Visualization (Tableau dashboards)
Analytical Thinking
Data Transformation

## Results & Business Recommendations
Key Insights:
1) Certain regions show significantly higher infection rates relative to population
2) Death percentages vary across continents, indicating differences in healthcare response
3) Vaccination rollout trends highlight uneven progress across countries

Recommendations:
1) Prioritize resources for high infection-rate regions
2) Monitor time-based trends to anticipate future spikes
3) Use vaccination trend analysis to optimize distribution strategies

## Next Steps
1) Integrate real-time or updated datasets for continuous monitoring
2) Include demographic-level analysis (age, density, etc.)
3) Enhance dashboard interactivity for deeper filtering
4) Address limitations such as missing or inconsistent data values
