# Ecological + Socio-Economic Integration: Two-Script Workflow

## Quick Start (3 Minutes)

```bash
# Step 1: Generate raw data
Rscript generate_eco_socio_data_FIXED.R

# Step 2: Analyze and visualize
Rscript analyze_eco_socio_data_FIXED.R
```

Or in RStudio:
```r
source("generate_eco_socio_data_FIXED.R")
source("analyze_eco_socio_data_FIXED.R")
```

---

## What You Get

### Script 1: Data Generation (`generate_eco_socio_data_FIXED.R`)

**Creates 3 raw data files:**

| File | Records | Columns | Description |
|------|---------|---------|-------------|
| `ecological_raw.csv` | 30 | 11 | 5 regions × 6 years (2018-2023) with coral, fish, species data |
| `socioeconomic_raw.csv` | 30 | 11 | 5 regions × 6 years with population, income, fishing data |
| `metadata.csv` | 2 | 8 | Documents data sources, issues, and time period |

**Intentional messiness introduced:**
- Ecological: ~8% missing coral_cover, ~6% missing fish_biomass, ~5% missing species_richness
- Socio-economic: ~7% missing income, ~5% missing fishing_dependence
- Quality flags (OK/SUSPECT/OUTLIER) and data sources noted

**Runtime:** ~2 seconds

---

### Script 2: Analysis & Visualization (`analyze_eco_socio_data_FIXED.R`)

**Produces:**

**Cleaned Data:**
- `combined_data_cleaned.csv` — Integrated ecological + socio-economic data (~28-30 records)

**Summary Tables:**
- `summary_by_region.csv` — Mean values by region across all years
- `trends_2018_2023.csv` — Changes from 2018 to 2023 for each region
- `data_provenance_log.csv` — Records retained at each cleaning step

**Visualizations (6 PNG files):**
1. `01_coral_trends.png` — Coral cover trends by region over time
2. `02_fishing_effort_trends.png` — Fishing effort increasing 2018-2023
3. `03_coral_vs_fishing.png` — Negative relationship between coral health and fishing
4. `04_population_trends.png` — Population growth in coastal regions
5. `05_integrated_trends_faceted.png` — All 4 variables faceted by region
6. `06_income_vs_coral.png` — Household income vs coral cover by region

**Statistical Models:**
- Model 1: Coral cover ~ fishing effort + income + year
- Model 2: Coral cover ~ fishing effort + income + year + region
- Model 3: Fish biomass ~ coral cover + fishing effort

**Runtime:** ~10 seconds

---

## Data Flow

```
Script 1: generate_eco_socio_data_FIXED.R
    ↓
    Creates:
    ├── data/raw/ecological_raw.csv
    ├── data/raw/socioeconomic_raw.csv
    └── data/raw/metadata.csv
    
        ↓
        
Script 2: analyze_eco_socio_data_FIXED.R
    ↓
    Reads raw data
    ├── Cleans ecological data (removes ~10% records)
    ├── Cleans socio-economic data (removes ~5% records)
    └── Integrates both datasets
    ↓
    Produces:
    ├── data/processed/combined_data_cleaned.csv
    ├── outputs/ (6 visualizations + 3 summary tables)
    └── outputs/data_provenance_log.csv
```

---

## Data Quality by Numbers

### Ecological Data
- **Raw records:** 30
- **After cleaning:** ~27 (90% retention)
- **Removed because:** Flagged as OUTLIER OR missing coral_cover
- **Data issues cleaned:**
  - ~8% missing coral_cover → removed
  - ~6% missing fish_biomass → removed/kept if coral_cover present
  - ~5% missing species_richness → removed if all ecological vars missing

### Socio-Economic Data
- **Raw records:** 30
- **After cleaning:** ~29 (97% retention)
- **Removed because:** Flagged SUSPECT AND missing key variables
- **Data issues cleaned:**
  - ~7% missing income → imputed with regional median
  - ~5% missing fishing_dependence → removed

### Combined Integration
- **Final dataset:** ~28 records (93% of original)
- **Coverage:** 5 regions × 6 years (though some cells may have missing values)
- **Time period:** 2018-2023
- **Variables:** Ecological (coral, fish, species) + Socio-economic (population, fishing, income)

---

## Key Differences from Original Script

| Aspect | Original | New Workflow |
|--------|----------|--------------|
| Data generation | Inline | Script 1 (separate) |
| Raw data storage | Temporary | Persistent files (`data/raw/`) |
| Cleaning logic | Hidden in code | Explicit in Script 2 |
| Data audit trail | None | Full provenance log |
| Visualization | Inline | Saved as PNG files |
| Reproducibility | Generated each run | Generate once, analyze multiple times |

---

## Common Customizations

### Generate More Years

**File:** `generate_eco_socio_data_FIXED.R`, line 15

**Change:**
```r
years <- 2018:2023  # Change to:
years <- 2015:2024
```

### Add More Regions

**File:** `generate_eco_socio_data_FIXED.R`, lines 13-14

**Change:**
```r
regions <- c("Northern Red Sea", "Central Red Sea", "Southern Red Sea", 
             "Gulf of Aqaba", "Saudi Coast")
# Add:
regions <- c(..., "New Region")
```

Then add corresponding data generation logic in the `case_when()` statements.

### Change Missing Data Rate

**File:** `generate_eco_socio_data_FIXED.R`, lines ~50-53

**Change:**
```r
# From:
coral_cover = ifelse(runif(n()) < 0.08, NA, coral_cover)
# To (25% missing):
coral_cover = ifelse(runif(n()) < 0.25, NA, coral_cover)
```

### Use Different Cleaning Strategy

**File:** `analyze_eco_socio_data_FIXED.R`, lines ~35-50

**Conservative approach (current):**
```r
filter(!is.na(coral_cover))  # Remove ANY missing
```

**Aggressive approach (keep more data):**
```r
mutate(
  coral_cover = ifelse(is.na(coral_cover), mean(coral_cover, na.rm = TRUE), coral_cover)
)  # Impute missing values
```

---

## Understanding the Analysis

### What Each Visualization Shows

| Plot | What It Reveals | Key Insight |
|------|-----------------|-------------|
| **01_coral_trends** | Coral health declining | Southern Red Sea declining fastest |
| **02_fishing_effort** | Fishing pressure increasing | All regions intensifying fishing |
| **03_coral_vs_fishing** | Negative relationship | More fishing = less coral |
| **04_population_trends** | Coastal population growing | Pressure on resources increasing |
| **05_integrated_trends** | Combined view of 4 variables | Simultaneous ecological & socio changes |
| **06_income_vs_coral** | Economic link to ecosystem | Healthier reefs may support more income |

### What Each Model Shows

| Model | Predicts | Key Finding |
|-------|----------|-------------|
| **Model 1** | Coral cover from fishing effort + income + year | Fishing effort has negative effect |
| **Model 2** | Same + region fixed effect | Regional differences important |
| **Model 3** | Fish biomass from coral + fishing | Healthy reefs support fish populations |

---

## File Structure

```
project-folder/
├── data/
│   ├── raw/                                 (created by Script 1)
│   │   ├── ecological_raw.csv
│   │   ├── socioeconomic_raw.csv
│   │   └── metadata.csv
│   └── processed/                           (created by Script 2)
│       └── combined_data_cleaned.csv
├── outputs/                                 (created by Script 2)
│   ├── 01_coral_trends.png
│   ├── 02_fishing_effort_trends.png
│   ├── 03_coral_vs_fishing.png
│   ├── 04_population_trends.png
│   ├── 05_integrated_trends_faceted.png
│   ├── 06_income_vs_coral.png
│   ├── summary_by_region.csv
│   ├── trends_2018_2023.csv
│   └── data_provenance_log.csv
├── generate_eco_socio_data_FIXED.R          (Script 1)
└── analyze_eco_socio_data_FIXED.R           (Script 2)
```

---

## Regional Focus Areas

### Northern Red Sea
- Moderate coral decline (55% → 48%)
- Moderate fishing pressure
- 35% population dependent on fishing

### Central Red Sea
- Moderate-fast coral decline (50% → 42%)
- High fishing pressure
- 48% population dependent on fishing

### Southern Red Sea
- Fastest coral decline (45% → 33%)
- Highest fishing pressure
- 62% population dependent on fishing
- **Status:** Highest risk region

### Gulf of Aqaba
- Slowest coral decline (65% → 58%)
- Lowest fishing pressure
- 22% population dependent on fishing
- **Status:** Most resilient region

### Saudi Coast
- Moderate coral decline (60% → 52%)
- High fishing pressure
- 40% population dependent on fishing

---

## Interpretation Guide

### Reading the Summary Table

Each row shows average values for a region across all 6 years:

```
region                 | coral_cover | fishing_effort | population | income
Gulf of Aqaba          | 61.5 (best) | 1,250 (lowest) | 36,000     | $1,400
Northern Red Sea       | 51.5        | 2,750         | 51,000     | $1,150
Central Red Sea        | 46.0        | 4,500         | 85,000     | $900
Saudi Coast            | 56.0        | 5,750         | 110,000    | $1,650
Southern Red Sea       | 39.0 (worst)| 7,000 (highest)| 135,000    | $750
```

**Interpretation:**
- Gulf of Aqaba: Healthiest ecosystem, lowest pressures
- Southern Red Sea: Most stressed, highest fishing pressure, lowest income
- Correlation suggests: High fishing → low coral → low fish → lower income

---

## Troubleshooting

### "File does not exist"
Run Script 1 first: `Rscript generate_eco_socio_data_FIXED.R`

### "Error: Column names must not be duplicated"
This was in the original script. The FIXED versions handle this correctly.

### Plots look blank
Ensure `ggplot2` is installed: `install.packages("ggplot2")`

### Missing values in summary
Some regions may not have complete data for all years due to cleaning. Check `data_provenance_log.csv`

---

## Next Steps

1. ✅ Run Script 1: `Rscript generate_eco_socio_data_FIXED.R`
2. ✅ Check raw files: `ls data/raw/`
3. ✅ Run Script 2: `Rscript analyze_eco_socio_data_FIXED.R`
4. ✅ Review outputs: `ls outputs/`
5. ✅ Customize as needed (see examples above)
6. ✅ Share with collaborators (scripts only, raw data for reproducibility)

---

**Workflow Version:** 1.0  
**Created:** December 30, 2025  
**Tested with:** R 4.3+, tidyverse 2.0+, ggplot2 3.4+
