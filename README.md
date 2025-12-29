# Coral Reef Data Analysis Project

## Overview
Integration of ecological and geospatial data for reef fisheries research in the Red Sea.

## Project Structure
- `scripts/` - R analysis scripts
- `data_raw/` - Raw input data
- `data_clean/` - Processed data
- `outputs/` - Figures and results

## Scripts

### 1. coral_geospatial_project.R
**Purpose**: Geospatial analysis combining reef survey sites with environmental rasters.

**What it does**:
- Generates 50 reef survey sites (vector points)
- Creates SST and depth rasters
- Extracts environmental values at each site
- Produces maps, scatter plots, and models

**Output**: 
- Visualizations of spatial patterns
- Linear model relating coral cover to temperature and depth
- Summary statistics by region

**Run**: `source("scripts/coral_geospatial_project.R")`

---

### 2. ecological_socioeconomic_analysis.R
**Purpose**: Integrate ecological and socio-economic data to understand reef-fisheries systems.

**What it does**:
- Generates ecological data (coral cover, fish biomass) by region/year
- Generates socio-economic data (population, fishing effort, income, dependence)
- Joins datasets using `dplyr`
- Creates trend visualizations
- Fits regression models testing relationships

**Key findings**:
- Coral cover declining in all regions 2018-2023
- Fishing effort increasing over time
- Strong negative correlation between fishing pressure and reef health
- Regions with high fishing dependence show greatest coral decline

**Output**:
- Trend plots and faceted visualizations
- Summary tables (by region, 2018 vs 2023)
- Model coefficients and interpretations
- CSV exports for downstream analysis

**Run**: `source("scripts/ecological_socioeconomic_analysis.R")`

---

## Key Skills Demonstrated

- **Data Integration**: Combining ecological and socio-economic datasets
- **Data Visualization**: Multi-layered ggplot2 graphics, faceted plots
- **Statistical Modeling**: Linear regression with multiple predictors
- **Geospatial Analysis**: Vector points + raster extraction
- **Reproducibility**: Scripts, documentation, version control
- **Communication**: README, tables, and publication-ready figures

## Dependencies

## Author
Tejaswi Telaginamani  
KAUST, Thuwal, Saudi Arabia

## Purpose
Demonstration for Research Specialist position at Integrated Reef Fisheries Lab, KAUST.


