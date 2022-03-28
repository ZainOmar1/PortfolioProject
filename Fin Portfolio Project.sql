Select *
from PortfolioProject..[Covid Deaths]


select * 
from PortfolioProject..[Covid Vaccinations]

-- Data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,new_deaths,population
from PortfolioProject..[Covid Deaths]
order by 1,2

-- Looking at Total Cases vs Total Deaths in the United States

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
where location like '%states%'
order by 1,2

-- COUNTRY NUMBERS

-- Looking at Total Cases vs Population
-- Showing what percentage of Population was infected at a given time

Select location,date,Population,total_cases,(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..[Covid Deaths]
order by 1,2

-- Showing Countries with Highest Infection Rate compared to Population

Select location,Population,max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as InfectionRate
from PortfolioProject..[Covid Deaths]
group by location,population
order by InfectionRate desc

-- Showing Countries with Highest Death Count

select location,max(cast(total_deaths as bigint)) as DeathCount
from PortfolioProject..[Covid Deaths]
where continent is not null
group by location
order by DeathCount desc


-- Showing Countries with Highest Death Count compared to Population

select location, population, max(cast(total_deaths as bigint)) as HighestDeaths, Max(cast(total_deaths as bigint))/population *100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
group by location,population
order by DeathPercentage desc

-- CONTINENT NUMBERS

-- Showing Continents with Highest Infection Rate compared to Population

Select location,Population,max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as InfectionRate
from PortfolioProject..[Covid Deaths]
where location not like '%Income%'
and location not like 'world'
and location not like 'international'
and continent is null
and location not like '%union%'
group by location,population
order by InfectionRate desc

--Showing Continents with Highest Death Count

select location,max(cast(total_deaths as bigint)) as DeathCount
from PortfolioProject..[Covid Deaths]
where location not like '%Income%'
and location not like 'world'
and location not like 'international'
and continent is null
and location not like '%union%'
group by location
order by DeathCount desc

--Showing Continents with Highest Death Count Compared to Population

select location, population ,max(cast(total_deaths as bigint)) as DeathCount, max(cast(total_deaths as bigint))/population *100 as DeathCountPercentage
from PortfolioProject..[Covid Deaths]
where location not like '%Income%'
and location not like 'world'
and location not like 'international'
and continent is null
and location not like '%union%'
group by location, population
order by DeathCountPercentage desc

--Looking at Global Numbers

--Global Cases, Deaths, and Death Percentage of people who have contracted Covid

--All Time
Select sum(New_cases) as TotalCases, sum(cast(New_deaths as bigint)) as TotalDeaths, Sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
where continent is not null
--Daily
Select date,sum(New_cases) as TotalCases, sum(cast(New_deaths as bigint)) as TotalDeaths, Sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
where continent is not null
group by date


--COVID DEATHS AND VACCINATION TABLE JOINED

--Looking at the total amount of vaccinations given out by country

select deaths.location, deaths.date,new_vaccinations,sum(cast(new_vaccinations as bigint)) over (partition by deaths.location order by deaths.date) as TotalVaccinations 
from PortfolioProject..[Covid Deaths] Deaths
join PortfolioProject..[Covid Vaccinations] Vac
	on deaths.location=vac.location
	and deaths.date=vac.date
where deaths.continent is not null
group by deaths.location, deaths.date, new_vaccinations
order by 1,2

--Looking at People Fully Vaccinated vs Population using CTE

with VaccinationPercentage(location,population,PeopleFullyVaccinated)
as
(
select deaths.location,population, max(cast(people_fully_vaccinated as bigint)) as PeopleFullyVaccinated
from PortfolioProject..[Covid Deaths] as Deaths
join PortfolioProject..[Covid Vaccinations] Vac
	on deaths.location=vac.location
	and deaths.date=vac.date
where deaths.continent is not null
group by deaths.location,population
)
Select *,(PeopleFullyVaccinated/population)*100 as PercentPeopleFullyVaccinated
from VaccinationPercentage
order by PercentPeopleFullyVaccinated desc


--Looking at People Fully Vaccinated vs Population using a TempTable

DROP table if exists #PercentPopulationFullyVaccinated
Create Table #PercentPopulationFullyVaccinated
(
location varchar (55),
population numeric,
PeopleFullyVaccinated numeric
)
insert into #PercentPopulationFullyVaccinated
select deaths.location,population, max(cast(people_fully_vaccinated as bigint)) as PeopleFullyVaccinated
from PortfolioProject..[Covid Deaths] as Deaths
join PortfolioProject..[Covid Vaccinations] Vac
	on deaths.location=vac.location
	and deaths.date=vac.date
where deaths.continent is not null
group by deaths.location,population
order by PeopleFullyVaccinated

select *, (PeopleFullyVaccinated/population)*100 as PercentPopulationFullyVaccinated
from #PercentPopulationFullyVaccinated
order by percentpopulationfullyvaccinated desc













