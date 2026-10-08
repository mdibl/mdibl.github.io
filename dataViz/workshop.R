##############################################################
# Introduction to Data Visualization in R
# MDIBL Comparative Genomics & Data Science Core
#
# Dataset: Portal Project ecological survey, Arizona 1977–1989
#   data/surveys_complete_77_89.csv
#
# How to use this script:
#   - Run lines with Ctrl+Enter (Windows) or Cmd+Return (Mac)
#   - Each section matches a part on the workshop webpage
#   - Exercise stubs are marked with ## EXERCISE
#   - Solutions are below each stub, marked with ## SOLUTION
#   - Uncomment solution lines to check your work
##############################################################

library(tidyverse)

surveys <- read_csv("data/surveys_complete_77_89.csv")


# ── PART 1: The Tidyverse & Data Wrangling ────────────────────────────────────

# ── The Pipe %>% ─────────────────────────────────────────────────────────────

# Without pipe — nested, read from inside out
arrange(filter(surveys, taxa == "Rodent"), desc(weight))

# With pipe — reads top to bottom like a recipe
surveys %>%
  filter(taxa == "Rodent") %>%
  arrange(desc(weight))


# ── filter() — keep rows matching a condition ─────────────────────────────────

surveys %>% filter(taxa == "Rodent")
surveys %>% filter(year == 1985)
surveys %>% filter(taxa == "Rodent", !is.na(weight))   # combine with ,

# %in% — match any value in a vector (cleaner than chaining | conditions)
surveys %>% filter(sex == "M" | sex == "F")       # verbose
surveys %>% filter(sex %in% c("M", "F"))          # same result, cleaner
# %in% also silently drops NAs and blank strings — "F" and "M" only

# Works with any vector, including a computed one
top_taxa <- c("Rodent", "Bird")
surveys %>% filter(taxa %in% top_taxa)


# ── select() — keep specific columns ─────────────────────────────────────────

surveys %>%
  select(species_id, year, weight, hindfoot_length)


# ── mutate() — create or modify columns ──────────────────────────────────────

# Add a scientific name column (permanent — reassign surveys)
surveys <- surveys %>%
  mutate(scientific_name = paste(genus, species))

surveys$scientific_name   # check it


# ── arrange() — sort rows ────────────────────────────────────────────────────

surveys %>%
  filter(!is.na(weight)) %>%
  arrange(desc(weight))   # heaviest first


# ── group_by() + summarise() — aggregate by group ────────────────────────────

# Mean weight per year
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  summarise(
    avg_weight = mean(weight),
    n_obs      = n()
  )

# Mean weight and count by taxa
surveys %>%
  filter(!is.na(weight), !is.na(taxa)) %>%
  group_by(taxa) %>%
  summarise(
    avg_weight = mean(weight),
    n          = n()
  )


# ── count() — quick frequency tables ─────────────────────────────────────────

surveys %>% count(species_id, sort = TRUE)
surveys %>% count(taxa)
surveys %>% count(plot_type, sort = TRUE)


## EXERCISE 1.1 — Pipe practice
# Using a single pipe chain, find the 5 heaviest Rodent observations.
# Show only species_id, weight, hindfoot_length, and year. Exclude NA weights.

## SOLUTION 1.1
# surveys %>%
#   filter(taxa == "Rodent", !is.na(weight)) %>%
#   select(species_id, weight, hindfoot_length, year) %>%
#   arrange(desc(weight)) %>%
#   head(5)


## EXERCISE 1.2 — Does sex predict weight?
# Part A: using surveys, calculate mean weight and n for each sex
#         (M and F only; exclude NA weights). What do you notice?
# Part B: add species_id as a second grouping variable.
#         Does the pattern from Part A hold within each species?

## SOLUTION 1.2 — Part A
# surveys %>%
#   filter(!is.na(weight), sex %in% c("M", "F")) %>%
#   group_by(sex) %>%
#   summarise(mean_weight = round(mean(weight), 1), n = n())
# Result: F ~53.1g, M ~53.2g — nearly identical at the aggregate level

## SOLUTION 1.2 — Part B
# surveys %>%
#   filter(!is.na(weight), sex %in% c("M", "F")) %>%
#   group_by(species_id, sex) %>%
#   summarise(mean_weight = round(mean(weight), 1), n = n(), .groups = "drop") %>%
#   arrange(species_id, sex)
# NL: M=168g, F=151g — largest dimorphism (~11% heavier males)
# PE, RM: females slightly heavier — species differences cancel out in the aggregate


# ── PART 2: The Grammar of Graphics ──────────────────────────────────────────

# ── Who is in this dataset? ───────────────────────────────────────────────────

# All four taxa are represented
surveys %>% count(taxa, sort = TRUE)
# Rodent 16148, Bird 300, Rabbit 69, Reptile 4, NA 357

# Weight was recorded for most Rodents but not for Birds, Rabbits, or Reptiles
surveys %>%
  filter(!is.na(taxa)) %>%
  group_by(taxa) %>%
  summarise(
    n_total       = n(),
    n_with_weight = sum(!is.na(weight)),
    pct_weight    = round(100 * n_with_weight / n_total, 1)
  )
# Rodent: 94% weight data recorded; Bird, Rabbit, Reptile: 0%

# After filtering for complete morphometrics, only Rodents remain
surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length)) %>%
  count(taxa)
# Only Rodent (13797) — filtering for !is.na(weight) ≈ filter(taxa == "Rodent")

# surveys_clean = rodent morphometric data (13,797 rows)
surveys_clean <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length))
nrow(surveys_clean)   # 13,797


# ── geom_histogram() ─────────────────────────────────────────────────────────

# Simple
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram()

# Control bins and colors (fixed — outside aes)
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white")


# ── labs() — add labels ───────────────────────────────────────────────────────

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  labs(
    title    = "Distribution of Body Weight",
    subtitle = "Portal Project data, 1977–1989",
    x        = "Weight (g)",
    y        = "Count"
  )


# ── Themes ────────────────────────────────────────────────────────────────────

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_minimal()

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_bw()

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_classic()

# Override specific elements on top of a named theme
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_minimal() +
  theme(
    plot.title  = element_text(size = 14, face = "bold"),
    axis.title  = element_text(size = 12)
  )


# ── geom_point() — scatter plots ──────────────────────────────────────────────

ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point()

# alpha controls transparency (0 = invisible, 1 = solid)
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2)


## EXERCISE — What explains the clusters?
# The scatter plot shows several distinct clouds. Use color to figure out
# what each cluster represents. Try mapping color to each of these in turn:
#   1. taxa
#   2. species_id
#   3. sex

## SOLUTION — clusters exercise
# 1. Color by taxa — only one color appears (all rodents in surveys_clean)
# ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = taxa)) +
#   geom_point(alpha = 0.3) + labs(title = "Color by taxa") + theme_bw()

# 2. Color by species_id — clusters snap into focus, each is a species
# ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
#   geom_point(alpha = 0.4) +
#   labs(title = "Color by species_id",
#        x = "Hindfoot Length (mm)", y = "Weight (g)") +
#   theme_bw()

# 3. Color by sex — no cluster structure; males and females overlap within species
# ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = sex)) +
#   geom_point(alpha = 0.3) + labs(title = "Color by sex") + theme_bw()

# Conclusion: species identity drives the clusters. Sex does not.


# ── geom_col() — bar charts ───────────────────────────────────────────────────

# Summarise first, then plot
surveys %>%
  filter(!is.na(taxa)) %>%
  count(taxa) %>%
  ggplot(aes(x = taxa, y = n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Observations by Taxa", x = "Taxa", y = "Count") +
  theme_bw()


## EXERCISE 2.1 — Distribution of hindfoot length
# Build a histogram of hindfoot_length using surveys_clean.
# Add a descriptive title, axis labels, and a theme of your choice.

## SOLUTION 2.1
# ggplot(surveys_clean, aes(x = hindfoot_length)) +
#   geom_histogram(bins = 25, fill = "seagreen", color = "white") +
#   labs(
#     title    = "Distribution of Hindfoot Length",
#     subtitle = "Portal Project data, 1977–1989",
#     x        = "Hindfoot Length (mm)",
#     y        = "Count"
#   ) +
#   theme_minimal()


## EXERCISE 2.2 — Does experimental treatment affect average body weight?
# The Portal Project plots use five treatments that control which animals enter.
# Using surveys, filter out NA weights, then summarise mean weight by plot_type.
# Plot as geom_col. Rotate x-axis labels with:
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))

## SOLUTION 2.2
# surveys %>%
#   filter(!is.na(weight)) %>%
#   group_by(plot_type) %>%
#   summarise(avg_weight = mean(weight)) %>%
#   ggplot(aes(x = plot_type, y = avg_weight)) +
#   geom_col(fill = "steelblue") +
#   labs(
#     title = "Average Rodent Weight by Plot Treatment",
#     x     = "Plot Type",
#     y     = "Average Weight (g)"
#   ) +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
#
# Long-term Krat Exclosure: ~31g (heavy kangaroo rats excluded)
# Control: ~59g — returns to this in Mini Project Q3


# ── PART 3: Layering & Customizing ───────────────────────────────────────────

# ── Color vs Fill ─────────────────────────────────────────────────────────────

# Fixed color outside aes
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(color = "steelblue", alpha = 0.3)

# Mapped color inside aes — each species gets its own color
# (surveys_clean is all rodents, so color = taxa would show only one color)
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4)

# Mapped fill — histogram colored by sex (default palette)
surveys_clean %>%
  filter(sex %in% c("M", "F")) %>%
  ggplot(aes(x = weight, fill = sex)) +
  geom_histogram(bins = 40, alpha = 0.7, position = "identity") +
  theme_minimal()


# ── Color Palettes ────────────────────────────────────────────────────────────
# scale_color_*() → controls the color aesthetic (points, lines)
# scale_fill_*()  → controls the fill  aesthetic (bars, histogram bars, tiles)
# They mirror each other:
#   scale_color_brewer()    <->  scale_fill_brewer()
#   scale_color_viridis_d() <->  scale_fill_viridis_d()
#   scale_color_manual()    <->  scale_fill_manual()

# scale_color_brewer() — ColorBrewer palettes for points
# Most palettes handle 8-12 groups max — limit to top 6 species
top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.5) +
  scale_color_brewer(palette = "Dark2") +
  labs(title = "Top 6 Species — Hindfoot vs Weight",
       x = "Hindfoot Length (mm)", y = "Weight (g)") +
  theme_bw()

# scale_fill_brewer() — same idea for histogram fills
surveys_clean %>%
  filter(sex %in% c("M", "F")) %>%
  ggplot(aes(x = weight, fill = sex)) +
  geom_histogram(bins = 40, alpha = 0.7, position = "identity") +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Weight (g)", y = "Count") +
  theme_minimal()

# scale_color_viridis_d() — colorblind-safe, handles all 17 species
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4) +
  scale_color_viridis_d() +
  theme_bw()

# scale_color_manual() — exact colors you choose
# Use when matching institutional colors or a published figure
surveys_clean %>%
  filter(sex %in% c("M", "F")) %>%
  ggplot(aes(x = hindfoot_length, y = weight, color = sex)) +
  geom_point(alpha = 0.4) +
  scale_color_manual(values = c("F" = "steelblue", "M" = "darkorange")) +
  theme_bw()
# scale_fill_manual() works the same way — just change the aesthetic to fill =


# ── geom_smooth() — trend lines ───────────────────────────────────────────────

# Linear trend line (method = "lm")
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", color = "darkred")

# se = FALSE removes the confidence band
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred")

# When color is mapped in aes, geom_smooth fits a line per group
# Use species_id — surveys_clean is all rodents (taxa gives only one line)
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE)


# ── facet_wrap() — small multiples ────────────────────────────────────────────

# Facet by species_id — more interesting than taxa (surveys_clean = one taxa)
# Limit to top 6 species so panels are readable
top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  facet_wrap(~ species_id) +
  theme_bw()

# scales = "free_y" lets each panel choose its own y range
surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  facet_wrap(~ species_id, scales = "free_y") +
  theme_bw()


# ── geom_tile() — heatmaps ────────────────────────────────────────────────────

# Minimal heatmap example — observations per year for the top 6 species
top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

heatmap_data <- surveys_clean %>%
  filter(species_id %in% top6) %>%
  group_by(year, species_id) %>%
  summarise(n_obs = n(), .groups = "drop")

ggplot(heatmap_data, aes(x = year, y = species_id, fill = n_obs)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(title = "Observations per Year by Species", fill = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## EXERCISE 3.1 — Weight over time, by species
# Summarise average weight by year and species_id for the top 6 species.
# Plot as a faceted line + point chart (one panel per species).
# Use scales = "free_y" (NL ~150g vs RM ~10g — shared axis flattens small species).
# Remove the legend.

## SOLUTION 3.1
# top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)
#
# weight_by_year_spp <- surveys_clean %>%
#   filter(species_id %in% top6) %>%
#   group_by(year, species_id) %>%
#   summarise(avg_weight = mean(weight), .groups = "drop")
#
# ggplot(weight_by_year_spp, aes(x = year, y = avg_weight, color = species_id)) +
#   geom_point() +
#   geom_line() +
#   facet_wrap(~ species_id, scales = "free_y") +
#   labs(
#     title = "Average Weight Over Time by Species",
#     x     = "Year",
#     y     = "Average Weight (g)"
#   ) +
#   theme_bw() +
#   theme(legend.position = "none")
# DM shows year-to-year fluctuations; DS shows a declining trend over the study period.


## EXERCISE 3.2 — Which species are captured in each plot type?
# Using top6 and surveys_clean, count observations by plot_type AND species_id.
# Plot as a geom_tile heatmap filled by count. Rotate x-axis labels.

## SOLUTION 3.2
# surveys_clean %>%
#   filter(species_id %in% top6) %>%
#   group_by(plot_type, species_id) %>%
#   summarise(n = n(), .groups = "drop") %>%
#   ggplot(aes(x = species_id, y = plot_type, fill = n)) +
#   geom_tile(color = "white", linewidth = 0.5) +
#   scale_fill_gradient(low = "white", high = "steelblue") +
#   labs(
#     title = "Captures by Plot Type and Species",
#     x     = "Species ID",
#     y     = "Plot Type",
#     fill  = "Count"
#   ) +
#   theme_minimal() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
# DM dominates Control; nearly absent from Krat Exclosures.
# Mini Project Q3 extends this by converting counts to within-plot proportions.


# ── ggsave() — saving figures ─────────────────────────────────────────────────

# Store your plot, then save
# Color by species_id — surveys_clean is all rodents (taxa = one color only)
my_plot <- ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Weight vs Hindfoot Length by Species",
       x = "Hindfoot Length (mm)", y = "Weight (g)") +
  theme_bw()

# ggsave("weight_hindfoot.png", my_plot, width = 8, height = 6, dpi = 300)


# ── MINI PROJECT ──────────────────────────────────────────────────────────────

# Setup
surveys_clean <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length)) %>%
  mutate(scientific_name = paste(genus, species))
nrow(surveys_clean)   # 13,797


## MINI PROJECT Q1.1 — Weight trend across all rodents
# Summarise mean weight per year, then plot points + smooth trend line.

## SOLUTION Q1.1
# weight_by_year <- surveys_clean %>%
#   group_by(year) %>%
#   summarise(avg_weight = mean(weight), n_obs = n())
#
# ggplot(weight_by_year, aes(x = year, y = avg_weight)) +
#   geom_point(size = 3, color = "steelblue") +
#   geom_smooth(method = "lm", color = "darkblue") +
#   labs(
#     title    = "Average Rodent Weight Over Time",
#     subtitle = "Portal Project data, 1977–1989",
#     x        = "Year",
#     y        = "Average Weight (g)"
#   ) +
#   theme_minimal()


## MINI PROJECT Q1.2 — Weight trend by species (faceted)
# Group by year AND scientific_name. Plot with facet_wrap(~ scientific_name).
# Remove legend; add theme and labels.

## SOLUTION Q1.2
# weight_by_year_sci <- surveys_clean %>%
#   group_by(year, scientific_name) %>%
#   summarise(avg_weight = mean(weight), .groups = "drop")
#
# ggplot(weight_by_year_sci, aes(x = year, y = avg_weight, color = scientific_name)) +
#   geom_point(size = 1.5) +
#   geom_line() +
#   facet_wrap(~ scientific_name) +
#   labs(
#     title    = "Average Weight Over Time by Species",
#     subtitle = "Portal Project data, 1977–1989",
#     x        = "Year",
#     y        = "Average Weight (g)"
#   ) +
#   theme_bw() +
#   theme(legend.position = "none")


## MINI PROJECT Q2.1 — Weight vs hindfoot length (overall)
# Scatter plot with alpha and a linear trend line.

## SOLUTION Q2.1
# ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
#   geom_point(alpha = 0.2) +
#   geom_smooth(method = "lm", color = "darkred") +
#   labs(
#     title = "Relationship Between Hindfoot Length and Weight",
#     x     = "Hindfoot Length (mm)",
#     y     = "Weight (g)"
#   ) +
#   theme_minimal()


## MINI PROJECT Q2.2 — Weight vs hindfoot by species (faceted)
# Color by species_id; facet_wrap(~ species_id); se = FALSE; no legend.

## SOLUTION Q2.2
# ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
#   geom_point(alpha = 0.4) +
#   geom_smooth(method = "lm", se = FALSE) +
#   facet_wrap(~ species_id) +
#   labs(
#     title    = "Weight vs Hindfoot Length by Species",
#     subtitle = "Portal Project data, 1977–1989",
#     x        = "Hindfoot Length (mm)",
#     y        = "Weight (g)"
#   ) +
#   theme_bw() +
#   theme(legend.position = "none")


## MINI PROJECT Q3 — Species composition heatmap
# Top 6 species × plot type, filled by proportion within each plot type.

## SOLUTION Q3
# top6_ids <- surveys_clean %>%
#   count(species_id, sort = TRUE) %>%
#   head(6) %>%
#   pull(species_id)
#
# surveys_clean %>%
#   filter(species_id %in% top6_ids) %>%
#   group_by(plot_type, species_id) %>%
#   summarise(n = n(), .groups = "drop") %>%
#   group_by(plot_type) %>%
#   mutate(proportion = n / sum(n)) %>%
#   ungroup() %>%
#   ggplot(aes(x = species_id, y = plot_type, fill = proportion)) +
#   geom_tile(color = "white", linewidth = 0.5) +
#   scale_fill_gradient(low = "white", high = "steelblue",
#                       labels = scales::percent) +
#   labs(
#     title    = "Species Composition by Plot Type",
#     subtitle = "Top 6 species, proportion of captures within each plot type",
#     x        = "Species ID",
#     y        = "Plot Type",
#     fill     = "Proportion"
#   ) +
#   theme_minimal() +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))


## MINI PROJECT WRAP UP — Save your favorite plot
# Store a plot you like in my_plot, then uncomment ggsave to save it.

# my_plot <- ggplot(...) + ...
# ggsave("my_favorite_plot.png", my_plot, width = 8, height = 6, dpi = 300)
