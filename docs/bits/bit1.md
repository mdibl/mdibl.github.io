# Bioinformatics Bit 1: Sample Naming Best Practices
> Updated: Jan 27, 2025

## **Why Good Sample Names Matter**

Poor sample naming can lead to confusion, errors in analysis, and difficulties in data sharing. Well-structured sample names make your data more:

- Readable for humans
- Parseable for computers
- Reproducible for future analysis
- Shareable with collaborators

## **Golden Rules for Sample Names**

1. No spaces - Use underscores (_) or hyphens (-) instead
2. No special characters - Stick to letters, numbers, and underscores/hyphens
3. Start with letters - Don't begin names with numbers or symbols
4. Be consistent - Use the same format across all samples
5. Be informative - Include key metadata but remain concise
6. Zero pad numbers - Ensure proper sorting and consistency

## **Zero Padding: Why It Matters**

Without zero padding, computer sorting can give unexpected results:
```
sample_1
sample_10
sample_2
sample_3
```
With zero padding, files sort naturally:
```
sample_01
sample_02
sample_03
sample_10
```
## **Example Structure**
```
[Condition]_[Replicate]_[TimePoint]
```
Good Examples:

```
WT_rep01_D00
KO_rep02_D07
treated_rep01_02h
control_rep02_24h
```
Bad Examples:
```
Sample 1                  # Contains space
2nd-replicate             # Starts with number
RNA-seq@timepoint2        # Contains special character
RNA_seq_rep_1             # Inconsistent with other names
WT_Rep1_D0               # Missing zero padding
```
## **Pro Tips**

- Document your naming convention in your project README (or similar metadata file)
- Keep names concise and short
- Include critical metadata but don't overload
- Consider future sorting when structuring names
- Use lowercase to avoid case-sensitivity issues
- Always zero pad numbers (01, 02... instead of 1, 2...)
- Decide on padding width before starting (e.g., 01-99 needs two digits)

---

Need help with sample names? Contact the CGDS Core -- CGDS@mdibl.org