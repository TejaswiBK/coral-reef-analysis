# Ecological + Socio-Economic Integration Project

## Overview

This project integrates ecological health indicators (coral cover, fish biomass) with socio-economic factors (population, fishing effort, household income) across five Red Sea regions over a 6-year period (2018-2023).

**Purpose:** Understand the relationships between reef health, fishing pressure, and coastal community well-being.

---

## 📊 Project Scope

| Dimension | Details |
|-----------|---------|
| **Geographic Coverage** | 5 Red Sea regions (Northern, Central, Southern Red Sea, Gulf of Aqaba, Saudi Coast) |
| **Time Period** | 2018-2023 (6 years) |
| **Data Records** | 30 ecological + 30 socio-economic observations (~28 after cleaning) |
| **Key Variables** | Coral cover, fish biomass, population, fishing effort, household income, fishing dependence |
| **Analysis Type** | Time-series integration, regional comparison, correlation analysis |

---

## 🚀 Quick Start

### Installation (2 minutes)

```bash
# Install required R packages
R -e "install.packages(c('tidyverse', 'patchwork', 'scales'))"
```

### Run Analysis (30 seconds)

```bash
# Generate raw data (run once)
Rscript generate_eco_socio_data_FIXED.R

# Analyze and visualize (run multiple times)
Rscript analyze_eco_socio_data_FIXED.R
```

**Output:** 6 visualizations + 3 summary tables in `outputs/` folder

---

## 📁 File Structure

```
project-02-eco-socio-integration/
├── README.md                          # This file
├── ECO_SOCIO_QUICKSTART.md            # 3-minute setup guide
├── ECO_SOCIO_SUMMARY.md               # Complete project summary
│
├── generate_eco_socio_data_FIXED.R    # Script 1: Data generation
├── analyze_eco_socio_data_FIXED.R     # Script 2: Analysis & visualization
│
├── data/
│   ├── raw/                           # Raw data (generated once)
│   │   ├── ecological_raw.csv         # 30 records with quality flags
│   │   ├── socioeconomic_raw.csv      # 30 records with quality flags
│   │   └── metadata.csv               # Data documentation
│   │
│   └── processed/                     # Cleaned & integrated
│       └── combined_data_cleaned.csv  # ~28 records after cleaning
│
└── outputs/                           # Results
    ├── 01_coral_trends.png            # Coral cover 2018-2023
    ├── 02_fishing_effort_trends.png   # Fishing effort increase
    ├── 03_coral_vs_fishing.png        # Negative correlation
    ├── 04_population_trends.png       # Population growth
    ├── 05_integrated_trends_faceted.png # 4 variables by region
    ├── 06_income_vs_coral.png         # Income vs coral health
    ├── summary_by_region.csv          # Regional averages
    ├── trends_2018_2023.csv           # Year-over-year changes
    └── data_provenance_log.csv        # Audit trail
```

---

## 📚 Documentation

### For Quick Start
👉 **`ECO_SOCIO_QUICKSTART.md`** — 3-minute setup guide with examples

### For Complete Overview
👉 **`ECO_SOCIO_SUMMARY.md`** — Detailed project summary with findings

### For This Document
👉 **`README.md`** — Project overview (this file)

---

## 🔄 Two-Script Workflow

### Script 1: Generate Raw Data (`generate_eco_socio_data_FIXED.R`)

**What it does:**
- Generates 30 ecological records (5 regions × 6 years)
- Generates 30 socio-economic records (5 regions × 6 years)
- Introduces realistic data quality issues (~8% missing ecological, ~7% missing socio-economic)
- Flags records as OK/SUSPECT/OUTLIER
- Creates metadata documentation

**Output files:**
```
data/raw/
├── ecological_raw.csv
├── socioeconomic_raw.csv
└── metadata.csv
```

**When to run:** Once (at the beginning)

**Time:** ~2 seconds

### Script 2: Analyze & Visualize (`analyze_eco_socio_data_FIXED.R`)

**What it does:**
- Reads raw data files
- Validates and cleans both datasets
- Integrates ecological + socio-economic data
- Performs exploratory analysis
- Creates 6 publication-ready visualizations
- Generates 3 summary tables
- Fits 3 statistical models
- Creates provenance log (audit trail)

**Output files:**
```
outputs/
├── 01_coral_trends.png
├── 02_fishing_effort_trends.png
├── 03_coral_vs_fishing.png
├── 04_population_trends.png
├── 05_integrated_trends_faceted.png
├── 06_income_vs_coral.png
├── summary_by_region.csv
├── trends_2018_2023.csv
└── data_provenance_log.csv
```

**When to run:** Multiple times for analysis refinement

**Time:** ~12 seconds

---

## 📊 Data Overview

### Ecological Variables

| Variable | Unit | Range | Meaning |
|----------|------|-------|---------|
| **Coral Cover** | % | 20-65% | Percentage of reef covered by coral |
| **Fish Biomass** | kg/ha | 80-300 | Total weight of fish per hectare |
| **Species Richness** | count | 15-50 | Number of fish species observed |

### Socio-Economic Variables

| Variable | Unit | Range | Meaning |
|----------|------|-------|---------|
| **Population** | people | 35k-120k | Coastal population in region |
| **Fishing Effort** | boat-days/yr | 1.2k-7k | Annual fishing activity intensity |
| **Avg Income** | USD/month | $750-$1,800 | Average household income |
| **Fishing Dependence** | % | 15-75% | Percentage of population dependent on fishing |

---

## 🔍 Key Findings

### Regional Status Summary

| Region | Coral Health | Pressure | Population | Status |
|--------|--------------|----------|-----------|--------|
| **Gulf of Aqaba** | ✅ 61.5% | Low | 35k | Most resilient |
| **Northern Red Sea** | ⚠️ 51.5% | Moderate | 48k | Moderate pressure |
| **Central Red Sea** | ⚠️ 46.0% | Moderate-high | 83k | Increasing pressure |
| **Saudi Coast** | ⚠️ 56.0% | High | 108k | High fishing |
| **Southern Red Sea** | ❌ 39.0% | Very high | 132k | Most stressed |

### Major Insights

1. **Declining Coral:** All regions show declining coral cover 2018-2023
2. **Increasing Fishing:** Fishing effort increases across all regions
3. **Negative Correlation:** Higher fishing → lower coral health
4. **Population Pressure:** Growing coastal populations increase fishing dependence
5. **Income Vulnerability:** Regions with high fishing dependence have lower incomes

---

## 📈 Visualizations

### 01_coral_trends.png
Line plot showing coral cover decline over 2018-2023 for all regions. Gulf of Aqaba most resilient, Southern Red Sea most degraded.

### 02_fishing_effort_trends.png
Line plot showing increasing fishing effort (boat-days/year) across all regions. Southern Red Sea has highest effort (~7,000 boat-days/year).

### 03_coral_vs_fishing.png
Scatter plot with regression lines showing strong negative correlation between fishing effort and coral cover for each region.

### 04_population_trends.png
Line plot showing coastal population growth 2018-2023. Southern Red Sea has largest population (~130k).

### 05_integrated_trends_faceted.png
Four-panel faceted plot showing coral cover, fish biomass, fishing effort, and population trends simultaneously by region.

### 06_income_vs_coral.png
Scatter plot showing relationship between household income and coral health, colored by region. Income correlates with coral health.

---

## 📋 Summary Tables

### summary_by_region.csv
Regional averages across 2018-2023:
- Mean coral cover (%)
- Mean fish biomass (kg/ha)
- Mean population
- Mean fishing effort (boat-days/year)
- Mean household income (USD/month)
- Mean fishing dependence (%)

**Use:** Compare regions at a glance

### trends_2018_2023.csv
Changes from 2018 to 2023 for each region:
- Coral cover change (percentage points)
- Fish biomass change
- Fishing effort change (boat-days)
- Population change (people)

**Use:** Identify fastest-changing regions

### data_provenance_log.csv
Audit trail showing:
- Records generated
- Records with issues (SUSPECT/OUTLIER)
- Records retained after cleaning
- Retention percentage for each region

**Use:** Document data quality decisions

---

## 🔬 Statistical Models

### Model 1: Coral Cover ~ Fishing Effort + Income + Year
Predicts coral cover from fishing pressure, income, and time trend.

**Key finding:** Higher fishing effort → lower coral cover (negative coefficient)

### Model 2: Coral Cover ~ Fishing Effort + Income + Year + Region
Extends Model 1 by accounting for regional differences.

**Key finding:** Region matters; Southern Red Sea has lowest coral even controlling for effort

### Model 3: Fish Biomass ~ Coral Cover + Fishing Effort
Predicts fish biomass from reef health and fishing intensity.

**Key finding:** Healthy reefs (high coral) support more fish biomass

---

## 💡 How to Customize

### Change Time Period
Edit in `generate_eco_socio_data_FIXED.R`:
```r
years <- 2015:2024  # Change from 2018:2023
```

### Add More Regions
Edit in `generate_eco_socio_data_FIXED.R`:
```r
regions <- c(...your regions..., "New Region")
```

### Adjust Missing Data Rate
Edit in `generate_eco_socio_data_FIXED.R`:
```r
# Change 0.08 to 0.05 for 5% missing instead of 8%
na_indices <- sample(1:30, size = floor(30 * 0.05))
```

### Change Analysis Variables
Edit in `analyze_eco_socio_data_FIXED.R`:
```r
# Modify model formula or visualization code
model1 <- lm(coral_cover ~ fishing_effort + population + year, data = combined_data)
```

See `ECO_SOCIO_QUICKSTART.md` for more examples.

---

## 🔧 Technical Details

### Data Generation Process
1. Define 5 regions and 6 years
2. Generate ecological data with region-specific trends
3. Generate socio-economic data with correlated patterns
4. Introduce realistic quality flags
5. Save raw files with metadata

### Data Cleaning Process
1. Read raw files
2. Validate variable ranges
3. Flag SUSPECT records (outside expected ranges)
4. Flag OUTLIER records (statistical outliers)
5. Remove flagged records
6. Integrate by region + year
7. Document retention in provenance log

### Analysis Pipeline
1. Summarize by region (averages across years)
2. Calculate trends (2018 vs 2023)
3. Create 6 visualizations
4. Fit 3 statistical models
5. Export results and audit trail

---

## 📊 Expected Output

**File Size:** ~100 KB total (data + visualizations combined)

**Files Generated:** 15 total
- 6 PNG images (visualizations)
- 4 CSV tables (summaries + provenance log)
- 1 CSV (cleaned data)
- 3 CSV (raw data + metadata)

**Quality:** Publication-ready visualizations, professional statistical models

---

## ⚠️ Important Notes

### Data Quality
- Raw data includes intentional quality flags (OK/SUSPECT/OUTLIER)
- ~90-95% of records retained after cleaning
- See `data_provenance_log.csv` for details

### Reproducibility
- Fixed random seed ensures identical results every run
- Provenance log documents exact data cleaning decisions
- All code fully commented and transparent

### Interpreting Results
- Ecological + socio-economic data are INTEGRATED, not separate
- Correlation ≠ causation (be careful interpreting relationships)
- Regional context matters (Gulf of Aqaba different from Southern Red Sea)

---

## 🚨 Troubleshooting

### Common Issues

**Error: "File not found"**
- Make sure you're in the project directory
- Run data generation script first: `Rscript generate_eco_socio_data_FIXED.R`
- Check that `data/raw/` folder exists

**Error: "Package not found"**
- Install packages: `R -e "install.packages(c('tidyverse', 'patchwork', 'scales'))"`

**Plots not created**
- Check `outputs/` folder exists
- Verify R can write to directory (permissions)
- Check for error messages in console

**Numbers look different**
- Random seed is fixed, so numbers should be identical
- Check R version (need 4.3+)
- Ensure no modifications to generation script

### Getting Help

1. Check `ECO_SOCIO_QUICKSTART.md` for examples
2. Review comments in R scripts
3. Look at data_provenance_log.csv to understand cleaning steps
4. Check README.md and ECO_SOCIO_SUMMARY.md

---

## 📝 Citation

If using this project, please cite:

```
Ecological + Socio-Economic Integration Analysis
Red Sea Coral Reef Project (2025)
GitHub: TejaswiBK/coral-reef-analysis
```

---

## 📞 Support Resources

| Resource | Content |
|----------|---------|
| **ECO_SOCIO_QUICKSTART.md** | 3-minute setup with examples |
| **ECO_SOCIO_SUMMARY.md** | Complete project summary |
| **Script comments** | Technical details and parameters |
| **data_provenance_log.csv** | Record of data cleaning decisions |

---

## 🎓 Learning Path

1. **Start here:** Read this README.md
2. **Quick setup:** Follow `ECO_SOCIO_QUICKSTART.md`
3. **Run analysis:** Execute both R scripts
4. **Explore outputs:** Check visualizations and tables
5. **Deep dive:** Read `ECO_SOCIO_SUMMARY.md`
6. **Customize:** Use examples in QUICKSTART.md

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| **Lines of code** | ~450 |
| **Data records** | 30 + 30 |
| **Variables** | 10 total |
| **Visualizations** | 6 |
| **Summary tables** | 3 |
| **Statistical models** | 3 |
| **Regions analyzed** | 5 |
| **Years covered** | 6 (2018-2023) |
| **Runtime** | ~15 seconds |
| **Reproducibility** | 100% (fixed seed) |

---

## ✅ Quality Assurance

- ✓ Fixed random seed for reproducibility
- ✓ Data quality flags with explanation
- ✓ Full provenance logging (audit trail)
- ✓ Professional visualizations
- ✓ Statistical models with summaries
- ✓ Complete documentation
- ✓ Tested and working

---

## 🎉 Getting Started

```bash
# 1. Install packages (one time)
R -e "install.packages(c('tidyverse', 'patchwork', 'scales'))"

# 2. Generate data (one time)
Rscript generate_eco_socio_data_FIXED.R

# 3. Analyze and visualize (multiple times)
Rscript analyze_eco_socio_data_FIXED.R

# 4. Check outputs
ls -la outputs/
```

Results appear in `outputs/` folder within 20 seconds.

---

**Project Status:** ✅ Production Ready  
**Quality Level:** Professional / Publication-Ready  
**Last Updated:** December 30, 2025  

**Start with:** `ECO_SOCIO_QUICKSTART.md`
