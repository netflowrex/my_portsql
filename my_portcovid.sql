create database my_portcovid;

use my_portcovid;

select *
from coviddeaths1;

select *
from coviddeaths1
order by 4,6;

-- Utilizing COVID-19 data from Alex Freberg's Data Analysis Bootcamp, I'm analyzing trends and insights across 1000 rows of data --
-- My focus includes identifying highest death rates by continent, tracking new cases, and comparing hospitalization statistics.This project showcases my data analysis skills for my portfolio. --

/*
Here are posible questions i'll be asking usin the data 

Highest Death Rate by Continent:

Identify the continent with the highest average death rate.
Total Cases and Deaths by Month:

Summarize total cases and total deaths for each month.
Country with Highest New Cases Smoothed Per Million:

Determine the country with the highest new cases smoothed per million on a specific date.
Weekly Average ICU Patients by Continent:

Calculate the average number of ICU patients per million on a weekly basis for each continent.
Countries with Decreasing Death Rates:

List countries with consistently decreasing death rates over the past week.
Total Cases in Relation to Population:

Find the ratio of total cases to population for each continent.
Countries with Reproduction Rate Below 1:

Identify countries with a reproduction rate consistently below 1 over the last two weeks.
Most Common Reproduction Rate Range:

Determine the most common range of reproduction rates among all countries.
Highest Weekly Hospital Admissions Rate:

Find the country with the highest weekly hospital admissions rate per million during a specific period.
Comparing Total Deaths in Specific Countries:

Compare the total deaths over time for specific countries.
*/

-- Identify the continent (5) with the highest average death rate.--


SELECT continent, AVG(total_deaths * 100.0 / total_cases) AS avg_death_rate
FROM coviddeaths1
GROUP BY continent
ORDER BY avg_death_rate DESC
LIMIT 5;

-- Summarize total cases and total deaths for each month.--

SELECT
    SUBSTRING_INDEX(date, '-', -1) AS year,
    SUBSTRING_INDEX(SUBSTRING_INDEX(date, '-', 1), '-', -1) AS month,
    SUM(total_cases) AS total_cases,
    SUM(total_deaths) AS total_deaths
FROM coviddeaths1
GROUP BY year,month
ORDER BY year,month;

-- Determine the country (10) with the highest new cases smoothed per million on a specific date.--

SELECT location, new_cases_smoothed_per_million
FROM coviddeaths1
WHERE date = '3/18/2020'
ORDER BY new_cases_smoothed_per_million DESC
LIMIT 10;

-- Calculate the average number of ICU patients per million on a weekly basis for each continent --

SELECT continent,
       WEEK(STR_TO_DATE(date, '%d-%m-%Y')) AS week_number,
       AVG(icu_patients_per_million) AS avg_icu_patients_per_million
FROM coviddeaths1
GROUP BY continent, week_number
ORDER BY continent, week_number;

-- List countries with consistently decreasing death rates over the past week. --

SELECT location,sum(new_deaths_smoothed) as decreasing_deaths
FROM coviddeaths1 c
GROUP BY location
HAVING SUM(CASE WHEN new_deaths_smoothed > 0 THEN 1 ELSE 0 END) 
    AND MIN(new_deaths_smoothed) <= MAX(new_deaths_smoothed)
ORDER BY location
limit 5;

-- Find the ratio of total cases to population for each continent.--


SELECT continent, SUM(total_cases) / SUM(population) AS cases_to_population_ratio
FROM coviddeaths1
GROUP BY continent;

-- Identify countries with a reproduction rate consistently below 1 over the last two weeks.--

SELECT location,AVG(reproduction_rate) as reproduction_rate 
FROM coviddeaths1 
GROUP BY location
HAVING AVG(reproduction_rate) < 1
ORDER BY location
limit 10;

-- Find the country with the highest weekly hospital admissions rate per million during a specific period.--

SELECT location, MAX(weekly_hosp_admissions_per_million) AS max_hospital_admissions_rate
FROM coviddeaths1
WHERE date BETWEEN '2/24/2020' AND '4/13/2021'
GROUP BY location
ORDER BY max_hospital_admissions_rate DESC
LIMIT 5;

-- Compare the total deaths over time for specific countries. --

SELECT date, location, total_deaths
FROM coviddeaths1
WHERE location IN ('denmrk', 'united kingdom', 'canada') -- Replace with your desired countries
ORDER BY date
limit 10;

-- Determine the most common range of reproduction rates among all countries. --

SELECT location,ROUND(reproduction_rate, 1) AS rate_range, COUNT(*) AS count
FROM coviddeaths1
GROUP BY rate_range,location
ORDER BY count DESC
LIMIT 5;



--  my covidvaccination data --

/* 
Here are possible question i can ask base on the data given 
What is the average positive rate of COVID-19 tests across all locations?
Which location has the highest total number of tests per thousand people?
What is the total number of people fully vaccinated per hundred people in each continent?
Which location has administered the highest number of new vaccinations recently?
What is the median age of the population in the continent with the highest total vaccinations?
Which location has the highest GDP per capita?
What is the average diabetes prevalence across all locations?
What percentage of females and males are smokers on average?
Which location has the highest number of hospital beds per thousand people?
What is the average human development index (HDI) across all locations?
*/

select *
from covidvaccinations2 as v
order by 5,15;

/*
What is the average positive rate of COVID-19 tests across all locations?
*/


SELECT location, AVG(positive_rate) AS average_positive_rate
FROM covidvaccinations2
GROUP BY location
ORDER BY average_positive_rate DESC
LIMIT 5;

/*
Which location has the highest total number of tests per thousand people?
*/


/*
What is the total number of people fully vaccinated per hundred people in each continent?
*/

SELECT continent, SUM(people_fully_vaccinated_per_hundred) AS total_fully_vaccinated_per_hundred
FROM covidvaccinations2
GROUP BY continent;

/*
Which location has administered the highest number of new vaccinations recently?
*/

SELECT location, MAX(new_vaccinations) AS highest_new_vaccinations
FROM covidvaccinations2
GROUP BY location
ORDER BY highest_new_vaccinations DESC
LIMIt 5;

/*
What is the median age of the population in the continent with the highest total vaccinations?
*/

SELECT continent, median_age
FROM covidvaccinations2
WHERE total_vaccinations = (
    SELECT MAX(total_vaccinations)
    FROM covidvaccinations2
)
LIMIT 1;

/*
Which location has the highest GDP per capita?
*/


SELECT location, MAX(gdp_per_capita) AS highest_gdp_per_capita
FROM covidvaccinations2
GROUP BY location
ORDER BY highest_gdp_per_capita DESC
LIMIT 5;

/*
What is the average diabetes prevalence across all locations?
*/

SELECT AVG(diabetes_prevalence) AS average_diabetes_prevalence
FROM covidvaccinations2;

/*
What percentage of females and males are smokers on average?
*/

SELECT AVG(female_smokers) AS average_female_smokers,
       AVG(male_smokers) AS average_male_smokers
FROM covidvaccinations2;

/*
Which location has the highest number of hospital beds per thousand people?
*/

SELECT location, MAX(hospital_beds_per_thousand) AS highest_beds_per_thousand
FROM covidvaccinations2
GROUP BY location
ORDER BY highest_beds_per_thousand DESC
LIMIT 5;

/*
What is the average human development index (HDI) across all locations?
*/

SELECT AVG(human_development_index) AS average_hdi
FROM covidvaccinations2;

-- use both table in join statements --

/*
Here possible question 

What is the average COVID-19 death rate per million population among countries that have administered at least 500,000 vaccinations?

Among countries with a GDP per capita above $40,000, which location has the highest total number of deaths?

What is the average percentage of fully vaccinated people across all locations?

Which location has the highest ratio of total deaths to total vaccinations administered?

*/

/*
What is the average COVID-19 death rate per million population among countries that have administered at least 500,000 vaccinations?
*/

SELECT AVG(cd.total_deaths / cd.population * 1000000) AS average_death_rate
FROM coviddeaths1 cd
JOIN covidvaccinations2 cv ON cd.location = cv.location
WHERE cv.total_vaccinations >= 500000;

/*
Among countries with a GDP per capita above $40,000, which location has the highest total number of deaths?
*/

SELECT cv.location, cd.total_deaths
FROM coviddeaths1 cd
JOIN covidvaccinations2 cv ON cd.location = cv.location
WHERE cv.gdp_per_capita < 40000
ORDER BY cd.total_deaths DESC
LIMIT 5;

/*
What is the average percentage of fully vaccinated people across all locations?
*/

SELECT AVG(people_fully_vaccinated / population_density * 100) AS average_percentage_fully_vaccinated
FROM covidvaccinations2;


/*
Which location has the highest ratio of total deaths to total vaccinations administered?
*/

SELECT cv.location, 
       (cd.total_deaths / cv.total_vaccinations) AS death_to_vaccination_ratio
FROM coviddeaths1 cd
JOIN covidvaccinations2 cv ON cd.location = cv.location
ORDER BY death_to_vaccination_ratio DESC
LIMIT 2;





