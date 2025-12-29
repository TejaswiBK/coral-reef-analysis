# Setup Guide: Coral Reef Analysis Repository

Complete installation and setup instructions for both projects in the coral-reef-analysis repository.

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation Steps](#installation-steps)
3. [Verify Installation](#verify-installation)
4. [Project-Specific Setup](#project-specific-setup)
5. [Troubleshooting](#troubleshooting)
6. [Next Steps](#next-steps)

---

## System Requirements

### Operating System
- **Windows 10+** (with Git Bash or WSL recommended)
- **macOS 10.13+** (Intel or Apple Silicon)
- **Linux** (Ubuntu 20.04+, Debian, Fedora, etc.)

### Software Requirements

#### R (Required)
- **Version:** R 4.3 or later
- **Download:** https://www.r-project.org/
- **Verify installation:**
  ```bash
  R --version
  ```

#### Git (Required)
- **Version:** Git 2.30 or later
- **Download:** https://git-scm.com/
- **Verify installation:**
  ```bash
  git --version
  ```

#### RStudio (Optional but Recommended)
- **Version:** RStudio 2023.10 or later
- **Download:** https://posit.co/download/rstudio-desktop/
- Makes development and running scripts easier

### System Specifications
- **Disk Space:** ~500 MB (for code + packages)
- **RAM:** 2 GB minimum (8 GB recommended)
- **Internet:** Required for package installation

---

## Installation Steps

### Step 1: Install R

#### On Windows
1. Download from https://www.r-project.org/
2. Run the installer
3. Accept default settings
4. Complete installation

#### On macOS
```bash
# Using Homebrew (recommended)
brew install r

# Or download from https://www.r-project.org/
```

#### On Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install r-base r-base-dev
```

#### Verify R Installation
```bash
R --version
# Should show R version 4.3.0 or later
```

---

### Step 2: Install Git

#### On Windows
1. Download from https://git-scm.com/download/win
2. Run installer
3. Accept default settings
4. Complete installation

#### On macOS
```bash
# Using Homebrew
brew install git

# Or download from https://git-scm.com/
```

#### On Linux
```bash
# Ubuntu/Debian
sudo apt install git

# Fedora/RHEL
sudo dnf install git
```

#### Verify Git Installation
```bash
git --version
# Should show git version 2.30.0 or later
```

---

### Step 3: Install R Packages

Open R or RStudio and run:

```r
# Install all required packages
install.packages(c(
  "tidyverse",    # Data manipulation and visualization
  "sf",           # Spatial features (for Project 1)
  "terra",        # Raster data (for Project 1)
  "viridis",      # Color scales
  "patchwork",    # Plot composition
  "scales"        # Scaling for axes
))
```

**Expected time:** 2-5 minutes (depends on internet speed)

**Success indicator:** All packages install without errors and show:
```
* DONE (package_name)
```

#### Alternative: Command Line Installation
```bash
R -e "install.packages(c('tidyverse', 'sf', 'terra', 'viridis', 'patchwork', 'scales'))"
```

#### Verify Package Installation
```r
# In R console, check if packages load:
library(tidyverse)
library(sf)
library(terra)
library(viridis)
library(patchwork)
library(scales)

# Should load without errors
```

---

### Step 4: Clone the Repository

#### Option A: Using Git Command Line (Recommended)

```bash
# Navigate to where you want the repository
cd ~/Documents
# Or: cd C:\Users\YourName\Documents (Windows)

# Clone the repository
git clone https://github.com/TejaswiBK/coral-reef-analysis.git

# Enter the repository
cd coral-reef-analysis
```

#### Option B: Using GitHub Desktop

1. Go to https://github.com/TejaswiBK/coral-reef-analysis
2. Click green "Code" button
3. Select "Open with GitHub Desktop"
4. Choose local path and clone

#### Option C: Download ZIP (Not Recommended)

1. Go to https://github.com/TejaswiBK/coral-reef-analysis
2. Click green "Code" button
3. Click "Download ZIP"
4. Extract to desired location
5. (Note: You won't have Git version control this way)

---

### Step 5: Create Directory Structure

Navigate to the repository and create directories:

#### Automated (Linux/macOS)
```bash
cd coral-reef-analysis
bash setup.sh
```

#### Manual (All Platforms)

**Windows (Command Prompt):**
```cmd
# Project 1
mkdir project-01-reef-geospatial\data\raw
mkdir project-01-reef-geospatial\data\processed
mkdir project-01-reef-geospatial\outputs

# Project 2
mkdir project-02-eco-socio-integration\data\raw
mkdir project-02-eco-socio-integration\data\processed
mkdir project-02-eco-socio-integration\outputs

# Docs
mkdir docs
```

**macOS/Linux:**
```bash
# Project 1
mkdir -p project-01-reef-geospatial/{data/{raw,processed},outputs}
mkdir -p project-02-eco-socio-integration/{data/{raw,processed},outputs}
mkdir -p docs
```

---

### Step 6: Verify Directory Structure

```bash
# Check that directories exist
tree coral-reef-analysis -L 2
# Or list contents
ls -la project-01-reef-geospatial/
ls -la project-02-eco-socio-integration/
```

Expected output:
```
project-01-reef-geospatial/
├── data/
│   ├── raw/
│   └── processed/
└── outputs/

project-02-eco-socio-integration/
├── data/
│   ├── raw/
│   └── processed/
└── outputs/
```

---

## Verify Installation

### Test R Setup

```bash
# Open R
R

# In R console, run:
packageVersion("tidyverse")
packageVersion("sf")
packageVersion("terra")

# Should show version numbers without errors
q()  # Exit R
```

### Test Project 1

```bash
cd project-01-reef-geospatial
Rscript generate_raw_data_FIXED.R
# Should create: data/raw/reef_survey_sites_raw.csv, etc.
# Should complete in ~2 seconds
```

### Test Project 2

```bash
cd ../project-02-eco-socio-integration
Rscript generate_eco_socio_data_FIXED.R
# Should create: data/raw/ecological_raw.csv, etc.
# Should complete in ~2 seconds
```

### Check Generated Files

```bash
# Project 1
ls -la project-01-reef-geospatial/data/raw/
# Should show: reef_survey_sites_raw.csv, sst_raw.csv, depth_raw.csv, metadata.csv

# Project 2
ls -la project-02-eco-socio-integration/data/raw/
# Should show: ecological_raw.csv, socioeconomic_raw.csv, metadata.csv
```

---

## Project-Specific Setup

### Project 1: Reef Geospatial Analysis

**Quick Start:**
```bash
cd project-01-reef-geospatial

# Generate data (run once)
Rscript generate_raw_data_FIXED.R

# Analyze and visualize (run multiple times)
Rscript analyze_reef_data_FIXED.R

# Check results
open outputs/  # macOS
xdg-open outputs/  # Linux
start outputs  # Windows
```

**Documentation:** See `project-01-reef-geospatial/QUICKSTART.md`

---

### Project 2: Ecological + Socio-Economic Integration

**Quick Start:**
```bash
cd project-02-eco-socio-integration

# Generate data (run once)
Rscript generate_eco_socio_data_FIXED.R

# Analyze and visualize (run multiple times)
Rscript analyze_eco_socio_data_FIXED.R

# Check results
open outputs/  # macOS
xdg-open outputs/  # Linux
start outputs  # Windows
```

**Documentation:** See `project-02-eco-socio-integration/ECO_SOCIO_QUICKSTART.md`

---

## Troubleshooting

### R Package Installation Issues

#### Error: "Package not found on CRAN"

**Solution:**
```r
# Check your internet connection
# Try specifying a different CRAN mirror
options(repos=c(CRAN="https://cloud.r-project.org"))
install.packages("package_name")
```

#### Error: "Library not found" (macOS with Apple Silicon)

**Solution:**
```bash
# Install packages with arm64 architecture
# This usually happens automatically, but if not:
install.packages("package_name", type="binary")
```

#### Compiler Error on Windows

**Solution:**
- Install Rtools: https://cran.r-project.org/bin/windows/Rtools/
- Restart R after installation
- Try package installation again

### Git Clone Issues

#### Error: "Permission denied (publickey)"

**Solution:**
```bash
# If cloning with SSH fails, use HTTPS instead:
git clone https://github.com/TejaswiBK/coral-reef-analysis.git
# Instead of: git@github.com:TejaswiBK/coral-reef-analysis.git
```

#### Error: "Repository not found"

**Solution:**
- Verify URL is correct: https://github.com/TejaswiBK/coral-reef-analysis
- Check your internet connection
- Verify GitHub is not blocked by firewall

### Script Execution Issues

#### Error: "File not found"

**Solution:**
```bash
# Make sure you're in the correct directory
pwd  # Check current directory
cd project-01-reef-geospatial  # Navigate correctly
Rscript generate_raw_data_FIXED.R
```

#### Error: "Permission denied" (macOS/Linux)

**Solution:**
```bash
# Make script executable
chmod +x generate_raw_data_FIXED.R
# Then run
Rscript generate_raw_data_FIXED.R
```

#### Error: "setwd: Cannot change directory"

**Solution:**
```bash
# Make sure data directories exist
mkdir -p data/raw data/processed outputs
# Then run script
Rscript analyze_eco_socio_data_FIXED.R
```

### Data Generation Issues

#### Error: "Column missing" or "Variable not found"

**Solution:**
- Ensure you're using the FIXED versions of scripts
- Check that previous script completed successfully
- Delete data/ folder and regenerate from scratch

#### Plots not appearing

**Solution:**
```bash
# Check if outputs directory exists
ls -la outputs/

# If missing, create it
mkdir -p outputs

# Rerun analysis script
Rscript analyze_reef_data_FIXED.R
```

---

## Verifying Everything Works

### Complete Verification Checklist

```bash
# 1. Check R is installed
R --version

# 2. Check Git is installed
git --version

# 3. Check you're in repository
pwd  # Should end with: coral-reef-analysis

# 4. Check directories exist
ls -la project-01-reef-geospatial/
ls -la project-02-eco-socio-integration/

# 5. Check R packages can load
R -e "library(tidyverse); library(sf); library(terra); cat('✓ All packages loaded\n')"

# 6. Run Project 1
cd project-01-reef-geospatial
Rscript generate_raw_data_FIXED.R
Rscript analyze_reef_data_FIXED.R
echo "✓ Project 1 complete"

# 7. Run Project 2
cd ../project-02-eco-socio-integration
Rscript generate_eco_socio_data_FIXED.R
Rscript analyze_eco_socio_data_FIXED.R
echo "✓ Project 2 complete"

# 8. Check outputs
ls -la project-01-reef-geospatial/outputs/
ls -la project-02-eco-socio-integration/outputs/
```

**If all steps complete without errors, setup is successful! ✅**

---

## Environment Setup (Optional)

### Using RStudio

1. Open RStudio
2. Click **File → Open Project**
3. Navigate to `coral-reef-analysis/`
4. Select `.Rproj` file (if exists, otherwise just open folder)
5. Working directory automatically set correctly

### Using VS Code

1. Install R extension
2. Open VS Code
3. Open folder: `coral-reef-analysis/`
4. Use integrated terminal to run scripts

### Using Command Line (Terminal/Git Bash)

```bash
# Navigate to repository
cd coral-reef-analysis

# Set your working directory properly
cd project-01-reef-geospatial

# Run scripts
Rscript generate_raw_data_FIXED.R
Rscript analyze_reef_data_FIXED.R
```

---

## Next Steps

1. ✅ Complete setup (follow above steps)
2. ✅ Verify installation (run verification checklist)
3. ✅ Read main `README.md` in repository root
4. ✅ Start with Project 1: Read `project-01-reef-geospatial/QUICKSTART.md`
5. ✅ Then Project 2: Read `project-02-eco-socio-integration/ECO_SOCIO_QUICKSTART.md`
6. ✅ Explore visualizations and results in `outputs/` folders

---

## Getting Help

### Documentation
- **Main Overview:** `README.md` (repository root)
- **Project 1 Setup:** `project-01-reef-geospatial/QUICKSTART.md`
- **Project 2 Setup:** `project-02-eco-socio-integration/ECO_SOCIO_QUICKSTART.md`
- **This Guide:** `docs/SETUP_GUIDE.md`

### Common Resources
- **R Documentation:** https://www.r-project.org/
- **Git Help:** https://git-scm.com/doc
- **RStudio Support:** https://posit.co/support/

### Reporting Issues
- Check this troubleshooting guide first
- Search existing GitHub Issues
- Create new GitHub Issue with error message

---

## Uninstall / Clean Up

### Remove Repository (Keep R & Git)

```bash
# Navigate out of repository
cd ..

# Delete repository folder
rm -rf coral-reef-analysis  # macOS/Linux
rmdir /s coral-reef-analysis  # Windows CMD
```

### Remove R Packages (If Needed)

```r
# In R console
remove.packages("tidyverse")
remove.packages("sf")
remove.packages("terra")
remove.packages("viridis")
remove.packages("patchwork")
remove.packages("scales")
```

### Remove R (If Completely Uninstalling)

#### Windows
- Control Panel → Programs → Uninstall a Program → R → Remove

#### macOS
```bash
sudo rm -rf /Library/Frameworks/R.framework
```

#### Linux
```bash
sudo apt remove r-base r-base-dev  # Ubuntu/Debian
sudo dnf remove R  # Fedora
```

---

## System-Specific Notes

### Windows Users

- Use **Git Bash** for running bash commands (included with Git)
- Alternatively, use **Windows PowerShell** or **Command Prompt**
- Path separators: Use forward slashes `/` in R scripts
- File paths in R: Use `data/raw/file.csv` not `data\raw\file.csv`

### macOS Users

- M1/M2 (Apple Silicon) macs: Use `install.packages(..., type="binary")`
- Homebrew recommended for installing R and Git
- Use Terminal.app or iTerm2

### Linux Users

- Most distros already have Git
- Use package manager to install R: `apt install r-base`, etc.
- Command line tools work the same as macOS

---

## Advanced Setup (Optional)

### Using Docker

```bash
# If you have Docker installed
docker run -it --rm -v $(pwd):/work rocker/tidyverse:latest

# In container:
cd /work
Rscript generate_eco_socio_data_FIXED.R
```

### Using Conda Environment

```bash
# Create isolated environment
conda create -n coral-reef r-base r-tidyverse
conda activate coral-reef

# Run scripts
Rscript generate_eco_socio_data_FIXED.R
```

---

## Quick Reference

### Installation Summary

```bash
# 1. Install R, Git, RStudio (from websites)
# 2. Install packages
R -e "install.packages(c('tidyverse', 'sf', 'terra', 'viridis', 'patchwork', 'scales'))"

# 3. Clone repository
git clone https://github.com/TejaswiBK/coral-reef-analysis.git

# 4. Create directories
cd coral-reef-analysis
bash setup.sh  # or create manually

# 5. Run projects
cd project-01-reef-geospatial && Rscript generate_raw_data_FIXED.R && Rscript analyze_reef_data_FIXED.R
cd ../project-02-eco-socio-integration && Rscript generate_eco_socio_data_FIXED.R && Rscript analyze_eco_socio_data_FIXED.R
```

**Total time:** ~10 minutes (first time)

---

**Setup Complete!** 🎉

You're now ready to use the coral-reef-analysis repository. Start with the main `README.md`.
