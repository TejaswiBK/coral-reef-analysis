# Practical Examples & Troubleshooting Guide

## Getting Started: Step-by-Step

### Example 1: Basic Setup on Your Computer

```bash
# 1. Create a project directory
mkdir ~/coral-reef-analysis
cd ~/coral-reef-analysis

# 2. Create subdirectories
mkdir -p data/raw data/processed outputs

# 3. Place your R files here:
# - generate_raw_data.R
# - analyze_reef_data.R

# 4. Install packages (in R console)
install.packages(c("tidyverse", "sf", "terra", "viridis"))

# 5. Run the scripts
Rscript generate_raw_data.R
Rscript analyze_reef_data.R

# 6. View results
ls outputs/          # List output files
ls data/raw/         # List raw data files
```

---

## Common Customizations with Examples

### Example 2: Generate 200 Sites Instead of 50

**File:** `generate_raw_data.R`

**Find line 20:**
```r
n_sites <- 50
```

**Change to:**
```r
n_sites <- 200
```

**Result:**
- 200 reef sites generated
- Larger datasets for analysis
- Rasters remain same size

**Run:**
```bash
Rscript generate_raw_data.R
Rscript analyze_reef_data.R
```

---

### Example 3: Increase Missing Data to 25%

**File:** `generate_raw_data.R`

**Find lines 34-35:**
```r
coral_cover = ifelse(runif(n_sites) < 0.1, NA, coral_cover),
fish_biomass = ifelse(runif(n_sites) < 0.08, NA, fish_biomass)
```

**Change to:**
```r
coral_cover = ifelse(runif(n_sites) < 0.25, NA, coral_cover),  # 25% missing
fish_biomass = ifelse(runif(n_sites) < 0.25, NA, fish_biomass)  # 25% missing
```

**Result:**
- More challenging data quality scenario
- More records removed during cleaning
- Useful for testing robustness

---

### Example 4: Use Different Geographic Region

**File:** `generate_raw_data.R`

**Find line 49:**
```r
extent_vec <- c(36, 43, 15, 28)  # Red Sea
```

**Change to Indian Ocean:**
```r
extent_vec <- c(40, 75, -20, 5)  # Indian Ocean
```

**Or change to Caribbean:**
```r
extent_vec <- c(-85, -60, 10, 25)  # Caribbean
```

**Update labels in comments:**
```r
# Create XX reef survey sites in the Indian Ocean
```

---

### Example 5: Use Mean Instead of Median for SST Imputation

**File:** `analyze_reef_data.R`

**Find lines 103-104:**
```r
if (any(is.na(sst_values))) {
  sst_values[is.na(sst_values)] <- median(sst_values, na.rm = TRUE)
```

**Change to:**
```r
if (any(is.na(sst_values))) {
  sst_values[is.na(sst_values)] <- mean(sst_values, na.rm = TRUE)
```

**Run analysis:**
```bash
Rscript analyze_reef_data.R
```

---

### Example 6: Export Results to Excel

**File:** `analyze_reef_data.R`

**After line 220 (after creating results_table), add:**
```r
# Install once: install.packages("openxlsx")
library(openxlsx)

# Export to Excel with multiple sheets
wb <- createWorkbook()
addWorksheet(wb, "Summary")
addWorksheet(wb, "Results")

writeData(wb, "Summary", temp_zone_summary)
writeData(wb, "Results", results_table)

saveWorkbook(wb, "outputs/reef_analysis_results.xlsx", overwrite = TRUE)
cat("✓ Saved: outputs/reef_analysis_results.xlsx\n")
```

**Then run:**
```bash
Rscript analyze_reef_data.R
```

---

### Example 7: Add a Third Temperature Zone with Different Thresholds

**File:** `analyze_reef_data.R`

**Find line 152 (temp_zone_summary calculation):**
```r
mutate(temp_zone = cut(sst, breaks = 3, labels = c("Cool", "Medium", "Warm")))
```

**Change to custom breaks:**
```r
mutate(temp_zone = cut(
  sst,
  breaks = c(0, 23, 25, 27, 100),
  labels = c("Very Cool", "Cool", "Warm", "Very Warm")
))
```

**Result:**
- 4 temperature zones instead of 3
- Custom threshold at 23°C, 25°C, 27°C

---

## Troubleshooting Guide

### Issue 1: "Could not find function 'write_csv'"

**Error Message:**
```
Error: could not find function "write_csv"
```

**Cause:** tidyverse not installed

**Solution:**
```r
install.packages("tidyverse")
library(tidyverse)
```

**Then run:**
```bash
Rscript generate_raw_data.R
```

---

### Issue 2: "File not found"

**Error Message:**
```
Error in read_csv("data/raw/reef_survey_sites_raw.csv"): 
  Cannot find file 'data/raw/reef_survey_sites_raw.csv'
```

**Cause:** 
- Working directory is wrong
- OR Script 1 hasn't been run yet

**Solution:**
```r
# Check current directory
getwd()

# If not in coral-reef-analysis folder:
setwd("/path/to/coral-reef-analysis")

# Then run Script 1 first
source("generate_raw_data.R")

# Then run Script 2
source("analyze_reef_data.R")
```

---

### Issue 3: "Raster file not found"

**Error Message:**
```
Error in rast("data/raw/sst_raw.tif"): 
  [rast] cannot find file
```

**Cause:** terra package not installed OR file wasn't created

**Solution:**
```r
install.packages("terra")
library(terra)

# Then regenerate raw data:
source("generate_raw_data.R")
```

---

### Issue 4: "Out of memory"

**Error Message:**
```
Error: cannot allocate vector of size X MB
```

**Cause:** Too many sites or high raster resolution

**Solutions:**

Option A: Reduce number of sites
```r
# In generate_raw_data.R, line 20
n_sites <- 100  # Instead of 200
```

Option B: Reduce raster resolution
```r
# In generate_raw_data.R, line 50
resolution <- 0.5  # Instead of 0.1
```

Option C: Restart R and clean memory
```r
rm(list = ls())
gc()  # Garbage collection
```

---

### Issue 5: Plots Are Blank or Not Saving

**Error Message:**
```
Warning message: Could not find/read file
```

**Cause:** ggplot not installed OR graphics device issue

**Solution:**
```r
install.packages("ggplot2")

# Or try different graphics backend:
# Windows
windows()
# Mac
quartz()
# Linux
x11()
```

---

### Issue 6: Model Results Are "NAs" or "NaN"

**Error Message:**
```
Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)       NA         NA      NA       NA
sst                NA         NA      NA       NA
```

**Cause:** Insufficient data after cleaning OR multicollinearity

**Solution:**
```r
# Check how many records remain:
cat("Remaining records:", nrow(reef_analysis), "\n")

# Check for correlations:
cor(reef_analysis[, c("coral_cover", "sst", "depth")])

# If too few records, reduce cleaning strictness:
# In analyze_reef_data.R, comment out one filter condition
```

---

## Data Quality Scenarios

### Scenario 1: Conservative Cleaning (Current)

```r
# In analyze_reef_data.R, lines 60-75
reef_clean <- reef_raw |>
  filter(data_quality_flag != "OUTLIER") |>
  filter(!(is.na(coral_cover) & is.na(fish_biomass))) |>
  filter(!is.na(coral_cover), !is.na(fish_biomass)) |>  # DELETE ANY MISSING
  distinct() |>
  filter(coral_cover >= 0 & coral_cover <= 100, ...)

# Result: ~38/50 records retained (24% loss)
```

---

### Scenario 2: Aggressive Cleaning (Keep more data)

```r
# In analyze_reef_data.R, lines 60-75
reef_clean <- reef_raw |>
  filter(data_quality_flag != "OUTLIER") |>
  filter(!(is.na(coral_cover) & is.na(fish_biomass))) |>
  # REMOVED: filter(!is.na(coral_cover), !is.na(fish_biomass))
  mutate(
    coral_cover = ifelse(is.na(coral_cover), mean(coral_cover, na.rm = TRUE), coral_cover),
    fish_biomass = ifelse(is.na(fish_biomass), mean(fish_biomass, na.rm = TRUE), fish_biomass)
  ) |>  # IMPUTE MISSING VALUES
  distinct() |>
  filter(coral_cover >= 0 & coral_cover <= 100, ...)

# Result: ~45/50 records retained (10% loss)
```

---

### Scenario 3: Keep All Records (No cleaning)

```r
# In analyze_reef_data.R, lines 60-75
reef_clean <- reef_raw |>
  select(-data_quality_flag, -observer_notes) |>
  mutate(
    coral_cover = ifelse(is.na(coral_cover), mean(coral_cover, na.rm = TRUE), coral_cover),
    fish_biomass = ifelse(is.na(fish_biomass), mean(fish_biomass, na.rm = TRUE), fish_biomass)
  )

# Result: 50/50 records retained (0% loss, but potentially biased)
```

---

## Analysis Variations

### Variation 1: Non-Linear Model (GAM)

**Add to analyze_reef_data.R after line 220:**

```r
# Install: install.packages("mgcv")
library(mgcv)

# Fit generalized additive model
model_gam <- gam(coral_cover ~ s(sst) + s(depth), data = reef_analysis)
summary(model_gam)
```

---

### Variation 2: Bayesian Model (Stan)

**Add to analyze_reef_data.R after line 220:**

```r
# Install: install.packages("rstanarm")
library(rstanarm)

# Fit Bayesian linear model
model_bayes <- stan_glm(
  coral_cover ~ sst + depth,
  data = reef_analysis,
  chains = 4,
  iter = 2000
)
summary(model_bayes)
```

---

### Variation 3: Robust Regression (Outlier-Resistant)

**Add to analyze_reef_data.R after line 220:**

```r
# Install: install.packages("MASS")
library(MASS)

# Fit robust regression
model_robust <- rlm(coral_cover ~ sst + depth, data = reef_analysis)
summary(model_robust)
```

---

## Batch Processing Multiple Regions

### Example: Analyze Same Data Structure for 3 Regions

**File:** `batch_analysis.R`

```r
library(tidyverse)
source("analyze_reef_data.R")  # Load analysis functions

# Define regions
regions <- list(
  list(name = "Red_Sea", extent = c(36, 43, 15, 28)),
  list(name = "Indian_Ocean", extent = c(40, 75, -20, 5)),
  list(name = "Caribbean", extent = c(-85, -60, 10, 25))
)

# For each region
for (region in regions) {
  cat("\n=== Processing:", region$name, "===\n")
  
  # Generate region-specific data
  # ... (modify generate_raw_data.R to use region$extent)
  
  # Analyze
  source("analyze_reef_data.R")
  
  # Rename outputs
  file.rename(
    "outputs/results_summary_table.csv",
    paste0("outputs/results_", region$name, ".csv")
  )
}
```

---

## Integration with Git

### .gitignore File

```
# Ignore large data files
data/raw/*
data/processed/*
outputs/*

# But keep directory structure
!data/raw/.gitkeep
!data/processed/.gitkeep
!outputs/.gitkeep

# Ignore R history
.Rhistory
.Rdata

# Ignore RStudio files
.Rproj.user/
*.Rproj

# Ignore logs
*.log
logs/
```

### Git Workflow

```bash
# Initialize repo
git init

# Add only scripts and documentation
git add generate_raw_data.R analyze_reef_data.R README.md QUICKSTART.md
git add ARCHITECTURE.md PROJECT_SUMMARY.md

# Ignore data
git add .gitignore

# Commit
git commit -m "Initial coral reef analysis workflow"

# View status
git status
```

---

## Automated Execution with Cron (Linux/Mac)

### Daily Analysis Update

**File:** `run_analysis.sh`

```bash
#!/bin/bash

# Set working directory
cd /home/user/coral-reef-analysis

# Run analysis
Rscript generate_raw_data.R >> logs/generate_$(date +%Y%m%d).log 2>&1
Rscript analyze_reef_data.R >> logs/analyze_$(date +%Y%m%d).log 2>&1

# Optional: Push to GitHub
git add outputs/*
git commit -m "Automated analysis $(date +%Y-%m-%d)"
git push origin main
```

**Add to crontab:**
```bash
crontab -e
```

**Add line:**
```
0 2 * * * /home/user/coral-reef-analysis/run_analysis.sh
```

**This runs the analysis every day at 2 AM.**

---

## Performance Optimization

### Slow Analysis? Try These Optimizations

**1. Cache cleaned data**
```r
# In analyze_reef_data.R, add at start:
cache_file <- "data/processed/reef_analysis_cleaned.csv"

if (file.exists(cache_file)) {
  reef_analysis <- read_csv(cache_file)
  cat("Loaded from cache\n")
} else {
  # ... run full analysis ...
  write_csv(reef_analysis, cache_file)
}
```

**2. Reduce visualization resolution**
```r
# In analyze_reef_data.R, change:
ggsave("outputs/01_map_reef_sites.png", map_coral, dpi = 150)  # Instead of 300
```

**3. Parallel processing for multiple datasets**
```r
# Install: install.packages("furrr")
library(furrr)

plan(multisession, workers = 4)

# Run multiple analyses in parallel
future_map(datasets, ~analyze_dataset(.))
```

---

## Debugging Tips

### Enable Verbose Logging

**Add at top of scripts:**
```r
# Verbose mode
VERBOSE <- TRUE

debug_cat <- function(...) {
  if (VERBOSE) cat(...)
}

debug_cat("Starting analysis...\n")
```

### Inspect Intermediate Objects

**In analyze_reef_data.R:**
```r
# After reading data
str(reef_raw)      # Structure
glimpse(reef_raw)  # Quick view
head(reef_raw, 20) # First 20 rows
summary(reef_raw)  # Statistical summary

# Check for issues
map_df(reef_raw, ~sum(is.na(.)))  # Count NAs per column
```

### Save Intermediate Results

```r
# After cleaning
write_csv(reef_clean, "debug/reef_clean_step2.csv")

# After spatial operations
write_csv(reef_analysis, "debug/reef_analysis_step3.csv")

# Check dimensions at each step
cat("After cleaning:", nrow(reef_clean), "rows\n")
cat("After spatial:", nrow(reef_analysis), "rows\n")
```

---

## Next Steps

1. ✅ Choose a customization example
2. ✅ Modify the script
3. ✅ Run and check results
4. ✅ Compare with original outputs
5. ✅ Iterate as needed

**For issues:** Check this troubleshooting guide or refer to README.md for detailed explanations.

---

**Guide Version:** 1.0  
**Last Updated:** December 2025  
**Tested with:** R 4.3+, RStudio 2023.12+
