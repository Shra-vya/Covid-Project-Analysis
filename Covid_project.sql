SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY location, date;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE location like'%states%'
ORDER BY location, date;

SELECT location, date, total_cases, total_deaths,
       (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location LIKE '%states%'
ORDER BY location, date;

SELECT location, date, total_cases, total_deaths,
       (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY location, date;

SELECT location, date, population, total_cases,
       (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS DeathPercentage
FROM covid_deaths
WHERE location = 'United States'
ORDER BY location, date;

--looking where countries are highly infected
SELECT location, population,
       MAX(CAST(total_cases AS FLOAT)) AS highestInfectCountry,
       MAX(
           (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0)) * 100
       ) AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC NULLS Last;

--Showing countries with highest death counts per population
SELECT location,
       MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC NULLS LAST;

--Lets break this by continents

SELECT continent,
       MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC NULLS LAST;

SELECT 
    SUM(CAST(new_cases AS FLOAT)) AS totalcases,
    SUM(CAST(new_deaths AS FLOAT)) AS totaldeaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL;

--Covid vaccination data
SELECT *
FROM covid_deaths dea
JOIN covid_vaccination vac
ON dea.location = vac.location
AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY');

--Total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccination vac
ON dea.location = vac.location
AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY')
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;


-- RollingPeopleVaccinated:
-- This calculates a running total of vaccinations for each country over time.
-- Example:
-- Date         New Vaccinations     Running Total
-- 2020-01-01        100                  100
-- 2020-01-02        200                  300   (100 + 200)
-- 2020-01-03        300                  600   (300 + 300)
-- So each day adds to the previous total.

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS FLOAT)) 
       OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccination vac
ON dea.location = vac.location
AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY')
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

--USE Common table expression (CTE)
WITH popvsvac AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS FLOAT)) 
           OVER (PARTITION BY dea.location ORDER BY dea.date) AS rollingpeoplevaccinated
    FROM covid_deaths dea
    JOIN covid_vaccination vac
    ON dea.location = vac.location
    AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY')
    WHERE dea.continent IS NOT NULL
)

SELECT *,
       (rollingpeoplevaccinated / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS percentvaccinated
FROM popvsvac;

--TEMP Table

CREATE TEMP TABLE percentpopulationvaccinated (
    continent TEXT,
    location TEXT,
    date DATE,
    population FLOAT,
    new_vaccinations FLOAT,
    rollingpeoplevaccinated FLOAT
);

INSERT INTO percentpopulationvaccinated
SELECT dea.continent, dea.location, dea.date, 
       CAST(dea.population AS FLOAT), 
       CAST(vac.new_vaccinations AS FLOAT),
       SUM(CAST(vac.new_vaccinations AS FLOAT)) 
       OVER (PARTITION BY dea.location ORDER BY dea.date)
FROM covid_deaths dea
JOIN covid_vaccination vac
ON dea.location = vac.location
AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY')
WHERE dea.continent IS NOT NULL;

SELECT *,
       (rollingpeoplevaccinated / NULLIF(population, 0)) * 100 AS percentvaccinated
FROM percentpopulationvaccinated;

--creating view to store data for later
CREATE VIEW percentpopulationvaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS FLOAT)) 
       OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccination vac
ON dea.location = vac.location
AND dea.date = TO_DATE(vac.date, 'DD/MM/YYYY')
WHERE dea.continent IS NOT NULL;


SELECT *
FROM percentpopulationvaccinated;