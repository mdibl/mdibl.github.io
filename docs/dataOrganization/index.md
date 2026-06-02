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

??? question "Exercise — What is the problem with this data format?"
    A field technician recorded the following survey data. Look at the columns carefully before reading on.

    | Date Collected | Plot | Species_Sex | Weight (g) |
    |---------------|------|-------------|-----------|
    | 7/16/2013 | 1 | DMM | 29 |
    | 7/16/2013 | 2 | DMF | 40 |
    | 7/18/2013 | 7 | DMM | 33 |
    | 8/19/2013 | 8 | DOF | 52 |

    The `Species_Sex` column combines the species code and sex code into a single value: `DMM` means species `DM`, sex `M` (male); `DOF` means species `DO`, sex `F` (female). Which cardinal rule does this violate, and how would you fix it?

    ??? success "Solution"
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

!!! tip "Keep the raw file closed"
    Once you download `survey_data_messy.xlsx`, **do not open it yet**. Step 1 of the workshop covers what to do before you touch any data.

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

## Workshop Roadmap

As you scroll, the table of contents on the right tracks where you are in the lesson.

| Section | Topic | Theme |
|---------|-------|-------|
| [Steps 1–2](#step-1-protect-your-raw-data) | Setup and table structure | Formatting Data Tables |
| [Steps 3–5](#step-3-one-piece-of-information-per-cell) | Cell and column hygiene | Common Spreadsheet Errors |
| [Steps 6–7](#step-6-never-encode-data-in-formatting) | Formatting and comments | Common Spreadsheet Errors |
| [Steps 8–9](#step-8-represent-missing-data-consistently) | Missing values and dates | Common Spreadsheet Errors |
| [Step 10](#step-10-quality-control) | Checking for errors | Quality Control |
| [Metadata](#metadata) | Documenting your data | Metadata |
| [Export](#exporting-your-data) | Saving in open formats | Exporting Data |

---

## Step 1 — Protect Your Raw Data

**The problem:** You receive a spreadsheet from a colleague and immediately start fixing things in place. Two hours later you realize you deleted a column, accidentally overwrote several values, and can no longer tell what the original data looked like. Raw data is the ground truth. Once it is gone, it is gone.

**The fix:** Before touching anything, duplicate the file and rename the copy.

```
survey_data_messy.xlsx    ← original; close it, never open it again
survey_data_clean.xlsx    ← working copy; all edits happen here
```

!!! tip "Name your working copy clearly"
    Use a suffix like `_clean`, `_working`, or today's date. Avoid `_final`, `_final2`, `_FINAL_v3` — those names always lie.

**Keeping track of your changes:** Document every cleaning step just like you would record a lab procedure. Create a plain-text file (e.g., `cleaning_notes.txt`) in the same folder as your data and write down what you changed and why. This makes your work reproducible and helps collaborators (or future-you) understand what happened to the raw data.

```
# cleaning_notes.txt
2024-11-01
- Made working copy: survey_data_clean.xlsx
- Removed blank rows separating tables in 2013 tab
- Renamed column M/F → Sex
...
```

!!! warning "Everything from here forward happens in survey_data_clean.xlsx"
    The messy file stays closed for the rest of the workshop.

??? question "Exercise 1.1 — Make your working copy"
    1. Right-click `survey_data_messy.xlsx` → **Duplicate** (Mac) or **Copy → Paste** (Windows).
    2. Rename the copy `survey_data_clean.xlsx`.
    3. Open `survey_data_clean.xlsx`. You are ready to begin.

    ??? success "Check"
        Two files should now exist side by side:

        - `survey_data_messy.xlsx` — closed, untouched
        - `survey_data_clean.xlsx` — open in Excel

!!! success "Key Points"
    - Never edit your original data file.
    - Work only on a named copy.
    - Keep a plain-text log of every change you make.

---

## Step 2 — One Table Per Sheet

**The problem:** Open the **2013** tab. The data is not one continuous table — there are multiple sub-tables stacked in the same sheet, separated by blank rows and repeated header rows:

```
Date Collected | Plot | M/F | Weight | Species
7/16/2013      |  1   |  M  |   0    | DM
7/16/2013      |  2   |  F  |   0    | DM
               |      |     |        |          ← blank row
Date Collected | Plot | M/F | Weight | Species  ← repeated header
8/19/2013      |  8   |  F  |  52    | DO
```

In 2013 the tables are split by **species**. In 2014 they are split by **plot**.

**Why this breaks things:** Analysis tools (R, Python, Excel pivot tables) expect a single rectangular table with exactly one header row. Blank rows and repeated headers cause silent import errors — your software will either crash or silently discard half the data. There is also no way to filter or sort across both sub-tables at once.

**The fix:** The species and plot information is already recorded in every row as column values — so the sub-table breaks are redundant. Delete the blank rows and repeated header rows so everything becomes one continuous table.

=== "Before (messy)"

    ```
    Date Collected | Plot | M/F | Weight | Species
    7/16/2013      |  1   |  M  |   0    | DM
    7/16/2013      |  2   |  F  |   0    | DM
                   |      |     |        |          ← blank row
    Date Collected | Plot | M/F | Weight | Species  ← repeated header
    8/19/2013      |  8   |  F  |  52    | DO
    ```

=== "After (clean)"

    ```
    Date Collected | Plot | M/F | Weight | Species
    7/16/2013      |  1   |  M  |   0    | DM
    7/16/2013      |  2   |  F  |   0    | DM
    8/19/2013      |  8   |  F  |  52    | DO
    ```

!!! tip "Freeze the header row"
    After flattening the table, freeze the top row so column names stay visible as you scroll: **View → Freeze Top Row**. This avoids needing to repeat the header.

??? question "Exercise 2.1 — Flatten the 2013 tab"
    1. Scroll through the **2013** tab and find all blank rows and repeated header rows.
    2. Delete each one.
    3. The result should be one continuous table with exactly one header row at the top.

    **Hint:** Press **Ctrl+End** (Mac: **Cmd+End**) to jump to the last cell and see how far the data extends.

    ??? success "Solution"
        There are two blank-row / repeated-header dividers in the 2013 data. After removing them, the tab should have one header row followed by continuous data with no gaps.

??? question "Exercise 2.2 — Flatten the 2014 tab"
    Repeat the same process for the **2014** tab. Here the sub-tables are divided by plot number rather than species.

    ??? success "Solution"
        Remove all blank rows and repeated header rows in the 2014 tab. The result is one uninterrupted table.

??? question "Check Your Understanding"
    Why is it safe to delete the sub-table dividers rather than keeping separate tables per species or plot?

    ??? success "Answer"
        Because the species and plot values are already recorded as column entries in every row. The blank rows and repeated headers conveyed no additional information — they were visual separators that happen to break every analysis tool.

!!! success "Key Points"
    - Each sheet contains exactly one table with exactly one header row.
    - Never use blank rows or repeated headers to separate groups within a dataset.
    - If you need to distinguish groups, add a column that encodes the group as a value.

---

## Step 3 — One Piece of Information Per Cell

**The problem:** In the **2014** tab, the data for **Plot 4** has species and sex merged into a single cell:

| Date Collected | Plot | Species_Sex | Weight |
|---------------|------|-------------|--------|
| 1/8/2014 | 4 | F_DM | 37 |
| 1/8/2014 | 4 | M_DM | 45 |
| 1/8/2014 | 4 | F_DS | 128 |

**Why this breaks things:** You cannot filter by species alone or by sex alone. Extracting either value requires a parsing formula — fragile, invisible to collaborators, and broken by any inconsistency. In the actual data, the order sometimes appears as `F_DM` and sometimes as `DM_F`, so even parsing fails silently.

**The fix:** Split the combined column into separate `Species` and `Sex` columns using **Data → Text to Columns → Delimited → `_`**.

=== "Before (messy)"

    | Date Collected | Plot | Species_Sex | Weight |
    |---------------|------|-------------|--------|
    | 1/8/2014 | 4 | F_DM | 37 |
    | 1/8/2014 | 4 | M_DM | 45 |
    | 1/8/2014 | 4 | F_DS | 128 |

=== "After (clean)"

    | Date Collected | Plot | Species | Sex | Weight |
    |---------------|------|---------|-----|--------|
    | 1/8/2014 | 4 | DM | F | 37 |
    | 1/8/2014 | 4 | DM | M | 45 |
    | 1/8/2014 | 4 | DS | F | 128 |

!!! tip "One variable, one column — always"
    If you find yourself putting a separator character (`_`, `/`, `;`) inside a cell to pack two things together, that is a sign you need another column.

??? question "Exercise 3.1 — Split Species_Sex"
    1. In the **2014** tab, find the `Species_Sex` column.
    2. Insert two new blank columns to its right: `Species` and `Sex`.
    3. Use **Data → Text to Columns** (delimited by `_`) to split the values.
    4. Verify the split, then delete the original `Species_Sex` column.

    **Note:** After merging tabs in Step 5, these two columns must sit in the same positions as the 2013 data.

    ??? success "Solution"
        Each row that had `F_DM` should now have `DM` in Species and `F` in Sex. Check for reversed-order entries like `DM_F` — these need to be corrected manually so Species always contains the code and Sex always contains `M` or `F`.

??? question "Check Your Understanding"
    A student records GPS coordinates as `"44.3N, 68.2W"` in one cell. What should they do instead?

    ??? success "Answer"
        Split into two columns: `Latitude` (44.3) and `Longitude` (-68.2). Use signed decimal degrees (negative for West/South) so the values are numbers rather than strings, making any geographic calculation straightforward.

!!! success "Key Points"
    - Each cell holds exactly one value.
    - Never use delimiters inside a cell to encode two things at once.
    - If a column name contains "and" or `/`, it almost certainly violates this rule.

---

## Step 4 — Write Clean Field Names

**The problem:** Two column names in the 2013 header row cause problems immediately:

- **`M/F`** — contains a special character and is ambiguous about what the values mean
- **`Date Collected`** — contains a space

The same issues appear in the 2014 tab.

**Why this breaks things:** Spaces in column names must be quoted in every programming language (`df["Date Collected"]` vs. `df$Date_Collected`). Forgetting the quotes is a common error. Special characters (`/`, `%`, `#`, `(`, `)`) are operators or reserved symbols in most tools and cause syntax errors on import. `M/F` also doesn't tell you what the values are.

**The rules for good field names:**

| Rule | Bad | Good |
|------|-----|------|
| No spaces | `Date Collected` | `Date_Collected` |
| No special characters | `M/F`, `Weight(g)` | `Sex`, `Weight` |
| Descriptive | `x`, `col1` | `plot_id`, `weight_g` |
| No leading numbers | `2023_count` | `count_2023` |
| Consistent style | `PlotID`, `sex`, `WEIGHT` | `plot_id`, `sex`, `weight` |

!!! note "Underscores vs. CamelCase"
    Both `date_collected` and `DateCollected` are acceptable — pick one style and apply it everywhere in the file.

!!! tip "Abbreviations in field names"
    Abbreviations like `sp` or `wt` save space but can confuse collaborators. If you use them, document their meaning in your data dictionary (covered in the [Metadata](#metadata) section below).

**The fix for this dataset:**

| Old Name | New Name | Reason |
|----------|----------|--------|
| `M/F` | `Sex` | Descriptive; no special character |
| `Date Collected` | `Date_Collected` | No space (we will break this into Y/M/D in Step 9) |

??? question "Exercise 4.1 — Fix the field names"
    1. In both the **2013** and **2014** tabs, rename `M/F` → `Sex`.
    2. Rename `Date Collected` → `Date_Collected`.
    3. Scan all remaining headers for any other spaces or special characters.

    ??? success "Solution"
        After this step, both tabs should have clean headers: `Date_Collected | Plot | Sex | Weight | Species`. No spaces, no symbols anywhere.

??? question "Check Your Understanding"
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

## Step 5 — Consolidate Data Across Tabs

**The problem:** Your working file has two tabs: **2013** and **2014**. Splitting records across tabs by year (or batch, or site) is common — and it creates chronic headaches downstream.

**Why this breaks things:** Most analysis tools load one table at a time. Every analysis that needs both years requires extra code or manual pre-processing. The two tabs can also silently drift apart in column order or naming over time, causing misaligned data when they are eventually combined.

**The fix:** Stack the two tables into one sheet. Two requirements must be met first:

1. **The year information must be preserved.** Both tabs have `Date_Collected` containing the year — so nothing will be lost. (You will formally break the date into `Year`, `Month`, `Day` in Step 9.)
2. **Column order must match exactly.** If 2013 has `Date_Collected | Plot | Sex | Weight | Species` but 2014 has `Date_Collected | Plot | Species | Sex | Weight`, stacking them will silently assign Sex values to the Weight column and vice versa.

!!! warning "Verify column order before stacking"
    Mismatched column order is one of the most common and hardest-to-catch mistakes in combining datasets. Compare headers side by side before copying any rows.

=== "Before"

    **Tab: 2013** — `Date_Collected | Plot | Sex | Weight | Species`

    **Tab: 2014** — `Date_Collected | Plot | Species | Sex | Weight` *(wrong order)*

=== "After"

    **Tab: AllData** — `Date_Collected | Plot | Sex | Weight | Species`

    *(all rows from both years, one continuous table)*

??? question "Exercise 5.1 — Align and merge the tabs"
    1. Compare the column order in both tabs side by side.
    2. Reorder the **2014** columns to match **2013** exactly.
    3. Copy all data rows (not the header) from the **2014** tab.
    4. Paste below the last data row in the **2013** tab.
    5. Rename the tab (e.g., `AllData`).
    6. Delete the now-empty **2014** tab.

    ??? success "Solution"
        The combined dataset has one header row, then all 2013 rows, then all 2014 rows. Verify by sorting on `Date_Collected` — all 2013 dates should sort before 2014. If any 2014 dates appear in the middle of the 2013 block, the column order was misaligned when you pasted.

??? question "Check Your Understanding"
    You are combining three experiment batches. Batch A: `Sample | Treatment | OD600`. Batch B: `Sample | OD600 | Treatment`. Batch C: `Sample | Treatment | OD_600`. What must happen before stacking?

    ??? success "Answer"
        Two issues: (1) Batch B has columns in a different order — reorder so `Treatment` precedes `OD600`. (2) Batch C uses `OD_600` instead of `OD600` — standardize the name. Only then is it safe to stack.

!!! success "Key Points"
    - Keep one table per file; avoid splitting related records across multiple sheets.
    - Before stacking, verify column names and positions are identical across all sources.
    - Identifying information (year, batch, site) must be a column value — tab names are lost when you combine sheets.

---

## Step 6 — Never Encode Data in Formatting

**The problem:** In the original messy file, some cells in the `Weight` column are **highlighted red**. The field team used this color to mark samples where the scale had not yet been zeroed — meaning those weight readings may be inaccurate. This is real, scientifically important information — but it lives only in a color.

**Why this breaks things:** Cell color is completely invisible to every analysis tool. When you import the spreadsheet into Python, R, or any database, the color disappears and so does the information. Colors are also lost when copying and pasting, cannot be filtered or counted, and their meaning is undocumented and subjective.

Other common formatting traps:

- **Bold** text to flag outliers
- **Italic** text to indicate estimated values
- **Merged cells** spanning a group label
- **Blank rows** used as visual separators (handled in Step 2)

**The fix:** Add a real column. Here, add a `Calibrated` column with values `Y` (scale was zeroed) or `N` (not zeroed). Use the coloring as a guide to fill in the values, then strip all cell colors.

=== "Before (messy)"

    | Date_Collected | Plot | Sex | Weight | Species |
    |---------------|------|-----|--------|---------|
    | 11/13/2013 | 14 | F | 113 | DS | ← *red fill* |
    | 11/13/2013 | 17 | M | 132 | DS | ← *red fill* |

=== "After (clean)"

    | Date_Collected | Plot | Sex | Weight | Species | Calibrated |
    |---------------|------|-----|--------|---------|-----------|
    | 11/13/2013 | 14 | F | 113 | DS | N |
    | 11/13/2013 | 17 | M | 132 | DS | N |
    | 7/16/2013 | 1 | M | | DM | Y |

??? question "Exercise 6.1 — Add the Calibrated column"
    1. Add a new column called `Calibrated` to the right of `Weight`.
    2. For each row highlighted red in the original file, enter `N`.
    3. For every other row, enter `Y`.
    4. Clear all cell colors: select all cells → **Home → Fill Color → No Fill**.

    **Reference:** The final cleaned dataset has exactly **4 rows** with `N` in `Calibrated`.

    ??? success "Solution"
        Filter `Calibrated` for `N` — you should see exactly 4 rows. All 4 are `DS` records. Remove all remaining cell coloring from the sheet.

??? question "Check Your Understanding"
    A researcher uses **bold font** in a species count spreadsheet to flag "species of special concern." Is this acceptable?

    ??? success "Answer"
        Not acceptable. Bold formatting is invisible on import and cannot be filtered or counted. They should add a `special_concern` column with `Y`/`N` and document what it means.

!!! success "Key Points"
    - Formatting (color, bold, italics, merged cells) is invisible to analysis tools and silently dropped on import.
    - Every piece of information that affects interpretation must live in a cell as a real value.

---

## Step 7 — Keep Cells Free of Comments and Units

**The problem:** Two issues remain:

1. Some `Weight` cells contain the value plus the unit: `33g`, `52g`
2. Some cells contain a text annotation typed directly into the cell, e.g., `"needs recalibration"`

**Why this breaks things:** `33g` is a text string, not a number. Excel will not sum it, and R/Python will import it as missing. A text comment in a numeric cell makes the entire column a mixed type — once you mix text and numbers in a column, that column is broken for any calculation.

**The fix:**

1. **Units:** Strip the unit suffix from all cell values. Record the unit once in the column header (`weight_g`) or in the data dictionary.
2. **Comments:** The calibration issue is already handled by the `Calibrated` column from Step 6. Remove any remaining embedded text from numeric cells.

=== "Before (messy)"

    ```
    Weight
    33g
    52g
    needs recalibration
    41g
    ```

=== "After (clean)"

    ```
    Weight
    33
    52

    41
    ```

!!! tip "Where to record units"
    Include units in the column header (`weight_g`, `length_mm`, `temp_celsius`) or document them in a data dictionary (covered in the [Metadata](#metadata) section). Never put units in individual cells.

??? question "Exercise 7.1 — Clean the Weight column"
    1. Select the `Weight` column only.
    2. Use **Ctrl+H** (Find & Replace): find `g`, replace with nothing.
    3. Find any cells with text comments and delete them. Confirm those rows have `N` in `Calibrated`.
    4. Verify the entire column contains only numbers or empty cells.

    ??? success "Solution"
        Selecting the column before Find & Replace is critical — a sheet-wide replacement of `g` would also strip the `g` from species codes like `DM` and `DO`.

??? question "Check Your Understanding"
    A form records temperature as `"37.2C"`, time as `"10 min"`, and pH as `"7.4"`. Which need fixing?

    ??? success "Answer"
        `37.2C` → `37.2` (rename column to `temp_celsius`). `10 min` → `10` (rename column to `time_min`). `7.4` is fine — pH is dimensionless.

!!! success "Key Points"
    - Cells hold values only — not values plus units, not values plus notes.
    - Record units once in the column header or data dictionary.
    - Mixed-type columns silently break every downstream calculation.

---

## Step 8 — Represent Missing Data Consistently

**The problem:** Three different representations of "no data recorded" appear across the dataset:

| Situation | How it appears | Problem |
|-----------|---------------|---------|
| 2013 weights not recorded | `0` | Zero is a valid weight — ambiguous |
| 2014 species unknown | `NA` | Is "NA" a species code or "not available"? |
| 2014 species unknown | *(blank)* | Is blank intentional or an entry error? |

**Why this breaks things:** `0` will be included in every sum and average without warning. `NA` could be a real value or a label — you cannot tell without checking the metadata. Inconsistent representations mean you cannot reliably filter for "missing" records.

!!! danger "Missing value symbols that cause problems"
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

=== "Before (messy)"

    | Date_Collected | Plot | Sex | Weight | Species |
    |---------------|------|-----|--------|---------|
    | 7/16/2013 | 1 | M | **0** | DM |
    | 1/8/2014 | 2 | | | **NA** |
    | 1/8/2014 | 2 | | | *(blank)* |

=== "After (clean)"

    | Date_Collected | Plot | Sex | Weight | Species |
    |---------------|------|-----|--------|---------|
    | 7/16/2013 | 1 | M | *(blank)* | DM |
    | 1/8/2014 | 2 | | | *(blank)* |
    | 1/8/2014 | 2 | | | *(blank)* |

??? question "Exercise 8.1 — Replace zero weights with blanks"
    In the **2013** data, find all `Weight` values of `0`. These represent measurements that were not recorded, not true zero weights. Replace each with a blank cell.

    **Important:** Select the `Weight` column first to avoid accidentally clearing cells like `10` or `20` elsewhere.

    ??? success "Solution"
        Filter the Weight column for `0`. Press **Delete** (not Backspace) on each matching cell to clear it. After clearing, the cell should be empty, not `0`.

??? question "Exercise 8.2 — Replace 'NA' species with blanks"
    In the Species column, find all cells containing `NA`. Confirm against `species.csv` that "NA" is not a valid code. Replace all with blank.

    ??? success "Solution"
        Use **Ctrl+H** with the Species column selected. Search for `NA`, replace with nothing (empty string). Confirm with a filter that no `NA` values remain.

??? question "Check Your Understanding"
    A researcher uses `-1` to represent "measurement not applicable." What are the risks?

    ??? success "Answer"
        `-1` is a real number and will be included in any mean, min, or sum without warning. Better: leave the cell blank and optionally add a boolean column `measurement_applicable` set to `N` for those rows.

!!! success "Key Points"
    - Choose one missing value representation (blank is safest) and use it everywhere.
    - Never use `0` for missing unless zero is genuinely impossible for that measurement.
    - Always check your metadata before deciding whether an unusual value is real or an error.

---

## Step 9 — Store Dates Safely

**The problem:** Dates are the single most dangerous data type in spreadsheets. Excel's automatic date interpretation causes more invisible data corruption than almost anything else.

Open the `Date_Collected` column. Some 2014 entries are missing the year — the data entry person wrote `1/8` instead of `1/8/2014`. Excel silently interpreted these as the **current year** and auto-filled them as **2025** (or whatever year was current when the file was saved). Records from 2014 now appear to be from 2025.

Additionally, Excel stores all dates internally as serial integers and renders them based on regional settings. `7/16/2013` on your computer may display as `16/7/2013` on a European colleague's, or as the raw integer `41471` if the cell format accidentally changes.

!!! danger "The gene name problem"
    Excel doesn't only mangle dates you type — it also auto-converts certain text values it *thinks* are dates. Gene names like `MAR1`, `DEC1`, and `OCT4` get silently converted to dates (March 1, December 1, October 4) **permanently altering your data**. This is a well-known problem in genomics. Always store identifiers as plain text (prefix with a single quote in Excel: `'MAR1`) or work in a format that preserves text exactly, like CSV.

**The fix:** Split the date into three separate integer columns: `Year`, `Month`, `Day`.

This is the safest and most portable representation: no regional ambiguity, immune to auto-reformatting, and filterable by any individual component. Use these Excel formulas in three new columns, then **Paste Special → Values Only** to lock in the numbers:

```
=YEAR(A2)     → Year
=MONTH(A2)    → Month
=DAY(A2)      → Day
```

=== "Before (messy)"

    | Date_Collected |
    |---------------|
    | 7/16/2013 |
    | 1/8/2025 | ← *should be 2014* |
    | 3/11/2014 |

=== "After (clean)"

    | Year | Month | Day |
    |------|-------|-----|
    | 2013 | 7 | 16 |
    | 2014 | 1 | 8 |
    | 2014 | 3 | 11 |

!!! tip "Alternative: ISO 8601"
    If you must keep dates in a single column, use **YYYY-MM-DD** (e.g., `2013-07-16`). This international standard is unambiguous, sorts alphabetically in the correct chronological order, and is recognized by every modern software tool.

??? question "Exercise 9.1 — Split and fix the dates"
    1. Insert three columns to the left of `Date_Collected`: `Year`, `Month`, `Day`.
    2. Enter `=YEAR()`, `=MONTH()`, `=DAY()` formulas referencing the `Date_Collected` cell.
    3. Fill all formulas down, then **Copy → Paste Special → Values Only** to freeze the numbers.
    4. Scan the `Year` column for any value that is not 2013 or 2014. Correct those to 2014.
    5. Delete the original `Date_Collected` column.

    ??? success "Solution"
        After splitting, `Year` should contain only `2013` and `2014`. Any `2025` values are the rows where the year was missing at entry. Correct each to `2014`.

??? question "Exercise 9.2 — Verify no empty date fields"
    Filter each of the three date columns for blanks. All three should be fully populated.

    ??? success "Solution"
        **Data → Filter**, click the `Year` dropdown, uncheck all except "Blanks." No rows should appear. Repeat for `Month` and `Day`.

??? question "Check Your Understanding"
    Why is `7/4/23` a problematic date format?

    ??? success "Answer"
        Three reasons: (1) Ambiguous — July 4 or April 7? (2) Two-digit year — 2023 or 1923? (3) Excel may interpret or re-display it differently depending on system settings. Safe alternatives: `2023-07-04` (ISO 8601) or three separate integer columns.

!!! success "Key Points"
    - Never trust Excel's automatic date interpretation — verify every year is correct.
    - Store dates as `Year`, `Month`, `Day` integer columns, or as `YYYY-MM-DD` text.
    - Watch out for gene names and other text IDs that Excel silently converts to dates.

---

## Step 10 — Quality Control

**The problem:** Even after fixing all structural issues, individual values may still be wrong. QC is the final check: verifying that every value in every column falls within its expected range or set of valid values.

**How to find unique values in Excel:** Click the filter arrow on any column and open the dropdown — every unique value in that column is listed. Anything unexpected stands out immediately. Alternatively, use **Insert → PivotTable** and drag a column into the Rows area to see all unique values and their counts.

=== "Sex"

    **Expected:** `M`, `F`, or blank

    **Look for:** `Male`, `Female`, `m`, `f`, trailing spaces like `M ` (invisible but breaks matching)

    Fix with Find & Replace.

=== "Plot"

    **Expected:** integers 1–24

    **Look for:** values outside 1–24, decimals, blanks

    Sort ascending — values outside range appear at the ends.

=== "Year"

    **Expected:** `2013`, `2014`

    **Look for:** `2025` (auto-filled by Excel in Step 9), two-digit years, blanks

=== "Species"

    **Expected:** any two-letter code from `species.csv`, or blank

    **Look for:** `NA` (should now be blank), codes not in `species.csv`, lowercase variants like `dm`

    Use the `=UNIQUE()` formula (Excel 365) or a PivotTable to list every distinct code, then cross-reference against `species.csv`.

=== "Weight"

    **Expected:** positive integers, or blank

    **Look for:** `0` (should have been removed in Step 8), decimals, negatives, any remaining text

    Sort ascending — zeros and negatives appear at the top.

!!! tip "Using conditional formatting for QC"
    **Home → Conditional Formatting → Highlight Cell Rules** can automatically color cells that fall outside a valid range (e.g., weight < 1 or weight > 300). This is a fast way to visually scan a large dataset for outliers without manually reviewing every cell.

??? question "Exercise 10.1 — QC the Sex column"
    Filter the `Sex` column and review every unique value. Fix anything that is not `M`, `F`, or blank.

    ??? success "Solution"
        Only `M`, `F`, and blank are valid. Use Find & Replace to fix `Male`/`Female` or lowercase versions.

??? question "Exercise 10.2 — QC the Species column"
    List all unique species codes. Cross-reference with `species.csv`. Fix any code not in that file. Confirm no `NA` values remain.

    ??? success "Solution"
        All species codes should appear in `species.csv`. Residual `NA` values should be replaced with blank. Also watch for codes with trailing spaces (`DM ` vs `DM`) which won't match during analysis.

??? question "Exercise 10.3 — QC the Weight column"
    Sort Weight smallest to largest. Check for remaining zeros at the top and any implausibly large values.

    **Reference:** The heaviest rodent in this dataset, the Banner-tail kangaroo rat (*Dipodomys spectabilis*, code `DS`), typically weighs 100–200 grams.

    ??? success "Solution"
        Any remaining zeros should be cleared. Weights above ~250g warrant a look at the original field notes before deciding whether to keep or flag them.

??? question "Check Your Understanding"
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

??? question "Exercise M.1 — Create data_info.csv"
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

!!! tip "CSV file naming"
    Apply the same rules to file names as to column names: no spaces, no special characters. `survey_data_clean.csv` is good. `Survey Data (Clean) Final v2.csv` is not.

!!! note "You can still open CSVs in Excel"
    Saving as CSV does not mean you lose Excel. You can always open a CSV in Excel for viewing or editing. The difference is that the file is now stored in a universal format that any tool can read — not locked inside a proprietary format.

??? question "Exercise E.1 — Export the clean dataset"
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
