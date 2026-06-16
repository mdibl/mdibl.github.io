##############################################################
# Introduction to R & RStudio
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


# ── PART 1: R as a Calculator & Objects ──────────────────────────────────────

# Basic arithmetic
5 + 3       # addition
10 - 4      # subtraction
6 * 7       # multiplication
100 / 4     # division
2 ^ 3       # exponentiation
17 %% 5     # modulo (remainder after division)

# Order of operations — parentheses work exactly as in math
2 + 3 * 4    # 14 — multiplication happens first
(2 + 3) * 4  # 20 — parentheses evaluated first


## EXERCISE 1.1 — Dog years
# Formula: human-equivalent age = (animal age / animal max lifespan) × human max lifespan
# Human max lifespan: 122.5 years
# Dog max lifespan:   24 years
# Dog's current age:  8 years
# Using ONLY numbers and arithmetic operators (no objects yet),
# calculate how old an 8-year-old dog is in human years.

## SOLUTION 1.1
# 8 / 24 * 122.5   # 40.83333 — about 41 human years


# ── Objects ──────────────────────────────────────────────────────────────────

# Assign values with <-
# After running, check the Environment pane (top-right) to see your objects
human_max <- 122.5
dog_max   <- 24
dog_age   <- 8

# Use objects in calculations — much more readable than raw numbers
dog_age / dog_max * human_max

# Objects can hold text (character strings)
species_name <- "Neotoma albigula"
species_name

# Objects can hold logical (TRUE/FALSE) values
is_nocturnal <- TRUE
is_nocturnal

# Check the type of any object with class()
class(human_max)     # "numeric"
class(species_name)  # "character"
class(is_nocturnal)  # "logical"

# NA is R's representation of missing data — not zero, not blank
unknown_weight <- NA
is.na(unknown_weight)  # TRUE


## EXERCISE 1.2 — Objects and the dog-years formula
# Using your existing objects human_max and dog_max:
#   1. How old is a 3-year-old dog in human years?
#   2. How old is a 15-year-old dog in human years?
#   3. Create cat_max <- 38 and recalculate both ages for a cat.

## SOLUTION 1.2
# 3  / dog_max * human_max   # 15.3125
# 15 / dog_max * human_max   # 76.5625
# cat_max <- 38
# 3  / cat_max * human_max   # 9.6...
# 15 / cat_max * human_max   # 48.3...


# ── PART 2: Vectors ───────────────────────────────────────────────────────────

# c() combines values into a vector — all elements must be the same type
weights  <- c(45, 32, 28, 51, 37)
taxa     <- c("Rodent", "Bird", "Rodent", "Rabbit", "Rodent")
captured <- c(TRUE, FALSE, TRUE, TRUE, FALSE)

# Inspect a vector
length(weights)   # number of elements: 5
class(weights)    # data type: "numeric"
str(weights)      # compact summary: type + values


# ── Type Coercion ─────────────────────────────────────────────────────────────

# R silently converts mixed types to the most flexible type that fits
# Hierarchy: logical < integer < numeric < character

mixed <- c(1, 2, "three")
class(mixed)   # "character" — one string forces everything to character
mixed          # "1"  "2"  "three" — the numbers became strings

mixed2 <- c(1, 2, TRUE, FALSE)
class(mixed2)  # "numeric" — TRUE → 1, FALSE → 0
mixed2         # 1 2 1 0


# ── Indexing Vectors ──────────────────────────────────────────────────────────

# R uses 1-based indexing — first element is [1], not [0]
weights[1]        # first element:       45
weights[3]        # third element:       28
weights[c(1, 3)]  # first and third:     45 28
weights[2:4]      # elements 2 through 4: 32 28 51
weights[-1]       # all EXCEPT first:    32 28 51 37


## EXERCISE 2.1 — Predict the class
# Before running, predict what class() returns for each vector. Then check.

# Vector A
v_a <- c(1, 2, 3)

# Vector B — note the L suffix
v_b  <- c(1L, 2L, 3L)
v_b2 <- as.integer(c(1, 2, 3))  # same result as L suffix

# Vector C
v_c <- c(TRUE, FALSE, TRUE)

# Vector D
v_d <- c(1, 2, "three")

# Vector E
v_e <- c(TRUE, FALSE, 1, 0)

# Vector F
v_f <- c("mouse", "rat", TRUE)

class(v_a); class(v_b); class(v_b2); class(v_c); class(v_d); class(v_e); class(v_f)

## SOLUTION 2.1
# v_a  → "numeric"   (plain numbers are 64-bit doubles by default)
# v_b  → "integer"   (L suffix forces integer storage)
# v_b2 → "integer"   (as.integer() does the same thing)
# v_c  → "logical"   (all logical)
# v_d  → "character" (one string forces everything to character)
# v_e  → "numeric"   (TRUE→1, FALSE→0; numeric wins over logical)
# v_f  → "character" (one string forces all; TRUE becomes "TRUE")
#
# as.integer() belongs to a family of type-conversion functions:
# as.numeric(), as.character(), as.logical()
# Use them when a column loads as the wrong type.


## EXERCISE 2.2 — Subsetting
captures <- c(12, 7, 19, 3, 25, 8, 14)
# Write a single line to extract each of the following:
#   1. The fourth element
#   2. The first and last elements
#   3. Elements 3 through 5
#   4. All elements except the second

## SOLUTION 2.2
# captures[4]          # 3
# captures[c(1, 7)]    # 12 14
# captures[3:5]        # 19 3 25
# captures[-2]         # 12 19 3 25 8 14


# ── PART 3: Loading and Exploring Data ───────────────────────────────────────

# read.csv() reads a comma-separated file into a data frame
# The path is relative to your working directory (set by introR.Rproj)
data <- read.csv("data/surveys_complete_77_89.csv")

# Tidyverse alternative — faster, reads blanks as NA automatically
# library(readr)
# data <- read_csv("data/surveys_complete_77_89.csv")


# ── Exploring a Data Frame ────────────────────────────────────────────────────

str(data)       # structure: column types + first few values
summary(data)   # min/max/quartiles for numeric; counts for character
dim(data)       # rows × columns:   16878 13
nrow(data)      # number of rows:   16878
ncol(data)      # number of columns: 13
names(data)     # column names as a character vector

head(data)      # first 6 rows
tail(data)      # last 6 rows
head(data, 10)  # first 10 rows

View(data)      # open spreadsheet-style viewer in RStudio (don't use in scripts)

# Frequency table — more useful than summary() for categorical columns
table(data$taxa)
hist(data$year)


## EXERCISE 3.1 — Explore the structure
# Run str(data) and summary(data). Before looking up the answers, try to
# answer these from the output alone:
#   1. How many columns contain numeric data? How many contain text?
#   2. Which column has the most missing values (NA)?
#   3. What is the range of years in this dataset?

## SOLUTION 3.1
# str(data); summary(data)
# 1. 7 numeric (integer) columns: record_id, month, day, year, plot_id,
#    hindfoot_length, weight
#    6 character columns: species_id, sex, genus, species, taxa, plot_type
# 2. hindfoot_length has the most NAs (2733) — visible as "NA's: 2733" in summary()
# 3. Year range: 1977–1989 (Min/Max in summary, or first values in str)


## EXERCISE 3.2 — First look at the data
# Using only the exploration functions above (no scrolling):
#   1. How many rows and columns does the dataset have?
#   2. What are the column names?
#   3. What taxa are present, and how many observations per taxon?
#   4. What is the mean weight across all observations? (watch out for NAs!)

## SOLUTION 3.2
# dim(data)               # 16878 rows, 13 columns
# nrow(data); ncol(data)
# names(data)
# table(data$taxa)        # Bird 300, Rabbit 69, Reptile 4, Rodent 16148
# mean(data$weight, na.rm = TRUE)  # ~53.2 grams


## EXERCISE 3.3 — Summary of the last 6 rows
# Calculate summary statistics for only the last 6 rows of the dataset.
# Try at least two approaches.

## SOLUTION 3.3
# Approach 1 — most readable:
# last6 <- tail(data); summary(last6)
#
# Approach 2 — most robust (works even if nrow changes):
# summary(data[(nrow(data) - 5):nrow(data), ])
#
# Approach 3 — hard-coded (works now, but avoid — fragile):
# summary(data[16873:16878, ])


# ── PART 4: Indexing Data Frames ─────────────────────────────────────────────

# $ extracts a single column as a vector
data$weight      # all 16,878 weight values
data$taxa        # all taxa labels

# [row, col] — always: data[rows, columns]; leave blank for "all"
data[1, ]        # row 1, all columns
data[, 9]        # all rows, column 9 (weight)
data[3, 5]       # row 3, column 5 — one cell
data[1:6, ]      # rows 1–6 (same as head())

# Index by column name — safer than by position
data[, "weight"]
data[, c("genus", "species")]


# ── Stop and think: why won't data[16] work? ─────────────────────────────────
# Try these three. Only one succeeds — why?
# data[16]     # Error: undefined columns selected (no column 16 — only 13 exist)
# data[16, ]   # Row 16, all columns ✓
# data[, 16]   # Error: undefined columns selected (same reason as data[16])
#
# data[16] treats the data frame like a list and selects column 16.
# data[16, ] uses [row, col] syntax — row 16, all columns. This is correct.


# ── Statistics on a Single Column ────────────────────────────────────────────

summary(data$weight)                        # min, Q1, median, mean, Q3, max, NAs
mean(data$weight, na.rm = TRUE)             # 53.2 — na.rm ignores NAs
median(data$hindfoot_length, na.rm = TRUE)  # 35
min(data$weight, na.rm = TRUE)
max(data$weight, na.rm = TRUE)

# Without na.rm = TRUE, any NA in the column returns NA as the result
mean(c(1, 2, NA, 4))             # NA
mean(c(1, 2, NA, 4), na.rm = TRUE)  # 2.333...


## EXERCISE 4.1 — Indexing practice
# Using bracket notation or $, answer without View():
#   1. What are the values in row 100? (all columns)
#   2. What is in row 50, column 8?
#   3. Extract just the plot_type column. How many unique values? (hint: unique())
#   4. What is the median hindfoot_length? What about for just the first 2000 rows?

## SOLUTION 4.1
# data[100, ]
# data[50, 8]
# data[50, "hindfoot_length"]          # same, by name
# data$plot_type
# unique(data$plot_type)               # 5 unique plot types
# median(data$hindfoot_length, na.rm = TRUE)           # 35
# median(data[1:2000, "hindfoot_length"], na.rm = TRUE) # 36


## EXERCISE 4.2 — Investigating the data
#   1. How many samples had a plot_type of "Control"? (hint: table() or sum())
#   2. What was the minimum recorded hindfoot_length? The first quartile?
#   3. Excluding NAs, what are the min and max weight in the first 2000 rows?

## SOLUTION 4.2
# table(data$plot_type)                     # Control: 7213
# sum(data$plot_type == "Control")          # 7213 — more direct
# summary(data$hindfoot_length)             # Min: 6 mm, 1st Qu.: 21 mm
# first2000_weight <- data[1:2000, "weight"]
# min(first2000_weight, na.rm = TRUE)       # 4 g
# max(first2000_weight, na.rm = TRUE)       # 239 g


# ── PART 5: Logical Operators & Filtering ────────────────────────────────────

x <- 10
y <- 15
z <- 20

# Comparison operators — return TRUE or FALSE
x == y     # equal?          FALSE
x != y     # not equal?      TRUE
y > x      # greater than?   TRUE
z / 2 <= x # less than/equal? TRUE (10 <= 10)

# Common mistake: = is assignment, == is comparison
# x = 10    # stores 10 in x
# x == 10   # asks "is x equal to 10?" → TRUE
# data[data$taxa = "Rodent", ]   # ERROR — use == not =
# data[data$taxa == "Rodent", ]  # correct

# Logical operators — combine conditions
x > 5 & y < 20    # AND: both TRUE → TRUE
x > 5 & y > 20    # AND: one FALSE → FALSE
x > 20 | y < 20   # OR: one TRUE → TRUE
!(x == 10)        # NOT: inverts TRUE → FALSE


# ── Logical Vectors ───────────────────────────────────────────────────────────

x_vec <- c(5, 10, 15, 20)
x_vec > 12              # FALSE FALSE TRUE TRUE — tests every element
x_vec[x_vec > 12]       # 15 20 — keeps only where TRUE


# ── Filtering Data Frames ─────────────────────────────────────────────────────

# Pattern: data[condition, ]
# Rows where condition is TRUE are kept; FALSE rows are dropped.

# Single condition
data_rodent <- data[data$taxa == "Rodent", ]
nrow(data_rodent)   # 16505 — includes 357 NA-taxa rows (NA != FALSE)

# Range condition
data_80s <- data[data$year >= 1980 & data$year <= 1989, ]
nrow(data_80s)

# Multi-condition
data_rodent_80s <- data[
  data$taxa == "Rodent" &
    data$year >= 1980 &
    data$year <= 1989,
]
nrow(data_rodent_80s)


# ── which() — row numbers instead of rows ────────────────────────────────────

# which() returns positions (row numbers) where condition is TRUE
which(data$year == 1985)     # row numbers for 1985 observations
which(data$weight > 100)     # row numbers for heavy individuals


# ── Handling NA Values ────────────────────────────────────────────────────────

# NA propagates — comparing anything to NA returns NA, not TRUE or FALSE
NA > 100    # NA
NA == 5     # NA

# Detect missing values
is.na(data$weight)           # logical vector: TRUE where weight is NA
sum(is.na(data$weight))      # 1692 NAs in the weight column
colSums(is.na(data))         # NA count for every column at once

# Rows that have at least one NA
data_has_na <- data[!complete.cases(data), ]
nrow(data_has_na)

# Blank strings ("") are NOT the same as NA — read.csv() keeps them as ""
sum(data$sex == "", na.rm = TRUE)  # 1300 blank strings in sex column
data[data == ""] <- NA             # convert all blanks to NA
sum(is.na(data$sex))               # 1300 — now they are proper NAs

# Remove all rows that contain any NA
data_clean <- na.omit(data)
nrow(data) - nrow(data_clean)   # rows removed


## EXERCISE 5.1 — Filtering practice
#   1. Subset to female animals (sex == "F"). How many rows?
#   2. Subset to observations where weight > 50 g (exclude NAs properly).
#   3. Subset to male Rodents in plot 2. How many observations?

## SOLUTION 5.1
# data_female <- data[data$sex == "F", ]
# nrow(data_female)   # 7318
#
# data_heavy <- data[!is.na(data$weight) & data$weight > 50, ]
# nrow(data_heavy)    # 4254
# # Note: data[data$weight > 50, ] without is.na() check would include NA rows
#
# data_m_rodent_p2 <- data[
#   data$sex == "M" &
#     data$taxa == "Rodent" &
#     data$plot_id == 2,
# ]
# nrow(data_m_rodent_p2)  # 529


## EXERCISE 5.2 — NA investigation
#   1. How many observations have a missing weight?
#   2. How many observations have a missing hindfoot_length?
#   3. How many rows have NO missing values in any column? (hint: complete.cases())
#   4. After replacing blank strings with NA, how many NAs are in the sex column?

## SOLUTION 5.2
# sum(is.na(data$weight))           # 1692
# sum(is.na(data$hindfoot_length))  # 2733
# sum(complete.cases(data))         # 13797
# sum(data$sex == "", na.rm = TRUE) # 1300 blanks before conversion
# data[data == ""] <- NA
# sum(is.na(data$sex))              # 1300


# ── CHALLENGES ────────────────────────────────────────────────────────────────
# All three can be answered with a single line of R.


## CHALLENGE 1 — Rodents from data_80s
# You already created data_80s. Starting from data_80s (not data),
# write a single line that keeps only Rodent observations.

## SOLUTION C1
# data_rodent_80s_v2 <- data_80s[data_80s$taxa == "Rodent", ]
# nrow(data_rodent_80s_v2)


## CHALLENGE 2 — Neotoma albigula in 1980, plot 2
# How many rows in the dataset are Neotoma albigula captured in 1980 on plot 2?
# Try both approaches: using genus & species, and using species_id.

## SOLUTION C2
# nrow(data[data$genus == "Neotoma" & data$species == "albigula" &
#             data$year == 1980 & data$plot_id == 2, ])   # 4
#
# nrow(data[data$species_id == "NL" & data$year == 1980 & data$plot_id == 2, ])  # 4


## CHALLENGE 3 — Heaviest individual
# Which single observation has the highest recorded weight?
# Return the ENTIRE row — all 13 columns — in one line.
# Hint: which.max()

## SOLUTION C3
# data[which.max(data$weight), ]
# A male Neotoma albigula (NL), 278 g, captured May 28 1987 in plot 2 — same species as Challenge 2!
