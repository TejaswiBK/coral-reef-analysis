# Troubleshooting Guide: Coral Reef Analysis

Solutions for common problems you might encounter when using the coral-reef-analysis repository.

---

## 📋 Table of Contents

1. [Installation Issues](#installation-issues)
2. [Script Execution Issues](#script-execution-issues)
3. [Data Generation Issues](#data-generation-issues)
4. [Analysis and Visualization Issues](#analysis-and-visualization-issues)
5. [Git and Version Control Issues](#git-and-version-control-issues)
6. [File System Issues](#file-system-issues)
7. [Performance Issues](#performance-issues)
8. [Getting Help](#getting-help)

---

## Installation Issues

### Issue: R Installation Not Found

**Error Message:**
```
'R' is not recognized as an internal or external command
```

**Causes:**
- R not installed
- R not in system PATH
- Computer needs restart after installation

**Solutions:**

1. **Verify R is installed:**
   ```bash
   R --version
   ```

2. **If not found, download and install:**
   - Windows: https://www.r-project.org/
   - macOS: `brew install r`
   - Linux: `sudo apt install r-base`

3. **Restart computer** after installation

4. **Add R to PATH** (Windows):
   - Control Panel → System → Advanced System Settings
   - Environment Variables → New → `R_HOME` = `C:\Program Files\R\R-4.3.0`

---

### Issue: Git Installation Not Found

**Error Message:**
```
'git' is not recognized as an internal or external command
```

**Solutions:**

1. **Verify Git is installed:**
   ```bash
   git --version
   ```

2. **Install Git:**
   - Windows: https://git-scm.com/download/win
   - macOS: `brew install git`
   - Linux: `sudo apt install git`

3. **Restart terminal/command prompt**

---

### Issue: R Packages Won't Install

**Error Message:**
```
Error: could not find package "tidyverse"
```

**Causes:**
- No internet connection
- Wrong CRAN mirror
- Compiler missing (for packages with C++ code)

**Solutions:**

1. **Check internet connection:**
   ```bash
   ping google.com
   ```

2. **Try different CRAN mirror:**
   ```r
   options(repos=c(CRAN="https://cloud.r-project.org"))
   install.packages("tidyverse")
   ```

3. **For Windows compiler errors:**
   - Install Rtools: https://cran.r-project.org/bin/windows/Rtools/
   - Restart R
   - Try installation again

4. **For macOS (Apple Silicon) issues:**
   ```r
   install.packages("tidyverse", type="binary")
   ```

5. **Install packages one by one:**
   ```r
   install.packages("tidyverse")
   install.packages("sf")
   install.packages("terra")
   # etc.
   ```

---

### Issue: Package Load Fails

**Error Message:**
```
Error in library(tidyverse): there is no package called 'tidyverse'
```

**Solutions:**

1. **Verify installation:**
   ```r
   library(tidyverse)  # Should load without error
   ```

2. **Reinstall package:**
   ```r
   remove.packages("tidyverse")
   install.packages("tidyverse")
   library(tidyverse)
   ```

3. **Check R version:**
   ```r
   R.version$major  # Should be 4 or higher
   ```

---

## Script Execution Issues

### Issue: "File not found" When Running Script

**Error Message:**
```
Error: File not found. data/raw/ecological_raw.csv
```

**Causes:**
- Wrong working directory
- Data generation script not run first
- File path incorrect

**Solutions:**

1. **Check working directory:**
   ```bash
   pwd  # macOS/Linux: Print Working Directory
   cd   # Windows: Show current directory
   ```

2. **Navigate to correct project:**
   ```bash
   cd project-02-eco-socio-integration
   ```

3. **Run data generation first:**
   ```bash
   Rscript generate_eco_socio_data_FIXED.R
   # This creates data/raw/files
   ```

4. **Verify files exist:**
   ```bash
   ls -la data/raw/  # macOS/Linux
   dir data\raw\     # Windows
   ```

---

### Issue: "Permission denied" Running Script

**Error Message:**
```
bash: ./generate_eco_socio_data_FIXED.R: Permission denied
```

**Causes:**
- File doesn't have execute permission
- On Windows with incorrect line endings

**Solutions:**

1. **Use Rscript instead:**
   ```bash
   Rscript generate_eco_socio_data_FIXED.R
   # Instead of: ./generate_eco_socio_data_FIXED.R
   ```

2. **Or make file executable (macOS/Linux):**
   ```bash
   chmod +x generate_eco_socio_data_FIXED.R
   ./generate_eco_socio_data_FIXED.R
   ```

3. **Or run from R console:**
   ```r
   source("generate_eco_socio_data_FIXED.R")
   ```

---

### Issue: Script Stops With No Error

**Symptom:**
- Script starts but stops halfway through
- No error message displayed
- Outputs partially created

**Causes:**
- Script contains `stop()` or assertion failure
- Memory issues
- Incomplete data

**Solutions:**

1. **Run script with verbose output:**
   ```bash
   Rscript generate_eco_socio_data_FIXED.R 2>&1 | tee output.log
   ```

2. **Run in R console with more detail:**
   ```r
   source("generate_eco_socio_data_FIXED.R")
   # Can see exact line where it stops
   ```

3. **Check data exists before analysis:**
   ```r
   if (file.exists("data/raw/ecological_raw.csv")) {
     cat("✓ Data file exists\n")
   } else {
     cat("✗ Data file missing - run generation script first\n")
   }
   ```

---

## Data Generation Issues

### Issue: Generated Data Numbers Different Each Time

**Symptom:**
- Run script twice, get different numbers
- Expect same results (seed is set)

**Causes:**
- Different R version
- Different package version
- Different operating system (rare)
- Seed not being set correctly

**Solutions:**

1. **Verify seed is set:**
   ```r
   set.seed(456)  # Should be in script
   rnorm(5)       # Same 5 numbers every time
   ```

2. **Check R version compatibility:**
   ```r
   R.version
   # Results reproducible within same R version
   ```

3. **Delete old data and regenerate:**
   ```bash
   rm -rf data/raw/*  # macOS/Linux
   Rscript generate_eco_socio_data_FIXED.R
   ```

---

### Issue: Data Quality Flags Unexpected

**Symptom:**
- More records flagged as SUSPECT/OUTLIER than expected
- Fewer records retained after cleaning

**Causes:**
- Quality thresholds too strict
- Data ranges need adjustment
- Random variation in generation

**Solutions:**

1. **Check quality flag definitions:**
   - Open data_provenance_log.csv
   - See how many records flagged and why

2. **Adjust thresholds in script:**
   ```r
   # In generate script, modify ranges:
   coral_cover <- case_when(
     region == "Gulf of Aqaba" ~ 65 - (year - 2018) * 1.5 + rnorm(n(), 0, 3),
     # Adjust the numbers to change data generation
   )
   ```

3. **Adjust cleaning criteria in analysis script:**
   ```r
   # In analyze script, modify filters:
   data_cleaned <- data_raw |>
     filter(quality_flag != "OUTLIER")  # Change filtering logic
   ```

---

## Analysis and Visualization Issues

### Issue: Plots Not Created

**Error Message:**
```
Error: Cannot open file "outputs/01_coral_trends.png"
```

**Causes:**
- outputs/ directory doesn't exist
- No write permission to outputs/
- Error in plot code

**Solutions:**

1. **Create outputs directory:**
   ```bash
   mkdir -p outputs  # macOS/Linux
   mkdir outputs     # Windows
   ```

2. **Check permissions:**
   ```bash
   ls -ld outputs/  # macOS/Linux: should have write permission
   ```

3. **Run analysis script again:**
   ```bash
   Rscript analyze_eco_socio_data_FIXED.R
   ```

4. **Check for plot errors:**
   ```r
   # Run plot code line by line in R console
   p1 <- ggplot(data, aes(x = year, y = coral_cover)) + 
     geom_line()
   print(p1)  # See if plot appears
   ```

---

### Issue: Visualizations Look Bad

**Symptoms:**
- Text overlapping
- Colors not visible
- Axis labels missing

**Causes:**
- Wrong plot dimensions
- Font size too large/small
- Theme issues

**Solutions:**

1. **Adjust figure size:**
   ```r
   # In script, modify ggsave:
   ggsave("outputs/plot.png", width = 12, height = 8, dpi = 300)
   # Increase width/height if text overlapping
   ```

2. **Adjust text sizes:**
   ```r
   # In ggplot theme:
   theme(
     axis.text = element_text(size = 10),      # Smaller
     axis.title = element_text(size = 11),
     plot.title = element_text(size = 12)
   )
   ```

3. **Check colors are visible:**
   ```r
   # Use colorblind-friendly palette:
   scale_color_viridis_d()
   ```

---

### Issue: Statistical Models Not Running

**Error Message:**
```
Error in lm(coral_cover ~ fishing_effort + ...) : object '...' not found
```

**Causes:**
- Variable name mispelled
- Variable doesn't exist in dataset
- Data not loaded correctly

**Solutions:**

1. **Verify data is loaded:**
   ```r
   head(combined_data)  # Check structure
   names(combined_data) # List column names
   ```

2. **Check variable spelling:**
   ```r
   # Make sure names match exactly
   model <- lm(coral_cover ~ fishing_effort, data = combined_data)
   # coral_cover and fishing_effort must exist in combined_data
   ```

3. **Check for missing values:**
   ```r
   # Models fail if variables have NA:
   sum(is.na(combined_data$coral_cover))
   # Should be 0 after cleaning
   ```

---

## Git and Version Control Issues

### Issue: Cannot Clone Repository

**Error Message:**
```
fatal: could not read Username for 'https://github.com': 
```

**Causes:**
- GitHub credentials not configured
- SSH key not set up
- Network blocked

**Solutions:**

1. **Use HTTPS instead of SSH:**
   ```bash
   git clone https://github.com/TejaswiBK/coral-reef-analysis.git
   # Instead of: git@github.com:TejaswiBK/coral-reef-analysis.git
   ```

2. **Configure git credentials:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

3. **Use GitHub CLI (easier):**
   ```bash
   gh auth login  # Authenticate
   gh repo clone TejaswiBK/coral-reef-analysis
   ```

---

### Issue: Files Not Showing as Changed

**Symptom:**
- Modified script but `git status` shows nothing changed

**Causes:**
- Changes not saved in editor
- File still open in editor
- Git not recognizing changes

**Solutions:**

1. **Save file:**
   - In your editor: Ctrl+S (Windows) or Cmd+S (macOS)

2. **Check git status:**
   ```bash
   git status
   # Should show modified files
   ```

3. **Force git to rescan:**
   ```bash
   git add .
   git status
   ```

---

### Issue: Accidentally Committed Large Data File

**Symptom:**
- Committed CSV file to Git
- Push fails or takes very long

**Causes:**
- Data files committed instead of ignored
- .gitignore not set up correctly

**Solutions:**

1. **Remove file from history (requires force push):**
   ```bash
   git rm --cached data/raw/file.csv
   git commit -m "Remove large data file"
   git push -u origin main
   ```

2. **Prevent this in future:**
   - Ensure .gitignore includes: `data/raw/*.csv`
   - Check `.gitignore` is correct

---

## File System Issues

### Issue: Wrong File Separator (Windows Path Issues)

**Error Message:**
```
Error: Cannot open file 'data\raw\file.csv'
```

**Cause:**
- Windows uses backslash `\` but R prefers forward slash `/`

**Solutions:**

1. **Use forward slashes in R:**
   ```r
   # Good
   read_csv("data/raw/file.csv")
   
   # Avoid
   read_csv("data\raw\file.csv")
   ```

2. **Or use double backslash:**
   ```r
   read_csv("data\\raw\\file.csv")
   ```

---

### Issue: Directory Not Created Automatically

**Symptom:**
- Script tries to save file but directory doesn't exist

**Causes:**
- Directory creation didn't happen
- Permissions issue

**Solutions:**

1. **Create directories manually:**
   ```bash
   mkdir -p data/raw data/processed outputs
   ```

2. **Or create in script:**
   ```r
   # Before saving files
   dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)
   write_csv(data, "data/raw/file.csv")
   ```

---

## Performance Issues

### Issue: Script Takes Very Long

**Symptom:**
- Script appears to hang/freeze
- No output for several minutes

**Causes:**
- Large data processing
- Inefficient code
- Memory issues

**Solutions:**

1. **Monitor progress:**
   ```r
   # Add progress messages
   cat("Starting analysis...\n")
   # ... code ...
   cat("Data loaded\n")
   # ... more code ...
   cat("Analysis complete\n")
   ```

2. **Check memory usage:**
   ```r
   # On macOS/Linux
   top -l 1 | head -20
   
   # In R, check object sizes
   object.size(data) / 1024^2  # Size in MB
   ```

3. **Optimize code if needed:**
   ```r
   # Use efficient tidyverse functions
   # Avoid loops when possible
   # Pre-filter data before operations
   ```

---

### Issue: Out of Memory Error

**Error Message:**
```
Error: cannot allocate vector of size ...
```

**Causes:**
- Dataset too large for available RAM
- Memory leak in script
- Too many large objects in memory

**Solutions:**

1. **Free up memory:**
   ```r
   rm(large_object)
   gc()  # Garbage collection
   ```

2. **Work with smaller subsets:**
   ```r
   # Process regions separately
   for (region in unique(data$region)) {
     data_subset <- filter(data, region == region)
     # Process subset
   }
   ```

3. **Increase available memory (OS level):**
   - Close other applications
   - Increase virtual memory/swap space

---

## Getting Help

### Before Asking for Help

✅ **Do these first:**
1. Check this troubleshooting guide
2. Read script comments
3. Look at data_provenance_log.csv
4. Check README.md and QUICKSTART.md
5. Run diagnosis script:

```bash
# Verify environment
R --version
git --version

# Verify working directory
pwd

# Verify files exist
ls -la data/raw/
ls -la outputs/

# Try running scripts again
Rscript generate_eco_socio_data_FIXED.R
```

---

### Getting Help Resources

| Resource | Use For |
|----------|---------|
| **README.md** | Project overview |
| **QUICKSTART.md** | Getting started |
| **Script comments** | Technical details |
| **This guide** | Common problems |
| **GitHub Issues** | Bugs and feature requests |
| **Stack Overflow** | General R/Git questions |
| **RStudio Community** | R-specific help |

---

### How to Report an Issue

When posting on GitHub or asking for help, include:

```
## Problem
[Describe what went wrong]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Etc.]

## Error Message
[Full error text in code block]

## Environment
- Operating System: [Windows/macOS/Linux]
- R Version: [Output of R --version]
- Project: [Project 1 or 2]
- Which script: [generate or analyze]

## What I've Tried
- [Thing 1]
- [Thing 2]
```

---

## Quick Checklist

When something goes wrong:

- [ ] Is R installed? (`R --version`)
- [ ] Are packages installed? (`R -e "library(tidyverse)"`)
- [ ] Am I in the correct directory? (`pwd` or `cd`)
- [ ] Do data/raw files exist? (`ls data/raw/`)
- [ ] Are file paths correct? (Use `/` not `\`)
- [ ] Does outputs directory exist? (`mkdir outputs`)
- [ ] Have I run generation script first? (generate before analyze)
- [ ] Are there error messages? (Read them carefully)
- [ ] Can I run a simple test? (`R -e "print('Hello')"`)

---

## Common Quick Fixes

| Problem | Quick Fix |
|---------|-----------|
| Script not found | Use `Rscript` command |
| Data not found | Run generation script first |
| Plot not created | Create outputs directory |
| Package not found | Run `install.packages()` |
| Wrong numbers | Delete data and regenerate |
| File path errors | Use forward slashes `/` |
| Permission denied | Use `Rscript` instead of `./` |
| Stuck waiting | Press Ctrl+C to cancel |

---

**Last Updated:** December 30, 2025  
**Status:** Comprehensive Troubleshooting Guide

Still having issues? Check the specific section above for your error.
