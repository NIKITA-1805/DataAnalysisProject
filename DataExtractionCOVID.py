import pandas as pd


data = pd.read_csv('CovidDeaths.csv')
dataVacs = pd.read_csv('CovidVaccinations.csv')

filteredData  = data[data['continent'].notna()]
sortedData = filteredData.sort_values(by = ['location', 'date'])


covidSummary = sortedData[['location', 'date', 'total_cases', 'new_cases', 'total_deaths', 'population']]


indiaData = filteredData[filteredData['location'].str.lower().str.contains('india')]
indiaDeathRate = indiaData[['location', 'date', 'total_cases', 'total_deaths']].copy()
indiaDeathRate['DeathPercentage'] = (indiaDeathRate['total_deaths']/indiaDeathRate['total_cases'])*100
indiaDeathRate = indiaDeathRate.sort_values(by = ['location', 'date'])


indiaInfectionData = filteredData[filteredData['location'].str.lower().str.contains('india')]
indiaInfectionRate = indiaInfectionData[['location', 'date', 'population', 'total_cases']].copy()
indiaInfectionRate['InfectedPopulationPercentage'] = (indiaInfectionRate['total_cases']/indiaInfectionRate['population'])*100
indiaInfectionRate = indiaInfectionRate.sort_values(by = ['location', 'date'])


infectionData = filteredData.copy()
infectionData['InfectionPercentage'] = (infectionData['total_cases']/infectionData['population'])*100
highestInfection = infectionData.groupby(['location', 'population'], as_index = False).agg({
    'total_cases' : 'max',
    'InfectionPercentage' : 'max'
})
highestInfection.rename(columns = {
    'total_cases' : 'HighestInfectionCount',
    'InfectionPercentage' : 'HighestInfectionPopulationPercentage'
}, inplace = True)
highestInfection = highestInfection.sort_values(by = 'HighestInfectionPopulationPercentage', ascending = False)


deathData = filteredData.copy()
deathData['total_deaths'] = deathData['total_deaths'].fillna(0)
highestDeaths = deathData.groupby('location', as_index = False)['total_deaths'].max()
highestDeaths.rename(columns = {'total_deaths' : 'TotalDeathCount'}, inplace = True)
highestDeaths = highestDeaths.sort_values(by = 'TotalDeathCount', ascending = False)


continentDeaths = filteredData.groupby('continent', as_index = False)['total_deaths'].max()
continentDeaths.rename(columns = {'total_deaths' : 'TotalDeathCount'}, inplace = True)
continentDeaths = continentDeaths.sort_values(by = 'TotalDeathCount', ascending = False)


globalData = filteredData.copy()
globalData['new_cases'] = globalData['new_cases'].fillna(0)
globalData['new_deaths'] = globalData['new_deaths'].fillna(0)
total_cases = globalData['new_cases'].sum()
total_deaths = globalData['new_deaths'].sum()
globalDeathPercentage = (total_deaths/total_cases)*100 if total_cases != 0 else 0
print("Global Total Cases:", total_cases)
print("Global Total Deaths:", total_deaths)
print("Global Death Percentage: {:.2f}%".format(globalDeathPercentage))


mergeData = pd.merge(
    filteredData,
    dataVacs,
    on=['location', 'date'],
    how='left'
)
mergeData = mergeData[mergeData['continent_x'].notna()]
mergeData.rename(columns={'continent_x': 'continent'}, inplace=True)
mergeData['new_vaccinations'] = pd.to_numeric(mergeData['new_vaccinations'], errors='coerce').fillna(0)
mergeData['vaccinatedPeople'] = (
    mergeData.sort_values(by=['location', 'date'])
    .groupby('location')['new_vaccinations']
    .cumsum()
)

vaccinationSummary = mergeData[['continent', 'location', 'date', 'population', 'new_vaccinations', 'vaccinatedPeople']] \
    .sort_values(by=['location', 'date'])


vaccinationSummary['VaccinatedPercentage'] = (
    vaccinationSummary['vaccinatedPeople'] / vaccinationSummary['population']
)*100


percentagePopulationVaccinated = vaccinationSummary.copy()
percentagePopulationVaccinated['VaccinatedPercentage'] = (
    percentagePopulationVaccinated['vaccinatedPeople'] / percentagePopulationVaccinated['population']
)*100
percentagePopulationVaccinated['VaccinatedPercentage'] = percentagePopulationVaccinated['VaccinatedPercentage'].round(2)


percentagePopulationView = vaccinationSummary.copy()
percentagePopulationView.rename(columns = {'continent_y' : 'continent'}, inplace = True)
percentagePopulationView['VaccinatedPercentage'] = (
    percentagePopulationView['vaccinatedPeople'] / percentagePopulationView['population']
)*100
percentagePopulationView['VaccinatedPercentage'] = percentagePopulationView['VaccinatedPercentage'].round(2)
percentagePopulationView.to_csv('PercentPopulationVaccinatedView.csv', index = False)
