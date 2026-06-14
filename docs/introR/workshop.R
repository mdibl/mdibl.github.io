##############################################################
# Introduction to R & RStudio
# MDIBL Comparative Genomics & Data Science Core
#
# Dataset: Portal Project ecological survey, Arizona 1977–1989
#   data/surveys_complete_77_89.csv
##############################################################


# ── SECTION 1: R as a Calculator ─────────────────────────

# Basic arithmetic
5 + 3
10 - 4
6 * 7
100 / 4

# Order of operations
2 + 3 * 4      # What do you expect?
(2 + 3) * 4   # Parentheses change the order


# ── SECTION 2: Objects ────────────────────────────────────

# Assign values to objects with <-
human_max <- 122.5
dog_max   <- 24
dog_age   <- 8

# Use objects in calculations
dog_age / dog_max * human_max

# Objects can hold text (character strings) too
species_name <- "Neotoma albigula"
species_name

# And logical (TRUE/FALSE) values
is_nocturnal <- TRUE
is_nocturnal


# ── SECTION 3: Vectors ────────────────────────────────────

# c() combines values into a vector
weights <- c(45, 32, 28, 51, 37)
taxa    <- c("Rodent", "Bird", "Rodent", "Rabbit", "Rodent")
caught  <- c(TRUE, FALSE, TRUE, TRUE, FALSE)

# Inspect a vector
length(weights)
class(weights)
class(taxa)
str(caught)

# Indexing: get a specific element
weights[1]       # first element
weights[3]       # third element
weights[c(1, 3)] # first and third
weights[2:4]     # elements 2 through 4

# Exercise: What is the class of this mixed vector?
mixed <- c(1, 2, "three")
class(mixed)
mixed   # What happened to the numbers?


# ── SECTION 4: Loading Data ───────────────────────────────

# read.csv() reads a comma-separated file into a data frame
data <- read.csv("data/surveys_complete_77_89.csv")

# read_csv() from the readr package is faster and handles NAs better
# library(readr)
# data <- read_csv("data/surveys_complete_77_89.csv")


# ── SECTION 5: Exploring a Data Frame ─────────────────────

# Quick overview
str(data)       # structure: column types + sample values
summary(data)   # statistical summary
dim(data)       # rows × columns
nrow(data)
ncol(data)
names(data)     # column names

# First and last rows
head(data)      # first 6 rows
tail(data)      # last 6 rows
head(data, 10)  # first 10 rows

# Open in a spreadsheet-style viewer
View(data)

# Frequency table for a categorical column
table(data$taxa)
hist(data$year)


# ── SECTION 6: Indexing a Data Frame ─────────────────────

# Syntax: dataframe[row, column]

# Access a column by name
data$weight
data[, "weight"]    # same result
data[, 9]           # same, by position (weight is column 9)

# Access specific rows
data[1, ]           # row 1, all columns
data[1:6, ]         # rows 1–6 (same as head())

# Specific cell
data[3, 5]          # row 3, column 5

# Summary of a single column
summary(data$weight)
mean(data$weight, na.rm = TRUE)
median(data$hindfoot_length, na.rm = TRUE)

# Activity: find the summary statistics for just the last 6 rows
# (more than one way to do it!)


# ── SECTION 7: Logical Operators ─────────────────────────

x <- 10
y <- 15
z <- 20

x == y     # equal?
x != y     # not equal?
y > x      # greater than?
z / 2 <= x # less than or equal?

# Combine conditions
x > 5 & y < 20   # AND: both must be TRUE
x == 10 | y == 999  # OR: at least one must be TRUE
!(x == 10)          # NOT


# ── SECTION 8: Logical Vectors ────────────────────────────

x_vec <- c(5, 10, 15, 20)
x_vec > 12              # returns a TRUE/FALSE vector
x_vec[x_vec > 12]       # keep only values where condition is TRUE

# Short exercise: what will this return?
seq_vector <- 1:10
seq_vector[seq_vector >= (y - x)]


# ── SECTION 9: Filtering Data Frames ─────────────────────

# Keep only rows where taxa == "Rodent"
data_rodent <- data[data$taxa == "Rodent", ]
head(data_rodent)
nrow(data_rodent)

# Keep only rows from the 1980s
data_80s <- data[data$year >= 1980 & data$year <= 1989, ]
nrow(data_80s)

# Combine: Rodents from the 1980s
data_rodent_80s <- data[
  data$taxa == "Rodent" &
    data$year >= 1980 &
    data$year <= 1989,
]
nrow(data_rodent_80s)

# which() returns the ROW NUMBERS that match instead of the rows themselves
which(data$year == 1985)
which(data$weight > 100)


# ── SECTION 10: NA Values ─────────────────────────────────

# NA propagates through comparisons
NA > 100    # returns NA, not FALSE

# Detect missing values
is.na(data$weight)
sum(is.na(data$weight))   # how many NAs in weight?
colSums(is.na(data))      # NA count per column

# Rows with any NA
data_nas <- data[!complete.cases(data), ]
nrow(data_nas)

# Blank strings are NOT caught by is.na()
data[data == ""] <- NA    # convert blanks to NA first

# Remove all rows with any NA
data_clean <- na.omit(data)
nrow(data) - nrow(data_clean)  # how many rows were removed?


# ── CHALLENGES ────────────────────────────────────────────

# 1. Write the Rodent filter starting from data_80s instead of data.

# 2. How many rows exist for Neotoma albigula from 1980 in plot #2?

# 3. Which species has the greatest average hindfoot_length?
#    Hint: aggregate(hindfoot_length ~ species_id, data = data, FUN = mean)
