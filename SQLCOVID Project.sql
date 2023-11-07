select * 
From CovidPortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4


--select * 
--From CovidPortfolioProject..CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
From CovidPortfolioProject..CovidDeaths
Order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolioProject..CovidDeaths
Where Location like '%state%'
Order by 1,2
 

 --Looking at total cases vs population
 --Shows what percentage of population got Covid
select Location, date, population, total_cases,  (total_cases/population)*100 as InfectedPercentage
From CovidPortfolioProject..CovidDeaths
Where Location like '%state%'
Order by 1,2


--What countries have highest infection rates

select Location, population, Max(total_cases) as HighestCaseCount,  Max((total_cases/population))*100 as InfectedPercentage
From CovidPortfolioProject..CovidDeaths
Group By Location, population
Order by InfectedPercentage desc


--What countries have highest death rates

select Location, Max(total_deaths) as TotalDeathCount
From CovidPortfolioProject..CovidDeaths
Where continent is not null
Group By Location
Order by TotalDeathCount desc


--Lets's Break Things down by continent

select Location, Max(total_deaths) as TotalDeathCount
From CovidPortfolioProject..CovidDeaths
Where continent is null
Group By Location
Order by TotalDeathCount desc

select continent, Max(total_deaths) as TotalDeathCount
From CovidPortfolioProject..CovidDeaths
Where continent is not null
Group By Continent
Order by TotalDeathCount desc



-- Global Numbers

select nullif(sum(new_cases), 0) as cases, nullif(sum(new_deaths), 0) as deaths, nullif(sum(new_deaths), 0)/nullif(sum(new_cases), 0)*100 as DeathPercentage
From CovidPortfolioProject..CovidDeaths
where continent is not null
--Group By Date
order by 1, 2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidPortfolioProject..CovidDeaths dea
Join CovidPortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Use CTE

With PopvsVac(Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidPortfolioProject..CovidDeaths dea
Join CovidPortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)

SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinatedPercentage
From PopvsVac

--Use Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidPortfolioProject..CovidDeaths dea
Join CovidPortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

SELECT *, (RollingPeopleVaccinated/population)*100 as VaccinatedPercentage
From #PercentPopulationVaccinated




--Creating view to store data for later visualizations

CREATE VIEW PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidPortfolioProject..CovidDeaths dea
Join CovidPortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
From PercentagePopulationVaccinated