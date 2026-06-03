# Data Organization in Spreadsheets

> **Workshop:** ~90 minutes hands-on &nbsp;·&nbsp; This page stays open for independent study and office-hours follow-up.

---

!!! info "Learning Objectives"
    By the end of this workshop you will be able to:

    - Explain why raw data should never be directly edited
    - Identify the cardinal rules of spreadsheet structure
    - Recognize and fix at least six common spreadsheet mistakes
    - Create a data dictionary to document your dataset
    - Export cleaned data in a portable, software-independent format

---

## Why Good Data Organization Matters

Good data organization is the foundation of any research project. Messy or poorly structured data makes every downstream step — data wrangling, statistical analysis, bioinformatics pipelines — much harder than it needs to be.

Consider how scientists typically spend their time on a project: a surprisingly large portion goes to **data preparation and cleaning**, not analysis. Organizing data well at the start reduces that burden dramatically and pays dividends every time someone opens the file — including future-you.

Organized data also improves:

- **Reproducibility** — anyone can open your file and understand it without asking you
- **Collaboration** — teammates and analysts can use your data without guessing what columns mean
- **Transparency** — reviewers and repositories can verify your results

**The single biggest mistake** researchers make with spreadsheets is treating them like a lab notebook — relying on margin notes, visual spacing, color highlighting, or merged cells to convey meaning. These cues make perfect sense to a human reader, but computers are completely literal. They cannot interpret merged cells, colored text, or visual spacing. Whatever information exists only as formatting will be silently lost the moment the file is imported into any analysis tool.

---

## What Are Spreadsheets?

"Spreadsheet" is broader than "Excel file." Any tabular data file that can be opened in a spreadsheet program qualifies — including plain-text formats:

| Format | Extension | Notes |
|--------|-----------|-------|
| Excel Workbook | `.xlsx`, `.xls` | Proprietary; not ideal for long-term storage |
| OpenDocument Spreadsheet | `.ods` | Open-source equivalent |
| Comma-Separated Values | `.csv` | Plain text; universally readable |
| Tab-Separated Values | `.tsv`, `.txt` | Plain text; universally readable |

Spreadsheet programs are useful for data entry, organizing records, sorting, and basic visualization. This workshop covers **none** of those advanced features — we are focused entirely on how to structure the underlying data so it can be used by any tool, any collaborator, and any analysis pipeline.

!!! note "What this workshop does not cover"
    Statistics, plotting, formulas, and scripting inside spreadsheet programs. Once your data is clean and well-organized, those tasks are better handled in dedicated tools like R or Python — which we cover in later courses in this series.

---

## The Cardinal Rules

Every decision you make about your spreadsheet structure should flow from three rules. Internalize these and the rest of the workshop follows naturally.

<div class="grid" markdown>

<div markdown>

**Columns = Variables**

Each column holds one type of measurement or attribute — weight, species, sex, date. Every row in that column contains the same kind of value.

</div>

<div markdown>

**Rows = Observations**

Each row records a single, complete observation — one captured animal, one experimental sample, one survey event. Do not place multiple observations in one row.

</div>

<div markdown>

**Cells = Data**

Each cell contains exactly one value. No units attached to numbers, no notes embedded in cells, no two pieces of information separated by a slash.

</div>

</div>

---

???+ question "Exercise — What is the problem with this data format?"
    A field technician recorded the following survey data. Look at the columns carefully before reading on.

    | Date Collected | Plot | Species_Sex | Weight (g) |
    |---------------|------|-------------|-----------|
    | 7/16/2013 | 1 | DMM | 29 |
    | 7/16/2013 | 2 | DMF | 40 |
    | 7/18/2013 | 7 | DMM | 33 |
    | 8/19/2013 | 8 | DOF | 52 |

    ??? success "Solution - part 1"
        
        The `Species_Sex` column combines the species code and sex code into a single value: `DMM` means species `DM`, sex `M` (male); `DOF` means species `DO`, sex `F` (female). 
        **Which cardinal rule does this violate, and how would you fix it?**
        
    ??? success "Solution - part 2"
    
        The `Species_Sex` column violates **Cells = Data** — one cell should hold exactly one value. By merging species and sex, you lose the ability to filter, sort, or analyze either variable on its own without writing a fragile parsing formula.

        The fix is to split the column into two, one variable each:

        | Date Collected | Plot | Species | Sex | Weight (g) |
        |---------------|------|---------|-----|-----------|
        | 7/16/2013 | 1 | DM | M | 29 |
        | 7/16/2013 | 2 | DM | F | 40 |
        | 7/18/2013 | 7 | DM | M | 33 |
        | 8/19/2013 | 8 | DO | F | 52 |

        This table is **tidy data**: columns = variables, rows = observations, cells = data. Any software can now import, filter, or analyze species and sex independently — no parsing required.

---

## The Dataset

This workshop uses real ecological survey data from the **Portal Project**, a decades-long study tracking small mammal populations in the Chihuahuan Desert of New Mexico and Arizona. Researchers set live traps across 24 experimental plots and recorded each captured animal's species, sex, and weight.

You will work with one file to start:

[:fontawesome-solid-file-excel: Download Messy Data](survey_data_messy.xlsx){ .md-button .md-button--primary }

### Protect Your Raw Data

Before you touch the data, there is one non-negotiable rule: **never edit your original file.**

Duplicate `survey_data_messy.xlsx` and rename the copy `survey_data_clean.xlsx`. All of your work happens in the copy — the original stays closed.

```
survey_data_messy.xlsx    ← original; close it, never open it again
survey_data_clean.xlsx    ← working copy; all edits happen here
```

!!! tip "Name your working copy clearly"
    Use a suffix like `_clean`, `_working`, or today's date. Avoid `_final`, `_final2`, `_FINAL_v3` — those names always lie.

**Keeping track of your changes:** Document every cleaning step like a lab procedure. Keep a plain-text file (e.g., `cleaning_notes.txt`) in the same folder as your data and write down what you changed and why. This makes your work reproducible and helps any future collaborator understand what happened to the original file.

```
# cleaning_notes.txt
2024-11-01
- Made working copy: survey_data_clean.xlsx
- Removed blank rows separating tables in 2013 tab
- Renamed column M/F → Sex
...
```

!!! success "Key Points"
    - Never edit your original data file.
    - Work only on a named copy.
    - Keep a plain-text log of every change you make.


### Reference Files

The dataset uses two-letter shorthand codes for species and integer IDs for plots. Keep these open alongside your spreadsheet while you work:

=== "Species Codes (excerpt)"

    | ID | Genus | Species | Taxa |
    |----|-------|---------|------|
    | DM | *Dipodomys* | *merriami* | Rodent |
    | DO | *Dipodomys* | *ordii* | Rodent |
    | DS | *Dipodomys* | *spectabilis* | Rodent |
    | OL | *Onychomys* | *leucogaster* | Rodent |
    | OT | *Onychomys* | *torridus* | Rodent |
    | PE | *Peromyscus* | *eremicus* | Rodent |
    | PF | *Perognathus* | *flavus* | Rodent |
    | PM | *Peromyscus* | *maniculatus* | Rodent |

    [:fontawesome-solid-file-csv: Full Species List](species.csv){ .md-button }

=== "Plot Types (excerpt)"

    | Plot ID | Type |
    |---------|------|
    | 1 | Spectab exclosure |
    | 2 | Control |
    | 3 | Long-term Krat Exclosure |
    | 4 | Control |
    | 5 | Rodent Exclosure |
    | 6 | Short-term Krat Exclosure |

    [:fontawesome-solid-file-csv: Full Plot List](plots.csv){ .md-button }

---

## Your Task

!!! abstract ":material-timer-outline: 10–15 minutes — Give it a try before scrolling further"
    Open `survey_data_clean.xlsx` and **clean and combine the two tabs into one consistent, analysis-ready dataset.**

    The file has two tabs — **2013** and **2014** — each recorded by a different field assistant. Your goal is a single flat table where every row is one observation and every column holds one variable.

    Keep the reference files (species codes, plot types) open alongside your spreadsheet as you work.

    **Don't aim for perfection on the first pass.** The goal is to notice problems and think through how you might fix them. We will work through each one together below.

---

## Cleaning Steps — Walkthrough

*After your initial attempt, the steps below explain each problem you likely encountered and the reasoning behind every fix. If you are working through this independently, follow along step by step.*

| Section | Topic | Theme |
|---------|-------|-------|
| [Step 1](#step-1-one-table-per-sheet) | One table per sheet | Formatting Data Tables |
| [Steps 2–4](#step-2-one-piece-of-information-per-cell) | Cell and column hygiene | Common Spreadsheet Errors |
| [Steps 5–6](#step-5-never-encode-data-in-formatting) | Formatting and comments | Common Spreadsheet Errors |
| [Steps 7–8](#step-7-represent-missing-data-consistently) | Missing values and dates | Common Spreadsheet Errors |
| [Step 9](#step-9-quality-control) | Checking for errors | Quality Control |
| [Metadata](#metadata) | Documenting your data | Metadata |
| [Export](#exporting-your-data) | Saving in open formats | Exporting Data |

---

## Step 1: One Table Per Sheet

!!! abstract "Before reading on..."
    - Notice the two tabs on the spreadsheet. 
    - Does the 2013 tab follow the cardinal rules? What about the 2014 tab? 
    - What (if any) schema is being used to record data currently? 

**The problem:** Open the **2013** tab. Instead of one flat table, you will find **three sub-tables laid out side by side across the columns**, with blank columns separating them. Look at the first three rows:

- Row 3: A title — "2013 Field Season"
- Row 6: Sub-table labels — **"Species: DM"**, **"Species: DO"**, **"Species: DS"**
- Row 7: Each sub-table's own header row — Date Collected, Plot, M/F (or Sex), Weight

```
        | Species: DM                      |   | Species: DO                   |   | Species: DS
Row 7:  | Date Collected | Plot | M/F | Wt |   | Date Collected | Plot | Sex | Wt |   | Date Collected | Plot | Sex    | Wt
Row 8:  | 7/16/2013      |  2   |  F  |  0 |   | 8/19/2013      |  8   |  F  | 52 |   | 11/12/2013     |  9   | Female | 117
Row 9:  | 7/16/2013      |  7   |  M  | 33g|   | 10/17/2013     |  3   |  F  | 33 |   | 11/12/2013     |  1   | Female | 121
```

Crucially, **none of the three sub-tables has a Species column** — the species identity lives only in the row 6 label above the table. The same side-by-side layout applies to the **2014** tab, which has sub-tables labeled Plot 1, Plot 2, and Plot 3 across the top — none with a Plot column — and a separate Plot 4 section below with entirely different column names (`species_sex`, `wgt`).

**Why this breaks things:** When software imports the spreadsheet row by row, it reads each row as one observation. Row 8 above contains data from two different animals in two different sub-tables — the software has no way to distinguish them, and they become one garbled record. Worse, because the species identity only exists in a label cell above the data and not in any column, it is permanently lost on import. The computer cannot read the label and infer what species each row belongs to.

**The fix:** For each sub-table, add a column for the variable that differentiates it, then stack all sub-tables vertically into one flat table.

???+ question "Exercise 1.1 — 2013: Add a `Species` column and stack the 2013 sub-tables"
    1. In the **2013** tab, identify which columns belong to the DM sub-table, which to DO, and which to DS.
    2. In each sub-table, insert a new column labeled `Species` and fill every data row with the appropriate code (DM, DO, or DS).
    3. Copy all data rows from the DO and DS sub-tables.
    4. Paste them below the DM data rows, aligning columns so the same type of information sits in the same column.
    5. Delete the original side-by-side layout once all rows are stacked.

    ??? success "Solution"

        === "Before"

			| Date | Plot | M/F | Weight | (blank) | Date | Plot | Sex | Wt | (blank) | Date | Plot | Sex | Weight |
			|------|------|-----|--------|---------|------|------|-----|----|---------|------|------|-----|--------|
			| 7/16/2013 | 2 | F | 0 | | 8/19/2013 | 8 | F | 52 | | 11/12/2013 | 9 | Female | 117 |
			| 7/16/2013 | 7 | M | 33g | | 10/17/2013 | 3 | F | 33 | | 11/12/2013 | 1 | Female | 121 |
			
			***Switch view to see After***

        === "After"

			| Date_Collected | Plot | M/F | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 7/16/2013 | 2 | F | 0 | DM |
			| 7/16/2013 | 7 | M | 33g | DM |
			| 8/19/2013 | 8 | F | 52 | DO |
			| 10/17/2013 | 3 | F | 33 | DO |
			| 11/12/2013 | 9 | Female | 117 | DS |
			| 11/12/2013 | 1 | Female | 121 | DS |
	
			The 2013 tab now has one flat table with columns: Date Collected, Plot, M/F (or Sex), Weight, Species. Each row has a species code. There are no side-by-side sections remaining.
			
			*This step fixes only the side-by-side layout. There are still many more fixes to be done in subsequent steps.*

???+ question "Exercise 1.2 — 2014: Add a `Plot` column and stack the 2014 sub-tables"
    Repeat the same process for the **2014** tab. Plots 1–3 are side by side at the top; Plot 4 is in a separate section below. Add a `Plot` column to each sub-table and stack all four.

    **Note:** Plot 4 uses different column names (`species_sex`, `wgt`) — add the Plot column and stack, but fix the column names in the next steps.

    ??? success "Solution"

        === "Before (side-by-side layout in 2014 tab)"

			| Plot 1  | | | | Plot 2  | | | | Plot 3  | | |
			|---|---|---|---|---|---|---|---|---|---|---|
			| Date collected | Sex | Weight | | Date collected | Sex | Weight | | Date collected | Sex | Weight |
			| 1/8/2014 | M | 44 | | 1/8/2014 | F | 37 | | 3/11/2014 | M | 29 |
	
			*(Plot 4 is in a separate section below with `species_sex` and `wgt` columns.)*
			
			***Switch view to see After***

        === "After (stacked with Plot column):"

			| Date_Collected | Plot | Sex | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 1/8/2014 | 1 | M | 44 | DM |
			| 1/8/2014 | 2 | F | 37 | DM |
			| 3/11/2025 | 3 | M | 29 | DM |
			| 1/8/1978 | 4 | (from species_sex) | (from wgt) | (from species_sex) |
	
			The 2014 tab now has one flat table with a `Plot` column and all four plots' data stacked vertically under one header row. The wrong years (2025, 1978) and the `species_sex`/`wgt` column issues are still present — those are fixed in later steps.

???+ question "Check Your Understanding"
    Why can't you just copy and paste the sub-tables together without first adding a Species or Plot column?

    ??? success "Answer"
        Because the species or plot identity exists only in the label above each sub-table, not as a column value in the data. Once you stack the rows, there is no way to tell which species or plot each row came from — that information would be permanently lost. You must add the column first to preserve it.

!!! success "Key Points"
    - Side-by-side sub-tables are just as problematic as stacked ones — both break every analysis tool.
    - When a variable (species, plot, year) separates sub-tables, add it as a column in each sub-table before combining.
    - After stacking, verify that the same type of data sits in the same column across all rows.

!!! tip "Freeze the header row"
    After combining into one table, freeze the top row so column names stay visible as you scroll: **View → Freeze Top Row**.

---

## Step 2: One Piece of Information Per Cell

!!! abstract "Before reading on..."
    - Look at the columns in the Plot 4 rows of your 2014 tab. 
    - Do they line up with the columns above? 
    - What does `DM_F` mean?
    - How would software distinguish the species code from the sex code inside `DM_F`?

**The problem:** After stacking the 2014 sub-tables in Step 1, Plot 4's data has a column named `species_sex` that combines the species code and sex code into one value:

| Date collected | Plot | species_sex | wgt |
|---------------|------|-------------|-----|
| 1/8/1978 | 4 | DM_F | 37 |
| 1/8/1978 | 4 | DM_F | 42 |
| 1/8/1978 | 4 | DM_M | 37 |
| 1/8/1978 | 4 | DS_F | 128 |

`DM_F` means species DM, sex F (female). `DM_M` means species DM, sex M (male).

 *The 1978 dates are also wrong, which is a date problem addressed in Step 8. The column name `wgt` is a field-naming problem addressed in Step 3.*

**Why this breaks things:** You cannot filter by species alone or by sex alone. Extracting either value requires a parsing formula — fragile, invisible to collaborators, and impossible to apply consistently if the format ever varies.

**The fix:** Split the `species_sex` column into two separate columns.

???+ question "Exercise 2.1 — Split species_sex"
    1. In the **2014** tab, find the `species_sex` column in the Plot 4 rows.
    2. Insert two new blank columns to its right: `Species` and `Sex`.
    3. Use **Data → Text to Columns** (delimited by `_`) to split the values — species code lands in the first column, sex code in the second.
    4. Verify the split, then delete the original `species_sex` column.

    **Note:** After merging tabs in Step 4, these two columns must sit in the same positions as the 2013 data.

    ??? success "Solution"

        === "Before"

			| Date collected | Plot | species_sex | wgt |
			|---------------|------|-------------|-----|
			| 1/8/1978 | 4 | DM_F | 37 |
			| 1/8/1978 | 4 | DM_M | 37 |
			| 1/8/1978 | 4 | DS_F | 128 |
			
			***Switch view to see After***

        === "After"

			| Date collected | Plot | Species | Sex | wgt |
			|---------------|------|---------|-----|-----|
			| 1/8/1978 | 4 | DM | F | 37 |
			| 1/8/1978 | 4 | DM | M | 37 |
			| 1/8/1978 | 4 | DS | F | 128 |
	
			Each row that had `DM_F` now has `DM` in the Species column and `F` in the Sex column. 
			
			*The 1978 dates are still wrong, which is a date problem addressed in Step 8.*
			
			*The column name `wgt` is still a field-naming problem addressed in Step 3.*

???+ question "Check Your Understanding"
    A student records GPS coordinates as `"44.3N, 68.2W"` in one cell. What should they do instead?

    ??? success "Answer"
        Split into two columns: `Latitude` (44.3) and `Longitude` (-68.2). Use signed decimal degrees (negative for West/South) so the values are numbers rather than strings, making any geographic calculation straightforward.


!!! success "Key Points"
    - Each cell holds exactly one value.
    - Never use delimiters inside a cell to encode two things at once.
    - If a column name contains "and" or `/`, it almost certainly violates this rule.

!!! tip "One variable, one column — always"
    If you find yourself putting a separator character (`_`, `/`, `;`) inside a cell to pack two things together, that is a sign you need another column.

---

## Step 3: Write Clean Field Names

!!! abstract "Before reading on..."
    - Flip back and forth between spreadsheet tabs side by side and compare column headers. Notice any differences? 
    - Are `Date Collected` and `Date collected` the same column name to a computer?

**The problem:** After combining the sub-tables, the dataset has several field-name problems — and they are not all in the same places. Each sub-table was entered by a different person, so inconsistencies crept in:

- **2013 DM sub-table:** uses `M/F` for the sex column (special character; ambiguous)
- **2013 DO and DS sub-tables:** use `Sex` — different from the DM sub-table in the same tab
- **All sub-tables:** use `Date Collected` or `Date collected` (space; inconsistent capitalization across tabs)
- **2014 Plot 4:** uses `wgt` instead of `Weight` (abbreviation; doesn't match other sub-tables)

This means the same piece of information has three different names across the combined dataset — `M/F`, `Sex`, and (implicitly after splitting) `Sex` from Plot 4. Before stacking any rows, all column names must match exactly.

**Why this breaks things:** Spaces in column names must be quoted in every programming language. Special characters cause syntax errors. Inconsistent naming (`M/F` vs `Sex`) means software treats them as different columns, splitting data that belongs together.

**The rules for good field names:**

| Rule | Bad | Good |
|------|-----|------|
| No spaces | `Date Collected` | `Date_Collected` |
| No special characters | `M/F` | `Sex` |
| Descriptive | `wgt`, `col1` | `Weight` |
| No leading numbers | `2023_count` | `count_2023` |
| Consistent style | `PlotID`, `sex`, `WEIGHT` | `plot_id`, `sex`, `weight` |

!!! note "Underscores vs. CamelCase"
    Both `date_collected` and `DateCollected` are acceptable — pick one style and apply it everywhere in the file.

**The fix:** Rename fields to appropriate names.

???+ question "Exercise 3.1 — Fix the field names"
	| Old Name | Where | New Name | Reason |
	|----------|-------|----------|--------|
	| `M/F` | 2013 DM sub-table | `Sex` | Matches the other sub-tables; no special character |
	| `Date Collected` / `Date collected` | All sub-tables | `Date_Collected` | No space; consistent casing across all tables |
	| `wgt` | 2014 Plot 4 | `Weight` | Descriptive; matches every other sub-table |


    1. In the stacked **2013** data, rename `M/F` → `Sex` and `Date Collected` → `Date_Collected`.
    2. In the stacked **2014** data, rename `Date collected` → `Date_Collected` and `wgt` → `Weight`.
    3. Scan every header in both tabs for any remaining spaces, special characters, or abbreviations.

    ??? success "Solution"

        === "Before (sample headers):"

			| 2013 tab | 2014 tab |
			|----------|----------|
			| `Date Collected`, `M/F`, `Weight` | `Date collected`, `Sex`, `wgt` |
			
			***Switch view to see After***

        === "After (both tabs):"

			| 2013 tab | 2014 tab |
			|----------|----------|
			| `Date_Collected`, `Sex`, `Weight` | `Date_Collected`, `Sex`, `Weight` |

			Both tabs should now have identical headers: `Date_Collected | Plot | Sex | Weight | Species`. There are no remaining spaces or symbols in any column name. The two tabs are still separate — they are merged in Step 4.

???+ question "Check Your Understanding"
    Which of these column names are problematic?

    - `sample_id`
    - `% GC Content`
    - `Time (hours)`
    - `replicate`
    - `2023_weight`
    - `gene name`

    ??? success "Answer"
        Problematic: `% GC Content` (space + `%`), `Time (hours)` (space + parentheses), `2023_weight` (starts with number), `gene name` (space).

        Fixed: `pct_gc_content`, `time_hours`, `weight_2023`, `gene_name`.

!!! success "Key Points"
    - Column names: lowercase, underscores instead of spaces, only letters/numbers/underscores.
    - Names should be descriptive enough to understand without a lookup.
    - Apply the same convention to every column in the file.

---

## Step 4: Consolidate Data Across Tabs

!!! abstract "Before reading on..."
    - Look at the column order in both tabs. If you copy the 2014 rows and paste them directly below the 2013 data, what could go wrong?
    - Can you apply a filter across both tabs at once, or do you have to do it separately for each tab?

**The problem:** Your working file has two tabs: **2013** and **2014**. Splitting records across tabs by year (or batch, or site) is common, and it creates chronic headaches downstream.

**Why this breaks things:** Most analysis tools load one table at a time. Every analysis that needs both years requires extra code or manual pre-processing. The two tabs can also silently drift apart in column order or naming over time, causing misaligned data when they are eventually combined.

**The fix:** Stack the two tables into one sheet.

???+ question "Exercise 4.1 — Align and merge the tabs"
    1. Compare the column order in both tabs side by side.
    2. Reorder the **2014** columns to match **2013** exactly.
    3. Copy all data rows (not the header) from the **2014** tab.
    4. Paste below the last data row in the **2013** tab.
    5. Rename the tab (e.g., `AllData`).
    6. Delete the now-empty **2014** tab.

    ??? success "Solution"

        === "Before merging — 2014 tab column order (wrong):"

            | Date_Collected | Species | Sex | Weight | Plot |
			|---------------|------|---------|-----|--------|
			| 1/9/2014 | DM | M | 40 | 1 |
			| 1/29/2014 | DM | F | 36| 1 |
			
			***Switch view to see After***
			
        === "After reordering and merging — AllData tab:"

            | Date_Collected | Plot | Sex | Weight | Species |
            |----------------|------|-----|--------|---------|
            | 7/16/2013 | 2 | F | 0 | DM |
			| 7/16/2013 | 7 | M | 33g | DM |
			| 8/19/2013 | 8 | F | 52 | DO |
			| 11/12/2013 | 9 | Female | 117 | DS |
			| 1/9/2014 | 1 | M | 40 | DM |
			| 1/29/2014 | 1 | F | 36 | DM |

			One header row, then all 2013 rows, then all 2014 rows in a single tab.
	
			*The wrong dates (2025, 1978), the `33g` weight values, `0` weights, `Female`/`Male` in Sex, and calibration notes are still present — those are cleaned in Steps 5–9.*


???+ question "Check Your Understanding"
    You are combining three experiment batches. Batch A: `Sample | Treatment | OD600`. Batch B: `Sample | OD600 | Treatment`. Batch C: `Sample | Treatment | OD_600`. What must happen before stacking?

    ??? success "Answer"
        Two issues: (1) Batch B has columns in a different order — reorder so `Treatment` precedes `OD600`. (2) Batch C uses `OD_600` instead of `OD600` — standardize the name. Only then is it safe to stack.

!!! success "Key Points"
    - Keep one table per file; avoid splitting related records across multiple sheets.
    - Before stacking, verify column names and positions are identical across all sources.
    - Identifying information (year, batch, site) must be a column value — tab names are lost when you combine sheets.

!!! tip "Always verify column order before stacking"
    Mismatched column order is one of the most common and hardest-to-catch mistakes in combining datasets. Compare headers side by side before copying any rows.

---

## Step 5: Never Encode Data in Formatting

!!! abstract "Before reading on..."
    - Look at the 2013 DS rows and the 2014 rows. Is the calibration issue recorded the same way in both?
    - If you export this as a CSV and open again, would the gray cell shading be preserved?
    - How would a collaborator know which records weren't calibrated if they only received the CSV file?

**The problem:** In the messy file, calibration status is communicated in two different ways by two different field assistants — and neither is stored as a real data value:

1. **2013 DS sub-table:** Calibration notes are embedded as text inside the weight cells themselves: `"132 (scale not calibrated)"`, `"113 (scale not callibtrated)"` *(note the typo — another reason free-text in cells is fragile)*.
2. **2014 (Plots 1–3):** A note reads *"gray cell means my measurement device wasn't calibrated correctly"* — the uncalibrated records are marked only by cell shading.

Both are real, scientifically important pieces of information. Neither can be read by any analysis tool.

**Why this breaks things:** Cell color is invisible on import and is lost when copying. Text embedded in a numeric cell turns that cell into a string, breaking every sum and average. The meaning of either convention is undocumented unless you happen to notice the note or the coloring — a new collaborator would have no idea. And because the two field assistants used *different* conventions, you must hunt through the whole dataset to find all uncalibrated records.

Other common formatting traps:

- **Bold** text to flag outliers
- **Italic** to indicate estimated values
- **Merged cells** spanning a group label

**The fix:** Add a `Calibrated` column with values `Y` (scale was zeroed) or `N` (not zeroed). 

???+ question "Exercise 5.1 — Add the Calibrated column"
    1. Add a new column called `Calibrated` to the right of `Weight`.
    2. For every row where weight has a calibration note embedded in the cell, enter `N`.
    3. For every row with gray cell shading indicating a calibration issue, enter `N`.
    4. For every other row, enter `Y`.
    5. Clear all cell colors: select all cells → **Home → Fill Color → No Fill**. (Leave the note text in the weight cells for now — that is cleaned in Step 6.)

    **Reference:** The final cleaned dataset has exactly **4 rows** with `N` in `Calibrated`.

    ??? success "Solution"

        === "Before (messy)"
	
			| Date_Collected | Plot | Sex | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 11/13/2013 | 14 | Female | `113 (scale not callibtrated)` | DS |
			| 11/13/2013 | 17 | Male | `132 (scale not calibrated)` | DS |
			| 1/8/2014 | 2 | M | 157 (gray fill) | DS |
			| 7/16/2013 | 2 | F | 0 | DM |
		
		=== "After (Calibrated column added, colors cleared)"
	
			| Date_Collected | Plot | Sex | Weight | Species | Calibrated |
			|---------------|------|-----|--------|---------|-----------|
			| 11/13/2013 | 14 | Female | `113 (scale not callibtrated)` | DS | N |
			| 11/13/2013 | 17 | Male | `132 (scale not calibrated)` | DS | N |
			| 1/8/2014 | 2 | M | 157 | DS | N |
			| 7/16/2013 | 2 | F | 0 | DM | Y |
		
			*The calibration notes (`132 (scale not calibrated)`) are still in the Weight cells — those are removed in Step 6. `0` weights, wrong dates, and `Female`/`Male` in Sex are cleaned in Steps 6–9.*
	
	
			Filter `Calibrated` for `N` — you should see exactly 4 rows, all `DS` records. The calibration notes in the Weight cells are still present (cleaned in Step 6). All cell coloring has been removed.

???+ question "Check Your Understanding"
    A researcher uses **bold font** in a species count spreadsheet to flag "species of special concern." Is this acceptable?

    ??? success "Answer"
        Not acceptable. Bold formatting is invisible on import and cannot be filtered or counted. They should add a `special_concern` column with `Y`/`N` and document what it means.

!!! success "Key Points"
    - Formatting (color, bold, italics, merged cells) is invisible to analysis tools and silently dropped on import.
    - Every piece of information that affects interpretation must live in a cell as a real value.

---

## Step 6: Keep Cells Free of Comments and Units

!!! abstract "Before reading on..."
    - Select the Weight column and look at Excel's status bar at the bottom — does it show a Sum?
    - Click on a `33g` cell: what data type does Excel show?
    - Try summing the first 10 rows of the Weight column — does it include all the values you expect?

**The problem:** Two issues remain in the `Weight` column, both from the **2013** data:

1. **Units embedded in cells (2013 DM sub-table):** Weights were entered with a `g` suffix — `33g`, `40g`, `48g`, etc. This makes every value a text string.
2. **Calibration notes embedded in cells (2013 DS sub-table):** Two weight cells contain the value plus a parenthetical note — `"132 (scale not calibrated)"`, `"113 (scale not callibtrated)"`. These are also text strings, not numbers.

The calibration status is now tracked in the `Calibrated` column from Step 5. The notes in the weight cells are redundant and need to be removed so the column is purely numeric.

**Why this breaks things:** `33g` is a text string, not a number. Excel will not sum it, and R/Python will import it as missing. Once any cell in a column is text, software may treat the entire column as text — silently discarding it from any numerical analysis.

**The fix:** Remove embedded notes and units

???+ question "Exercise 6.1 — Clean the Weight column"
    1. Select the `Weight` column only.
    2. Use **Ctrl+H** (Find & Replace): find `g` and replace with nothing to strip the unit suffix from the DM rows.
    3. For the DS rows with embedded calibration notes, delete everything after the number — leave only the integer value.
    4. Confirm those rows already have `N` in the `Calibrated` column.
    5. Verify the entire `Weight` column contains only numbers or empty cells — no text.

    ??? success "Solution"

        === "Before (messy)"

			| Date_Collected | Plot | Sex | Weight | Species | Calibrated |
			|---------------|------|-----|--------|---------|-----------|
			| 7/16/2013 | 7 | M | 33g | DM | Y |
			| 7/16/2013 | 2 | F | 40g | DM | Y |
			| 11/13/2013 | 14 | Female | 113 (scale not callibtrated) | DS | N |
			| 11/13/2013 | 17 | Male | 132 (scale not calibrated) | DS | N |
		
		=== "After (Weight column cleaned)"
		
			| Date_Collected | Plot | Sex | Weight | Species | Calibrated |
			|---------------|------|-----|--------|---------|-----------|
			| 7/16/2013 | 7 | M | 33 | DM | Y |
			| 7/16/2013 | 2 | F | 40 | DM | Y |
			| 11/13/2013 | 14 | Female | 113 | DS | N |
			| 11/13/2013 | 17 | Male | 132 | DS | N |
		
			*`0` weights, wrong dates (2025, 1978), and `Female`/`Male` in Sex are still present — those are cleaned in Steps 7–9.*
			

???+ question "Check Your Understanding"
    A form records temperature as `"37.2C"`, time as `"10 min"`, and pH as `"7.4"`. Which need fixing?

    ??? success "Answer"
        `37.2C` → `37.2` (rename column to `temp_celsius`). `10 min` → `10` (rename column to `time_min`). `7.4` is fine — pH is dimensionless.

!!! success "Key Points"
    - Cells hold values only — not values plus units, not values plus notes.
    - Record units once in the column header or data dictionary.
    - Mixed-type columns silently break every downstream calculation.

!!! tip "Where to record units"
    Include units in the column header (`weight_g`, `length_mm`, `temp_celsius`) or document them in a data dictionary (covered in the [Metadata](#metadata) section). Never put units in individual cells.


---

## Step 7: Represent Missing Data Consistently

!!! abstract "Before reading on..."
    - In the 2013 data, some Weight values are `0`. Did those animals actually weigh zero grams, or was the measurement just not recorded?
    - In the Species column, you'll see both `NA` and blank cells — is there a difference? How would a computer distinguish them?
    - If you ran an average on Weight, how would `0` values affect the result?

**The problem:** Three different representations of "no data recorded" appear across the dataset:

| Situation | How it appears | Problem |
|-----------|---------------|---------|
| 2013 weights not recorded | `0` | Zero is a valid weight — ambiguous |
| 2014 species unknown | `NA` | Is "NA" a species code or "not available"? |
| 2014 species unknown | *(blank)* | Is blank intentional or an entry error? |

**Why this breaks things:** `0` will be included in every sum and average without warning. `NA` could be a real value or a label. You cannot tell without checking the metadata. Inconsistent representations mean you cannot reliably filter for "missing" records.

!!! warning "Missing value symbols that cause problems"
    | Bad choice | Why |
    |-----------|-----|
    | `0` for a missing measurement | Treated as a real zero in all calculations |
    | `999`, `-999` | Look like real values; corrupt summary statistics |
    | `n/a`, `N/A`, `na`, `NA` (mixed) | Inconsistent capitalization fails string matching |
    | `?`, `--`, `.` | Meaningless to software |

**The rules:**

1. **Use blank cells for missing values.** This is what R (`NA`), Python (`NaN`), and databases (`NULL`) expect by default on import.
2. **Check your metadata.** Is `NA` a real species code? Consult `species.csv` — it is not listed there. So `NA` in the Species column means missing data, not a species name.
3. **Never use 0 to mean missing** unless zero is a physically impossible measurement value. For weight, zero is possible in principle, so zero should not represent "not recorded."

!!! note "On using NA"
    Blank cells are the safest universal choice. `NA` (as text) is recognized natively in R but can still cause issues in Python and Excel. If you're sharing data with R users specifically, blank cells still work — R imports them as `NA` automatically.



    *Wrong dates (2025, 1978) and `Female`/`Male` in the Sex column are still present — those are fixed in Steps 8–9.*


???+ question "Exercise 7.1 — Replace zero weights and 'NA' species with blanks"
    In the Weight column, find all cells containing values of `0`. These represent measurements that were not recorded, not true zero weights. Replace each with a blank cell.

	In the Species column, find all cells containing `NA`. Confirm against `species.csv` that "NA" is not a valid code. Replace all with blank.

    ??? success "Solution"

        === "Before (messy)"

			| Date_Collected | Plot | Sex | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 7/16/2013 | 1 | M | **0** | DM |
			| 1/8/2014 | 2 | | | **NA** |
			| 1/8/2014 | 2 | | | *(blank)* |
		
		=== "After (missing values standardized to blank)"
		
			| Date_Collected | Plot | Sex | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 7/16/2013 | 1 | M | *(blank)* | DM |
			| 1/8/2014 | 2 | | | *(blank)* |
			| 1/8/2014 | 2 | | | *(blank)* |

???+ question "Check Your Understanding"
    A researcher uses `-1` to represent "measurement not applicable." What are the risks?

    ??? success "Answer"
        `-1` is a real number and will be included in any mean, min, or sum without warning. Better: leave the cell blank and optionally add a boolean column `measurement_applicable` set to `N` for those rows.

!!! success "Key Points"
    - Choose one missing value representation (blank is safest) and use it everywhere.
    - Never use `0` for missing unless zero is genuinely impossible for that measurement.
    - Always check your metadata before deciding whether an unusual value is real or an error.


---

## Step 8: Store Dates Safely

!!! abstract "Before reading on..."
    - Look at the dates for Plot 3 and Plot 4 of the 2014 data. Do those years match when the field study was actually conducted?
    - If a colleague in Europe opened this file, would `7/16/2013` display the same way to them?
    - What happens to a date that's missing the year when Excel auto-fills it?

**The problem:** Dates are the single most dangerous data type in spreadsheets. Excel's automatic date interpretation causes more invisible data corruption than almost anything else.

Open the `Date_Collected` column. Several 2014 entries are missing the year — the data entry person wrote `1/8` or `3/11` instead of `1/8/2014` or `3/11/2014`. Excel filled the missing year in two different ways depending on context:

- **Plot 3 rows:** dates show **2025** — Excel assumed the current year when the year was omitted.
- **Plot 4 rows:** dates show **1978** — an older or differently-configured Excel version interpreted the partial date differently, landing on a nonsensical year.

Both are wrong, but they fail in different ways, which is exactly why date problems are so dangerous: they do not always produce an obvious error. A 2025 date might be noticed; a 1978 date in an ecology dataset about 2014 fieldwork is harder to catch.

Additionally, Excel stores all dates internally as serial integers and renders them based on regional settings. `7/16/2013` on your computer may display as `16/7/2013` on a European colleague's, or as the raw integer `41471` if the cell format accidentally changes.

!!! note "The gene name problem"
    Excel doesn't only mangle dates you type — it also auto-converts certain text values it *thinks* are dates. Gene names like `MAR1`, `DEC1`, and `OCT4` get silently converted to dates (March 1, December 1, October 4) **permanently altering your data**. This is a well-known problem in genomics. Always store identifiers as plain text (prefix with a single quote in Excel: `'MAR1`) or work in a format that preserves text exactly, like CSV.

**The fix:** Split the date into three separate integer columns: `Year`, `Month`, `Day`.

This is the safest and most portable representation: no regional ambiguity, immune to auto-reformatting, and filterable by any individual component. 

???+ question "Exercise 8.1 — Split and fix the dates"
    1. Insert three columns to the left of `Date_Collected`: `Year`, `Month`, `Day`.
    2. Enter `=YEAR()`, `=MONTH()`, `=DAY()` formulas referencing the `Date_Collected` cell.
    3. Fill all formulas down, then **Copy → Paste Special → Values Only** to freeze the numbers.
    4. Scan the `Year` column for any value that is not 2013 or 2014. Correct those to 2014.
    5. Delete the original `Date_Collected` column.

    ??? success "Solution"

        === "Before (messy dates)"

			| Date_Collected | Plot | Sex | Weight | Species |
			|---------------|------|-----|--------|---------|
			| 7/16/2013 | 2 | F | | DM |
			| 3/11/2025 | 3 | M | 29 | DM |
			| 1/8/1978 | 4 | F | 37 | DM |
		
		=== "After (split into Year/Month/Day, corrected)"
		
			| Year | Month | Day | Plot | Sex | Weight | Species |
			|------|-------|-----|------|-----|--------|---------|
			| 2013 | 7 | 16 | 2 | F | | DM |
			| 2014 | 3 | 11 | 3 | M | 29 | DM |
			| 2014 | 1 | 8 | 4 | F | 37 | DM |
		
			*`Female`/`Male` in the Sex column is still present — that is fixed in Step 9 QC.*

        	After splitting, `Year` should contain only `2013` and `2014`. Both `2025` values (Plot 3 rows) and `1978` values (Plot 4 rows) are errors where the year was missing at entry. We can verify their source by looking at the **raw data**. Correct all of them to `2014`.

???+ question "Exercise 8.2 — Verify no empty date fields"
    Filter each of the three date columns for blanks. All three should be fully populated.

    ??? success "Solution"

        **Data → Filter**, click the `Year` dropdown, uncheck all except "Blanks." No rows should appear. Repeat for `Month` and `Day`. If any blanks appear, trace them back to the original `Date_Collected` column to determine whether the date was missing from the raw data.

???+ question "Check Your Understanding"
    Why is `7/4/23` a problematic date format?

    ??? success "Answer"
        Three reasons: (1) Ambiguous — July 4 or April 7? (2) Two-digit year — 2023 or 1923? (3) Excel may interpret or re-display it differently depending on system settings. Safe alternatives: `2023-07-04` (ISO 8601) or three separate integer columns.

!!! success "Key Points"
    - Never trust Excel's automatic date interpretation — verify every year is correct.
    - Store dates as `Year`, `Month`, `Day` integer columns, or as `YYYY-MM-DD` text.
    - Watch out for gene names and other text IDs that Excel silently converts to dates.

!!! tip "Alternative: ISO 8601"
    If you must keep dates in a single column, use **YYYY-MM-DD** (e.g., `2013-07-16`). This international standard is unambiguous, sorts alphabetically in the correct chronological order, and is recognized by every modern software tool.

---

## Step 9: Quality Control

!!! abstract "Before reading on..."
    - After all your cleaning, filter the Sex column and look at every unique value — any surprises?
    - Sort Plot IDs from smallest to largest — are all values between 1 and 24?
    - Is there still any `0` in the Weight column?

**The problem:** Even after fixing all structural issues, individual values may still be wrong. QC is the final check: verifying that every value in every column falls within its expected range or set of valid values.

**How to find unique values in Excel:** Click the filter arrow on any column and open the dropdown — every unique value in that column is listed. Anything unexpected stands out immediately. 

=== "Sex"

    **Expected:** `M`, `F`, or blank

    **What's actually in the data:** The 2013 DS sub-table used `Female` and `Male` instead of `F` and `M`.

    Fix with Find & Replace: `Female` → `F`, `Male` → `M`.

=== "Plot"

    **Expected:** integers 1–24

    **What's actually in the data:** The 2013 DO sub-table has a value of **32** — which does not correspond to any real plot. This is a data entry error (possibly a transposition of `23`). Flag it and check the original field notes.

    Sort ascending — values outside range appear at the ends.

=== "Year"

    **Expected:** `2013`, `2014`

    **What's actually in the data:** `2025` (Plot 3 rows) and `1978` (Plot 4 rows), both corrected in Step 8. Verify none remain.

=== "Species"

    **Expected:** any two-letter code from `species.csv`, or blank

    **Look for:** `NA` (should now be blank), codes not in `species.csv`, lowercase variants like `dm`

    Use the `=UNIQUE()` formula (Excel 365) or a PivotTable to list every distinct code, then cross-reference against `species.csv`.

=== "Weight"

    **Expected:** positive integers, or blank

    **Look for:** `0` (should have been removed in Step 7), decimals, negatives, any remaining text

    Sort ascending — zeros and negatives appear at the top.

!!! tip "Using conditional formatting for QC"
    **Home → Conditional Formatting → Highlight Cell Rules** can automatically color cells that fall outside a valid range (e.g., weight < 1 or weight > 300). This is a fast way to visually scan a large dataset for outliers without manually reviewing every cell.


???+ question "Exercise 9.1 — QC the Sex column"
    Filter the `Sex` column and review every unique value. Fix anything that is not `M`, `F`, or blank.

    ??? success "Solution"

        === "Before"

			| Sex (unique values found) |
			|--------------------------|
			| F |
			| M |
			| Female |
			| Male |
			| *(blank)* |

        === "After"

			| Sex (unique values after fix) |
			|-------------------------------|
			| F |
			| M |
			| *(blank)* |
	
			Use Find & Replace to fix `Female` → `F` and `Male` → `M`. Only `M`, `F`, and blank should remain.

???+ question "Exercise 9.2 — QC the Species column"
    List all unique species codes. Cross-reference with `species.csv`. Fix any code not in that file. Confirm no `NA` values remain.

    ??? success "Solution"

        === "Before (possible unique values)"

			| Species | In species.csv? |
			|---------|----------------|
			| DM | Yes |
			| DO | Yes |
			| DS | Yes |
			| NA | No — means missing |
			| *(blank)* | — |

        === "After:"

			| Species | In species.csv? |
			|---------|----------------|
			| DM | Yes |
			| DO | Yes |
			| DS | Yes |
			| *(blank)* | — |
	
			All species codes should appear in `species.csv`. Residual `NA` values should be replaced with blank. Also watch for codes with trailing spaces (`DM ` vs `DM`) which won't match during analysis.

???+ question "Exercise 9.3 — QC the Weight column"
    Sort Weight smallest to largest. Check for remaining zeros at the top and any implausibly large values.

    ??? success "Solution"

        === "Before (sorted ascending — potential issues)"

			| Weight | Species |
			|--------|---------|
			| 0 | DM |
			| 29 | DM |
			| 33 | DM |
			| ... | ... |

        === "After (sorted ascending — clean)"

			| Weight | Species |
			|--------|---------|
			| *(blank)* | DM |
			| 29 | DM |
			| 33 | DM |
			| ... | ... |
	
			Any remaining zeros should be cleared. Weights above ~250g warrant a look at the original field notes before deciding whether to keep or flag them. Plot 32 (an out-of-range plot ID found in Step 9.2 QC on the Plot column) should also be flagged for checking against the original field notes.

???+ question "Check Your Understanding"
    You are QC-ing a PCR dataset. `Ct_value` ranges from 12–45 but three cells contain `0`. What are two possible explanations and how would you investigate?

    ??? success "Answer"
        Explanations: (1) `0` means "no amplification detected" (undetermined Ct), or (2) data entry error. Investigate: check the original instrument export or lab notebook for those wells. If they are true non-amplifications, replace `0` with blank and document this in the data dictionary.

!!! success "Key Points"
    - QC is the last line of defense before your data enters an analysis pipeline.
    - For every column, check the complete set of unique values for anything unexpected.
    - Cross-reference coded columns (species, plot, treatment) against their metadata files.
    - Fix every error found — silent errors produce silent wrong results.

---

## Metadata

Good metadata is what separates a dataset that can be understood and reused from one that only its creator can interpret. It is just as important as the data itself.

### What Is Metadata?

Metadata is **data about the data** — information that describes, contextualizes, and makes your dataset interpretable to others (and to future-you).

There are three types:

| Type | What it covers | Examples |
|------|---------------|---------|
| **Administrative** | Who owns and manages the data | Principal investigator, project dates, funder, data license |
| **Descriptive** | What the dataset is and where it came from | Title, authors, abstract, keywords, related publications |
| **Structural** | How the data is organized internally | Column definitions, units, valid values, collection method, sample size |

For most research datasets, structural metadata — the **data dictionary** — is the most immediately useful.

!!! note "Metadata can use spaces and special characters"
    Unlike your data spreadsheet, a metadata file does not need to follow strict naming conventions. It is documentation, not data. Feel free to use full sentences, spaces, and punctuation.

### Metadata Files in This Dataset

This dataset already has two metadata files you have been using:

- **`species.csv`** — a reference table mapping two-letter species codes to genus, species name, and taxonomic group. Without this file, a code like `DM` is meaningless.
- **`plots.csv`** — a reference table mapping plot IDs (1–24) to their experimental type. Without this, plot 4 is just a number.

These are structural metadata. They make the coded values in your main dataset interpretable.

### Exercise: Create a Data Dictionary

The most important structural metadata document is a **data dictionary** — a plain description of every column in your dataset. It records:

- What each column represents
- The units used
- The valid values or range
- Any special notes about the data

???+ question "Exercise M.1 — Create data_info.csv"
    Create a new spreadsheet called `data_info.csv` (or open a new tab) with the following columns: `Column`, `Description`, `Notes`.

    Fill in one row for each column in your cleaned dataset. Use the information you have learned throughout this workshop plus what you know about the Portal Project.

    After completing, compare with the reference version below.

    ??? success "Reference: data_info.csv"

        | Column | Description | Notes |
        |--------|-------------|-------|
        | Year | Date collected — year | |
        | Month | Date collected — month | |
        | Day | Date collected — day | |
        | Plot | Plot ID | See plots.csv for descriptions |
        | Sex | M = male, F = female | |
        | Weight | Weight in grams | Blank = not recorded |
        | Species | Species ID | See species.csv for descriptions |
        | Calibrated | Y = yes, N = no | Only 4 samples were not calibrated |

        [:fontawesome-solid-file-csv: Download data_info.csv](data_info.csv){ .md-button }

### README Files

A data dictionary covers column-level detail, but your dataset also deserves a broader description. A **README file** (plain text, `.txt` or `.md`) lives in the same folder as your data and gives any reader the big picture:

- What is this dataset and why was it collected?
- Who collected it and when?
- How are the files organized?
- What do abbreviations mean?
- Are there known issues or limitations?

```
# Portal Project Rodent Survey — Cleaned Data

## Overview
Long-term small mammal survey data from the Chihuahuan Desert, AZ/NM.
Records from 2013 and 2014, cleaned from survey_data_messy.xlsx.

## Files
- survey_data_clean.csv  — cleaned survey data
- species.csv            — species code reference
- plots.csv              — plot type reference
- data_info.csv          — column-level data dictionary
- cleaning_notes.txt     — log of all cleaning steps applied

## Known Issues
- 4 samples (Calibrated = N) have weight readings that may be inaccurate.
```

!!! tip "README files travel with the data"
    Whenever you share your data — by email, on a server, in a repository — include the README and all metadata files in the same folder. A dataset without its metadata is incomplete.

!!! success "Key Points"
    - Metadata makes your dataset understandable without asking the creator.
    - A data dictionary defines every column: what it means, its units, and its valid values.
    - A README file provides the big-picture context: who, what, when, why, and how the data was collected.
    - Keep metadata files in the same folder as the data they describe.

---

## Exporting Your Data

### Why Not Save as .xlsx?

Excel's native format (`.xlsx`, `.xls`) has several serious limitations for long-term data storage:

- **Proprietary:** Future software versions may not open old Excel files correctly.
- **Version-sensitive:** Different Excel versions handle dates, formulas, and encoding differently, which can introduce silent errors.
- **Software-dependent:** Other spreadsheet programs (LibreOffice, Google Sheets) sometimes misread Excel-specific features, causing data loss.
- **Not accepted by repositories:** Journals and data repositories require open formats for data submission.

### How to Save as CSV

A **CSV (comma-separated values)** file is plain text — columns separated by commas, rows separated by line breaks. It can be opened and read by virtually every software tool in existence, now and in the future.

To export from Excel:

1. **File → Save As**
2. Under Format, choose **Comma Separated Values (.csv)**
3. Confirm the file name and click **Save**
4. When Excel warns that some features will be lost, click **Continue** — that's expected and fine

!!! note "CSV file naming"
    Apply the same rules to file names as to column names: no spaces, no special characters. `survey_data_clean.csv` is good. `Survey Data (Clean) Final v2.csv` is not.


???+ question "Exercise E.1 — Export the clean dataset"
    1. With `survey_data_clean.xlsx` open, go to **File → Save As**.
    2. Choose **Comma Separated Values (.csv)** as the format.
    3. Save as `survey_data_clean.csv` in the same folder.
    4. Open the CSV in a text editor (TextEdit, Notepad, VS Code) and confirm it looks like plain comma-separated text.

    ??? success "What you should see"
        ```
        Year,Month,Day,Plot,Sex,Weight,Species,Calibrated
        2013,7,16,1,M,,DM,Y
        2013,7,16,2,F,,DM,Y
        2013,7,18,7,M,33,DM,Y
        ...
        ```

!!! success "Key Points"
    - Save analysis-ready data as CSV, not `.xlsx`.
    - CSV files are plain text: universal, portable, and readable by any tool now or in the future.
    - Keep the `.xlsx` working copy for your own reference, but share and archive the `.csv`.

!!! tip "You can still open CSVs in Excel"
    Saving as CSV does not mean you lose Excel. You can always open a CSV in Excel for viewing or editing. The difference is that the file is now stored in a universal format that any tool can read — not locked inside a proprietary format.

---

## The Clean Dataset

After completing all steps, your `survey_data_clean.xlsx` should match this structure:

| Column | Type | Valid Values |
|--------|------|-------------|
| Year | Integer | 2013, 2014 |
| Month | Integer | 1–12 |
| Day | Integer | 1–31 |
| Plot | Integer | 1–24 |
| Sex | Text | M, F, or blank |
| Weight | Integer | Positive integers, or blank |
| Species | Text | 2-letter code from species.csv, or blank |
| Calibrated | Text | Y or N |

A preview of the first rows:

| Year | Month | Day | Plot | Sex | Weight | Species | Calibrated |
|------|-------|-----|------|-----|--------|---------|-----------|
| 2013 | 7 | 16 | 1 | M | | DM | Y |
| 2013 | 7 | 16 | 2 | F | | DM | Y |
| 2013 | 7 | 18 | 7 | M | 33 | DM | Y |
| 2013 | 11 | 13 | 14 | F | 113 | DS | N |
| 2013 | 11 | 13 | 17 | M | 132 | DS | N |
| 2014 | 1 | 8 | 2 | M | 44 | DM | Y |

[:fontawesome-solid-file-excel: Download Clean Data (.xlsx)](survey_data_clean.xlsx){ .md-button .md-button--primary }
[:fontawesome-solid-file-csv: Download Clean Data (.csv)](survey_data_clean.csv){ .md-button }

---

## Summary

!!! success "The Rules — in one place"

    | # | Rule |
    |---|------|
    | 1 | **Protect raw data.** Work on a copy; never modify the original. Log every change. |
    | 2 | **One table per sheet.** Remove blank rows and repeated headers. |
    | 3 | **One value per cell.** Split combined fields into separate columns. |
    | 4 | **Clean field names.** No spaces, no special characters, descriptive, consistent. |
    | 5 | **One table per file.** Stack data from multiple tabs; verify columns align first. |
    | 6 | **No formatting as data.** Color and bold are invisible to every analysis tool. |
    | 7 | **No units or comments in cells.** Record units in column headers or the data dictionary. |
    | 8 | **Consistent missing values.** Use blank everywhere; never use `0` for a missing measurement. |
    | 9 | **Safe dates.** Split into `Year`, `Month`, `Day` or use `YYYY-MM-DD`. Watch for auto-conversion of text to dates. |
    | 10 | **Quality control.** Check every column's unique values before sharing. |
    | + | **Write metadata.** Document every column in a data dictionary. Keep a README with your data. |
    | + | **Export as CSV.** Save your final, analysis-ready data in a universal plain-text format. |

---

## Further Reading

- [Data Carpentry: Data Organization in Spreadsheets for Ecologists](https://datacarpentry.org/spreadsheet-ecology-lesson/) — the lesson that inspired this workshop
- [Tidy Data — Hadley Wickham (2014)](https://www.jstatsoft.org/article/view/v059i10) — the foundational paper on what clean tabular data looks like
- [Data Organization in Spreadsheets — Broman & Woo (2018)](https://www.tandfonline.com/doi/full/10.1080/00031305.2017.1375989) — a practical guide aimed at researchers
- [Gene name errors from Excel — Ziemann et al. (2016)](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1044-7) — a study quantifying how often Excel's date auto-conversion corrupts published genomics data

---

**Next in this series:** [Managing Data & Projects for Genomics](../genomics/index.md)

*Questions? Come to office hours or contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
