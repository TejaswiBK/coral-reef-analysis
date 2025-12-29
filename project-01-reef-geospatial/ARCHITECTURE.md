# Workflow Architecture Diagram

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      CORAL REEF ANALYSIS WORKFLOW                        │
└─────────────────────────────────────────────────────────────────────────┘

PHASE 1: DATA GENERATION (Run Once)
═════════════════════════════════════════════════════════════════════════════

    generate_raw_data.R
    ├─ Set seed (123)
    │
    ├─ GENERATE VECTOR DATA
    │  ├─ 50 reef sites (latitude 15-28°N, longitude 36-43°E)
    │  ├─ Coral cover (%): 10-85
    │  ├─ Fish biomass (kg/ha): 50-500
    │  └─ Add messiness:
    │     ├─ ~10% missing coral_cover
    │     ├─ ~8% missing fish_biomass
    │     ├─ Quality flags (OK, SUSPECT, OUTLIER, MISSING)
    │     └─ Observer notes
    │     ▼
    │  data/raw/reef_survey_sites_raw.csv (50 records, 8 columns)
    │
    ├─ GENERATE RASTER DATA
    │  ├─ Grid: 0.1° resolution (70×70 cells)
    │  ├─ Sea Surface Temperature (SST)
    │  │  ├─ Realistic gradient: 26°C ± 0.5°C
    │  │  ├─ Add ~5% missing cells (NAs)
    │  │  └─ Impute during cleaning
    │  │     ▼
    │  │  data/raw/sst_raw.tif
    │  │
    │  └─ Depth (Bathymetry)
    │     ├─ Realistic pattern: 0-30m
    │     ├─ Add ~3% negative values (sensor errors)
    │     └─ Correct during cleaning
    │        ▼
    │     data/raw/depth_raw.tif
    │
    └─ SAVE METADATA
       └─ data/raw/metadata.csv (documents all 3 files)


PHASE 2: DATA ANALYSIS (Run Multiple Times)
═════════════════════════════════════════════════════════════════════════════

    analyze_reef_data.R

    ┌─ STAGE 1: DATA READING ──────────────────────────────────────────────┐
    │  READ RAW FILES WITH VALIDATION                                       │
    │  ├─ reef_survey_sites_raw.csv                                         │
    │  │  └─ 50 records, check for missing values                           │
    │  ├─ sst_raw.tif                                                       │
    │  │  └─ 70×70 raster, count missing cells                              │
    │  ├─ depth_raw.tif                                                     │
    │  │  └─ 70×70 raster, count negative values                            │
    │  └─ metadata.csv                                                       │
    │     └─ Document data issues                                            │
    └──────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 2: DATA CLEANING ─────────────────────────────────────────────┐
    │  TRANSFORM RAW DATA TO CLEAN DATA                                     │
    │  ├─ Vector data cleaning:                                             │
    │  │  ├─ Remove OUTLIER-flagged records                                 │
    │  │  ├─ Remove records with all missing measurements                   │
    │  │  ├─ Delete rows with missing coral_cover OR fish_biomass           │
    │  │  ├─ Remove duplicates                                              │
    │  │  └─ Validate ranges & spatial extent                               │
    │  │     └─ Records: 50 → ~38 (24% loss, fully documented)              │
    │  │
    │  └─ Raster data cleaning:                                             │
    │     ├─ SST: Impute missing cells with median                          │
    │     └─ Depth: Convert negative values to absolute                     │
    │
    │  OUTPUT: Cleaned dataset                                              │
    │  data/processed/reef_analysis_cleaned.csv (~38 records)               │
    └──────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 3: SPATIAL OPERATIONS ───────────────────────────────────────┐
    │  EXTRACT ENVIRONMENTAL VARIABLES AT REEF SITES                       │
    │  ├─ Convert reef data to spatial points (sf object)                  │
    │  ├─ Extract SST values from raster at each point                     │
    │  └─ Extract depth values from raster at each point                   │
    │                                                                       │
    │  OUTPUT: reef_analysis (cleaned data + environment)                  │
    └──────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 4: EXPLORATORY ANALYSIS ──────────────────────────────────────┐
    │  SUMMARIZE AND EXPLORE DATA                                           │
    │  ├─ Summary statistics (mean, sd, range)                              │
    │  └─ Grouping by temperature zone:                                     │
    │     ├─ Cool (<24°C)                                                   │
    │     ├─ Medium (24-26°C)                                               │
    │     └─ Warm (>26°C)                                                   │
    │                                                                        │
    │  OUTPUT: temperature_zone_summary.csv                                 │
    └────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 5: VISUALIZATIONS ───────────────────────────────────────────┐
    │  CREATE PUBLICATION-READY GRAPHICS                                   │
    │  ├─ 01_map_reef_sites.png                                            │
    │  │  └─ Spatial map colored by coral cover                            │
    │  ├─ 02_scatter_sst.png                                               │
    │  │  └─ Coral cover vs SST with regression line                       │
    │  ├─ 03_scatter_depth.png                                             │
    │  │  └─ Coral cover vs depth with regression line                     │
    │  └─ 04_faceted_temp_zones.png                                        │
    │     └─ Depth vs cover, faceted by temperature zone                   │
    └────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 6: STATISTICAL MODELING ──────────────────────────────────────┐
    │  FIT LINEAR REGRESSION MODELS                                         │
    │  ├─ Model 1: coral_cover ~ sst + depth                               │
    │  ├─ Model 2: coral_cover ~ sst * depth (with interaction)            │
    │  └─ Print summary statistics & p-values                              │
    │                                                                        │
    │  INTERPRETATION:                                                      │
    │  ├─ Coefficient sign indicates direction (positive/negative)          │
    │  ├─ p-value < 0.05 indicates statistical significance                │
    │  └─ R² indicates model fit quality                                    │
    └────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 7: RESULTS TABLE ─────────────────────────────────────────────┐
    │  CROSS-TABULATED SUMMARY                                              │
    │  └─ By temperature category (Cool/Medium/Warm)                        │
    │     × depth category (Shallow/Medium/Deep)                            │
    │     → Mean coral cover & fish biomass                                 │
    │                                                                        │
    │  OUTPUT: results_summary_table.csv                                    │
    └────────────────────────────────────────────────────────────────────┘
                                  ▼
    ┌─ STAGE 8: PROVENANCE LOG ────────────────────────────────────────────┐
    │  DOCUMENT DATA TRANSFORMATION HISTORY                                 │
    │  ├─ Raw data: 50 records                                              │
    │  ├─ After cleaning: ~38 records (76% retention)                       │
    │  ├─ After spatial operations: ~38 records                             │
    │  └─ Final analysis: ~38 records                                       │
    │                                                                        │
    │  OUTPUT: data_provenance_log.csv                                      │
    │  (Shows exactly what happened to each record)                         │
    └────────────────────────────────────────────────────────────────────┘


FINAL OUTPUTS
═════════════════════════════════════════════════════════════════════════════

    outputs/
    ├─ DATA FILES
    │  ├─ temperature_zone_summary.csv
    │  ├─ results_summary_table.csv
    │  └─ data_provenance_log.csv
    │
    ├─ VISUALIZATIONS
    │  ├─ 01_map_reef_sites.png
    │  ├─ 02_scatter_sst.png
    │  ├─ 03_scatter_depth.png
    │  └─ 04_faceted_temp_zones.png
    │
    └─ MODEL SUMMARIES (printed to console)
       ├─ Model 1: coral_cover ~ sst + depth
       │  └─ Coefficients, p-values, R²
       └─ Model 2: coral_cover ~ sst * depth
          └─ Coefficients, p-values, R²


DATA QUALITY PIPELINE
═════════════════════════════════════════════════════════════════════════════

    Raw Input (50 records)
         │
         ├─ Remove flagged outliers
         │  └─ Removed: ~3 records
         │
         ├─ Remove all-missing rows
         │  └─ Removed: ~1 record
         │
         ├─ Remove missing measurements
         │  └─ Removed: ~5 records with missing coral_cover
         │  └─ Removed: ~3 records with missing fish_biomass
         │
         ├─ Remove duplicates
         │  └─ Removed: 0 records
         │
         └─ Validate ranges
            └─ Removed: ~0 (all within expected ranges)
                 │
                 ▼
         Clean Output (~38 records, 76% retention)


FILE DEPENDENCY GRAPH
═════════════════════════════════════════════════════════════════════════════

    generate_raw_data.R
    ├─ Creates: data/raw/reef_survey_sites_raw.csv
    ├─ Creates: data/raw/sst_raw.tif
    ├─ Creates: data/raw/depth_raw.tif
    └─ Creates: data/raw/metadata.csv
         │
         ▼
    analyze_reef_data.R
    ├─ Reads: all files from data/raw/
    ├─ Creates: data/processed/reef_analysis_cleaned.csv
    └─ Creates: outputs/* (all results)


EXECUTION MODES
═════════════════════════════════════════════════════════════════════════════

Mode 1: Full Pipeline (First Time)
    $ Rscript generate_raw_data.R
    $ Rscript analyze_reef_data.R
    └─ Result: Complete analysis with all outputs

Mode 2: Analysis Only (Subsequent Iterations)
    $ Rscript analyze_reef_data.R
    └─ Result: Updated analysis using existing raw data
    └─ Faster: Skips expensive raw data generation

Mode 3: Interactive Development (in RStudio)
    > source("generate_raw_data.R")    # Run once
    > source("analyze_reef_data.R")    # Run multiple times
    └─ Allows inspection of intermediate objects

Mode 4: Version Control
    $ git add generate_raw_data.R analyze_reef_data.R
    $ git add README.md QUICKSTART.md PROJECT_SUMMARY.md
    $ git ignore data/ outputs/
    └─ Result: Reproducible, version-controlled workflow
```

---

## Key Decision Points

### Where Decisions Are Made

```
┌─ generate_raw_data.R
│  ├─ How many sites? (n_sites = 50)
│  ├─ What spatial extent? (36-43°E, 15-28°N)
│  ├─ What data quality issues? (~10% missing values)
│  └─ How much noise in rasters? (~5% missing SST cells)
│
└─ analyze_reef_data.R
   ├─ How to handle missing values? (conservative deletion)
   ├─ How to detect outliers? (quality flags)
   ├─ How to impute raster gaps? (median value)
   ├─ What statistical model? (linear regression)
   └─ What visualizations? (4 plots)
```

### Separation of Concerns

| Aspect | Script 1 | Script 2 | Rationale |
|--------|----------|----------|-----------|
| Data generation | ✓ | | Happens once |
| Data validation | | ✓ | Depends on data quality |
| Data cleaning | | ✓ | Policy-specific decisions |
| Analysis | | ✓ | Iterative refinement |
| Visualization | | ✓ | Results dissemination |

---

## Execution Timeline

```
Timeline (Minutes)

generate_raw_data.R (5 seconds)
├─ Create tibble: 0.5s
├─ Create rasters: 2s
├─ Write files: 1s
└─ Write metadata: 0.5s

analyze_reef_data.R (15 seconds)
├─ Read files: 2s
├─ Clean data: 1s
├─ Spatial operations: 2s
├─ Summary statistics: 1s
├─ Visualizations: 7s
├─ Model fitting: 1s
└─ Write outputs: 1s

Total: ~20 seconds per full run
```

---

## Integration with Larger Pipelines

```
├─ Data Sources
│  └─ generate_raw_data.R ← Can replace with external data source
│
├─ Data Processing
│  └─ analyze_reef_data.R ← Can add validation, unit tests
│
├─ Results
│  └─ outputs/ ← Can pipe to report generation, dashboards
│
└─ Version Control
   └─ Git → Can add CI/CD, automated testing, deployment
```

---

## Customization Flow

```
Want different analysis?
  └─ Modify analyze_reef_data.R
     └─ No changes needed to raw data
     └─ Faster iteration

Want different raw data?
  └─ Modify generate_raw_data.R
     └─ Re-run to regenerate data/raw/
     └─ analyze_reef_data.R runs on new data

Want to add new variable?
  └─ Add to generate_raw_data.R
     └─ Extract in analyze_reef_data.R
     └─ Use in models/visualizations
```

---

**Diagram Version:** 1.0  
**Last Updated:** December 2025
