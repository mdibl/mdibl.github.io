---
hide:
  - toc
---

# Quick Reference — Managing Data & Projects for Genomics

<div class="print-controls" markdown>

*Managing Data & Projects for Genomics · MDIBL Comparative Genomics and Data Science Core · [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*

[:material-printer: Print / Save as PDF](#){ .md-button .md-button--primary onclick="window.print(); return false;" }
&nbsp;
[:material-arrow-left: Back to Workshop](index.md){ .md-button }

</div>

---

## FAIR Data Principles

| Principle | Core idea | How to apply |
|-----------|-----------|--------------|
| **Findable** | You and others can locate the data | Consistent file names · logical folder structure · searchable metadata |
| **Accessible** | You can open and read the data | Documented file paths · readable formats · clear metadata |
| **Interoperable** | The data works across tools | Open formats (`.csv`, `.tsv`) · standard gene IDs (Ensembl) · no proprietary features |
| **Reusable** | Others can repeat or build on your work | README · sample sheet · documented parameters · tidy data structure |

---

## Metadata — What to Create

| Document | Contents | Location |
|----------|----------|----------|
| **`samplesheet.csv`** | File name → sample → condition → replicate | `data/` |
| **`design.tsv`** | One row per sample: condition, treatment variables, replicate (for analysis code) | `analysis/input/` |
| **`README.txt`** | Project overview, directory structure, tool versions, how to use the files | Project root |

**Always document:** organism + strain · genome build + annotation version (e.g., GRCm39, Ensembl 114) · pipeline name + version · statistical cutoffs used

---

## File Naming Rules

**Pattern:** `{variable1}_{variable2}_{variable3}_{YYYY-MM-DD}.{ext}`

| Rule | Do this | Not this |
|------|---------|----------|
| No spaces | `Mock_DMSO_rep1.fastq.gz` | `Mock DMSO rep1.fastq.gz` |
| No special characters | `results_v2.csv` | `results (v2)!.csv` |
| Zero-pad numbers | `s01, s02, s12` | `s1, s2, s12` |
| ISO 8601 dates | `2024-07-16` | `07-16-24` or `JUL-16` |
| Consistent case | `LD_phyA`, `LD_phyB` | `LD_phyA`, `ld_phyb` |
| Content-based names | `PCA_all_samples.png` | `fig_3_a.png` |
| Experimental variables first | `LD_phyA_on_t04.norm.txt` | `2024-07-14_s1_LD.txt` |

---

## Project Directory Template

```
project_name/
├── README.txt          ← who/what/when/where/how; directory map
├── data/               ← raw data + metadata (READ-ONLY, never modify)
│   ├── samplesheet.csv
│   └── *.fastq.gz / reference files
├── analysis/           ← code, pipeline inputs, pipeline outputs
│   ├── script.Rmd
│   ├── input/
│   └── output/
├── doc/                ← notes, protocols, documentation
└── results/            ← final figures and tables for the paper
```

**Key rules:** one project per directory · separate raw from processed · no `OLD/`, `misc/`, or version-number suffixes · use git for version control · name files by content, not manuscript position

---

## Gene IDs — Use Standard Identifiers

| ID type | Example | Source | Use when |
|---------|---------|--------|---------|
| Ensembl Gene ID | `ENSG00000141510` | Ensembl | Primary join key in analysis |
| Entrez Gene ID | `7157` | NCBI | Cross-referencing databases |
| Gene symbol | `TP53` | HGNC/MGI | Convenience label only — never as a join key |

**Never use gene symbols as primary identifiers.** They are not unique across species, change with annotation updates, and cause silent mismatches due to capitalization differences.

---

## README Checklist

- [ ] Project title and one-sentence description
- [ ] Organism (species + strain/cell line)
- [ ] Date created and last updated
- [ ] Point of contact (name + email)
- [ ] Directory structure — what each folder contains
- [ ] Sample sheet location and file naming convention
- [ ] Reference genome build and annotation version
- [ ] Analysis pipeline name and version
- [ ] Key statistical parameters (cutoffs, normalization method)
- [ ] Known issues or data caveats

---

## One Thing to Fix This Week

| If you don't have... | Do this now |
|---------------------|-------------|
| A README | Write one for your most-used project. Start: what is it, who owns it, where is the raw data. |
| A sample sheet | New `.csv`: sample name · condition · replicate · FASTQ file name. |
| Consistent file names | Write down the convention you wish you had used. Apply to new files going forward. |
| Open-format results | Export your key result from `.xlsx` to `.csv`. |
| Documented gene IDs | Add an `id_source` column: e.g., `Ensembl_114_GRCm39`. |
