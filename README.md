# 🦠 COVID-19 Data Analysis & Visualization

This project analyzes global COVID-19 data using SQL Server for data processing and Tableau for insightful visualization. It provides a clear picture of total cases, deaths, infection rates, and trends across countries and continents. The dataset includes details on confirmed cases, deaths, population, and vaccinations.

## 📁 Project Structure

- **SQL Queries**: Data cleaning, aggregation, and trend analysis using SQL Server
- **Tableau Dashboard**: Visual representation of the data
- **Data Source**: COVID-19 data from [Our World in Data](https://ourworldindata.org/covid-deaths)

---

## 📊 Dashboard Overview

The Tableau dashboard presents:

### 🔹 Global Statistics
- Total Cases
- Total Deaths
- Global Death Percentage

### 🔹 Deaths by Continent
- Bar chart showing total deaths grouped by continent

### 🔹 Percent Population Infected (Map View)
- Choropleth world map showing infection percentages per country

### 🔹 Infection Trend Over Time
- Multi-country line chart showing how infection rates evolved month by month

---

## 🧮 SQL Analysis

### ✅ Key Metrics Calculated:

- **Global Death Percentage**  
  ```sql
  SUM(new_deaths) / SUM(new_cases) * 100
  ```

- **Total Deaths by Continent**  
  Grouped by `location` where `continent IS NULL` (aggregated locations only)

- **Highest Infection Rate by Country**  
  Using:  
  ```sql
  MAX(total_cases / population) * 100
  ```

- **Infection Trends Over Time**  
  By grouping on `location`, `population`, and `date`

---

## 📌 Tools Used

- **SQL Server Management Studio (SSMS)** – Data querying and transformation
- **Tableau Public** – Dashboard creation and interactive visualization
- **GitHub** – Version control and project sharing

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/covid19-sql-tableau.git
   ```

2. Open SQL scripts in SSMS and run against your COVID-19 dataset

3. Open the Tableau workbook (`.twbx` or `.twb`) to view the dashboard or publish it on [Tableau Public](https://public.tableau.com/)

---

## 📷 Preview

![Dashboard Screenshot](Screenshot%20(19).png)


---

## ✨ Future Enhancements

- Add vaccination analysis dashboard
- Forecast future case trends using ML models
- Automate data updates with scheduled ETL jobs

---

## 📩 Contact

Created by **Nikita Jadhao**  
If you found this helpful or have suggestions, feel free to open an issue or reach out!
