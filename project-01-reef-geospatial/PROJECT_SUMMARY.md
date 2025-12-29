# Project Summary: Refactored Coral Reef Analysis

## What Was Changed

Your original script combined **data generation** and **data analysis** into one monolithic workflow. This refactored version separates them into two independent, professional-grade scripts.

---

## The Two-Script Approach

### Before (Original)
```
Single Script
├── Generate data inline
├── Clean data inline
└── Analyze data inline
```

**Problems:**
- Unclear what is generated vs. loaded
- Hard to re-run analysis without regenerating data
- No audit trail of data transformations
- Messy data issues hidden in code

### After (Refactored)
```
Script 1: generate_raw_data.R
└── Creates messy raw files → data/raw/

     ↓

Script 2: analyze_reef_data.R
├── Reads raw files
├── Cleans data
├── Analyzes cleaned data
└── Outputs results → outputs/
```

**Benefits:**
- Clear separation of data generation and analysis
- Raw data files are immutable reference
- Can iterate on analysis independently
- Full audit trail with provenance log
- Professional data science best practice

---

## File Inventory

### Scripts (Your New Files)

| File | Purpose | Size |
|------|---------|------|
| `generate_raw_data.R` | Generate messy raw data files | ~100 lines |
| `analyze_reef_data.R` | Read raw files, clean, analyze, visualize | ~300 lines |
| `README.md` | Comprehensive documentation | ~400 lines |
| `QUICKSTART.md` | Quick reference guide | ~300 lines |

### Generated Data Files (Created by Script 1)

| File | Type | Size (approx) | Records |
|------|------|---------------|---------|
| `data/raw/reef_survey_sites_raw.csv` | CSV | 5 KB | 50 sites |
| `data/raw/sst_raw.tif` | GeoTIFF | 40 KB | 70×70 raster |
| `data/raw/depth_raw.tif` | GeoTIFF | 40 KB | 70×70 raster |
| `data/raw/metadata.csv` | CSV | 1 KB | 3 files described |

### Cleaned Data & Results (Created by Script 2)

| File | Type | Purpose |
|------|------|---------|
| `data/processed/reef_analysis_cleaned.csv` | CSV | Clean data ready for analysis (~38 sites) |
| `outputs/01_map_reef_sites.png` | PNG | Spatial distribution map |
| `outputs/02_scatter_sst.png` | PNG | Coral cover vs temperature |
| `outputs/03_scatter_depth.png` | PNG | Coral cover vs depth |
| `outputs/04_faceted_temp_zones.png` | PNG | Faceted analysis by temperature zone |
| `outputs/temperature_zone_summary.csv` | CSV | Summary statistics by zone |
| `outputs/results_summary_table.csv` | CSV | Cross-tabulated results |
| `outputs/data_provenance_log.csv` | CSV | Records retained at each step |

---

## Key Improvements Over Original

### 1. Data Reproducibility
- **Before:** Data generated each time analysis runs
- **After:** Raw data is persistent; can analyze independently

### 2. Data Auditability
- **Before:** No record of what happened to data
- **After:** `data_provenance_log.csv` shows exactly how many records retained

### 3. Code Clarity
- **Before:** 300+ lines mixing generation, cleaning, analysis
- **After:** Separate scripts with clear, documented stages

### 4. Collaboration
- **Before:** Difficult for teams to work on different parts
- **After:** Data team generates raw files; analysis team works from stable files

### 5. Data Quality Documentation
- **Before:** Quality issues hidden in code
- **After:** `metadata.csv` explicitly documents all issues

### 6. Messiness Control
- **Before:** Could accidentally generate clean data
- **After:** `generate_raw_data.R` intentionally creates realistic issues

---

## How to Use

### Quick Start (5 minutes)

```bash
# Run both scripts in sequence
Rscript generate_raw_data.R
Rscript analyze_reef_data.R
```

### Detailed Workflow

**Phase 1: Generate Raw Data**
```r
# Run once to create data/raw/*
source("generate_raw_data.R")
```
- Creates 50 reef survey sites
- Generates temperature and depth rasters
- Introduces realistic data quality issues
- Saves metadata documenting all issues

**Phase 2: Analyze Clean Data**
```r
# Run as many times as needed for analysis refinement
source("analyze_reef_data.R")
```
- Loads raw files with validation
- Cleans and validates data
- Produces 4 publication-ready visualizations
- Fits statistical models
- Generates 3 results tables
- Creates data provenance log

### Iterate on Analysis

```r
# Modify analyze_reef_data.R
# Re-run without regenerating raw data

source("analyze_reef_data.R")

# Results updated in outputs/
```

---

## Data Quality Issues Documented

### In Raw Data
- ~10% missing coral cover (simulates incomplete surveys)
- ~8% missing fish biomass (simulates equipment failures)
- Quality flags (OK, SUSPECT, OUTLIER, MISSING)
- Observer notes (visibility, equipment issues)
- Geographic validation needed

### In Rasters
- ~5% missing SST cells (sensor failures)
- ~3% negative depth values (processing errors)
- Requires interpolation/correction

### After Cleaning
- Records reduced from 50 → ~38 (24% loss, fully documented)
- All remaining data validated and within realistic ranges
- Cleaned data ready for publication

---

## Directory Structure

```
coral-reef-analysis/
├── data/
│   ├── raw/                          ← OUTPUT FROM SCRIPT 1
│   │   ├── reef_survey_sites_raw.csv
│   │   ├── sst_raw.tif
│   │   ├── depth_raw.tif
│   │   └── metadata.csv
│   └── processed/                    ← OUTPUT FROM SCRIPT 2
│       └── reef_analysis_cleaned.csv
├── outputs/                          ← OUTPUT FROM SCRIPT 2
│   ├── 01_map_reef_sites.png
│   ├── 02_scatter_sst.png
│   ├── 03_scatter_depth.png
│   ├── 04_faceted_temp_zones.png
│   ├── temperature_zone_summary.csv
│   ├── results_summary_table.csv
│   └── data_provenance_log.csv
├── generate_raw_data.R               ← SCRIPT 1
├── analyze_reef_data.R               ← SCRIPT 2
├── README.md                         ← FULL DOCUMENTATION
└── QUICKSTART.md                     ← QUICK REFERENCE
```

---

## Comparison: Original vs. Refactored

### Original Script
```r
library(tidyverse)
library(sf)
library(terra)

# Data generation (lines 10-80)
reef_data <- tibble(...)
sst_raster <- rast(...)
depth_raster <- rast(...)

# Data cleaning (lines 85-120)
reef_sf <- st_as_sf(...)
values(sst_raster) <- ...

# Analysis (lines 125-300)
ggplot(...) + ...
model <- lm(...)
write_csv(...)
```

**Issues:**
- Mixes three concerns in one file
- No separation between stages
- Impossible to run just analysis
- No data quality documentation

### Refactored Scripts

**Script 1: generate_raw_data.R**
```r
# Create 50 sites with realistic messiness
reef_raw <- tibble(
  data_quality_flag = sample(...),  # Intentional quality issues
  coral_cover = ifelse(runif(...) < 0.1, NA, ...)  # Missing values
)
write_csv(reef_raw, "data/raw/reef_survey_sites_raw.csv")
```

**Script 2: analyze_reef_data.R**
```r
# Load and clean raw files
reef_raw <- read_csv("data/raw/reef_survey_sites_raw.csv")
reef_clean <- reef_raw |>
  filter(!is.na(coral_cover))  # Clean documented data quality issues

# Analysis on cleaned data only
model <- lm(coral_cover ~ sst + depth, data = reef_analysis)
```

**Benefits:**
- Clear responsibility of each script
- Raw data immutable and documented
- Analysis independent of generation
- Full audit trail in provenance log

---

## Professional Standards Applied

### 1. **ETL Pattern (Extract-Transform-Load)**
- **Extract:** `generate_raw_data.R` creates raw files
- **Transform:** `analyze_reef_data.R` cleans and transforms
- **Load:** Results saved as CSV and PNG

### 2. **Data Versioning**
- Raw files are immutable reference
- Processed files show cleaned state
- Outputs show final results

### 3. **Documentation**
- `metadata.csv` documents raw data issues
- `data_provenance_log.csv` tracks transformations
- Comments in scripts explain each stage

### 4. **Reproducibility**
- Set seed in generation script
- All steps logged
- Can regenerate exact same results

### 5. **Auditability**
- Every record's journey tracked
- Cleaning logic explicit
- Retention rates documented

---

## Common Customizations

### Generate More Sites
```r
# In generate_raw_data.R, line 20
n_sites <- 200  # Was 50
```

### Change Missing Data Percentage
```r
# In generate_raw_data.R, lines 34-35
coral_cover = ifelse(runif(n_sites) < 0.20, NA, coral_cover)  # 20%
fish_biomass = ifelse(runif(n_sites) < 0.15, NA, fish_biomass)  # 15%
```

### Use Different Imputation
```r
# In analyze_reef_data.R, line 65
sst_values[is.na(sst_values)] <- mean(sst_values, na.rm = TRUE)  # Instead of median
```

### Add More Output Formats
```r
# In analyze_reef_data.R, after analysis
write_json(reef_analysis, "outputs/reef_data.json")
openxlsx::write.xlsx(results_table, "outputs/results.xlsx")
```

---

## FAQ

**Q: Why separate data generation and analysis?**  
A: Because real projects have separate teams: data engineers generate raw data, data scientists analyze it. This mirrors professional workflows.

**Q: Do I have to run both scripts?**  
A: First time yes. After that, you can run just `analyze_reef_data.R` to iterate on analysis without regenerating data.

**Q: What if my raw data is from an external source?**  
A: Copy external files to `data/raw/` and skip `generate_raw_data.R`. Just run `analyze_reef_data.R` (adjusting for your data structure).

**Q: How do I share this with collaborators?**  
A: Share the two R scripts. They run the scripts to generate reproducible outputs. See `.gitignore` example in README.

**Q: Can I modify raw data?**  
A: No—that defeats the purpose. If you need different raw data, modify `generate_raw_data.R` and regenerate.

**Q: What does "data provenance" mean?**  
A: A record of where data came from and what happened to it. See `data_provenance_log.csv`.

---

## Next Steps

1. ✅ **Understand the structure** (this document)
2. ✅ **Read QUICKSTART.md** for running instructions
3. ✅ **Read README.md** for detailed documentation
4. ✅ **Run `generate_raw_data.R`** to create raw data files
5. ✅ **Run `analyze_reef_data.R`** to analyze and visualize
6. ✅ **Customize as needed** using examples above
7. ✅ **Version control** using suggested `.gitignore`

---

## Bonus: Extending the Workflow

### Add a Third Script: `report_generation.R`
```r
# Reads outputs/ and creates an automated report (HTML/PDF)
```

### Add a Fourth Script: `data_validation.R`
```r
# Reads data/raw/ and validates against schema before analysis
```

### Add Logging: Capture console output
```bash
Rscript generate_raw_data.R > logs/generate_$(date +%Y%m%d).log
Rscript analyze_reef_data.R > logs/analyze_$(date +%Y%m%d).log
```

### Add Caching: Skip expensive operations
```r
if (!file.exists("data/processed/reef_analysis_cleaned.csv")) {
  source("analyze_reef_data.R")
} else {
  reef_analysis <- read_csv("data/processed/reef_analysis_cleaned.csv")
}
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 2025 | Initial refactored version from monolithic script |

---

**Questions?** Refer to README.md or QUICKSTART.md for specific topics.

**Created by:** Professional Data Science Workflow Standards  
**Last Updated:** December 2025
