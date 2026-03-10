# ==============================================================================
# White-bellied Heron Annual Report: 2026 Trend Analysis
# Description: Professional processing and visualization of population counts 
#              across basins, rivers, and locations for the 2026 reporting year.
# Author: [Your Name/Organization]
# ==============================================================================

# -------------------------
# 1. Load Packages
# -------------------------
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(janitor)
library(ggplot2)
library(forcats)
library(scales)
library(patchwork)
library(ggforce)

# -------------------------
# 2. Configuration & Constants
# -------------------------
# File paths and year definitions
INPUT_FILE      <- "population_count.xlsx"
OUTPUT_DIR      <- "tables_plots"
FOCUS_YEAR      <- 2026
PREV_YEAR       <- 2025
BASELINE_START  <- 2020
BASELINE_END    <- 2025

# Visual constants (Preserving original specifications)
YEAR_BREAKS_REPORT <- c(2003, 2008, 2014, 2020, 2026)

if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR)

# -------------------------
# 3. Helper Functions
# -------------------------
# Axis breaks for integer counts
integer_breaks <- function(x) {
  xmax <- max(x, na.rm = TRUE)
  if (!is.finite(xmax)) return(NULL)
  if (xmax <= 1) return(c(0, 1))
  brks <- pretty(c(0, ceiling(xmax)), n = 5)
  brks <- unique(round(brks))
  brks[brks >= 0]
}

# Plot theme and font sizes
theme_report <- function() {
  theme_minimal(base_size = 13) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      axis.title = element_text(face = "bold"),
      plot.title = element_text(face = "bold", size = 13),
      plot.subtitle = element_text(size = 10),
      strip.text = element_text(face = "bold"),
      legend.position = "right"
    )
}

# -------------------------
# 4. Data Processing
# -------------------------
df <- read_excel(INPUT_FILE, sheet = "count_location") %>%
  clean_names() %>%
  mutate(
    location = str_squish(as.character(location)),
    river    = str_squish(as.character(river)),
    basin    = str_squish(as.character(basin)),
    year     = as.integer(year),
    count    = as.numeric(count),
    lat      = as.numeric(lat),
    long     = as.numeric(long)
  ) %>%
  filter(!is.na(location), !is.na(year), !is.na(count), count > 0)

# Annual summary (Table 1)
annual_summary <- df %>%
  group_by(year) %>%
  summarise(
    total_count = sum(count, na.rm = TRUE),
    n_locations = n_distinct(location),
    n_rivers    = n_distinct(river),
    n_basins    = n_distinct(basin),
    .groups = "drop"
  ) %>%
  arrange(year)

# Focus-year subsets
df_2026 <- df %>% filter(year == FOCUS_YEAR)
df_2025 <- df %>% filter(year == PREV_YEAR)
annual_2026 <- annual_summary %>% filter(year == FOCUS_YEAR)
annual_2025 <- annual_summary %>% filter(year == PREV_YEAR)
annual_baseline <- annual_summary %>% filter(year >= BASELINE_START, year <= BASELINE_END)

# -------------------------
# 5. Comparative Tables (1-10)
# -------------------------
# Table 1
write.csv(annual_summary, file.path(OUTPUT_DIR, "table1_summary_by_year.csv"), row.names = FALSE)

# Table 2: Comparison Summary
comparison_summary <- tibble(
  metric = c("Total count", "Occupied locations", "Occupied rivers", "Occupied basins"),
  value_2026 = c(annual_2026$total_count, annual_2026$n_locations, annual_2026$n_rivers, annual_2026$n_basins),
  value_2025 = c(annual_2025$total_count, annual_2025$n_locations, annual_2025$n_rivers, annual_2025$n_basins),
  mean_2020_2025 = c(mean(annual_baseline$total_count), mean(annual_baseline$n_locations), 
                     mean(annual_baseline$n_rivers), mean(annual_baseline$n_basins))
) %>%
  mutate(
    change_vs_2025 = value_2026 - value_2025,
    pct_change_vs_2025 = 100 * change_vs_2025 / value_2025,
    change_vs_mean_2020_2025 = value_2026 - mean_2020_2025,
    pct_change_vs_mean_2020_2025 = 100 * change_vs_mean_2020_2025 / mean_2020_2025
  )
write.csv(comparison_summary, file.path(OUTPUT_DIR, "table2_comparison_summary.csv"), row.names = FALSE)

# Table 3: Annual Rank
annual_rank <- annual_summary %>% arrange(desc(total_count), year) %>% mutate(rank_total_count = row_number())
write.csv(annual_rank, file.path(OUTPUT_DIR, "table3_annual_rank_total_count.csv"), row.names = FALSE)

# Hierarchical dataset generation
all_years  <- sort(unique(df$year))
all_basins <- sort(unique(df$basin))
all_rivers <- sort(unique(df$river))

# Table 4 & 5: Basin and River Year
basin_year <- expand_grid(year = all_years, basin = all_basins) %>%
  left_join(df %>% group_by(year, basin) %>% summarise(total_count = sum(count), n_locations = n_distinct(location), .groups = "drop"), by = c("year", "basin")) %>%
  mutate(across(c(total_count, n_locations), ~replace_na(.x, 0)))
write.csv(basin_year, file.path(OUTPUT_DIR, "table4_basin_by_year.csv"), row.names = FALSE)

river_year <- expand_grid(year = all_years, river = all_rivers) %>%
  left_join(df %>% group_by(year, river) %>% summarise(total_count = sum(count), n_locations = n_distinct(location), .groups = "drop"), by = c("year", "river")) %>%
  mutate(across(c(total_count, n_locations), ~replace_na(.x, 0)))
write.csv(river_year, file.path(OUTPUT_DIR, "table5_river_by_year.csv"), row.names = FALSE)

# Table 6: Location Year
location_year <- df %>% group_by(year, location, river, basin) %>% summarise(total_count = sum(count), .groups = "drop")
write.csv(location_year, file.path(OUTPUT_DIR, "table6_location_by_year.csv"), row.names = FALSE)

# Table 7-9: 2026 Summaries
basin_2026 <- basin_year %>% filter(year == FOCUS_YEAR) %>% mutate(share_pct = 100 * total_count / sum(total_count)) %>% arrange(desc(total_count))
write.csv(basin_2026, file.path(OUTPUT_DIR, "table7_basin_summary_2026.csv"), row.names = FALSE)

river_2026 <- river_year %>% filter(year == FOCUS_YEAR) %>% mutate(share_pct = 100 * total_count / sum(total_count)) %>% arrange(desc(total_count))
write.csv(river_2026, file.path(OUTPUT_DIR, "table8_river_summary_2026.csv"), row.names = FALSE)

location_2026 <- df_2026 %>% group_by(location, river, basin) %>% summarise(total_count = sum(count), .groups = "drop") %>% arrange(desc(total_count))
write.csv(location_2026, file.path(OUTPUT_DIR, "table9_location_summary_2026.csv"), row.names = FALSE)

# Table 10 & 11: Multi-Year Change Analysis
basin_baseline <- basin_year %>% filter(year >= BASELINE_START, year <= BASELINE_END) %>% group_by(basin) %>% summarise(mean_2020_2025 = mean(total_count), .groups = "drop")
basin_change <- expand_grid(basin = all_basins) %>%
  left_join(basin_baseline, by = "basin") %>%
  left_join(basin_year %>% filter(year == PREV_YEAR) %>% select(basin, count_2025 = total_count), by = "basin") %>%
  left_join(basin_year %>% filter(year == FOCUS_YEAR) %>% select(basin, count_2026 = total_count), by = "basin") %>%
  mutate(across(where(is.numeric), ~replace_na(.x, 0)),
         change_vs_mean_2020_2025 = count_2026 - mean_2020_2025,
         change_vs_2025 = count_2026 - count_2025)
write.csv(basin_change, file.path(OUTPUT_DIR, "table10_basin_change_summary.csv"), row.names = FALSE)

river_baseline <- river_year %>% filter(year >= BASELINE_START, year <= BASELINE_END) %>% group_by(river) %>% summarise(mean_2020_2025 = mean(total_count), .groups = "drop")
river_change <- expand_grid(river = all_rivers) %>%
  left_join(river_baseline, by = "river") %>%
  left_join(river_year %>% filter(year == PREV_YEAR) %>% select(river, count_2025 = total_count), by = "river") %>%
  left_join(river_year %>% filter(year == FOCUS_YEAR) %>% select(river, count_2026 = total_count), by = "river") %>%
  mutate(across(where(is.numeric), ~replace_na(.x, 0)),
         change_vs_mean_2020_2025 = count_2026 - mean_2020_2025,
         change_vs_2025 = count_2026 - count_2025)
write.csv(river_change, file.path(OUTPUT_DIR, "table11_river_change_summary.csv"), row.names = FALSE)

# -------------------------
# 6. Trend Plots (Figs 1-6)
# -------------------------
p1 <- ggplot(annual_summary, aes(x = year, y = total_count)) +
  geom_smooth(method = "lm", formula = y ~ x, se = TRUE, linewidth = 0.5, linetype = "dashed", alpha = 0.2) +
  geom_line(linewidth = 0.5) + geom_point(size = 2) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks, labels = label_number(accuracy = 1)) +
  labs(title = "A. Total count by year", x = "Year", y = "Total count") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig1_total_count_trend.png"), p1, width = 5, dpi = 1200)

p2 <- ggplot(annual_summary, aes(x = year, y = n_locations)) +
  geom_line(linewidth = 0.5) + geom_point(size = 2) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "B. Occupied locations by year", x = "Year", y = "Number of locations") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig2_occupied_locations_trend.png"), p2, width = 7, dpi = 1200)

p3 <- ggplot(annual_summary, aes(x = year, y = n_rivers)) +
  geom_line(linewidth = 0.5) + geom_point(size = 2) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "C. Occupied rivers by year", x = "Year", y = "Number of rivers") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig3_occupied_rivers_trend.png"), p3, width = 7, dpi = 1200)

p4 <- ggplot(annual_summary, aes(x = year, y = n_basins)) +
  geom_line(linewidth = 0.5) + geom_point(size = 2) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "D. Occupied basins by year", x = "Year", y = "Number of basins") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig4_occupied_basins_trend.png"), p4, width = 7, dpi = 1200)

p5 <- ggplot(basin_year, aes(x = year, y = total_count, fill = basin)) +
  geom_col(width = 0.8) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "E. Annual count by basin", x = "Year", y = "Total count", fill = "Basin") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig5_annual_count_by_basin.png"), p5, width = 7, dpi = 1200)

p6 <- ggplot(river_year, aes(x = year, y = total_count, fill = river)) +
  geom_col(width = 0.8) +
  scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "F. Annual count by river", x = "Year", y = "Total count", fill = "River") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig6_annual_count_by_river.png"), p6, width = 7, height = 6, dpi = 1200)

# Fig 1-6 Combined
trend_grid <- (p1 | p2 | p3) / (p4 | p5 | p6)
ggsave(file.path(OUTPUT_DIR, "fig1-6_combined.png"), trend_grid, width = 14, height = 10, dpi = 1200)

# -------------------------
# 7. Comparison Plots (Figs 7-12)
# -------------------------

# Fig 7: 2026 versus Mean (Basin)
p7 <- basin_change %>%
  select(basin, mean_2020_2025, count_2026) %>%
  pivot_longer(cols = c(mean_2020_2025, count_2026), names_to = "group", values_to = "value") %>%
  mutate(group = recode(group, mean_2020_2025 = "Mean 2020-2025", count_2026 = "2026"),
         basin = fct_reorder(basin, value, .fun = max)) %>%
  ggplot(aes(x = basin, y = value, fill = group)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) + coord_flip() +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "2026 versus 2020-2025 mean by basin", x = NULL, y = "Annual count", fill = NULL) + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig7_basin_2026_vs_mean.png"), p7, width = 7, dpi = 1200)

# Fig 8: 2026 versus Mean (River)
p8 <- river_change %>%
  select(river, mean_2020_2025, count_2026) %>%
  pivot_longer(cols = c(mean_2020_2025, count_2026), names_to = "group", values_to = "value") %>%
  mutate(group = recode(group, mean_2020_2025 = "Mean 2020-2025", count_2026 = "2026"),
         river = fct_reorder(river, value, .fun = max)) %>%
  ggplot(aes(x = river, y = value, fill = group)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) + coord_flip() +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "2026 versus 2020-2025 mean by river", x = NULL, y = "Annual count", fill = NULL) + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig8_river_2026_vs_mean.png"), p8, width = 7, dpi = 1200)

# Fig 9: Change vs Mean (Basin)
p9 <- basin_change %>%
  mutate(basin = fct_reorder(basin, change_vs_mean_2020_2025)) %>%
  ggplot(aes(x = basin, y = change_vs_mean_2020_2025)) +
  geom_col() + coord_flip() + geom_hline(yintercept = 0, linewidth = 0.4) +
  labs(title = "Change from 2020-2025 mean to 2026 by basin", x = NULL, y = "Change in count") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig9_basin_change_vs_mean.png"), p9, width = 7, dpi = 1200)

# Fig 10: Change vs Mean (River)
p10 <- river_change %>%
  mutate(river = fct_reorder(river, change_vs_mean_2020_2025)) %>%
  ggplot(aes(x = river, y = change_vs_mean_2020_2025)) +
  geom_col() + coord_flip() + geom_hline(yintercept = 0, linewidth = 0.4) +
  labs(title = "Change from 2020-2025 mean to 2026 by river", x = NULL, y = "Change in count") + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig10_river_change_vs_mean.png"), p10, width = 7, dpi = 1200)

# Fig 11: 2025 vs 2026 (Basin)
p11 <- basin_change %>%
  select(basin, count_2025, count_2026) %>%
  pivot_longer(cols = c(count_2025, count_2026), names_to = "group", values_to = "value") %>%
  mutate(group = recode(group, count_2025 = "2025", count_2026 = "2026"),
         basin = fct_reorder(basin, value, .fun = max)) %>%
  ggplot(aes(x = basin, y = value, fill = group)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) + coord_flip() +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "2025 versus 2026 by basin", x = NULL, y = "Annual count", fill = NULL) + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig11_basin_2025_vs_2026.png"), p11, width = 7, dpi = 1200)

# Fig 12: 2025 vs 2026 (River)
p12 <- river_change %>%
  select(river, count_2025, count_2026) %>%
  pivot_longer(cols = c(count_2025, count_2026), names_to = "group", values_to = "value") %>%
  mutate(group = recode(group, count_2025 = "2025", count_2026 = "2026"),
         river = fct_reorder(river, value, .fun = max)) %>%
  ggplot(aes(x = river, y = value, fill = group)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) + coord_flip() +
  scale_y_continuous(breaks = integer_breaks) +
  labs(title = "2025 versus 2026 by river", x = NULL, y = "Annual count", fill = NULL) + theme_report()
ggsave(file.path(OUTPUT_DIR, "fig12_river_2025_vs_2026.png"), p12, width = 7, dpi = 1200)

# -------------------------
# 8. Paginated Trends (Figs 13-14)
# -------------------------
save_paginated_trends <- function(data, group_var, title_prefix, file_prefix) {
  clean_data <- data %>% filter(!get(group_var) %in% c("Heron Center", "Heron Conservation Center"))
  items <- sort(unique(clean_data[[group_var]]))
  n_pages <- ceiling(length(items) / 6)
  
  for (i in seq_len(n_pages)) {
    p <- ggplot(clean_data, aes(x = year, y = total_count)) +
      geom_line(linewidth = 0.5) + geom_point(size = 1.2) +
      ggforce::facet_wrap_paginate(vars(!!sym(group_var)), ncol = 2, nrow = 3, page = i, scales = "free_y") +
      scale_x_continuous(breaks = YEAR_BREAKS_REPORT) +
      scale_y_continuous(breaks = integer_breaks) +
      labs(title = paste(title_prefix, "(page", i, "of", n_pages, ")"), x = "Year", y = "Total count") + theme_report()
    
    ggsave(file.path(OUTPUT_DIR, paste0(file_prefix, "_page_", i, ".png")), p, width = 7, dpi = 1200)
  }
}

save_paginated_trends(basin_year, "basin", "Annual count trends by basin", "fig13_basin_trends")
save_paginated_trends(river_year, "river", "Annual count trends by river", "fig14_river_trends")

message("Workflow complete. Tables and 14+ high-res plots are in: ", OUTPUT_DIR)