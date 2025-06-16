SELECT *
FROM SQLProject..CovidDeaths
where continent is not null
ORDER BY 3,4

--SELECT *
--FROM SQLProject..CovidVaccinations
--ORDER BY 3,4


--select data to be used
select location, date, total_cases, new_cases, total_deaths, population
from SQLProject..CovidDeaths
where continent is not null
ORDER by 1,2

--total cases vs. totals deaths
--chances of dying by covid-19
select location, date, total_cases, total_deaths, (total_deaths*1.0/total_cases)*100 as DeathPercentage
from SQLProject..CovidDeaths
where location like '%india%'
and continent is not null
ORDER by 1,2

--total cases vs. population
--percentage of infected population
select location, date, population, total_cases, (total_cases*1.0/population)*100 as InfectedPopulationPercentage
from SQLProject..CovidDeaths
where location like '%india%'
and continent is not null
ORDER by 1,2

--countries with highest infection rate
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases*1.0/population))*100 as HighestInfectedPopulationPercentage
from SQLProject..CovidDeaths
where continent is not null
group by location, population
ORDER by HighestInfectedPopulationPercentage desc

--countries with highest deaths
-- to typecast a column, e.g., cast(total_deaths as int), convert(int, total_deaths)
select location, max(total_deaths) as totalDeathCount
from SQLProject..CovidDeaths
where continent is not null
group by location
ORDER by totalDeathCount desc


--continents with highest deaths
select continent, max(total_deaths) as totalDeathCount
from SQLProject..CovidDeaths
where continent is not null
group by continent
ORDER by totalDeathCount desc

--Global breakdown
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,sum(new_deaths)*1.0/sum(new_cases)*100 as DeathPercentage
from SQLProject..CovidDeaths
where continent is not null
--group by date
ORDER by 1,2


--total population vs. total vaccinations
select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
, sum(convert(int, vacs.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as vaccinatedPeople
from SQLProject..CovidDeaths deaths
join SQLProject..CovidVaccinations vacs
	on deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null
order by 2,3


--using CTE
with populationvsVaccinations(continent, location, date, population, new_vaccinations, vaccinatedPeople) 
as(
select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
, sum(convert(int, vacs.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as vaccinatedPeople
from SQLProject..CovidDeaths deaths
join SQLProject..CovidVaccinations vacs
	on deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null
--order by 2,3
)

select *, (vaccinatedPeople*1.0/population)*100
from populationvsVaccinations


	
--temp table
drop table if exists #PercentPopulationVaccineted
create table #PercentPopulationVaccineted(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinatedPeople numeric
)

insert into #PercentPopulationVaccineted
select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
, sum(convert(int, vacs.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as vaccinatedPeople
from SQLProject..CovidDeaths deaths
join SQLProject..CovidVaccinations vacs
	on deaths.location = vacs.location
	and deaths.date = vacs.date
--where deaths.continent is not null
--order by 2,3

select *, (vaccinatedPeople*1.0/population)*100
from #PercentPopulationVaccineted


--creating view for later visualization
create view PercentPopulationVaccineted as 
select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
, sum(convert(int, vacs.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as vaccinatedPeople
from SQLProject..CovidDeaths deaths
join SQLProject..CovidVaccinations vacs
	on deaths.location = vacs.location
	and deaths.date = vacs.date
where deaths.continent is not null
--order by 2,3


select *
from PercentPopulationVaccineted
