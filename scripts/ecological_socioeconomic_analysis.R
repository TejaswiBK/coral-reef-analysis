# ========================================
# ECOLOGICAL + SOCIO-ECONOMIC DATA INTEGRATION
# ========================================

# Install packages (run once)
# install.packages(c("tidyverse", "patchwork", "scales"))

library(tidyverse)
library(patchwork)
library(scales)

# ---- 1. GENERATE ECOLOGICAL DATA ----

set.seed(456)

# Ecological surveys: 5 regions, 2018-2023
regions <- c("Northern Red Sea", "Central Red Sea", "Southern Red Sea", 
             "Gulf of Aqaba", "Saudi Coast")
years <- 2018:2023

ecological_data <- expand_grid(
  region = regions,
  year = years
) |>
  mutate(
    # Coral cover declining over time, varies by region
    coral_cover = case_when(
      region == "Gulf of Aqaba" ~ 65 - (year - 2018) * 1.5 + rnorm(n(), 0, 3),
      region == "Northern Red Sea" ~ 55 - (year - 2018) * 2.0 + rnorm(n(), 0, 3),
      region == "Central Red Sea" ~ 50 - (year - 2018) * 2.5 + rnorm(n(), 0, 3),
      region == "Southern Red Sea" ~ 45 - (year - 2018) * 3.0 + rnorm(n(), 0, 3),
      region == "Saudi Coast" ~ 60 - (year - 2018) * 1.8 + rnorm(n(), 0, 3)
    ),
    # Fish biomass correlates with coral cover
    fish_biomass = coral_cover * 4.5 + rnorm(n(), 0, 15),
    # Species richness
    species_richness = coral_cover * 0.8 + rnorm(n(), 0, 5),
    # Number of survey sites per region
    n_sites = sample(8:15, n(), replace = TRUE)
  ) |>
  mutate(
    coral_cover = round(pmax(coral_cover, 20), 1),  # keep realistic
    fish_biomass = round(pmax(fish_biomass, 80), 1),
    species_richness = round(pmax(species_richness, 15), 0)
  )

glimpse(ecological_data)

# ---- 2. GENERATE SOCIO-ECONOMIC DATA ----

# Economic and fishing data by region and year
socioeconomic_data <- expand_grid(
  region = regions,
  year = years
) |>
  mutate(
    # Population growing over time
    population = case_when(
      region == "Northern Red Sea" ~ 45000 + (year - 2018) * 1200 + rnorm(n(), 0, 500),
      region == "Central Red Sea" ~ 78000 + (year - 2018) * 2500 + rnorm(n(), 0, 800),
      region == "Southern Red Sea" ~ 120000 + (year - 2018) * 3200 + rnorm(n(), 0, 1000),
      region == "Gulf of Aqaba" ~ 35000 + (year - 2018) * 800 + rnorm(n(), 0, 400),
      region == "Saudi Coast" ~ 95000 + (year - 2018) * 2800 + rnorm(n(), 0, 900)
    ),
    # Fishing effort (boat-days per year) increasing
    fishing_effort = case_when(
      region == "Northern Red Sea" ~ 2500 + (year - 2018) * 150 + rnorm(n(), 0, 100),
      region == "Central Red Sea" ~ 4200 + (year - 2018) * 280 + rnorm(n(), 0, 150),
      region == "Southern Red Sea" ~ 6800 + (year - 2018) * 450 + rnorm(n(), 0, 200),
      region == "Gulf of Aqaba" ~ 1200 + (year - 2018) * 50 + rnorm(n(), 0, 80),
      region == "Saudi Coast" ~ 5500 + (year - 2018) * 380 + rnorm(n(), 0, 180)
    ),
    # Average household income (USD/month)
    avg_income = case_when(
      region == "Northern Red Sea" ~ 1200 + (year - 2018) * 50 + rnorm(n(), 0, 80),
      region == "Central Red Sea" ~ 950 + (year - 2018) * 45 + rnorm(n(), 0, 60),
      region == "Southern Red Sea" ~ 800 + (year - 2018) * 35 + rnorm(n(), 0, 50),
      region == "Gulf of Aqaba" ~ 1500 + (year - 2018) * 80 + rnorm(n(), 0, 100),
      region == "Saudi Coast" ~ 1800 + (year - 2018) * 120 + rnorm(n(), 0, 120)
    ),
    # Percentage dependent on fishing
    fishing_dependence = case_when(
      region == "Northern Red Sea" ~ 35 + rnorm(n(), 0, 3),
      region == "Central Red Sea" ~ 48 + rnorm(n(), 0, 3),
      region == "Southern Red Sea" ~ 62 + rnorm(n(), 0, 4),
      region == "Gulf of Aqaba" ~ 22 + rnorm(n(), 0, 2),
      region == "Saudi Coast" ~ 40 + rnorm(n(), 0, 3)
    )
  ) |>
  mutate(
    population = round(population, 0),
    fishing_effort = round(fishing_effort, 0),
    avg_income = round(avg_income, 0),
    fishing_dependence = round(pmin(pmax(fishing_dependence, 15), 75), 1)
  )

glimpse(socioeconomic_data)

# ---- 3. COMBINE ECOLOGICAL + SOCIO-ECONOMIC DATA ----

# Join by region and year
combined_data <- ecological_data |>
  left_join(socioeconomic_data, by = c("region", "year"))

glimpse(combined_data)

# Check for successful join
print(paste("Ecological records:", nrow(ecological_data)))
print(paste("Socioeconomic records:", nrow(socioeconomic_data)))
print(paste("Combined records:", nrow(combined_data)))

# ---- 4. SUMMARY TABLES ----

# 4a. Summary by region (averaged across years)
summary_by_region <- combined_data |>
  group_by(region) |>
  summarise(
    mean_coral_cover = round(mean(coral_cover), 1),
    mean_fish_biomass = round(mean(fish_biomass), 1),
    mean_population = round(mean(population), 0),
    mean_fishing_effort = round(mean(fishing_effort), 0),
    mean_income = round(mean(avg_income), 0),
    fishing_dependence = round(mean(fishing_dependence), 1)
  ) |>
  arrange(desc(mean_coral_cover))

print("=== SUMMARY BY REGION ===")
print(summary_by_region)

# 4b. Trends over time (2018 vs 2023)
trends_table <- combined_data |>
  filter(year %in% c(2018, 2023)) |>
  select(region, year, coral_cover, fish_biomass, fishing_effort, population) |>
  pivot_wider(
    names_from = year,
    values_from = c(coral_cover, fish_biomass, fishing_effort, population)
  ) |>
  mutate(
    coral_change = round(coral_cover_2023 - coral_cover_2018, 1),
    effort_change = round(fishing_effort_2023 - fishing_effort_2018, 0)
  )

print("=== CHANGES 2018-2023 ===")
print(trends_table)

# ---- 5. VISUALIZATIONS ----

# 5a. Coral cover trends by region over time
p1 <- ggplot(combined_data, aes(x = year, y = coral_cover, color = region)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.5) +
  scale_x_continuous(breaks = 2018:2023) +
  labs(
    title = "Coral Cover Declining Across All Regions",
    subtitle = "2018-2023 ecological surveys",
    x = "Year",
    y = "Coral Cover (%)",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p1)

# 5b. Fishing effort trends by region
p2 <- ggplot(combined_data, aes(x = year, y = fishing_effort, color = region)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.5) +
  scale_x_continuous(breaks = 2018:2023) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Fishing Effort Increasing Over Time",
    subtitle = "Measured in boat-days per year",
    x = "Year",
    y = "Fishing Effort (boat-days)",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p2)

# 5c. Coral cover vs fishing effort (all regions, all years)
p3 <- ggplot(combined_data, aes(x = fishing_effort, y = coral_cover, color = region)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Coral Cover Negatively Associated with Fishing Effort",
    x = "Fishing Effort (boat-days/year)",
    y = "Coral Cover (%)",
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p3)

# 5d. Faceted: ecological vs socio-economic by region
p4 <- combined_data |>
  select(region, year, coral_cover, fish_biomass, fishing_effort, population) |>
  pivot_longer(
    cols = c(coral_cover, fish_biomass, fishing_effort, population),
    names_to = "variable",
    values_to = "value"
  ) |>
  mutate(
    variable = factor(variable, levels = c("coral_cover", "fish_biomass", 
                                           "fishing_effort", "population"),
                     labels = c("Coral Cover (%)", "Fish Biomass (kg/ha)",
                               "Fishing Effort (boat-days)", "Population"))
  ) |>
  ggplot(aes(x = year, y = value, color = region)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.5) +
  facet_wrap(~variable, scales = "free_y", ncol = 2) +
  scale_x_continuous(breaks = c(2018, 2020, 2023)) +
  labs(
    title = "Ecological and Socio-Economic Trends by Region",
    x = "Year",
    y = NULL,
    color = "Region"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p4)

# 5e. Combined layout
combined_plot <- (p1 / p2) | p3
print(combined_plot)

# ---- 6. STATISTICAL MODELS ----

# Model 1: Coral cover ~ fishing effort + income + year
model1 <- lm(coral_cover ~ fishing_effort + avg_income + year, 
             data = combined_data)
summary(model1)

# Model 2: Include region as factor
model2 <- lm(coral_cover ~ fishing_effort + avg_income + year + region, 
             data = combined_data)
summary(model2)

# Model 3: Fish biomass ~ coral cover + fishing effort
model3 <- lm(fish_biomass ~ coral_cover + fishing_effort, 
             data = combined_data)
summary(model3)

cat("\n=== MODEL INTERPRETATION ===\n")
cat("Model 1 - Coral cover predicted by fishing effort, income, year:\n")
cat("  Fishing effort coefficient:", round(coef(model1)["fishing_effort"], 5), "\n")
cat("  Interpretation: Higher fishing effort → lower coral cover\n\n")

cat("Model 3 - Fish biomass predicted by coral cover and fishing effort:\n")
cat("  Coral cover coefficient:", round(coef(model3)["coral_cover"], 3), "\n")
cat("  Interpretation: Healthier reefs (higher coral) → more fish biomass\n")

# ---- 7. EXPORT DATA ----

write_csv(combined_data, "outputs/combined_ecological_socioeconomic.csv")
write_csv(summary_by_region, "outputs/summary_by_region.csv")
write_csv(trends_table, "outputs/trends_2018_2023.csv")

cat("\n=== FILES EXPORTED ===\n")
cat("✓ combined_ecological_socioeconomic.csv\n")
cat("✓ summary_by_region.csv\n")
cat("✓ trends_2018_2023.csv\n")

# ---- 8. KEY INSIGHTS ----

cat("\n=== KEY INSIGHTS ===\n")
cat("1. Coral cover declining in all regions, fastest in Southern Red Sea\n")
cat("2. Fishing effort increasing across all regions over 2018-2023\n")
cat("3. Strong negative correlation between fishing effort and coral health\n")
cat("4. Regions with higher fishing dependence show greater coral decline\n")
cat("5. Fish biomass closely tracks coral cover, suggesting reef health drives fishery productivity\n")
