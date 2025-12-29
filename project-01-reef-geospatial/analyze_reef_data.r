# ========================================
# CORAL REEF GEOSPATIAL ANALYSIS SCRIPT
# Reads raw data files, cleans, and analyzes them
# ========================================

# Install packages (run once)
# install.packages(c("tidyverse", "sf", "terra", "viridis"))

library(tidyverse)
library(sf)
library(terra)
library(viridis)

# Create output directories
dir.create("outputs", recursive = TRUE, showWarnings = FALSE)

# ---- 1. READ RAW DATA FILES ----

cat("=== READING RAW DATA FILES ===\n\n")

# Read raw reef survey sites
reef_raw <- read_csv("data/raw/reef_survey_sites_raw.csv", show_col_types = FALSE)
cat("✓ Loaded: reef_survey_sites_raw.csv\n")
cat("  Dimensions:", nrow(reef_raw), "sites ×", ncol(reef_raw), "variables\n")
cat("  Missing coral_cover:", sum(is.na(reef_raw$coral_cover)), "\n")
cat("  Missing fish_biomass:", sum(is.na(reef_raw$fish_biomass)), "\n\n")

# Read raw raster files
sst_raster <- rast("data/raw/sst_raw.tif")
cat("✓ Loaded: sst_raw.tif\n")
cat("  Dimensions:", nrow(sst_raster), "×", ncol(sst_raster), "\n")
cat("  Missing cells:", sum(is.na(values(sst_raster))), "\n\n")

depth_raster <- rast("data/raw/depth_raw.tif")
cat("✓ Loaded: depth_raw.tif\n")
cat("  Dimensions:", nrow(depth_raster), "×", ncol(depth_raster), "\n")
cat("  Negative values (errors):", sum(values(depth_raster) < 0, na.rm = TRUE), "\n\n")

# Read metadata
metadata <- read_csv("data/raw/metadata.csv", show_col_types = FALSE)
cat("✓ Loaded: metadata.csv\n\n")

# ---- 2. DATA CLEANING AND VALIDATION ----

cat("=== DATA CLEANING PIPELINE ===\n\n")

# 2a. Clean reef survey data
reef_clean <- reef_raw |>
  # Remove or handle invalid records
  filter(data_quality_flag != "OUTLIER") |>
  # Remove rows with all missing measurements
  filter(!(is.na(coral_cover) & is.na(fish_biomass))) |>
  # Fill missing values with spatial/temporal imputation or mark for exclusion
  # Here we use deletion (conservative approach)
  filter(!is.na(coral_cover), !is.na(fish_biomass)) |>
  # Remove duplicates
  distinct() |>
  # Data type corrections and rounding
  mutate(
    longitude = round(longitude, 6),
    latitude = round(latitude, 6),
    coral_cover = round(coral_cover, 1),
    fish_biomass = round(fish_biomass, 2)
  ) |>
  # Validate ranges
  filter(
    coral_cover >= 0 & coral_cover <= 100,
    fish_biomass > 0,
    latitude >= 15 & latitude <= 28,
    longitude >= 36 & longitude <= 43
  ) |>
  select(-data_quality_flag, -observer_notes)  # Remove temporary QA columns

cat("Records retained after cleaning:", nrow(reef_clean), "/", nrow(reef_raw), "\n")
cat("Records removed:", nrow(reef_raw) - nrow(reef_clean), "\n\n")

# 2b. Clean raster data
# Fix SST raster (interpolate missing values)
sst_clean <- sst_raster
sst_values <- values(sst_clean)
# Simple forward-fill imputation (more sophisticated methods available)
if (any(is.na(sst_values))) {
  sst_values[is.na(sst_values)] <- median(sst_values, na.rm = TRUE)
  values(sst_clean) <- sst_values
}
names(sst_clean) <- "sst"

cat("SST raster: Imputed", sum(is.na(values(sst_raster))), "missing cells\n\n")

# 2c. Clean depth raster
depth_clean <- depth_raster
depth_values <- values(depth_clean)
# Remove negative values (sensor errors)
n_negative <- sum(depth_values < 0, na.rm = TRUE)
depth_values[depth_values < 0] <- abs(depth_values[depth_values < 0])
values(depth_clean) <- depth_values
names(depth_clean) <- "depth"

cat("Depth raster: Corrected", n_negative, "negative values (sensor errors)\n\n")

# ---- 3. CONVERT TO SPATIAL OBJECT & EXTRACT RASTER VALUES ----

cat("=== SPATIAL OPERATIONS ===\n\n")

# Convert cleaned reef data to sf object
reef_sf <- st_as_sf(
  reef_clean,
  coords = c("longitude", "latitude"),
  crs = 4326
)

# Extract environmental variables at reef sites
reef_sf$sst <- terra::extract(sst_clean, vect(reef_sf))[, 2]
reef_sf$depth <- terra::extract(depth_clean, vect(reef_sf))[, 2]

cat("Extracted environmental variables for", nrow(reef_sf), "sites\n\n")

# Convert to tibble for analysis
reef_analysis <- reef_sf |>
  st_drop_geometry() |>
  mutate(
    depth = round(depth, 1),
    sst = round(sst, 2)
  )

# Save cleaned analysis dataset
write_csv(reef_analysis, "data/processed/reef_analysis_cleaned.csv")
cat("✓ Saved cleaned data: data/processed/reef_analysis_cleaned.csv\n\n")

# ---- 4. EXPLORATORY DATA ANALYSIS ----

cat("=== EXPLORATORY DATA ANALYSIS ===\n\n")

# 4a. Summary statistics
cat("Summary Statistics:\n")
print(summary(reef_analysis |> select(coral_cover, fish_biomass, sst, depth)))

cat("\n")

# 4b. Table: Mean coral cover by temperature zone
temp_zone_summary <- reef_analysis |>
  mutate(temp_zone = cut(sst, breaks = 3, labels = c("Cool", "Medium", "Warm"))) |>
  group_by(temp_zone) |>
  summarise(
    n_sites = n(),
    mean_coral_cover = round(mean(coral_cover), 1),
    sd_coral_cover = round(sd(coral_cover), 1),
    mean_fish_biomass = round(mean(fish_biomass), 1),
    .groups = "drop"
  )

cat("Mean Values by Temperature Zone:\n")
print(temp_zone_summary)

# Save summary table
write_csv(temp_zone_summary, "outputs/temperature_zone_summary.csv")
cat("\n✓ Saved: outputs/temperature_zone_summary.csv\n\n")

# ---- 5. VISUALIZATIONS ----

cat("=== GENERATING VISUALIZATIONS ===\n\n")

# 5a. Map: Reef sites colored by coral cover
map_coral <- ggplot() +
  geom_sf(data = reef_sf, aes(color = coral_cover, size = coral_cover)) +
  scale_color_viridis(option = "plasma", name = "Coral Cover (%)") +
  scale_size_continuous(range = c(2, 6), guide = "none") +
  labs(
    title = "Red Sea Reef Survey Sites",
    subtitle = "Point size and color represent coral cover"
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "lightblue"),
    panel.grid = element_line(color = "white")
  )

ggsave("outputs/01_map_reef_sites.png", map_coral, width = 10, height = 8, dpi = 300)
cat("✓ Saved: outputs/01_map_reef_sites.png\n")

# 5b. Scatter plot: Coral cover vs SST
scatter_sst <- ggplot(reef_analysis, aes(x = sst, y = coral_cover)) +
  geom_point(aes(size = fish_biomass, color = depth), alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red", linewidth = 1.2) +
  scale_color_viridis(name = "Depth (m)") +
  scale_size_continuous(name = "Fish biomass\n(kg/ha)", range = c(2, 8)) +
  labs(
    title = "Coral Cover vs Sea Surface Temperature",
    subtitle = "Point size = fish biomass, color = depth",
    x = "Sea Surface Temperature (°C)",
    y = "Coral Cover (%)"
  ) +
  theme_minimal()

ggsave("outputs/02_scatter_sst.png", scatter_sst, width = 10, height = 6, dpi = 300)
cat("✓ Saved: outputs/02_scatter_sst.png\n")

# 5c. Scatter plot: Coral cover vs depth
scatter_depth <- ggplot(reef_analysis, aes(x = depth, y = coral_cover)) +
  geom_point(aes(color = sst), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "darkblue") +
  scale_color_viridis(option = "inferno", name = "SST (°C)") +
  labs(
    title = "Coral Cover vs Depth",
    x = "Depth (m)",
    y = "Coral Cover (%)"
  ) +
  theme_minimal()

ggsave("outputs/03_scatter_depth.png", scatter_depth, width = 10, height = 6, dpi = 300)
cat("✓ Saved: outputs/03_scatter_depth.png\n")

# 5d. Faceted plot: by temperature zone
faceted_plot <- reef_analysis |>
  mutate(temp_zone = cut(sst, breaks = 3, labels = c("Cool", "Medium", "Warm"))) |>
  ggplot(aes(x = depth, y = coral_cover)) +
  geom_point(aes(color = fish_biomass), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  scale_color_viridis(name = "Fish biomass") +
  facet_wrap(~temp_zone) +
  labs(
    title = "Coral Cover vs Depth across Temperature Zones",
    x = "Depth (m)",
    y = "Coral Cover (%)"
  ) +
  theme_minimal()

ggsave("outputs/04_faceted_temp_zones.png", faceted_plot, width = 12, height = 5, dpi = 300)
cat("✓ Saved: outputs/04_faceted_temp_zones.png\n\n")

# ---- 6. STATISTICAL MODELING ----

cat("=== STATISTICAL MODELING ===\n\n")

# Simple linear model: coral cover ~ SST + depth
model <- lm(coral_cover ~ sst + depth, data = reef_analysis)
cat("Model 1: coral_cover ~ sst + depth\n")
print(summary(model))

cat("\n")

# Model with interaction
model_interaction <- lm(coral_cover ~ sst * depth, data = reef_analysis)
cat("Model 2: coral_cover ~ sst * depth (with interaction)\n")
print(summary(model_interaction))

cat("\n")

# ---- 7. RESULTS TABLE ----

cat("=== RESULTS TABLE ===\n\n")

results_table <- reef_analysis |>
  mutate(
    temp_category = case_when(
      sst < 24 ~ "Cool (<24°C)",
      sst < 26 ~ "Medium (24-26°C)",
      TRUE ~ "Warm (>26°C)"
    ),
    depth_category = case_when(
      depth < 10 ~ "Shallow (<10m)",
      depth < 20 ~ "Medium (10-20m)",
      TRUE ~ "Deep (>20m)"
    )
  ) |>
  group_by(temp_category, depth_category) |>
  summarise(
    n_sites = n(),
    mean_coral = round(mean(coral_cover), 1),
    sd_coral = round(sd(coral_cover), 1),
    mean_biomass = round(mean(fish_biomass), 1),
    .groups = "drop"
  ) |>
  arrange(temp_category, depth_category)

print(results_table)

# Save results table
write_csv(results_table, "outputs/results_summary_table.csv")
cat("\n✓ Saved: outputs/results_summary_table.csv\n\n")

# ---- 8. INTERPRETATION & REPORT ----

cat("=== MODEL INTERPRETATION ===\n\n")

sst_coef <- coef(model)["sst"]
depth_coef <- coef(model)["depth"]

cat("Simple Model Coefficients:\n")
cat("Coefficient for SST:", round(sst_coef, 4), "\n")
cat("Coefficient for depth:", round(depth_coef, 4), "\n\n")

cat("Interpretation:\n")
if (sst_coef < 0) {
  cat("- NEGATIVE SST coefficient: Warmer sites tend to have LOWER coral cover\n")
} else {
  cat("- POSITIVE SST coefficient: Warmer sites tend to have HIGHER coral cover\n")
}

if (depth_coef < 0) {
  cat("- NEGATIVE depth coefficient: Deeper sites tend to have LOWER coral cover\n")
} else {
  cat("- POSITIVE depth coefficient: Deeper sites tend to have HIGHER coral cover\n")
}

cat("\n- Check model p-values (< 0.05) to assess statistical significance\n")
cat("- Check R-squared to assess model fit\n\n")

# ---- 9. DATA PROVENANCE LOG ----

cat("=== DATA PROVENANCE LOG ===\n\n")

provenance_log <- tibble(
  step = c(
    "Raw data generated",
    "Raw data files created",
    "Data cleaning performed",
    "Spatial operations completed",
    "Analysis and visualization complete"
  ),
  timestamp = Sys.time(),
  files_involved = c(
    "generate_raw_data.R",
    "reef_survey_sites_raw.csv, sst_raw.tif, depth_raw.tif",
    "analyze_reef_data.R",
    "analyze_reef_data.R",
    "analyze_reef_data.R"
  ),
  records_retained = c(
    nrow(reef_raw),
    nrow(reef_raw),
    nrow(reef_clean),
    nrow(reef_analysis),
    nrow(reef_analysis)
  )
)

write_csv(provenance_log, "outputs/data_provenance_log.csv")
cat("✓ Saved: outputs/data_provenance_log.csv\n\n")

cat("=== ANALYSIS COMPLETE ===\n")
cat("Output files saved to: outputs/\n")
