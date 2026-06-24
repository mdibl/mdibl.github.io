# Introduction to Data Visualization in R

> **Workshop:** ~2 hours hands-on &nbsp;·&nbsp; This page stays open for independent study and office-hours follow-up.

---

!!! info "Learning Objectives"
    By the end of this workshop you will be able to:

    - Use dplyr verbs to filter, transform, and summarize a data frame
    - Understand the grammar of graphics and how ggplot2 layers work
    - Build histograms, scatter plots, bar plots, and heatmaps from real survey data
    - Map variables to color, fill, size, and facets to reveal patterns
    - Save publication-quality figures with `ggsave()`

---

## Launch Your Workspace

!!! info "You need a free GitHub account to use this workshop"
    This workshop runs in **GitHub Codespaces** — a cloud environment that requires a GitHub account. If you do not have one, create one for free at [github.com](https://github.com) before the session. No paid plan is required.

    **GitHub Free quota (per account, per month):**

    - 120 core-hours of compute — equivalent to **60 hours** of run time on a standard 2-core Codespace
    - 15 GB of storage

    This is enough for workshops and occasional use, but is **not intended to replace a local development environment** for everyday work.

This workshop runs entirely in a cloud environment — no software installation required. One click opens a pre-configured RStudio session with all packages installed and the workshop data ready to use.

<div style="margin: 1.2rem 0;">
<a href="https://codespaces.new/mdibl/mdibl.github.io?devcontainer_path=.devcontainer%2Fdata-viz%2Fdevcontainer.json" target="_blank">
  <img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" style="height:32px;">
</a>
</div>

!!! info "First launch takes ~5 minutes"
    The first time the Codespace builds, GitHub installs R packages including the full tidyverse collection. Subsequent launches are instant. Start the build, then read through the "Why Visualize?" section while it runs.

**What you'll see:**

1. GitHub opens a VS Code editor in your browser — this is the Codespace container. You do not need to use VS Code for this workshop.
2. A browser tab for **RStudio** will open automatically at port 8787. No login is required.
3. If RStudio does not open automatically: in VS Code, click the **Ports** tab at the bottom panel, find port `8787`, and click the globe icon to open it in a new tab.

!!! tip "Keep your Codespace awake — and stop it when you're done"
    Codespaces automatically pause after **30 minutes of inactivity**, but suspended Codespaces still consume your monthly storage quota. **Closing the browser tab does not stop the Codespace.**

    **At the start of the workshop**, open a new terminal tab in VS Code (**Terminal → New Terminal**) and run this keepalive loop:

    ```bash
    while true; do echo "keepalive $(date)"; sleep 300; done
    ```

    This pings the Codespace every 5 minutes to prevent it from suspending during the session.

	!!! danger "How to stop your Codespace *when you're done*"

		1. Switch to the VS Code terminal tab where the `keepalive` loop is running.
		2. Press **Ctrl+C** to stop it.
		3. Go to [github.com/codespaces](https://github.com/codespaces), find your Codespace, click `···`, and select **Stop codespace**.

		***Closing the browser tab is not enough — a suspended Codespace still counts against your monthly storage quota.***

**Getting oriented in RStudio:**

Once RStudio is open, get the workshop files ready:

1. In the **Files** pane (bottom-right), you will see the workshop directory. Click `dataViz.Rproj` to open the project — this sets your working directory correctly so data paths in the script will resolve.
2. Open `workshop.R` (File → Open File, or click it in the Files pane). This is the script you will work through during the workshop.
3. Run lines by placing your cursor on them and pressing **Ctrl+Enter** (Windows/Linux) or **Cmd+Return** (Mac).

!!! tip "Save your work"
    Press **Ctrl+S** / **Cmd+S** often. At the end of the session, use the **Files** pane → More → Export to download your completed script to your computer before closing the Codespace.

---

## Why Visualize?

!!! abstract "Before reading on..."
    Think about the last time you looked at a table of numbers and tried to spot a pattern. How long did it take? How confident were you?

A well-chosen plot communicates in seconds what a table of numbers cannot communicate in minutes. Visualization is not decoration — it is the primary tool for **exploring** a dataset you have never seen before and for **communicating** findings to others.

In this workshop we use the same Portal Project dataset from the Introduction to R workshop (`surveys_complete_77_89.csv`, 16,878 observations of small mammals in southern Arizona, 1977–1989). By the end you will have turned those rows and columns into figures that tell a biological story.

---

## Part 1: The Tidyverse & Data Wrangling

### What is the Tidyverse?

The **tidyverse** is a collection of R packages that share a common design philosophy and work seamlessly together. The two we use most in this workshop:

| Package | What it does |
|---------|-------------|
| `dplyr` | Transform and summarize data frames (filter, group, aggregate) |
| `ggplot2` | Build plots layer by layer using the grammar of graphics |

Load the entire collection with a single call:

```r
library(tidyverse)
```

When you load tidyverse, R confirms which packages were attached. You will see `ggplot2`, `dplyr`, `readr`, and others listed.

Now load the data. We will call it `surveys` throughout this workshop to distinguish it from the `data` object in the Introduction to R workshop.

```r
surveys <- read_csv("data/surveys_complete_77_89.csv")
```

`read_csv()` (from the `readr` package, part of tidyverse) is slightly preferred over base R's `read.csv()` — it reads blank cells as `NA` automatically and prints a column-type summary on load.

### The Pipe `%>%`

The pipe operator `%>%` passes the result of one function directly into the next. It lets you write a chain of operations from top to bottom instead of nesting them inside each other.

```r
# Without pipe — you have to read from the inside out
arrange(filter(surveys, taxa == "Rodent"), desc(weight))

# With pipe — reads like a recipe, top to bottom
surveys %>%
  filter(taxa == "Rodent") %>%
  arrange(desc(weight))
```

Both produce identical output. The pipe version is easier to read, easier to edit, and easier to debug one step at a time.

!!! tip "Reading the pipe"
    Read `%>%` as **"then"**: take `surveys`, *then* filter, *then* arrange.

### `filter()` — Keep Rows Matching a Condition

`filter()` keeps rows where a condition is `TRUE` and drops the rest. The conditions use the same comparison operators you know from base R (`==`, `!=`, `>`, `<`, `>=`, `<=`, `&`, `|`).

```r
# Keep only Rodents
surveys %>% filter(taxa == "Rodent")

# Keep only observations from 1985
surveys %>% filter(year == 1985)

# Combine conditions: Rodents with a recorded weight
surveys %>% filter(taxa == "Rodent", !is.na(weight))
```

**`%in%` — match any value in a vector**

When you want to keep rows matching any one of several values, `%in%` is cleaner than chaining `|` conditions:

```r
# Without %in% — verbose
surveys %>% filter(sex == "M" | sex == "F")

# With %in% — clean, scales to any number of values
surveys %>% filter(sex %in% c("M", "F"))

# Works with any vector, including one you computed earlier
top6 <- surveys %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)
surveys %>% filter(species_id %in% top6)
```

`%in%` also silently excludes `NA` values — `filter(sex %in% c("M", "F"))` drops blank strings and NAs at the same time, which is why you will see it used instead of `sex == "M" | sex == "F"` throughout the exercises.

### `select()` — Choose Columns

`select()` keeps only the columns you name, dropping the rest. This makes large data frames easier to work with.

```r
surveys %>%
  select(species_id, year, weight, hindfoot_length)
```

### `mutate()` — Create or Modify Columns

`mutate()` adds new columns (or overwrites existing ones) without changing the number of rows.

```r
# Combine genus and species into a single readable name
surveys <- surveys %>%
  mutate(scientific_name = paste(genus, species))
```

### `arrange()` — Sort Rows

`arrange()` sorts rows by one or more columns. Default is ascending; wrap a column in `desc()` to reverse.

```r
# Heaviest individuals first
surveys %>%
  filter(!is.na(weight)) %>%
  arrange(desc(weight))
```

### `group_by()` + `summarise()` — Aggregate by Group

This is the workhorse combination for producing summaries. `group_by()` splits the data into invisible groups; `summarise()` collapses each group down to a single row of statistics.

```r
# Mean weight per year
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  summarise(
    avg_weight = mean(weight),
    n_obs      = n()
  )
```

```r
# Mean weight and count by taxa
surveys %>%
  filter(!is.na(weight), !is.na(taxa)) %>%
  group_by(taxa) %>%
  summarise(
    avg_weight = mean(weight),
    n          = n()
  )
```

`n()` inside `summarise()` counts the rows in each group — no argument needed.

### `count()` — Quick Frequency Tables

`count()` is a shortcut for `group_by() %>% summarise(n = n())`. Use `sort = TRUE` to rank from most to least common.

```r
# Most common species
surveys %>% count(species_id, sort = TRUE)
```

---

???+ question "Exercise 1.1 — Pipe practice"

    Using a single pipe chain, find the **5 heaviest Rodent observations** in the dataset. Show only the columns `species_id`, `weight`, `hindfoot_length`, and `year`. Exclude rows where `weight` is `NA`.

    ??? success "Solution"

        ```r
        surveys %>%
          filter(taxa == "Rodent", !is.na(weight)) %>%
          select(species_id, weight, hindfoot_length, year) %>%
          arrange(desc(weight)) %>%
          head(5)
        ```

        All five are large-bodied species. The heaviest individual (278 g) is *Neotoma albigula* — you may recognize it from the Introduction to R workshop challenges.

???+ question "Exercise 1.2 — Does sex predict weight?"

    **Part A.** Using `surveys`, calculate **mean weight and number of observations for each sex** (`"M"` and `"F"` only — exclude NA weights). What do you notice about the result?
	
	??? success "Part A Solution"

        **Part A — mean weight by sex overall:**

        ```r
        surveys %>%
          filter(!is.na(weight), sex %in% c("M", "F")) %>%
          group_by(sex) %>%
          summarise(mean_weight = round(mean(weight), 1), n = n())
        ```

        Males and females are nearly identical — both average ~53 g. The aggregate result hides what is really going on.
	
	
    **Part B.** Now add `species_id` as a second grouping variable so you get mean weight per **species and sex**. Does the pattern from Part A hold within each species?
    
	??? success "Part B Solution"

        **Part B — mean weight by species and sex:**

        ```r
        surveys %>%
          filter(!is.na(weight), sex %in% c("M", "F")) %>%
          group_by(species_id, sex) %>%
          summarise(mean_weight = round(mean(weight), 1), n = n(), .groups = "drop") %>%
          arrange(species_id, sex) 
        ```

        Within species the picture is more interesting. *Neotoma albigula* (NL) shows the clearest dimorphism — males average ~168 g vs females ~151 g (~11% heavier). In contrast, *Peromyscus eremicus* (PE) and *Reithrodontomys megalotis* (RM) go the other way, with females slightly heavier than males. The community-wide average lands at ~53 g for both sexes because these species-level differences cancel out across the dataset.

!!! success "Key Points — Data Wrangling"
    - Load tidyverse with `library(tidyverse)` — this gives you both `dplyr` and `ggplot2`.
    - The pipe `%>%` chains operations: read it as "then."
    - `filter()` keeps rows; `select()` keeps columns; `mutate()` adds columns.
    - `group_by()` + `summarise()` produce aggregate statistics per group.
    - `count(col, sort = TRUE)` is a fast way to build a frequency table.

---

## Part 2: The Grammar of Graphics

### How ggplot2 Thinks

Every plot in ggplot2 is built from the same three ingredients:

| Ingredient | What it is | Example |
|-----------|-----------|---------|
| **Data** | The data frame | `surveys_clean` |
| **Aesthetics** `aes()` | Columns mapped to visual properties | `x = hindfoot_length, y = weight` |
| **Geometry** `geom_*()` | The shape drawn for each observation | `geom_point()`, `geom_histogram()` |

The template is always:

```r
ggplot(data, aes(x = col1, y = col2)) +
  geom_*()
```

Layers are added with `+`. Each layer is a new `geom_*()`, `scale_*()`, `labs()`, or `theme_*()` call.

!!! note "ggplot2 uses `+`, not `%>%`"
    The pipe `%>%` connects dplyr steps. Inside a ggplot, layers are connected with `+`. You will often pipe data *into* `ggplot()` and then switch to `+` for the layers.

### Who is actually in this dataset?

Before we start plotting, it's worth understanding what `surveys` contains — because the subset we use for most of this workshop is not the full picture.

```r
# All four taxa are represented
surveys %>%
  count(taxa, sort = TRUE)
```

```
# A tibble: 5 × 2
  taxa        n
  <chr>   <int>
1 Rodent  16148
2 Bird      300
3 Rabbit     69
4 Reptile     4
5 NA        357
```

Rodents account for 96% of all captures. Birds, Rabbits, and Reptiles were recorded, but much less frequently — and crucially, weight and hindfoot length were almost never measured for them:

```r
# How complete is the weight column by taxa?
surveys %>%
  filter(!is.na(taxa)) %>%
  group_by(taxa) %>%
  summarise(
    n_total        = n(),
    n_with_weight  = sum(!is.na(weight)),
    pct_weight     = round(100 * n_with_weight / n_total, 1)
  )
```

```
  taxa    n_total n_with_weight pct_weight
  Rodent    16148         15186       94.0
  Bird        300             0        0.0
  Rabbit       69             0        0.0
  Reptile       4             0        0.0
```

No weight values were recorded for Birds, Rabbits, or Reptiles. When we filter for rows where both `weight` and `hindfoot_length` are present, we are effectively keeping only Rodent observations. This is intentional — the morphometric analysis in this workshop applies to the rodent data. The other taxa are real and ecologically important, but the data collected for them supports different questions (presence/absence, plot distribution) rather than size-based analysis.

```r
# Confirm: after filtering for complete morphometrics, only Rodents remain
surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length)) %>%
  count(taxa)
```

```
  taxa       n
  Rodent 13797
```

!!! info "surveys_clean = rodent morphometric data"
    From here forward, `surveys_clean` refers to the 13,797 rodent observations that have both `weight` and `hindfoot_length` recorded. When you see a plot labeled "surveys_clean," you are looking at rodents only.

```r
surveys_clean <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length))
```

### Histograms with `geom_histogram()`

A histogram shows the distribution of a single numeric variable by counting how many observations fall into each bin.

```r
# Simple histogram
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram()
```

```r
# Control bin count and colors
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white")
```

`fill` controls the bar interior; `color` controls the bar outline. Both are fixed here (set outside `aes()`) so every bar gets the same color.

### Adding Labels with `labs()`

`labs()` sets the title, subtitle, axis labels, and legend titles:

```r
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  labs(
    title    = "Distribution of Body Weight",
    subtitle = "Portal Project data, 1977–1989",
    x        = "Weight (g)",
    y        = "Count"
  )
```

### Themes

Themes control all non-data visual elements: background, grid lines, font sizes. Three built-in themes cover most use cases:

```r
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_minimal()   # clean, light grid

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_bw()        # white background, black border

ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_classic()   # no grid, clean axes — common in publications
```

You can stack `theme()` on top of a named theme to override individual elements:

```r
ggplot(surveys_clean, aes(x = weight)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white") +
  theme_minimal() +
  theme(
    plot.title   = element_text(size = 14, face = "bold"),
    axis.title   = element_text(size = 12)
  )
```

### Scatter Plots with `geom_point()`

Scatter plots show the relationship between two numeric variables.

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point()
```

With 13,797 points, overplotting is a problem. Use `alpha` (transparency, 0–1) to reveal density:

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2)
```

???+ question "Exercise — What explains the clusters?"

    The scatter plot shows several distinct clouds of points rather than one continuous spread. Use color to figure out what each cluster represents. Try mapping `color` to each of these columns in turn:

    1. `taxa`
    2. `species_id`
    3. `sex`

    Which one best explains the cluster structure? What does this tell you about rodent body size?

    ??? success "Solution"

        ```r
        # 1. Color by taxa — only one color appears. Why?
        ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = taxa)) +
          geom_point(alpha = 0.3) +
          labs(title = "Color by taxa") +
          theme_bw()
        ```

        Only `"Rodent"` appears because `surveys_clean` contains only rodent observations — all other taxa had no weight or hindfoot data recorded. This is a good reminder that a filter can silently reshape your data.

        ```r
        # 2. Color by species_id — clusters snap into focus
        ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
          geom_point(alpha = 0.4) +
          labs(title = "Color by species_id",
               x = "Hindfoot Length (mm)", y = "Weight (g)") +
          theme_bw()
        ```

        Each cluster is a different species. Rodent species vary enormously in body size — *Neotoma albigula* (NL) occupies the upper-right corner (large hindfoot, high weight), while *Reithrodontomys megalotis* (RM) sits in the lower-left (small hindfoot, low weight).

        ```r
        # 3. Color by sex — no cluster structure
        ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = sex)) +
          geom_point(alpha = 0.3) +
          labs(title = "Color by sex") +
          theme_bw()
        ```

        Sex does not explain the clusters — males and females of each species overlap almost completely in body size. **Species identity is the dominant driver of the cluster structure.**

### Bar Charts with `geom_col()`

`geom_col()` draws bars where the height is a value already in your data (as opposed to `geom_bar()`, which counts rows for you). The typical workflow is to summarise first, then plot.

```r
surveys %>%
  filter(!is.na(taxa)) %>%
  count(taxa) %>%
  ggplot(aes(x = taxa, y = n)) +
  geom_col(fill = "steelblue") +
  labs(title = "Observations by Taxa", x = "Taxa", y = "Count") +
  theme_bw()
```

Note how `%>%` pipes the summarised data directly into `ggplot()` — you do not need to save an intermediate object.

---

???+ question "Exercise 2.1 — Distribution of hindfoot length"

    Build a histogram of `hindfoot_length` using `surveys_clean`. Add a descriptive title, clear axis labels, and a theme of your choice.

    ??? success "Solution"

        ```r
        ggplot(surveys_clean, aes(x = hindfoot_length)) +
          geom_histogram(bins = 25, fill = "seagreen", color = "white") +
          labs(
            title    = "Distribution of Hindfoot Length",
            subtitle = "Portal Project data, 1977–1989",
            x        = "Hindfoot Length (mm)",
            y        = "Count"
          ) +
          theme_minimal()
        ```

        The multi-modal shape reflects mutliple size classes of rodents in the data.

???+ question "Exercise 2.2 — Does experimental treatment affect average body weight?"

    The Portal Project plots have five experimental treatments that manipulate which animals can enter each plot. Do these treatments affect the average body weight of captured animals?

    Using `surveys`, filter out rows where `weight` is `NA`, then summarise **mean weight by `plot_type`**. Plot the result as a bar chart. Add descriptive labels and rotate the x-axis text so the plot type names don't overlap (`theme(axis.text.x = element_text(angle = 45, hjust = 1))`).

    ??? success "Solution"

        ```r
        surveys %>%
          filter(!is.na(weight)) %>%
          group_by(plot_type) %>%
          summarise(avg_weight = mean(weight)) %>%
          ggplot(aes(x = plot_type, y = avg_weight)) +
          geom_col(fill = "steelblue") +
          labs(
            title = "Average Rodent Weight by Plot Treatment",
            x     = "Plot Type",
            y     = "Average Weight (g)"
          ) +
          theme_bw() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        ```

        The Long-term Krat Exclosure plots have the lowest average weight (~31 g) — the heavy kangaroo rat species (*Dipodomys merriami*, *D. spectabilis*) are excluded by the barriers, so the remaining community is dominated by smaller rodents. Control plots sit in the middle (~59 g). You will return to plot-type differences in Question 3 of the Mini Project.

!!! success "Key Points — Grammar of Graphics"
    - Every ggplot needs data, `aes()` mappings, and at least one `geom_*()`.
    - Layers are added with `+`. Order matters — later layers draw on top of earlier ones.
    - `labs()` sets all text labels. `theme_*()` controls non-data appearance.
    - `alpha` (0–1) controls transparency — essential when points overlap.
    - Pipe (`%>%`) into `ggplot()`, then switch to `+` for ggplot layers.

---

## Part 3: Layering & Customizing

### Color vs. Fill

Two aesthetics control color in ggplot2:

| Aesthetic | Controls | Applies to |
|-----------|---------|-----------|
| `color` | Point outlines, line color, text color | `geom_point()`, `geom_line()`, `geom_smooth()` |
| `fill` | Interior fill | `geom_histogram()`, `geom_col()`, `geom_tile()` |

Set them **outside `aes()`** as a fixed value (every element gets the same color):

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(color = "steelblue", alpha = 0.3)
```

Map them **inside `aes()`** to a column (each group gets a different color). Because `surveys_clean` is rodent-only, map to `species_id` to see meaningful color variation:

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4)
```

### Color Palettes — `scale_color_brewer()` and `scale_fill_brewer()`

ggplot2 assigns colors automatically, but you can control the palette explicitly. The `scale_color_*()` and `scale_fill_*()` families mirror each other — use whichever matches the aesthetic you mapped in `aes()`:

| Goal | Aesthetic is `color =` | Aesthetic is `fill =` |
|------|------------------------|----------------------|
| Named palette (ColorBrewer) | `scale_color_brewer()` | `scale_fill_brewer()` |
| Colorblind-safe, many groups | `scale_color_viridis_d()` | `scale_fill_viridis_d()` |
| Exact colors you choose | `scale_color_manual()` | `scale_fill_manual()` |

**`scale_color_brewer()` — named palettes for points and lines**

ColorBrewer palettes (`"Set1"`, `"Set2"`, `"Dark2"`) are designed for readability and colorblind accessibility. Most handle up to 8–12 groups, so limit to the top 6 species for a clean result:

```r
top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.5) +
  scale_color_brewer(palette = "Dark2") +
  labs(title = "Top 6 Species — Hindfoot vs Weight",
       x = "Hindfoot Length (mm)", y = "Weight (g)") +
  theme_bw()
```

**`scale_fill_brewer()` — the same idea, for bar and histogram fills**

```r
surveys_clean %>%
  filter(sex %in% c("M", "F")) %>%
  ggplot(aes(x = weight, fill = sex)) +
  geom_histogram(bins = 40, alpha = 0.7, position = "identity") +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Weight (g)", y = "Count") +
  theme_minimal()
```

**`scale_color_viridis_d()` — when you have many categories**

When groups outnumber a Brewer palette, viridis palettes handle the full 17-species range gracefully. They are perceptually uniform, colorblind-safe, and print well in grayscale. The `_d` suffix stands for discrete:

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4) +
  scale_color_viridis_d() +
  theme_bw()
```

**`scale_color_manual()` — when you need exact colors**

Use `scale_color_manual()` when you need to match specific colors — institutional palette, reproducing a published figure, or highlighting one group. Supply a named vector so each level maps to a color explicitly:

```r
surveys_clean %>%
  filter(sex %in% c("M", "F")) %>%
  ggplot(aes(x = hindfoot_length, y = weight, color = sex)) +
  geom_point(alpha = 0.4) +
  scale_color_manual(values = c("F" = "steelblue", "M" = "darkorange")) +
  theme_bw()
```

`scale_fill_manual()` works identically — just swap the aesthetic from `color =` to `fill =` in both `aes()` and the scale call.

### `geom_smooth()` — Trend Lines

Add a trend line on top of a scatter plot. `method = "lm"` fits a straight line; the default fits a smooth curve (LOESS). `se = TRUE` (default) adds a shaded confidence band.

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", color = "darkred")
```

When a color aesthetic is mapped in `aes()`, `geom_smooth()` fits a separate trend line per group. Using `species_id` in `surveys_clean` shows how the weight–hindfoot relationship differs across rodent species:

```r
ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE)
```

### `facet_wrap()` — Small Multiples

`facet_wrap(~ variable)` splits a single plot into panels, one per level of the variable. This is one of the most powerful tools in ggplot2 for revealing group-level patterns.

With 17 species in `surveys_clean`, all panels at once would be too small to read. Limit to the top 6 species first:

```r
top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  facet_wrap(~ species_id) +
  theme_bw()
```

Add `scales = "free_y"` to let each panel choose its own y-axis range — essential here because body size differs so much across species:

```r
surveys_clean %>%
  filter(species_id %in% top6) %>%
  ggplot(aes(x = hindfoot_length, y = weight)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  facet_wrap(~ species_id, scales = "free_y") +
  theme_bw()
```

Add `ncol =` to control the number of columns in the panel grid.

### `geom_tile()` — Heatmaps

`geom_tile()` draws a filled rectangle for every row of data. It requires three aesthetics: `x`, `y` (the two categorical axes), and `fill` (the value encoded by color).

```r
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
```

---

???+ question "Exercise 3.1 — Weight over time, by species"

    Create a summary of **average weight by year and species** for the top 6 species in `surveys_clean`, then build a faceted line + point plot. Use `facet_wrap(~ species_id, scales = "free_y")` so each panel uses its own y-axis range. Remove the legend (it is redundant with the facet labels).

    ??? success "Solution"

        ```r
        top6 <- surveys_clean %>% count(species_id, sort = TRUE) %>% head(6) %>% pull(species_id)

        weight_by_year_spp <- surveys_clean %>%
          filter(species_id %in% top6) %>%
          group_by(year, species_id) %>%
          summarise(avg_weight = mean(weight), .groups = "drop")

        ggplot(weight_by_year_spp, aes(x = year, y = avg_weight, color = species_id)) +
          geom_point() +
          geom_line() +
          facet_wrap(~ species_id, scales = "free_y") +
          labs(
            title = "Average Weight Over Time by Species",
            x     = "Year",
            y     = "Average Weight (g)"
          ) +
          theme_bw() +
          theme(legend.position = "none")
        ```

        Each species shows a different trajectory. DM (*Dipodomys merriami*) shows notable year-to-year fluctuations; DS (*D. spectabilis*) shows a declining trend over the study period. The `free_y` scale is essential here — NL weighs ~150 g while RM weighs ~10 g, so a shared axis would flatten the smaller species into a flat line.

???+ question "Exercise 3.2 — Which species are captured in each plot type?"

    Using the `top6` object from the teaching example above and `surveys_clean`, count observations by **`plot_type` and `species_id`**, then display the result as a heatmap filled by count. Rotate the x-axis labels.

    ??? success "Solution"

        ```r
        surveys_clean %>%
          filter(species_id %in% top6) %>%
          group_by(plot_type, species_id) %>%
          summarise(n = n(), .groups = "drop") %>%
          ggplot(aes(x = species_id, y = plot_type, fill = n)) +
          geom_tile(color = "white", linewidth = 0.5) +
          scale_fill_gradient(low = "white", high = "steelblue") +
          labs(
            title = "Captures by Plot Type and Species",
            x     = "Species ID",
            y     = "Plot Type",
            fill  = "Count"
          ) +
          theme_minimal() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        ```

        DM (*Dipodomys merriami*) dominates in Control plots and is nearly absent from Krat Exclosure plots — exactly what the experimental barriers are designed to produce. In the Mini Project you will convert these raw counts to within-plot proportions to make a fairer comparison across plot types that differ in total sampling effort.

### `ggsave()` — Saving Figures

Store the plot in a variable, then save it to a file:

```r
my_plot <- ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Weight vs Hindfoot Length by Species",
       x = "Hindfoot Length (mm)", y = "Weight (g)") +
  theme_bw()

ggsave("weight_hindfoot.png", my_plot, width = 8, height = 6, dpi = 300)
```

`dpi = 300` produces print-quality resolution. The file is saved to your working directory (the `dataViz/` folder when you have opened `dataViz.Rproj`).

!!! success "Key Points — Customizing"
    - `color` affects lines and points; `fill` affects bars and tiles. Inside `aes()` maps to data; outside sets a fixed value.
    - `scale_color_manual()` / `scale_fill_manual()` let you choose your own palette.
    - `geom_smooth()` adds a trend line. Use `method = "lm"` for linear fits.
    - `facet_wrap(~ var)` creates a panel per group — one of the most powerful ggplot2 tools.
    - `geom_tile()` builds heatmaps using `x`, `y`, and `fill` aesthetics.
    - `ggsave("file.png", plot, width, height, dpi)` saves to disk.

---

## Mini Project — Research Questions

*Apply what you have learned to answer three biological questions about the Portal Project data. Each question has a starter outline; try the code yourself before opening the solution.*

### Setup

```r
library(tidyverse)
surveys <- read_csv("data/surveys_complete_77_89.csv")

# Working dataset: rows with both weight and hindfoot_length recorded
surveys_clean <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length))

# Add full scientific name
surveys_clean <- surveys_clean %>%
  mutate(scientific_name = paste(genus, species))

nrow(surveys_clean)   # 13,797 rows
```

---

### Question 1 — How does average rodent weight change over time?

???+ question "Q1.1 — Weight trend across all rodents"

    Summarise `surveys_clean` to get **mean weight per year** (all species combined), then plot:

    - `year` on x, `avg_weight` on y
    - Points (`geom_point()`) + a trend line (`geom_smooth()`)
    - Descriptive title, axis labels, and a theme

    ??? success "Solution"

        ```r
        weight_by_year <- surveys_clean %>%
          group_by(year) %>%
          summarise(avg_weight = mean(weight), n_obs = n())

        ggplot(weight_by_year, aes(x = year, y = avg_weight)) +
          geom_point(size = 3, color = "steelblue") +
          geom_smooth(method = "lm", color = "darkblue") +
          labs(
            title    = "Average Rodent Weight Over Time",
            subtitle = "Portal Project data, 1977–1989",
            x        = "Year",
            y        = "Average Weight (g)"
          ) +
          theme_minimal()
        ```

???+ question "Q1.2 — Does the trend differ by species?"

    Group by **both `year` and `species_id`**, summarise the mean weight, then plot with:

    - Points and lines colored by `species_id`
    - `facet_wrap(~ scientific_name)` for one panel per species
    - No legend (redundant with facet labels)
    - A publication-ready theme and labels

    ??? success "Solution"

        ```r
        weight_by_year_sci <- surveys_clean %>%
          group_by(year, scientific_name) %>%
          summarise(avg_weight = mean(weight), .groups = "drop")

        ggplot(weight_by_year_sci, aes(x = year, y = avg_weight, color = scientific_name)) +
          geom_point(size = 1.5) +
          geom_line() +
          facet_wrap(~ scientific_name) +
          labs(
            title    = "Average Weight Over Time by Species",
            subtitle = "Portal Project data, 1977–1989",
            x        = "Year",
            y        = "Average Weight (g)"
          ) +
          theme_bw() +
          theme(legend.position = "none")
        ```

        Each species shows a different trajectory. Some are stable; others show clear trends. Consider which species might be responding to the experimental plot treatments.

---

### Question 2 — Is weight correlated with hindfoot length?

???+ question "Q2.1 — Overall scatter plot with trend line"

    Plot `hindfoot_length` (x) vs `weight` (y) for all of `surveys_clean`. Add a linear trend line. What is the overall pattern?

    ??? success "Solution"

        ```r
        ggplot(surveys_clean, aes(x = hindfoot_length, y = weight)) +
          geom_point(alpha = 0.2) +
          geom_smooth(method = "lm", color = "darkred") +
          labs(
            title = "Relationship Between Hindfoot Length and Weight",
            x     = "Hindfoot Length (mm)",
            y     = "Weight (g)"
          ) +
          theme_minimal()
        ```

        There is a positive association overall, but the scatter is wide — the relationship is driven largely by species differences rather than within-species variation.

???+ question "Q2.2 — Does the relationship hold within species?"

    Repeat the scatter plot, but color by `species_id` and add `facet_wrap(~ species_id)`. Add a per-species trend line. Does each species show the same relationship?

    ??? success "Solution"

        ```r
        ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
          geom_point(alpha = 0.4) +
          geom_smooth(method = "lm", se = FALSE) +
          facet_wrap(~ species_id) +
          labs(
            title    = "Weight vs Hindfoot Length by Species",
            subtitle = "Portal Project data, 1977–1989",
            x        = "Hindfoot Length (mm)",
            y        = "Weight (g)",
            color    = "Species"
          ) +
          theme_bw() +
          theme(legend.position = "none")
        ```

        Within most species, the positive relationship is weaker — some species show it clearly, others show almost no within-species correlation. This is a textbook example of **Simpson's paradox**: an aggregate trend driven by group membership can disappear or reverse when groups are examined separately.

---

### Question 3 — Do plot types attract different species?

???+ question "Q3 — Species composition heatmap"

    Reproduce the proportional heatmap from Exercise 3.2 and interpret it ecologically. The five plot types reflect different experimental treatments: Control plots are unmanipulated; Krat Exclosures block kangaroo rats (*Dipodomys* spp.); Rodent Exclosures block all rodents; Spectab exclosures block *Dipodomys spectabilis* specifically.

    Given those treatments, does the heatmap match your expectations?

    ??? success "Solution"

        ```r
        top6_ids <- surveys_clean %>%
          count(species_id, sort = TRUE) %>%
          head(6) %>%
          pull(species_id)

        surveys_clean %>%
          filter(species_id %in% top6_ids) %>%
          group_by(plot_type, species_id) %>%
          summarise(n = n(), .groups = "drop") %>%
          group_by(plot_type) %>%
          mutate(proportion = n / sum(n)) %>%
          ungroup() %>%
          ggplot(aes(x = species_id, y = plot_type, fill = proportion)) +
          geom_tile(color = "white", linewidth = 0.5) +
          scale_fill_gradient(low = "white", high = "steelblue",
                              labels = scales::percent) +
          labs(
            title    = "Species Composition by Plot Type",
            subtitle = "Top 6 species, proportion of captures within each plot type",
            x        = "Species ID",
            y        = "Plot Type",
            fill     = "Proportion"
          ) +
          theme_minimal() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        ```

        DM (*Dipodomys merriami*) dominates Control plots and nearly disappears in Rodent Exclosures — exactly what we expect since it is a rodent. In Long-term Krat Exclosure plots, RM (*Reithrodontomys megalotis*) and OT (*Onychomys torridus*) increase their share, consistent with competitive release once kangaroo rats are removed.

---

### Wrap Up — Save Your Favorite Plot

```r
# Store your plot in a variable
my_plot <- ggplot(surveys_clean, aes(x = hindfoot_length, y = weight, color = species_id)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Weight vs Hindfoot Length by Species",
    x = "Hindfoot Length (mm)",
    y = "Weight (g)"
  ) +
  theme_bw()

# Save to a PNG file (lands in your working directory)
ggsave("my_favorite_plot.png", my_plot, width = 8, height = 6, dpi = 300)
```

---

!!! danger "Before you leave — stop your Codespace"
    1. Switch to the VS Code terminal tab where the keepalive loop is running.
    2. Press **Ctrl+C** to stop it.
    3. Go to [github.com/codespaces](https://github.com/codespaces), find your Codespace, click `···`, and select **Stop codespace**.

    Closing the browser tab is **not** enough — a suspended Codespace still counts against your monthly storage quota.

---

## Workshop Summary

### Key dplyr Functions

| Function | What it does | Example |
|----------|-------------|---------|
| `filter()` | Keep rows matching a condition | `filter(taxa == "Rodent")` |
| `select()` | Keep specific columns | `select(species_id, weight, year)` |
| `mutate()` | Add or modify a column | `mutate(sci = paste(genus, species))` |
| `arrange()` | Sort rows | `arrange(desc(weight))` |
| `group_by()` | Group for aggregation | `group_by(year)` |
| `summarise()` | Collapse groups to summary rows | `summarise(avg = mean(weight))` |
| `count()` | Frequency table shortcut | `count(species_id, sort = TRUE)` |
| `%>%` | Pipe: pass result to next function | `surveys %>% filter(...) %>% ...` |

### Key ggplot2 Functions

| Function | What it does | Example |
|----------|-------------|---------|
| `ggplot()` | Initialize a plot | `ggplot(data, aes(x, y))` |
| `aes()` | Map columns to visual properties | `aes(x = year, color = taxa)` |
| `geom_histogram()` | Distribution of one variable | `geom_histogram(bins = 30)` |
| `geom_point()` | Scatter plot | `geom_point(alpha = 0.3)` |
| `geom_line()` | Connect points with lines | `geom_line()` |
| `geom_col()` | Bar chart (pre-summarised heights) | `geom_col(fill = "steelblue")` |
| `geom_smooth()` | Trend line | `geom_smooth(method = "lm")` |
| `geom_tile()` | Heatmap | `geom_tile(color = "white")` |
| `facet_wrap()` | Panel per group | `facet_wrap(~ taxa)` |
| `labs()` | Set all text labels | `labs(title = "...", x = "...")` |
| `theme_bw()` | Clean black-and-white theme | `theme_bw()` |
| `theme()` | Override specific elements | `theme(legend.position = "none")` |
| `scale_fill_gradient()` | Custom continuous fill scale | `scale_fill_gradient(low, high)` |
| `scale_color_manual()` | Custom discrete color scale | `scale_color_manual(values = c(...))` |
| `ggsave()` | Save a plot to file | `ggsave("plot.png", p, width = 8)` |

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using `%>%` inside ggplot layers | Switch to `+` after `ggplot()` |
| Color is wrong type (fill vs color) | Check geometry: bars need `fill`, points need `color` |
| Mapping color outside `aes()` | Move inside `aes()` to map to a variable |
| Overplotted scatter with 10k+ points | Add `alpha = 0.2` to `geom_point()` |
| `summarise()` with no `group_by()` | Add `group_by()` before `summarise()` |
| `geom_bar()` instead of `geom_col()` | Use `geom_col()` when y is already a count/value |
