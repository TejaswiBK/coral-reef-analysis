# Coral Reef Geospatial Analysis: Two-Script Workflow

## Overview

This project uses a **two-script separation of concerns** approach:

1. **`generate_raw_data.R`** - Generates messy, realistic raw data files
2. **`analyze_reef_data.R`** - Reads raw data, cleans it, and performs analysis

This structure follows professional data science best practices and enables reproducibility, auditability, and collaboration.

---

## Project Structure

```
coral-reef-analysis/
├── data/
│   ├── raw/                              # Raw, unprocessed data
│   │   ├── reef_survey_sites_raw.csv    # Survey observations (with quality issues)
│   │   ├── sst_raw.tif                  # Sea Surface Temperature raster
│   │   ├── depth_raw.tif                # Depth/Bathymetry raster
│   │   └── metadata.csv                 # Data documentation
│   └── processed/
│       └── reef_analysis_cleaned.csv    # Cleaned data ready for analysis
├── outputs/                              # Generated results
│   ├── 01_map_reef_sites.png
│   ├── 02_scatter_sst.png
│   ├── 03_scatter_depth.png
│   ├── 04_faceted_temp_zones.png
│   ├── temperature_zone_summary.csv
│   ├── results_summary_table.csv
│   └── data_provenance_log.csv
├── generate_raw_data.R                  # Step 1: Generate raw data
├── analyze_reef_data.R                  # Step 2: Analyze cleaned data
└── README.md                             # This file

```

---

## Workflow

### Step 1: Generate Raw Data

```bash
Rscript generate_raw_data.R
```

**What this does:**
- Generates 50 reef survey sites in the Red Sea (latitude 15-28°N, longitude 36-43°E)
- Creates environmental rasters (SST and depth) with realistic spatial patterns
- Intentionally introduces data quality issues:
  - ~10% missing coral cover values
  - ~8% missing fish biomass values
  - ~5% missing SST cells
  - ~3% negative depth values (sensor errors)
  - Quality flags and observer notes
- Saves files to `data/raw/`

**Output files:**
- `reef_survey_sites_raw.csv` - 50 rows, 8 columns with data quality flags
- `sst_raw.tif` - Raster with missing values
- `depth_raw.tif` - Raster with sensor errors
- `metadata.csv` - Data documentation

**Key idea:** These files simulate real-world data challenges.

---

### Step 2: Analyze Cleaned Data

```bash
Rscript analyze_reef_data.R
```

**What this does:**
1. **Reads raw data files** from `data/raw/`
2. **Data validation & cleaning:**
   - Removes outlier-flagged records
   - Handles missing values (conservative deletion)
   - Corrects sensor errors (negative depths)
   - Validates value ranges
   - Removes duplicates
3. **Spatial operations:**
   - Extracts SST and depth at reef site locations
   - Saves cleaned dataset to `data/processed/`
4. **Exploratory analysis:**
   - Summary statistics
   - Grouping by temperature zones
5. **Visualizations:**
   - Map of reef sites colored by coral cover
   - Scatter plots with regression lines
   - Faceted plots by temperature zones
6. **Statistical modeling:**
   - Linear models (main effects and interactions)
   - Results table by temperature/depth category
7. **Reporting:**
   - Creates data provenance log
   - Documents number of records retained at each step

**Output files:**
- `reef_analysis_cleaned.csv` - Clean dataset ready for publication
- `01_map_reef_sites.png` - Spatial map
- `02_scatter_sst.png` - Coral cover vs temperature
- `03_scatter_depth.png` - Coral cover vs depth
- `04_faceted_temp_zones.png` - Faceted analysis
- `temperature_zone_summary.csv` - Summary by zone
- `results_summary_table.csv` - Results by category
- `data_provenance_log.csv` - Records retained at each step

---

## Data Quality Issues Introduced

### Survey Data (`reef_survey_sites_raw.csv`)

| Issue | Frequency | Example |
|-------|-----------|---------|
| Missing coral_cover | ~10% | `NA` |
| Missing fish_biomass | ~8% | `NA` |
| Quality flags | 25% each | "OK", "SUSPECT", "OUTLIER", "MISSING" |
| Observer notes | Some | "Good visibility", "Equipment malfunction" |

### Raster Data

**SST (`sst_raw.tif`)**
- ~5% missing cells (represents sensor failures)
- Imputed with median value during cleaning

**Depth (`depth_raw.tif`)**
- ~3% negative values (sensor/processing errors)
- Converted to absolute values during cleaning

---

## Data Cleaning Pipeline

```
Raw Data (50 records)
        ↓
Remove "OUTLIER" flagged records
        ↓
Remove records with all missing measurements
        ↓
Remove records with missing coral_cover OR fish_biomass
        ↓
Deduplicate
        ↓
Validate ranges & spatial extent
        ↓
CLEANED DATA (~35-40 records)
```

See `data_provenance_log.csv` for exact retention counts.

---

## Key Files Explained

### 1. `reef_survey_sites_raw.csv`

Columns:
- `site_id` - Unique site identifier (e.g., SITE_001)
- `longitude` - 36-43°E
- `latitude` - 15-28°N
- `coral_cover` - % coral cover (0-100), **with missing values**
- `fish_biomass` - kg/hectare, **with missing values**
- `year` - 2023
- `data_quality_flag` - QA flag ("OK", "SUSPECT", "OUTLIER", "MISSING")
- `observer_notes` - Text notes (may be NA)

### 2. `sst_raw.tif`

- GeoTIFF raster format
- Resolution: 0.1° (~11 km)
- CRS: EPSG:4326 (WGS84)
- Values: ~20-27°C with realistic gradients
- Contains ~5% missing cells (represented as NA)

### 3. `depth_raw.tif`

- GeoTIFF raster format
- Resolution: 0.1° (~11 km)
- CRS: EPSG:4326 (WGS84)
- Values: ~0-30 m depth, **with some negative values**
- Contains sensor errors requiring correction

### 4. `metadata.csv`

- Documents each raw file
- Describes data issues
- Records spatial extent and CRS

---

## Running the Analysis

### Option A: Sequential Execution (Recommended)

```bash
# Step 1: Generate raw data
Rscript generate_raw_data.R

# Step 2: Analyze and produce results
Rscript analyze_reef_data.R
```

### Option B: Just Analyze (if raw data already exists)

```bash
Rscript analyze_reef_data.R
```

### Option C: Interactive (in RStudio)

1. Open `generate_raw_data.R` → Run all → Creates `data/raw/`
2. Open `analyze_reef_data.R` → Run all → Creates `outputs/`

---

## Advantages of This Approach

### 1. **Separation of Concerns**
- Data generation is isolated from analysis
- Easy to modify raw data generation without touching analysis code
- Follows ETL (Extract-Transform-Load) principle

### 2. **Reproducibility**
- Raw data files serve as immutable reference
- Can re-run analysis without regenerating raw data
- Peer review can examine raw data directly

### 3. **Auditability**
- Clear record of what was cleaned and how many records remained
- `data_provenance_log.csv` documents each step
- Easy to trace data through the pipeline

### 4. **Collaboration**
- Data team can generate raw files independently
- Analysis team works from stable raw files
- No conflicts from concurrent data generation

### 5. **Performance**
- Raw data generation is done once
- Can iterate on analysis without regenerating large rasters
- Easier to version control (raw files are stable)

### 6. **Documentation**
- `metadata.csv` documents each raw file
- Scripts include detailed comments
- Data issues are explicitly documented

---

## Customization

### Add More Sites
Edit `generate_raw_data.R`:
```r
n_sites <- 100  # Change from 50
```

### Change Missing Data Rate
Edit `generate_raw_data.R`:
```r
coral_cover = ifelse(runif(n_sites) < 0.15, NA, coral_cover)  # 15% missing
```

### Change Spatial Extent
Edit `generate_raw_data.R`:
```r
extent_vec <- c(30, 50, 10, 35)  # xmin, xmax, ymin, ymax
```

### Change Cleaning Logic
Edit `analyze_reef_data.R` in Section 2a (Data Cleaning)
```r
reef_clean <- reef_raw |>
  # Modify filtering/imputation logic here
```

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "File not found" error | Ensure working directory is set correctly; check `data/raw/` exists |
| Missing packages | Run `install.packages(c("tidyverse", "sf", "terra", "viridis"))` |
| Raster format error | Ensure `terra` package is installed (required for .tif files) |
| CRS mismatch warning | Safe to ignore; all files use EPSG:4326 consistently |

---

## Output Interpretation

### `data_provenance_log.csv`
Shows how many records survive each step:
- Raw data: 50 records
- After cleaning: ~35-40 records (10-20% loss)
- Final analysis: Same number (all retained in analysis)

### Model Coefficients
Check `summary(model)` output:
- **SST coefficient < 0**: Warmer sites have lower coral cover
- **Depth coefficient > 0**: Deeper sites have higher coral cover
- **p-value < 0.05**: Result is statistically significant

### Visualizations
- **Map**: Spatial patterns of coral cover
- **Scatter plots**: Relationships with temperature/depth
- **Faceted plots**: How relationships differ by temperature zone

---

## References & Best Practices

1. **Raw Data Immutability**: Never modify `data/raw/` after generation
2. **Logging**: The `cat()` statements show progress; save output with `Rscript ... > logfile.txt`
3. **Version Control**: Commit scripts, not raw data (use `.gitignore` for `data/` and `outputs/`)
4. **Documentation**: Update `metadata.csv` if raw data structure changes
5. **Reproducibility**: Always set `seed` in generation script

---

## Questions?

Refer to inline comments in each script or consult the data provenance log for details on record retention.

**Last Updated:** December 2025
