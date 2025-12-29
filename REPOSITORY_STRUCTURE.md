# Coral Reef Analysis Repository Structure

A professional two-project organization for geospatial ecological analysis.

## Directory Structure

```
coral-reef-analysis/
│
├── README.md                          # Main project overview
├── .gitignore                         # Git configuration
│
├── project-01-reef-geospatial/        # Coral Reef Geospatial Analysis
│   ├── README.md                      # Project-specific guide
│   ├── QUICKSTART.md                  # 5-minute setup
│   ├── ARCHITECTURE.md                # Data flow diagrams
│   ├── generate_raw_data_FIXED.R      # Script 1: Data generation
│   ├── analyze_reef_data_FIXED.R      # Script 2: Analysis
│   │
│   ├── data/
│   │   ├── raw/                       # Raw generated data
│   │   │   ├── .gitkeep
│   │   │   ├── reef_survey_sites_raw.csv
│   │   │   ├── sst_raw.tif
│   │   │   ├── depth_raw.tif
│   │   │   └── metadata.csv
│   │   └── processed/                 # Cleaned data
│   │       ├── .gitkeep
│   │       └── reef_analysis_cleaned.csv
│   │
│   └── outputs/                       # Results
│       ├── .gitkeep
│       ├── 01_map_reef_sites.png
│       ├── 02_scatter_sst.png
│       ├── 03_scatter_depth.png
│       ├── 04_faceted_temp_zones.png
│       ├── temperature_zone_summary.csv
│       ├── results_summary_table.csv
│       └── data_provenance_log.csv
│
├── project-02-eco-socio-integration/  # Ecological + Socio-Economic Integration
│   ├── README.md                      # Project-specific guide
│   ├── ECO_SOCIO_QUICKSTART.md        # 3-minute setup
│   ├── generate_eco_socio_data_FIXED.R  # Script 1: Data generation
│   ├── analyze_eco_socio_data_FIXED.R   # Script 2: Analysis
│   │
│   ├── data/
│   │   ├── raw/                       # Raw generated data
│   │   │   ├── .gitkeep
│   │   │   ├── ecological_raw.csv
│   │   │   ├── socioeconomic_raw.csv
│   │   │   └── metadata.csv
│   │   └── processed/                 # Cleaned & integrated data
│   │       ├── .gitkeep
│   │       └── combined_data_cleaned.csv
│   │
│   └── outputs/                       # Results
│       ├── .gitkeep
│       ├── 01_coral_trends.png
│       ├── 02_fishing_effort_trends.png
│       ├── 03_coral_vs_fishing.png
│       ├── 04_population_trends.png
│       ├── 05_integrated_trends_faceted.png
│       ├── 06_income_vs_coral.png
│       ├── summary_by_region.csv
│       ├── trends_2018_2023.csv
│       └── data_provenance_log.csv
│
└── docs/                              # Shared documentation
    ├── SETUP_GUIDE.md                 # Installation & setup for both
    ├── WORKFLOW_COMPARISON.md         # Before/after refactoring
    ├── PROFESSIONAL_STANDARDS.md      # ETL, best practices
    └── TROUBLESHOOTING.md             # Common issues & solutions
```

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/TejaswiBK/coral-reef-analysis.git
cd coral-reef-analysis
```

### 2. Install Dependencies (One Time)

```r
# In R console
install.packages(c("tidyverse", "sf", "terra", "viridis", "patchwork", "scales"))
```

### 3. Run Project 1 (Reef Geospatial Analysis)

```bash
cd project-01-reef-geospatial
Rscript generate_raw_data_FIXED.R
Rscript analyze_reef_data_FIXED.R
cd ..
```

### 4. Run Project 2 (Eco-Socio Integration)

```bash
cd project-02-eco-socio-integration
Rscript generate_eco_socio_data_FIXED.R
Rscript analyze_eco_socio_data_FIXED.R
cd ..
```

---

## Project Details

### Project 1: Reef Geospatial Analysis
- **Location:** `project-01-reef-geospatial/`
- **Data:** 50 reef survey sites + SST/depth rasters
- **Region:** Red Sea (36-43°E, 15-28°N)
- **Time:** Single year (2023)
- **Outputs:** 4 visualizations + 3 summary tables

**Quick start:**
```bash
cd project-01-reef-geospatial && bash run_analysis.sh
```

### Project 2: Ecological + Socio-Economic Integration
- **Location:** `project-02-eco-socio-integration/`
- **Data:** 5 regions × 6 years (2018-2023)
- **Integration:** Ecological + socio-economic variables
- **Outputs:** 6 visualizations + 3 summary tables

**Quick start:**
```bash
cd project-02-eco-socio-integration && bash run_analysis.sh
```

---

## .gitignore Configuration

```
# Ignore data directories (tracked with .gitkeep for structure)
project-01-reef-geospatial/data/raw/*
project-01-reef-geospatial/data/processed/*
project-01-reef-geospatial/outputs/*

project-02-eco-socio-integration/data/raw/*
project-02-eco-socio-integration/data/processed/*
project-02-eco-socio-integration/outputs/*

# But keep directory structure
!**/data/raw/.gitkeep
!**/data/processed/.gitkeep
!**/outputs/.gitkeep

# Ignore R history and data files
.Rhistory
.Rdata
*.csv
*.tif
*.tiff
*.png
*.pdf

# Ignore RStudio files
.Rproj.user/
*.Rproj

# Ignore system files
.DS_Store
Thumbs.db
```

---

## File Organization Benefits

### Separation of Concerns
- Each project has its own scripts, data, and outputs
- Easy to run projects independently
- Clear folder structure for navigation

### Data Management
- Raw data in `data/raw/` (immutable reference)
- Processed data in `data/processed/` (cleaned/integrated)
- Results in `outputs/` (visualizations & tables)
- `.gitkeep` files maintain directory structure in Git

### Documentation
- Main `README.md` explains the overall repository
- Project-specific `README.md` in each folder
- Shared `docs/` folder for general guidance
- Quick-start guides in each project

### Reproducibility
- Fixed seeds in data generation scripts
- Full audit trails via provenance logs
- Complete file paths for portability
- Both projects can be reproduced independently

---

## Version Control Strategy

### What to Commit
```bash
# R scripts (always)
git add project-*/generate_*.R
git add project-*/analyze_*.R

# Documentation (always)
git add project-*/README.md
git add project-*/*.md
git add docs/

# Directory structure (always)
git add **/. gitkeep
git add .gitignore
```

### What NOT to Commit
```bash
# Data files (too large, regenerated from scripts)
# .csv, .tif files in data/ folders

# Output files (regenerated by analysis scripts)
# .png, .csv files in outputs/ folders

# R history and temporary files
.Rhistory, .Rdata
```

### Reproduce Analysis

For collaborators to reproduce:
```bash
# Clone repo
git clone https://github.com/TejaswiBK/coral-reef-analysis.git
cd coral-reef-analysis

# Run both projects
cd project-01-reef-geospatial && Rscript generate_raw_data_FIXED.R && Rscript analyze_reef_data_FIXED.R
cd ../project-02-eco-socio-integration && Rscript generate_eco_socio_data_FIXED.R && Rscript analyze_eco_socio_data_FIXED.R
```

Results regenerated in seconds!

---

## Directory Navigation

### From Repository Root

```bash
# Run Project 1
cd project-01-reef-geospatial
Rscript generate_raw_data_FIXED.R
Rscript analyze_reef_data_FIXED.R

# Run Project 2
cd ../project-02-eco-socio-integration
Rscript generate_eco_socio_data_FIXED.R
Rscript analyze_eco_socio_data_FIXED.R

# View results
open ../project-01-reef-geospatial/outputs/
open ../project-02-eco-socio-integration/outputs/
```

### From Each Project Folder

```bash
# Inside project-01-reef-geospatial/ or project-02-eco-socio-integration/
Rscript generate_*.R
Rscript analyze_*.R

# All outputs go to relative paths:
# ./data/raw/, ./data/processed/, ./outputs/
```

---

## File Paths in Scripts

All file paths use **relative paths** for portability:

```r
# In generate_raw_data_FIXED.R
write_csv(reef_raw, "data/raw/reef_survey_sites_raw.csv")

# In analyze_reef_data_FIXED.R
reef_raw <- read_csv("data/raw/reef_survey_sites_raw.csv")
write_csv(combined_data, "data/processed/reef_analysis_cleaned.csv")
ggsave("outputs/01_map_reef_sites.png")
```

**Works correctly whether you run from:**
- Repository root: `cd project-01-reef-geospatial && Rscript generate_raw_data_FIXED.R`
- Project folder: `cd project-01-reef-geospatial && Rscript generate_raw_data_FIXED.R`
- RStudio with project open

---

## Shared Documentation Structure

### `docs/SETUP_GUIDE.md`
- Installation instructions for both projects
- R package requirements
- System requirements

### `docs/WORKFLOW_COMPARISON.md`
- Before/after refactoring for both projects
- Benefits of two-script approach
- Professional standards applied

### `docs/PROFESSIONAL_STANDARDS.md`
- ETL pattern explanation
- Data versioning best practices
- Reproducibility guidelines

### `docs/TROUBLESHOOTING.md`
- Common issues for both projects
- Error messages and solutions
- FAQ for each project

---

## README.md Template for Repository Root

```markdown
# Coral Reef Analysis

Professional geospatial and ecological analysis of Red Sea coral reefs.

## Projects

### 1. Reef Geospatial Analysis
Spatial analysis of 50 reef survey sites with environmental variables.
- Location: `project-01-reef-geospatial/`
- Start: See `QUICKSTART.md` in that folder

### 2. Ecological + Socio-Economic Integration
5-region, 6-year analysis integrating ecological and socio-economic data.
- Location: `project-02-eco-socio-integration/`
- Start: See `ECO_SOCIO_QUICKSTART.md` in that folder

## Quick Start

```bash
# Project 1
cd project-01-reef-geospatial
Rscript generate_raw_data_FIXED.R && Rscript analyze_reef_data_FIXED.R

# Project 2
cd ../project-02-eco-socio-integration
Rscript generate_eco_socio_data_FIXED.R && Rscript analyze_eco_socio_data_FIXED.R
```

## Documentation

- `docs/SETUP_GUIDE.md` — Installation & configuration
- `docs/WORKFLOW_COMPARISON.md` — Before/after refactoring
- `docs/PROFESSIONAL_STANDARDS.md` — Best practices applied
- `docs/TROUBLESHOOTING.md` — Common issues & solutions

## Requirements

- R 4.3+
- Packages: tidyverse, sf, terra, viridis, patchwork, scales

See `docs/SETUP_GUIDE.md` for detailed installation.

## Status

✅ Both projects ready to use
✅ Fully documented
✅ Production-ready quality
```

---

## GitHub Repository Layout

When pushed to GitHub, the repository will have:

```
TejaswiBK/coral-reef-analysis
├── README.md
├── .gitignore
├── project-01-reef-geospatial/
│   ├── README.md
│   ├── QUICKSTART.md
│   ├── ARCHITECTURE.md
│   ├── generate_raw_data_FIXED.R
│   ├── analyze_reef_data_FIXED.R
│   └── data/ (structure only, data via scripts)
│   └── outputs/ (structure only, generated by scripts)
├── project-02-eco-socio-integration/
│   ├── README.md
│   ├── ECO_SOCIO_QUICKSTART.md
│   ├── generate_eco_socio_data_FIXED.R
│   ├── analyze_eco_socio_data_FIXED.R
│   └── data/ (structure only, data via scripts)
│   └── outputs/ (structure only, generated by scripts)
└── docs/
    ├── SETUP_GUIDE.md
    ├── WORKFLOW_COMPARISON.md
    ├── PROFESSIONAL_STANDARDS.md
    └── TROUBLESHOOTING.md
```

**Total repository size:** ~500 KB (scripts + documentation only)
**Data generated on-demand:** Scripts regenerate all data automatically

---

## Collaboration Workflow

### For Team Members

1. Clone the repository
2. Install R packages
3. Run scripts to generate data
4. Modify scripts as needed
5. Commit script changes to Git
6. Data regenerates automatically for everyone

### Data Sharing

- **No need to share data files** (everyone regenerates)
- **Share only scripts** (fixed seed = identical results)
- **Version control simplified** (only track code changes)

---

## Next Steps

1. ✅ Create directory structure locally (use commands below)
2. ✅ Copy both R scripts to respective project folders
3. ✅ Copy documentation files
4. ✅ Initialize Git repository
5. ✅ Commit scripts and documentation
6. ✅ Push to GitHub

### Create Directories

```bash
# Clone or create new repo
mkdir coral-reef-analysis && cd coral-reef-analysis

# Project 1
mkdir -p project-01-reef-geospatial/{data/{raw,processed},outputs}
touch project-01-reef-geospatial/data/raw/.gitkeep
touch project-01-reef-geospatial/data/processed/.gitkeep
touch project-01-reef-geospatial/outputs/.gitkeep

# Project 2
mkdir -p project-02-eco-socio-integration/{data/{raw,processed},outputs}
touch project-02-eco-socio-integration/data/raw/.gitkeep
touch project-02-eco-socio-integration/data/processed/.gitkeep
touch project-02-eco-socio-integration/outputs/.gitkeep

# Docs
mkdir -p docs

# Git
git init
echo ".gitignore content here" > .gitignore
```

---

**Repository Structure Ready to Use**  
**Place scripts and documentation in appropriate folders**  
**Run analysis independently for each project**
