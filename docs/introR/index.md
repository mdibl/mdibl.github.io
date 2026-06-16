# Introduction to R & RStudio

> **Workshop:** ~2 hours hands-on &nbsp;·&nbsp; This page stays open for independent study and office-hours follow-up.

---

!!! info "Learning Objectives"
    By the end of this workshop you will be able to:

    - Navigate the RStudio interface with confidence
    - Create and use objects and vectors in R
    - Load a real dataset into R from a CSV file
    - Explore a data frame using core inspection functions
    - Access specific rows, columns, and cells using `$` and bracket notation
    - Filter data using logical conditions and handle missing values

---

## Launch Your Workspace

This workshop runs entirely in a cloud environment — no software installation required. One click opens a pre-configured RStudio session with all packages installed and the workshop data ready to use.

<div style="margin: 1.2rem 0;">
<a href="https://codespaces.new/mdibl/mdibl.github.io?devcontainer_path=.devcontainer%2Fintro-r%2Fdevcontainer.json" target="_blank">
  <img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" style="height:32px;">
</a>
</div>

!!! warning "First launch takes ~5 minutes"
    The first time the Codespace builds, GitHub installs R packages including the full tidyverse collection. Subsequent launches are instant. Start the build, then read through the "Why R?" section while it runs.

**What you'll see:**

1. GitHub opens a VS Code editor in your browser — this is the Codespace container. You do not need to use VS Code for this workshop.
2. A browser tab for **RStudio** will open automatically at port 8787. No login is required.
3. If RStudio does not open automatically: in VS Code, click the **Ports** tab at the bottom panel, find port `8787`, and click the globe icon to open it in a new tab.

**Getting oriented in RStudio:**

Once RStudio is open, get the workshop files ready:

1. In the **Files** pane (bottom-right), you will see the workshop directory. Click `introR.Rproj` to open the project — this sets your working directory correctly so data paths in the script will resolve.
2. Open `workshop.R` (File → Open File, or click it in the Files pane). This is the script you will work through during the workshop.
3. Run lines by placing your cursor on them and pressing **Ctrl+Enter** (Windows/Linux) or **Cmd+Return** (Mac).

!!! tip "Save your work"
    Press **Ctrl+S** / **Cmd+S** often. At the end of the session, use the **Files** pane → More → Export to download your completed script to your computer before closing the Codespace.

---

## Why R?

!!! abstract "Before reading on..."
    Think about these questions before scrolling to the explanations below:

    1. What tools do you currently use to analyze data? What are their limitations?
    2. If you had to hand your analysis to a collaborator tomorrow, could they reproduce every step exactly?

### What is R?

R is a **statistical programming language** built specifically for data analysis and visualization. It runs on Windows, Mac, Linux, and in the cloud. It is free and open source.

"R" refers to both the language itself and the software that interprets your commands. When you type an instruction, R reads it, executes it, and returns a result.

### What is RStudio?

RStudio is an **Integrated Development Environment (IDE)** — a user-friendly application that wraps around R and makes it easier to write, organize, and run your code. Think of it as a lab bench: R is the science; RStudio is the workbench you use to do it.

!!! note "R ≠ RStudio"
    R can run without RStudio. RStudio cannot run without R. This workshop uses both — R does the computing, RStudio provides the interface.

### Why use R for science?

**Your analysis lives in code, not memory.**
Point-and-click tools (Excel, GraphPad, etc.) require you to remember every menu, every button, every order of operations. In R, every step is a line of code — readable, shareable, and repeatable. Added more samples? Rerun the script. Caught a data error? Fix it once and the whole analysis updates.

**An ecosystem built for science.**
Over 20,000 packages extend base R with tools for statistics, ecology, genomics, machine learning, geographic analysis, and more. The same code that works on a 100-row dataset scales to millions of rows without rewriting anything.

**Publication-quality figures.**
R's `ggplot2` package produces figures that meet the standards of high-impact journals — with full control over every visual element.

**Free, open, and trustworthy.**
No licensing costs. Runs on laptops, HPC clusters, and cloud platforms. Because the code is open source, you can inspect exactly what any function does.

### A Tour of RStudio

RStudio is divided into four panes. Understanding what lives where will save you a lot of confusion.

| Pane | Location | What it does |
|------|----------|--------------|
| **Script Editor** | Top-left | Where you write and save R code. Code here is not run until you explicitly execute it. |
| **Console** | Bottom-left | Where R runs commands and prints output. You can type directly here for quick one-off commands. |
| **Environment / History** | Top-right | Shows every object currently in memory (Environment tab) and every command you have run (History tab). |
| **Files / Plots / Help** | Bottom-right | A file browser, a viewer for plots, and built-in help documentation. |

!!! tip "Running code from the Script Editor"
    Place your cursor anywhere on a line and press **Ctrl+Enter** (Windows) or **Cmd+Return** (Mac) to run that line. Select multiple lines to run them all at once. Output appears in the Console below.

???+ question "Exercise — Get oriented in RStudio"

    Complete these steps to get comfortable with the RStudio interface:

    1. **Create a new script:** File → New File → R Script. A blank editor tab opens.
    2. **Type and run a line:** In the script, type `print("Hello world!")`. Press Ctrl+Enter / Cmd+Return. The result (`[1] "Hello world!"`) appears in the Console.
    3. **Save the script:** File → Save As. Name it `practice.R`. Notice it appears in the Files pane.
    4. **Find the Help tab:** In the bottom-right pane, click the Help tab. Type `print` in the search box and read the documentation that appears.

    ??? success "What to expect"

        - After running `print("Hello world!")`, your Console should show:
          ```
          > print("Hello world!")
          [1] "Hello world!"
          ```
          The `[1]` is R telling you this is the first element of the result — not an error.
        - The script file appears in the Files pane once saved.
        - The Help page for `print` shows the function signature, arguments, and examples. You will use this pattern constantly as you learn R.

---

## Part 1: R as a Calculator & Objects

### R as a Calculator

At its core, R is a calculator. You can type any arithmetic expression and R evaluates it immediately.

```r
# Basic arithmetic
5 + 3       # addition
10 - 4      # subtraction
6 * 7       # multiplication
100 / 4     # division
2 ^ 3       # exponentiation (2 to the power of 3)
17 %% 5     # modulo (remainder after division)
```

Parentheses control order of operations exactly as in math:

```r
2 + 3 * 4    # 14 — multiplication happens first
(2 + 3) * 4  # 20 — parentheses evaluated first
```

???+ question "Exercise 1.1 — Dog years"

    Different species age at different rates. A common way to convert an animal's age into "human-equivalent years" is to use the **lifespan ratio**:

    ```
    human-equivalent age = (animal age / animal max lifespan) × human max lifespan
    ```

    Use these values:

    | | Value |
    |---|---|
    | Human maximum lifespan | 122.5 years |
    | Dog maximum lifespan | 24 years |
    | Dog's current age | 8 years |

    **Using only numbers and arithmetic operators** (no objects yet), type the formula into R and calculate: **how old is an 8-year-old dog in human years?**

    ??? success "Solution"

        ```r
        8 / 24 * 122.5
        ```
        ```
        [1] 40.83333
        ```

        An 8-year-old dog is approximately **41 human years** old.

        Notice that the formula works, but it is hard to read — what does `8` mean? What does `24` represent? If you needed to change the dog's age, you would have to hunt through the expression to find the right number. In the next section we solve this with **objects**.

### Objects: Saving Values for Later

Typing raw numbers is tedious when you want to reuse values across many calculations. **Objects** let you give a value a name and recall it whenever you need it.

Create an object with the **assignment operator** `<-`:

```r
human_max <- 122.5
dog_max   <- 24
dog_age   <- 8
```

After running these lines, check the **Environment pane** (top-right) — you will see all three objects listed with their values.

Now use them:

```r
dog_age / dog_max * human_max
```

```
[1] 40.83333
```

An 8-year-old dog is equivalent to about 41 human years.

!!! tip "Why `<-` and not `=`?"
    R accepts `=` for assignment, but `<-` is the convention almost all R programmers use. The reason: `=` is also used inside function calls to name arguments (e.g., `mean(x, na.rm = TRUE)`). Using `<-` for assignment keeps the two uses visually distinct.

### Object Types

Objects can hold different kinds of data. The three you will encounter most:

| Type | Also called | Example | What it stores |
|------|-------------|---------|----------------|
| `numeric` | double, integer | `42`, `3.14` | Numbers — mathematical operators work here |
| `character` | string | `"Neotoma albigula"` | Text — always wrapped in quotes |
| `logical` | boolean | `TRUE`, `FALSE` | Binary values — the result of any comparison |

```r
# Numeric
body_weight <- 47.3
class(body_weight)   # "numeric"

# Character
species_name <- "Neotoma albigula"
class(species_name)  # "character"

# Logical
is_nocturnal <- TRUE
class(is_nocturnal)  # "logical"
```

**`NA` is a special value** meaning "missing" or "not available". It is not zero, not blank, not `"NA"` — it is R's explicit representation of absent data. Many real datasets contain NAs, and how you handle them matters (we return to this in Part 5).

```r
unknown_weight <- NA
is.na(unknown_weight)  # TRUE
```

### Naming Objects

Object names can be almost anything, but a few rules apply:

- Names are **case-sensitive**: `Weight` and `weight` are different objects
- Names must **start with a letter** (not a number or symbol)
- Use **underscores** to separate words: `body_weight`, not `body.weight` or `bodyWeight` (though all three work)
- Make names **informative**: `dog_age` is better than `x` because it tells you what the value represents

???+ question "Exercise 1.2 — Objects and the dog-years formula"

    Reminder of the formula for converting an animal's age to an equivalent human age is:

    ```
    human-equivalent age = (animal age / animal max lifespan) × human max lifespan
    ```

    Using your existing objects `human_max <- 122.5` and `dog_max <- 24`:

    1. How old is a 3-year-old dog in human years?
    2. How old is a 15-year-old dog in human years?
    3. Make a new object for the maximum lifespan of a cat which is 38, and recalculate both ages.

    ??? success "Solution"

        ```r
        human_max <- 122.5
        dog_max   <- 24

        # 1. 3-year-old dog
        3 / dog_max * human_max    # 15.3125

        # 2. 15-year-old dog
        15 / dog_max * human_max   # 76.5625

        # 3. Same ages, but for a cat (max lifespan = 38 years)
        cat_max <- 38
		3  / cat_max * human_max   # 9.6...
		15 / cat_max * human_max   # 48.3...
        ```

!!! success "Key Points — Objects"
    - Use `<-` to assign a value to a named object.
    - Object names are case-sensitive and should be informative.
    - The three main types are `numeric`, `character`, and `logical`.
    - `NA` represents missing data — it is not zero and not blank.
    - Check the **Environment pane** to see all objects currently in memory.

---

## Part 2: Vectors

So far every object has held a single value. R's real power comes from working on **collections of values** all at once.

### What is a Vector?

A **vector** is an ordered sequence of values of the same type. It is the most fundamental data structure in R — nearly everything else is built from vectors.

Create vectors with `c()`, which stands for "combine":

```r
weights  <- c(45, 32, 28, 51, 37)      # numeric vector
taxa     <- c("Rodent", "Bird", "Rodent", "Rabbit", "Rodent")  # character
captured <- c(TRUE, FALSE, TRUE, TRUE, FALSE)  # logical
```

Each of these creates a vector of five elements.

### Type Coercion

All values in a vector must be the same type. If you mix types, R silently converts everything to the most flexible type that fits — this is called **coercion**.

The hierarchy (from least to most flexible): `logical` → `integer` → `numeric` → `character`

```r
mixed <- c(1, 2, "three")
class(mixed)   # "character"
mixed          # "1"  "2"  "three"  — numbers became strings
```

```r
mixed2 <- c(1, 2, TRUE, FALSE)
class(mixed2)   # "numeric"
mixed2          # 1 2 1 0  — TRUE becomes 1, FALSE becomes 0
```

!!! warning "Silent coercion is a common bug"
    R will not warn you when it coerces values. If your numeric column suddenly becomes character, check whether a stray text value (like `"unknown"` or `"N/A"`) snuck into your data.

### Inspecting Vectors

Three functions give you quick information about any vector:

```r
length(weights)   # number of elements: 5
class(weights)    # data type: "numeric"
str(weights)      # compact summary: num [1:5] 45 32 28 51 37
```

`str()` (structure) is especially useful for complex objects — it tells you the type, dimensions, and the first few values all at once.

### Indexing Vectors

Access specific elements with square brackets `[]`. R uses **1-based indexing** — the first element is at position 1, not 0.

```r
weights[1]        # first element: 45
weights[3]        # third element: 28
weights[c(1, 3)]  # first and third: 45 28
weights[2:4]      # elements 2 through 4: 32 28 51
```

`2:4` creates the integer sequence `2, 3, 4` — a shortcut for `c(2, 3, 4)`.

```r
weights[-1]       # all elements EXCEPT the first: 32 28 51 37
```

???+ question "Exercise 2.1 — Predict the class"

    Before running these in R, predict what `class()` will return for each vector. Then run them to check.

    ```r
    # Vector A
    v_a <- c(1, 2, 3)

    # Vector B
    v_b <- c(1L, 2L, 3L) 
    v_b2 <- as.integer(c(1,2,3))

    # Vector C
    v_c <- c(TRUE, FALSE, TRUE)

    # Vector D
    v_d <- c(1, 2, "three")

    # Vector E
    v_e <- c(TRUE, FALSE, 1, 0)

    # Vector F
    v_f <- c("mouse", "rat", TRUE)
    ```

    ??? success "Solution"

        | Vector | Class | Reason |
        |--------|-------|--------|
        | `v_a` | `"numeric"` | Plain numbers are stored as 64-bit doubles by default |
        | `v_b` / `v_b2` | `"integer"` | `L` suffix and `as.integer()` both produce integer storage |
        | `v_c` | `"logical"` | All logical |
        | `v_d` | `"character"` | One string forces all to character |
        | `v_e` | `"numeric"` | `TRUE`→1, `FALSE`→0; numeric wins over logical |
        | `v_f` | `"character"` | One string forces all to character; `TRUE` becomes `"TRUE"` |

        The coercion hierarchy is: `logical` < `integer` < `numeric` < `character`.

        **Two ways to create an integer vector:**

        ```r
        c(1L, 2L, 3L)         # L suffix at definition
        as.integer(c(1, 2, 3)) # convert an existing numeric vector
        ```

        Both return `"integer"` from `class()`. `as.integer()` is part of a family of type-conversion functions — `as.numeric()`, `as.character()`, `as.logical()` — that let you explicitly change a vector's type. This is useful when a column comes in as the wrong type (e.g., a year read as character that needs to be numeric).

???+ question "Exercise 2.2 — Subsetting"

    Given this vector:
    ```r
    captures <- c(12, 7, 19, 3, 25, 8, 14)
    ```

    Write a single line of R code to extract each of the following:

    1. The fourth element
    2. The first and last elements
    3. Elements 3 through 5
    4. All elements **except** the second

    ??? success "Solution"

        ```r
        captures <- c(12, 7, 19, 3, 25, 8, 14)

        captures[4]          # 3
        captures[c(1, 7)]    # 12 14
        captures[3:5]        # 19 3 25
        captures[-2]         # 12 19 3 25 8 14
        ```

!!! success "Key Points — Vectors"
    - `c()` combines values into a vector. All elements must be the same type.
    - If you mix types, R silently coerces to the most flexible type (`character` wins over everything).
    - Index with `[]`: single position, `c()` for multiple, `:` for ranges, `-` to exclude.
    - `length()`, `class()`, and `str()` are your go-to inspection functions.

---

## Part 3: Loading and Exploring Data

### What is a Data Frame?

A **data frame** is R's representation of a table: rows are observations, columns are variables. Each column is a vector, which means all values in a column share the same type — but different columns can have different types.

The dataset we will use for the rest of the workshop:

**Portal Project Ecological Survey — Southern Arizona, 1977–1989**
A long-running study capturing small mammals across 24 experimental plots. Each row is one captured animal. The file `data/surveys_complete_77_89.csv` contains **16,878 observations** across 13 variables.

| Column | Type | Description |
|--------|------|-------------|
| `record_id` | integer | Unique observation ID |
| `month`, `day`, `year` | integer | Date of capture |
| `plot_id` | integer | Which of the 24 plots |
| `species_id` | character | Two-letter species code |
| `sex` | character | M / F |
| `hindfoot_length` | numeric | Hind foot length in mm |
| `weight` | numeric | Body weight in grams |
| `genus`, `species` | character | Full taxonomic name |
| `taxa` | character | Rodent / Bird / Rabbit / Reptile |
| `plot_type` | character | Experimental treatment applied to the plot |

### Loading Data

`read.csv()` is the base R function for reading comma-separated files into a data frame:

```r
data <- read.csv("data/surveys_complete_77_89.csv")
```

The **file path** tells R where to find the file relative to your working directory. Because you opened `introR.Rproj`, your working directory is the `introR/` folder — so `data/surveys_complete_77_89.csv` means "the file `surveys_complete_77_89.csv` inside the `data/` subfolder."

!!! tip "readr's `read_csv()` — a tidyverse alternative"
    The `readr` package (part of tidyverse, already installed) provides `read_csv()`:

    ```r
    library(readr)
    data <- read_csv("data/surveys_complete_77_89.csv")
    ```

    Key differences from `read.csv()`:

    - Faster for large files
    - Automatically reads blank cells as `NA` (base R reads them as `""`)
    - Displays a column type summary when loading

    Either function works for this workshop. We will use `read.csv()` so all code runs in base R without loading any packages.

### Exploring a Data Frame

Once the data is loaded, resist the temptation to scroll through it. These functions give you a faster, more reliable picture:

```r
str(data)      # structure: column count, types, first few values
```
```
'data.frame':	16878 obs. of  13 variables:
 $ record_id      : int  1 2 3 4 5 6 7 8 9 10 ...
 $ month          : int  7 7 7 7 7 7 7 7 7 7 ...
 $ day            : int  16 16 16 16 16 16 16 16 16 16 ...
 $ year           : int  1977 1977 1977 1977 1977 ...
 ...
```

```r
summary(data)  # min, max, quartiles for numeric; counts for character
dim(data)      # c(16878, 13) — rows × columns
nrow(data)     # 16878
ncol(data)     # 13
names(data)    # column names as a character vector
head(data)     # first 6 rows
tail(data)     # last 6 rows
head(data, 10) # first 10 rows
View(data)     # open spreadsheet-style viewer in RStudio
```

For categorical columns, a frequency table is often more informative than a numeric summary:

```r
table(data$taxa)   # counts per taxa group
hist(data$year)    # quick histogram of collection year
```

???+ question "Exercise 3.1 — Explore the structure"

    Run `str(data)` and `summary(data)` in your script. Before looking up the answers, try to answer these questions from the output alone:

    1. How many columns contain numeric data? How many contain text?
    2. Which column has the most missing values (`NA`)?
    3. What is the range of years in this dataset?

    ??? success "Solution"

        ```r
        str(data)
        summary(data)
        ```

        1. **Numeric columns:** `record_id`, `month`, `day`, `year`, `plot_id`, `hindfoot_length`, `weight` — 7 columns. Text (character) columns: `species_id`, `sex`, `genus`, `species`, `taxa`, `plot_type` — 6 columns.
        2. **Most NAs:** `hindfoot_length` has the most missing values — visible in `summary(data)` as `NA's: <count>`.
        3. **Year range:** `str(data)` shows years starting at 1977; `summary(data)` shows Min = 1977, Max = 1989.

???+ question "Exercise 3.2 — First look at the data"

    Answer these questions using only the exploration functions above (no manual scrolling):

    1. How many rows and columns does the dataset have?
    2. What are the column names?
    3. What taxa are present, and how many observations belong to each?
    4. What is the mean weight across all observations? (Watch out for NAs!)

    ??? success "Solution"

        ```r
        data <- read.csv("data/surveys_complete_77_89.csv")

        # 1. Dimensions
        dim(data)          # 16878 rows, 13 columns
        nrow(data); ncol(data)

        # 2. Column names
        names(data)
        # record_id  month  day  year  plot_id  species_id  sex
        # hindfoot_length  weight  genus  species  taxa  plot_type

        # 3. Taxa counts
        table(data$taxa)
        # Bird    Rabbit    Reptile    Rodent
        #   300        69          4     16148

        # 4. Mean weight — na.rm removes NA values before calculating
        mean(data$weight, na.rm = TRUE)   # ~53.2 grams
        ```

???+ question "Exercise 3.3 — Summary of the last 6 rows"

    Calculate summary statistics for **only the last 6 rows** of the dataset. There is more than one way to do this.

    ??? success "Solution"

        ```r
        # Approach 1: two steps
        last6 <- tail(data)
        summary(last6)

        # Approach 2: one step using nrow()
        summary(data[(nrow(data) - 5):nrow(data), ])

        # Approach 3: indexing directly
        summary(data[16873:16878, ])
        ```

        **Approach 1 is the most readable**. Approach 2 is the most robust — it works even if the number of rows changes. Approach 3 works for now, but won't always work if the data structure changes. Approach 3 is called "hard-coding" and is **not recommended.**

!!! success "Key Points — Loading & Exploring"
    - `read.csv("path")` loads a CSV into a data frame. The path is relative to your working directory.
    - `str()` and `summary()` are the two most useful first-look functions.
    - `head()`, `tail()`, `dim()`, `nrow()`, `ncol()`, `names()`, and `table()` complete the exploration toolkit.
    - `View()` opens a spreadsheet viewer in RStudio — useful for exploration, but never use it inside automated scripts.

---

## Part 4: Indexing Data Frames

Loading the data is only the start. Most analysis requires working with specific subsets: one column, a range of rows, or a particular cell.

### Accessing Columns with `$`

The `$` operator extracts a single column by name and returns it as a vector:

```r
data$weight          # all 16,878 weight values as a numeric vector
data$taxa            # all taxa labels as a character vector
```

Everything you know about vector operations applies to the result — you can pass it directly to `mean()`, `table()`, `hist()`, etc.

### Bracket Notation `[row, column]`

Square brackets give you full control over rows and columns:

```r
data[1, ]      # row 1, all columns
data[, 9]      # all rows, column 9 (weight)
data[3, 5]     # row 3, column 5 — a single cell
data[1:6, ]    # rows 1–6, all columns (same as head())
```

The syntax is always `data[rows, columns]`. Leaving either side blank means "all of them."

You can also index columns by name — often safer than by position:

```r
data[, "weight"]             # same as data$weight
data[, c("genus", "species")]  # two columns by name
```

!!! abstract "Stop and think — why won't `data[16]` work?"
    Try running `data[16]`, `data[16, ]`, and `data[, 16]` in R. What does each return?

    ??? success "Explanation"

        ```r
        > data[16]
        Error in `[.data.frame`(data, 16) : undefined columns selected

        > data[16, ]
           record_id month day year plot_id species_id sex hindfoot_length weight     genus  species   taxa plot_type
        16        16     7  16 1977       4         DM   F              36     NA Dipodomys merriami Rodent   Control

        > data[, 16]
        Error in `[.data.frame`(data, , 16) : undefined columns selected
        ```

        `data` only has 13 columns, so both `data[16]` and `data[, 16]` throw an error — there is no 16th column to select. The comma makes all the difference:

        - `data[16]` — treats the data frame like a list and tries to return column 16; errors because column 16 doesn't exist
        - `data[16, ]` — row 16, all columns ✓ (this is the one that works)
        - `data[, 16]` — all rows, column 16 — same error as `data[16]`

        The syntax `[row, col]` is the correct way to index a data frame. When you omit the comma, R treats it as a column selector, not a row selector.

### Statistics on a Single Column

Once you have a column, the full range of R's statistical functions is available:

```r
summary(data$weight)                       # min, Q1, median, mean, Q3, max
mean(data$weight, na.rm = TRUE)            # mean, ignoring NAs
median(data$hindfoot_length, na.rm = TRUE) # median
min(data$weight, na.rm = TRUE)             # minimum
max(data$weight, na.rm = TRUE)             # maximum
```

The `na.rm = TRUE` argument tells R to **ignore NA values** before calculating. Without it, any NA in the column returns `NA` as the result — R is being explicit that the answer cannot be known with certainty when data are missing.

```r
mean(c(1, 2, NA, 4))             # NA — missing data present
mean(c(1, 2, NA, 4), na.rm = TRUE)  # 2.333... — NAs excluded
```

???+ question "Exercise 4.1 — Indexing practice"

    Using bracket notation or `$`, answer these questions without `View()`-ing the full dataset:

    1. What are the values in row 100? (all columns)
    2. What is in row 50, column 8?
    3. Extract just the `plot_type` column. How many unique values does it have? (Hint: `unique()`)
    4. What is the median `hindfoot_length`? What about for just the first 2000 observations?

    ??? success "Solution"

        ```r
        # 1. Row 100
        data[100, ]

        # 2. Row 50, column 8 (hindfoot_length)
        data[50, 8]
        # or more readably:
        data[50, "hindfoot_length"]

        # 3. Plot types
        data$plot_type
        unique(data$plot_type)   # 5 unique plot types

        # 4. Median hindfoot_length — full dataset vs. first 2000 rows
        median(data$hindfoot_length, na.rm = TRUE)
        median(data[1:2000, "hindfoot_length"], na.rm = TRUE)
        ```

???+ question "Exercise 4.2 — Investigating the data"

    1. How many samples had a `plot_type` of `"Control"`? (Hint: `table()`)
    2. What was the minimum recorded `hindfoot_length`? What was the first quartile value?
    3. Excluding NA values, what are the minimum and maximum values from the first 2000 observations in the `weight` column?

    ??? success "Solution"

        ```r
        # 1. Control samples
        table(data$plot_type)
        # Control: 7213 samples

        # Or more directly:
        sum(data$plot_type == "Control")

        # 2. Min and Q1 of hindfoot_length
        summary(data$hindfoot_length)
        # Min: 6 mm   1st Qu.: 21 mm

        # 3. Weight range in first 2000 rows (excluding NAs)
        first2000_weight <- data[1:2000, "weight"]
        min(first2000_weight, na.rm = TRUE)   # 4 g
        max(first2000_weight, na.rm = TRUE)   # 239 g
        ```

!!! success "Key Points — Indexing"
    - `data$column` extracts a column as a vector.
    - `data[row, col]` selects by position. Leave either blank for "all."
    - Use column names instead of positions where possible — they are more readable and won't break if columns are reordered.
    - Always use `na.rm = TRUE` with `mean()`, `median()`, `min()`, `max()` to avoid NA propagation.

---

## Part 5: Logical Operators & Filtering

The real power of a programming language over a spreadsheet is the ability to **ask questions of your data** and filter it based on the answers.

### Comparison Operators

Comparison operators test a condition and return `TRUE` or `FALSE`:

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | equal to | `5 == 5` | `TRUE` |
| `!=` | not equal to | `5 != 3` | `TRUE` |
| `>` | greater than | `10 > 7` | `TRUE` |
| `<` | less than | `3 < 1` | `FALSE` |
| `>=` | greater than or equal | `5 >= 5` | `TRUE` |
| `<=` | less than or equal | `4 <= 3` | `FALSE` |

!!! warning "Assignment `<-` vs. comparison `==`"
    This is one of the most common mistakes in R:

    ```r
    x <- 10   # assignment — stores the value 10 in x
    x == 10   # comparison — asks "is x equal to 10?" Returns TRUE
    x = 10    # also assignment (works, but avoid inside function calls)
    ```

    If you write `data[data$taxa = "Rodent", ]` instead of `data[data$taxa == "Rodent", ]`, R will throw an error. Double the equals sign for comparisons.

### Logical Operators

Combine multiple conditions with logical operators:

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `&` | AND — both must be TRUE | `5 > 3 & 10 < 20` | `TRUE` |
| `\|` | OR — at least one must be TRUE | `5 > 10 \| 3 < 4` | `TRUE` |
| `!` | NOT — inverts TRUE/FALSE | `!(5 == 5)` | `FALSE` |

```r
x <- 10
y <- 15

x > 5 & y < 20    # TRUE — both conditions met
x > 5 & y > 20    # FALSE — second condition fails
x > 20 | y < 20   # TRUE — second condition met
!(x == 10)        # FALSE — x IS 10, so !TRUE = FALSE
```

### Logical Vectors

When you apply a comparison to a vector, R tests every element and returns a **logical vector** of the same length:

```r
x_vec <- c(5, 10, 15, 20)
x_vec > 12        # FALSE FALSE  TRUE  TRUE
```

Use the logical vector inside `[]` to keep only the elements where the condition is `TRUE`:

```r
x_vec[x_vec > 12]  # 15 20
```

This is the core mechanism behind all data filtering in R.

### Filtering Data Frames

Apply the same logic to filter rows of a data frame. The pattern is:

```r
data[condition, ]
```

The condition is tested for every row. Rows where it is `TRUE` are kept; rows where it is `FALSE` are dropped.

```r
# Keep only rows where taxa is "Rodent"
data_rodent <- data[data$taxa == "Rodent", ]
nrow(data_rodent)   # 16505

# Keep only observations from the 1980s
data_80s <- data[data$year >= 1980 & data$year <= 1989, ]
nrow(data_80s)

# Combine: Rodents from the 1980s
data_rodent_80s <- data[
  data$taxa == "Rodent" &
    data$year >= 1980 &
    data$year <= 1989,
]
nrow(data_rodent_80s)
```

### `which()` — Row Numbers Instead of Rows

`which()` returns the **positions** (row numbers) where a condition is TRUE, rather than the actual rows:

```r
which(data$year == 1985)    # row numbers for year 1985 observations
which(data$weight > 100)    # row numbers for heavy individuals
```

This is useful when you need to know *where* something is, not just *what* it is.

### Handling NA Values

NAs require special attention in logical operations. Comparing anything to `NA` returns `NA` — not `TRUE` or `FALSE`:

```r
NA > 100    # NA — not FALSE, not TRUE
NA == 5     # NA
5 == NA     # NA
```

This means a filter like `data[data$weight > 100, ]` will include rows where `weight` is `NA` in an unpredictable way. Always check for NAs before filtering.

**Detecting missing values:**

```r
is.na(data$weight)              # logical vector: TRUE where weight is NA
sum(is.na(data$weight))         # count of NAs in weight column
colSums(is.na(data))            # NA count for every column
```

**Rows with any NA:**

```r
data_has_na <- data[!complete.cases(data), ]  # rows where at least one column is NA
nrow(data_has_na)
```

**Blank strings are NOT NAs:**
Base R's `read.csv()` reads blank cells as empty strings `""`, not `NA`. After loading, convert them explicitly:

```r
data[data == ""] <- NA    # replace all blanks with NA
```

**Removing rows with any NA:**

```r
data_clean <- na.omit(data)
nrow(data) - nrow(data_clean)   # how many rows were removed?
```

???+ question "Exercise 5.1 — Filtering practice"

    Using the Portal Project data:

    1. Create a subset containing only observations of **female** animals (`sex == "F"`). How many rows does it have?
    2. Create a subset of observations where `weight` is greater than 50 grams.
    3. Create a subset of **male Rodents** captured in **plot 2**. How many observations?

    ??? success "Solution"

        ```r
        # 1. Female animals
        data_female <- data[data$sex == "F", ]
        nrow(data_female)   # 7318

        # 2. Weight > 50 g (includes some NA rows — see note below)
        data_heavy <- data[!is.na(data$weight) & data$weight > 50, ]
        nrow(data_heavy) # 4254

        # 3. Male Rodents in plot 2
        data_m_rodent_p2 <- data[
          data$sex == "M" &
            data$taxa == "Rodent" &
            data$plot_id == 2,
        ]
        nrow(data_m_rodent_p2) # 529
        ```

        Note on question 2: `data[data$weight > 50, ]` will include rows where `weight` is `NA` (because `NA > 50` is `NA`, not `FALSE`). Adding `!is.na(data$weight) &` ensures NAs are excluded.

???+ question "Exercise 5.2 — NA investigation"

    1. How many observations have a missing `weight`?
    2. How many observations have a missing `hindfoot_length`?
    3. How many rows have **no missing values in any column**? (Use `complete.cases()`)
    4. After replacing blank strings with NA, how many additional NAs appear in the `sex` column?

    ??? success "Solution"

        ```r
        # 1. Missing weights
        sum(is.na(data$weight))           # 1692

        # 2. Missing hindfoot_length
        sum(is.na(data$hindfoot_length))  # 2733

        # 3. Complete rows (no NAs anywhere)
        sum(complete.cases(data))         # 13797

        # 4. Blank strings in sex column
        sum(data$sex == "", na.rm = TRUE)   # count blanks before conversion
        data[data == ""] <- NA
        sum(is.na(data$sex))               # now includes both original NAs and converted blanks
        ```

!!! success "Key Points — Logical Filtering"
    - Comparison operators (`==`, `!=`, `>`, `<`, `>=`, `<=`) return `TRUE`/`FALSE`.
    - `&` (AND) and `|` (OR) combine conditions. `!` inverts them.
    - `data[condition, ]` keeps rows where the condition is `TRUE`.
    - NA propagates through comparisons — always check with `is.na()` before filtering on columns that have missing values.
    - `complete.cases()` identifies rows with no NAs; `na.omit()` removes them.

---

## Challenges

*All three can be answered with a single line of R. Try them before opening the solutions.*

???+ question "Challenge 1 — Rodents from data_80s"

    You already created `data_80s` (observations from 1980–1989). How would you filter `data_80s` to keep only Rodents, using a **single line** that starts from `data_80s`?

    ??? success "Solution"

        ```r
        data_rodent_80s_v2 <- data_80s[data_80s$taxa == "Rodent", ]
        nrow(data_rodent_80s_v2)
        ```

        This is equivalent to the multi-condition filter on `data` from Part 5. When you already have a pre-filtered dataset, you only need to apply the additional condition.

???+ question "Challenge 2 — Neotoma albigula in 1980, plot 2"

    How many rows in the dataset are for *Neotoma albigula* captured in the year 1980 on plot 2?

    ??? success "Solution"

        ```r
        # approach 1: using genus & species
        nrow(data[data$genus == "Neotoma" & data$species == "albigula" &
                    data$year == 1980 & data$plot_id == 2, ])   # 4

        # approach 2: using species_id
        nrow(data[data$species_id == "NL" & data$year == 1980 & data$plot_id == 2, ])   # 4
        ```

???+ question "Challenge 3 — Heaviest individual"

    Which single observation has the highest recorded `weight`? Return the **entire row** — species, location, date, and all — in one line.

    ??? success "Solution"

        ```r
        data[which.max(data$weight), ]
        ```

        ```
          record_id month day year plot_id species_id sex hindfoot_length weight   genus  species   taxa plot_type
          12871     5  28 1987       2         NL   M              32    278 Neotoma albigula Rodent   Control
        ```

        `which.max()` returns the **index** of the largest value. Passing that index to `data[row, ]` retrieves the full row — every column at once. This is the same indexing pattern from Part 4, combined with the `which()` family from Part 5. The heaviest individual (278 g) is a male *Neotoma albigula.*

---

## Workshop Summary

### Key Functions Reference

| Function | What it does | Example |
|----------|-------------|---------|
| `<-` | Assign a value to an object | `x <- 42` |
| `c()` | Combine values into a vector | `c(1, 2, 3)` |
| `class()` | Data type of an object | `class(x)` |
| `length()` | Number of elements | `length(v)` |
| `str()` | Compact structural summary | `str(data)` |
| `read.csv()` | Load a CSV file into a data frame | `read.csv("file.csv")` |
| `head()` / `tail()` | First / last 6 rows | `head(data)` |
| `summary()` | Statistical summary | `summary(data$weight)` |
| `dim()` / `nrow()` / `ncol()` | Data frame dimensions | `dim(data)` |
| `names()` | Column names | `names(data)` |
| `table()` | Frequency counts | `table(data$taxa)` |
| `View()` | Spreadsheet viewer (RStudio only) | `View(data)` |
| `mean()` / `median()` | Arithmetic mean / median | `mean(x, na.rm = TRUE)` |
| `min()` / `max()` | Minimum / maximum | `max(x, na.rm = TRUE)` |
| `is.na()` | Test for missing values | `is.na(data$weight)` |
| `complete.cases()` | Rows with no NAs | `complete.cases(data)` |
| `na.omit()` | Remove rows with any NA | `na.omit(data)` |
| `which()` | Positions where condition is TRUE | `which(x > 10)` |
| `aggregate()` | Summary statistic by group | `aggregate(y ~ x, data, mean)` |
| `unique()` | Unique values in a vector | `unique(data$taxa)` |

### Operators Cheat Sheet

| Operator | Type | Meaning |
|----------|------|---------|
| `<-` | Assignment | Store value in a named object |
| `==` | Comparison | Equal to |
| `!=` | Comparison | Not equal to |
| `>`, `<` | Comparison | Greater / less than |
| `>=`, `<=` | Comparison | Greater / less than or equal |
| `&` | Logical | AND — both conditions must be TRUE |
| `\|` | Logical | OR — at least one condition must be TRUE |
| `!` | Logical | NOT — inverts TRUE/FALSE |
| `[]` | Indexing | Select elements by position or condition |
| `$` | Indexing | Access a data frame column by name |
| `:` | Sequence | Integer range, e.g. `1:10` |

### Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Using `=` instead of `==` in a filter | `data[data$taxa == "Rodent", ]` not `= "Rodent"` |
| Forgetting `na.rm = TRUE` in `mean()`, `max()`, etc. | Always add `na.rm = TRUE` for numeric summaries |
| Missing the comma in `data[row, col]` | `data[1, ]` for row 1; never `data[1]` |
| Assuming blank strings are NA | Run `data[data == ""] <- NA` after loading with `read.csv()` |
| Filtering on a column that has NAs | Add `!is.na(data$col) &` before the condition |

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
