# Quick Start Guide

## Setup (First Time Only)

```bash
# Create project directory structure
mkdir -p coral-reef-analysis
cd coral-reef-analysis
mkdir -p data/raw data/processed outputs

# Copy the three files into this directory:
# - generate_raw_data.R
# - analyze_reef_data.R
# - README.md

# Install R packages (run once in R console)
install.packages(c("tidyverse", "sf", "terra", "viridis"))
```

---

## Run the Analysis

### Full Pipeline (Start to Finish)

```bash
# Terminal/Command Prompt
Rscript generate_raw_data.R
Rscript analyze_reef_data.R
```

### Or in RStudio

**In RStudio Console:**

```r
# Generate raw data
source("generate_raw_data.R")

# Then run analysis
source("analyze_reef_data.R")
```

---

## Expected Outputs

After running both scripts, your directory will look like:

```
coral-reef-analysis/
├── data/
│   ├── raw/
│   │   ├── reef_survey_sites_raw.csv
│   │   ├── sst_raw.tif
│   │   ├── depth_raw.tif
│   │   └── metadata.csv
│   └── processed/
│       └── reef_analysis_cleaned.csv
├── outputs/
│   ├── 01_map_reef_sites.png
│   ├── 02_scatter_sst.png
│   ├── 03_scatter_depth.png
│   ├── 04_faceted_temp_zones.png
│   ├── temperature_zone_summary.csv
│   ├── results_summary_table.csv
│   └── data_provenance_log.csv
├── generate_raw_data.R
├── analyze_reef_data.R
└── README.md
```

---

## What Each Script Does

### `generate_raw_data.R`

**Purpose:** Create realistic messy raw data files

**Key Features:**
- Generates 50 coral reef survey sites
- Creates environmental rasters (SST, depth)
- Introduces realistic data quality issues:
  - Missing values (~10% coral cover, ~8% fish biomass)
  - Sensor errors (negative depths, missing raster cells)
  - Quality flags and observer notes
- Saves all data to `data/raw/`

**Runtime:** ~5 seconds

**Console Output:**
```
=== RAW DATA GENERATION COMPLETE ===
Files created in data/raw/:
  1. reef_survey_sites_raw.csv - Survey site observations
  2. sst_raw.tif - Sea Surface Temperature raster
  3. depth_raw.tif - Depth/Bathymetry raster
  4. metadata.csv - Data documentation
```

---

### `analyze_reef_data.R`

**Purpose:** Load raw data, clean it, and perform comprehensive analysis

**Key Features:**
1. **Data Reading:** Loads raw files with validation reporting
2. **Data Cleaning:** 
   - Removes outlier-flagged records
   - Handles missing values
   - Corrects sensor errors
   - Validates ranges
3. **Spatial Operations:** Extracts raster values at reef sites
4. **Exploratory Analysis:** Summaries and groupings
5. **Visualizations:** 4 publication-ready maps/plots
6. **Modeling:** Linear regression with diagnostics
7. **Reporting:** Creates summary tables and provenance log

**Runtime:** ~15 seconds

**Console Output:**
```
=== READING RAW DATA FILES ===
✓ Loaded: reef_survey_sites_raw.csv
  Dimensions: 50 sites × 8 variables
  Missing coral_cover: 5
  Missing fish_biomass: 4

=== DATA CLEANING PIPELINE ===
Records retained after cleaning: 38 / 50

=== SPATIAL OPERATIONS ===
Extracted environmental variables for 38 sites

=== RESULTS TABLE ===
[Summary by temperature and depth category]

=== MODEL INTERPRETATION ===
Coefficient for SST: -0.XXXX
Coefficient for depth: 0.XXXX
```

---

## Key Output Files Explained

### Data Files

| File | Format | Purpose | Rows | Columns |
|------|--------|---------|------|---------|
| `reef_survey_sites_raw.csv` | CSV | Raw observations with quality issues | 50 | site_id, lon, lat, coral_cover, fish_biomass, year, data_quality_flag, observer_notes |
| `sst_raw.tif` | GeoTIFF | Raw temperature raster (~5% missing) | 70×70 | Single layer: sst |
| `depth_raw.tif` | GeoTIFF | Raw depth raster (~3% negative errors) | 70×70 | Single layer: depth |
| `reef_analysis_cleaned.csv` | CSV | Clean data ready for publication | ~38 | site_id, lon, lat, coral_cover, fish_biomass, year, sst, depth |

### Results Files

| File | Purpose |
|------|---------|
| `temperature_zone_summary.csv` | Mean coral cover & fish biomass by temperature zone |
| `results_summary_table.csv` | Results by temperature × depth category |
| `data_provenance_log.csv` | Records retained at each cleaning step |

### Visualizations

| File | Content |
|------|---------|
| `01_map_reef_sites.png` | Spatial map of reef sites colored by coral cover |
| `02_scatter_sst.png` | Coral cover vs temperature (with regression) |
| `03_scatter_depth.png` | Coral cover vs depth (with regression) |
| `04_faceted_temp_zones.png` | Coral cover vs depth, faceted by temperature zone |

---

## Understanding the Data Quality Issues

### Why Introduce Messy Data?

Real-world data is never clean. This workflow demonstrates:
- How to document data quality issues
- How to implement data validation
- How many records are lost during cleaning (transparency)
- How to report provenance (what happened to each record)

### Data Quality Issues by Source

**Survey Data (`reef_survey_sites_raw.csv`):**
- ~10% missing coral_cover (e.g., sites not surveyed)
- ~8% missing fish_biomass (e.g., equipment failure)
- Quality flags manually assigned (SUSPECT, OUTLIER)
- Observer notes documenting conditions

**Temperature Raster (`sst_raw.tif`):**
- ~5% missing cells (sensor malfunction, cloud cover)
- Imputed using median value during cleaning

**Depth Raster (`depth_raw.tif`):**
- ~3% negative values (data processing error)
- Converted to absolute values during cleaning

### Cleaning Pipeline

```
Raw Data (50 records)
    ↓ Remove OUTLIER flags
    ↓ Remove records with all missing measurements
    ↓ Remove missing coral_cover OR fish_biomass
    ↓ Remove duplicates
    ↓ Validate geographic bounds & value ranges
    ↓
Clean Data (~38 records, 76% retention)
```

---

## Customization Examples

### Increase Number of Sites

Edit line 20 in `generate_raw_data.R`:
```r
n_sites <- 100  # Change from 50
```

### Increase Missing Data Rate

Edit lines 34-35 in `generate_raw_data.R`:
```r
coral_cover = ifelse(runif(n_sites) < 0.20, NA, coral_cover),  # 20% missing (was 10%)
fish_biomass = ifelse(runif(n_sites) < 0.15, NA, fish_biomass)  # 15% missing (was 8%)
```

### Change Geographic Region

Edit line 49 in `generate_raw_data.R`:
```r
extent_vec <- c(40, 55, 5, 15)  # Different extent
```

### Use Different Imputation Strategy

Edit lines 103-104 in `analyze_reef_data.R`:
```r
# Replace median imputation with mean or nearest-neighbor
sst_values[is.na(sst_values)] <- mean(sst_values, na.rm = TRUE)
```

---

## Troubleshooting

| Error | Solution |
|-------|----------|
| **"Could not find function..."** | Run `install.packages(c("tidyverse", "sf", "terra", "viridis"))` |
| **"No such file or directory"** | Ensure `generate_raw_data.R` has been run first to create `data/raw/` |
| **"cannot open file 'data/raw/...'"** | Set working directory correctly: `setwd("path/to/coral-reef-analysis")` |
| **Raster CRS warning** | Safe to ignore; all files use EPSG:4326 consistently |
| **Out of memory** | Reduce raster resolution or number of sites |

---

## Integration with Git/Version Control

### Recommended `.gitignore`

```
# Ignore data directories (but track structure with .gitkeep)
data/raw/*
data/processed/*
outputs/*

# Keep directory structure
!data/raw/.gitkeep
!data/processed/.gitkeep
!outputs/.gitkeep

# Ignore R history
.Rhistory
.Rdata
```

Then commit only:
- `generate_raw_data.R`
- `analyze_reef_data.R`
- `README.md`
- `QUICKSTART.md` (this file)

---

## Next Steps

1. ✅ Copy the three R scripts to your computer
2. ✅ Run `Rscript generate_raw_data.R`
3. ✅ Run `Rscript analyze_reef_data.R`
4. ✅ Review outputs in `outputs/` folder
5. ✅ Customize as needed
6. ✅ Share reproducible analysis with collaborators

---

## Support

For detailed documentation, see `README.md`

For script details:
- Comments in `generate_raw_data.R` explain data generation logic
- Comments in `analyze_reef_data.R` explain cleaning and analysis steps

---

**Created:** December 2025  
**Tested with:** R 4.3+, tidyverse 2.0+, terra 1.7+, sf 1.0+
