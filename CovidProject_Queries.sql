select location,date,iso_code,total_cases,new_cases,total_deaths,population
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
order by 1,2

-- let's look at total cases vs total deaths
select location,date,iso_code,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_percentage
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
order by 1,2

--let's look at total cases vs population
select location,date,iso_code,total_cases,population,(total_cases/population)*100 as Infected_percentage
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
-- where location like '%India%'
order by 1,2

--loooking for countries with highest infection rate
select location,max(total_cases) as Highest_no_of_cases,population,max(total_cases/population)*100 as Highest_Infected_percentage
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
group by population,location
order by Highest_Infected_percentage DESC 

--A/C to continents
select continent,max(cast(total_deaths AS int)) as TotalDeathCount
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
where continent is not null 
group by continent
order by TotalDeathCount desc

--A/C to continents
select location,max(cast(total_deaths AS int)) as TotalDeathCount
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
where continent is null 
group by location
order by TotalDeathCount desc

--showing continents with highest death counts per population


--Global numbers
select sum(new_cases) as TotalNewCases,sum(cast(new_deaths as int)) as TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases) as NewDeathPercentage
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths`
where continent is not null 
-- group by date
order by NewDeathPercentage desc 

-- Looking at TotalPopulation vs. TotalVaccination
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as NoofPeopleVaccinated 
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths` dea
join `stellar-fin-316605.portfolio_projectt_1.covid_vaccination` vacc
on dea.location=vacc.location 
and dea.date=vacc.date
where dea.continent is not null 
-- where dea.location like '%India%'
order by 2,3




--use CTE for using created col
with vacpop as(
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as NoofPeopleVaccinated 
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths` dea
join `stellar-fin-316605.portfolio_projectt_1.covid_vaccination` vacc
on dea.location=vacc.location 
and dea.date=vacc.date
where dea.continent is not null 
-- order by 2,3 
)
select *,(NoofPeopleVaccinated	/population)*100
from vacpop






--create table
create table `stellar-fin-316605.portfolio_projectt_1.PopulationGotVaccinated`
(
    continent string(255),
Location string(255),
Date datetime,
Population numeric,
NewVaccinations numeric,
NoofPeopleVaccinated numeric
)

INSERT INTO `stellar-fin-316605.portfolio_projectt_1.PopulationGotVaccinated`
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as NoofPeopleVaccinated 
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths` dea
join `stellar-fin-316605.portfolio_projectt_1.covid_vaccination` vacc
on dea.location=vacc.location 
and dea.date=vacc.date
-- where dea.continent is not null 


select *,(NoofPeopleVaccinated	/population)*100
from `stellar-fin-316605.portfolio_projectt_1.PopulationGotVaccinated`



--create view
create view `stellar-fin-316605.portfolio_projectt_1.PopulationGotVaccinated` as 
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
sum(cast(vacc.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)  as NoofPeopleVaccinated 
from `stellar-fin-316605.portfolio_projectt_1.covid_deaths` dea
join `stellar-fin-316605.portfolio_projectt_1.covid_vaccination` vacc
on dea.location=vacc.location 
and dea.date=vacc.date
where dea.continent is not null 
