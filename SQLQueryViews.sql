--table 1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))*1.0/SUM(New_Cases)*100 as DeathPercentage
From SQLProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--table 2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From SQLProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--table 3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases*1.0/population))*100 as PercentPopulationInfected
From SQLProject..CovidDeaths
--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc


--table 4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases*1.0/population))*100 as PercentPopulationInfected
From SQLProject..CovidDeaths
--Where location like '%india%'
Group by Location, Population, date
order by PercentPopulationInfected desc