# Prompt Examples

Use this page as an exercise in thinking deeply about the questions asked to an LLM.
Common mistakes in prompting as well as their effects on resulting output are described. 
There are several examples of weak and strong prompts below which should illustrate robust instructions to any LLM.

## Common Pitfalls

Each row pairs a weak prompt with a stronger one. The notes column explains what makes the difference.
See how many apply to the example prompts below!

### General pitfalls

| Pitfall | Weak prompt | Stronger prompt | Notes |
|---------|-------------|-----------------|-------|
| **Vague quantities** | "Give me a short summary." | "Summarize in 3 sentences, under 80 words." | "Short" means different things to different readers, and the model will pick its own default. A number can be checked; an adjective can't. |
| **Too many instructions** | "Be accurate. Be clear. Use correct grammar. Don't make mistakes. Be thorough. Be concise. Use simple language. Be scientific..." | "List any genes you can't identify. Don't cite papers I haven't provided." | Past roughly 8 rules, compliance drops. Generic virtues ("be accurate") add nothing the model wasn't already trying to do. Keep only rules it would break without being told. |
| **Contradictory instructions** | "Be comprehensive but brief." | "Cover all four figures. Two sentences per figure." | The weak version forces the model to decide which instruction to break, and you won't know which it chose. The stronger one shows how both goals can be met at once. |
| **Uncheckable quality criteria** | "Make sure everything is correct." | "Mark any statement not directly supported by the data I pasted with [inferred]." | Neither you nor the model can verify "correct." Tagging inferences gives you something concrete to check, and tells you where to focus your review. |
| **Sycophancy: the model agrees with your premise** | "Explain why the upregulation of these inflammatory genes shows that aging drives cardiac inflammation." | "Here are the upregulated genes. What biological themes are present? Give at least two explanations besides inflammation, and say what data would distinguish them." | Models trained on human feedback tend to agree with the user [\[6\]](../llmPrompting/index.md#references). The weak prompt has the conclusion built in, so you will get a defense of it. In research this is the most dangerous pitfall, because the premise is usually your own hypothesis. |
| **Sycophancy: a general fix** | (any prompt that states an interpretation) | Add: "Don't assume claims in my question are correct. If my interpretation isn't supported by the data, say so first." | A sentence you can add to almost any prompt that contains a hypothesis. It gives the model explicit permission to disagree. |

### Biology-specific pitfalls

| Pitfall | Weak prompt | Stronger prompt | Notes |
|---------|-------------|-----------------|-------|
| **Unstated organism** | "What does SOX9 do?" | "What is known about sox9a and sox9b in zebrafish fin regeneration? Separate zebrafish evidence from what's inferred from mammals." | With no organism named, you'll get human biology. The stronger prompt names the species, the paralogs, and the biological context, and asks the model to label where mammalian knowledge is being borrowed. |
| **Ortholog and paralog collapse** | "Here are my killifish DEGs: SOX9, COL1A1, ..." | "These are human orthologs mapped by BLAST from killifish genes. Genes marked \_dup are two killifish paralogs that map to one human symbol; keep them separate." | Teleosts have duplicated genomes, and human-ortholog mapping is often one-to-many. If the model doesn't know the symbols are mapped, it treats them as the human genes and may merge paralogs that behave differently. |
| **Gene symbol ambiguity** | A gene list copied from a spreadsheet, symbols only | "Gene IDs are Ensembl (ENSDARG...). Report both the ID and the current ZFIN symbol." | Symbols are reused across species, renamed over time, and mangled by spreadsheets (the well-known SEPT2-to-date problem [\[7\]](../llmPrompting/index.md#references)). Stable IDs remove the ambiguity, and asking for the convention you want back keeps the output consistent. |
| **Unstated genome build** | "Give me the coordinates of the tert promoter." | "Write code that extracts the region 2 kb upstream of tert from the GRCz11 / Ensembl 110 GTF I'm using." | Coordinates differ between builds, and the model won't say which one it assumed. The stronger version also avoids asking for coordinates from memory: it gets the model to write code that reads them from your annotation. |
| **Unstated software versions** | "Write Seurat code to integrate my samples." | "Write Seurat code to integrate my samples. I'm on Seurat 5.1 and R 4.4; sessionInfo() is pasted below." | Package APIs change between versions (Seurat's integration workflow changed substantially in v5). Without versions, the model may write code for whichever release dominated its training data. |
| **Asking for references from memory** | "Give me 5 papers showing X." | "Here are 5 abstracts I found on PubMed. Summarize what each shows about X and note where they disagree." | Models produce references that look real but don't exist or don't say what's claimed [\[2\]](../llmPrompting/index.md#references). Find papers with a search tool or database; use the model to read and compare them. Verify every citation by opening it. |
| **Asking for numbers from memory** | "What primers should I use for zebrafish actb1?" | "Here's a primer pair from PrimerBank and the transcript sequence. Check GC content, self-complementarity, and whether the amplicon spans an exon junction." | Primer sequences, dilutions, and concentrations are easy to generate plausibly and wrongly. The model is much more reliable checking numbers you provide than supplying them. |
| **Treating fluent interpretation as analysis** | "What pathways are enriched in this gene list?" | "Here are my fgsea results (NES, padj) for Hallmark gene sets. Help me interpret the top five and note which leading-edge genes overlap." | A model can tell a convincing story about any gene list, including a random one. Enrichment is a statistical test: run it, then use the model to help interpret the results. |
| **Sharing data you shouldn't** | Pasting patient identifiers, clinical metadata, or a collaborator's unpublished results | Paste de-identified data with sample codes only, after confirming that hosted AI tools are allowed for this dataset. | Check your institution's policy and any data use agreements first. Prompt quality doesn't matter if the data shouldn't have been shared. |

---

## Before and After

### How to read these examples

Each example shows:

- **Before:** a typical first attempt
- **What typically goes wrong** 
- **After:** an improved version
- **Why it's better**

The tags under each heading list the components used. The improved versions use labeled sections so the components are easy to pick out; Example 4 also shows the same prompt written as prose.

---

### Example 1: Interpreting a differential expression gene list

`TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

**Before**

```text
Here are my top upregulated genes from old vs young fish heart.
What's going on biologically?
[gene list]
```

??? warning "What typically goes wrong"
    - Assumes human or mouse biology.
    - Produces a smooth narrative tying every gene to "aging" and "inflammation."
    - Invents functions for poorly characterized genes.
    - Doesn't separate strong from weak evidence.
    - May mention "studies have shown" with no basis.

**After**

```text
__TASK__
- Group the upregulated genes below into biological themes and
  assess how strongly each theme is supported.

__CONTEXT__
- Organism: Nothobranchius furzeri (turquoise killifish).
- Tissue: whole heart; bulk RNA-seq.
- Comparison: 20-week vs. 6-week males, n = 5 per group; DESeq2,
  padj < 0.05, |log2FC| > 1. 212 genes up; the 40 with largest
  log2FC are listed with values.
- Symbols are human orthologs from a sequence-similarity mapping;
  "_dup" marks genes with two killifish paralogs mapping to one symbol.

__FRAME__
- Distinguish what the gene list shows from what is inferred.
- Treat mammalian functional knowledge as a hypothesis for killifish,
  not a fact.

__CONSTRAINTS__
- At most 5 themes; each must contain at least 3 listed genes.
- For each theme, give one alternative explanation (e.g., change in
  cell-type composition rather than per-cell expression).
- Do not cite literature.
- Do not use the words "clearly" or "demonstrates".

__OUTPUT_FORMAT__
- Markdown table: theme | genes | support (strong/moderate/weak) |
  alternative explanation.
- Then a list titled "Not assigned" with genes you could not
  confidently place.

__FALLBACK__
- If fewer than 3 genes support a theme, do not create the theme.

<genes>
GENE    log2FC   padj
...
</genes>
```

??? success "Why it's better"
    - The organism, mapping caveat, and thresholds are on the record.
    - Alternatives (like composition shifts, a common confound in bulk tissue) are required.
    - Unassignable genes are surfaced instead of hidden.

---

### Example 2: Writing analysis code

`TASK` `CONTEXT` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

**Before**

```text
Write DESeq2 code to compare treatment vs control.
```

??? warning "What typically goes wrong"
    - Guesses file formats and column names.
    - Uses `~ condition` while ignoring your batch or paired structure.
    - Picks a contrast direction you didn't intend.
    - May use functions or arguments from a different package version.
    - Includes no checks.

**After**

```text
__TASK__
- Write an R script that runs DESeq2 on the count matrix and sample
  table described below and exports results for treated vs. control.

__CONTEXT__
- counts.tsv: genes x samples, first column "gene_id" (Ensembl), integers.
- samples.tsv: columns sample_id, condition (control/treated),
  batch (A/B), animal_id. Each animal contributes one control and one
  treated sample (paired design).
- Environment: R 4.4, DESeq2 1.44, apeglm installed. (sessionInfo below.)

__CONSTRAINTS__
- Design must account for the pairing; explain your design formula
  in one comment line.
- Reference level for condition is "control".
- Stop with an informative error if sample IDs don't match between files.
- Use lfcShrink with apeglm for the exported fold changes.
- No tidyverse; base R plus DESeq2 only.

__OUTPUT_FORMAT__
- One R code block, then a short list of any assumptions you made.

__FALLBACK__
- If the design as described is not full rank, say so and explain why
  instead of writing code that will fail.

<sessionInfo>
...
</sessionInfo>
```

??? success "Why it's better"
    - The pairing, reference level, and versions are explicit.
    - The script fails loudly on mismatched IDs.
    - The model is told to object rather than silently "fix" a bad design (for instance, if `batch` is nested within `animal_id`).

---

### Example 3: Extracting methods from papers into a table

`TASK` `CONSTRAINTS` `OUTPUT FORMAT` `EXAMPLES` `FALLBACK`

This example omits CONTEXT, AUDIENCE, and STYLE: it's a machine-readable extraction, so format and rules do the work.

**Before**

```text
Summarize the methods of these papers.
```

??? warning "What typically goes wrong"
    - Inconsistent detail per paper.
    - Fills gaps with "typical" values (e.g., assumes a read length).
    - Merges papers together.

**After**

```text
__TASK__
- For each paper below, extract the fields listed in OUTPUT FORMAT.

__CONSTRAINTS__
- Use only information stated in the provided text.
- If a field is not stated, use null. Never infer or use typical values.
- Copy organism and tissue names as written.

__OUTPUT_FORMAT__
- JSON array; one object per paper with keys:
  paper_id, organism, tissue, assay, platform, read_length,
  n_per_group, aligner, de_method
- No text outside the JSON.

__EXAMPLES__
Input: "...libraries were sequenced on a NovaSeq 6000 (2x150 bp) and
        aligned with STAR; differential expression used edgeR..."
Output: {"paper_id": "1", "organism": null, "tissue": null,
         "assay": "RNA-seq", "platform": "NovaSeq 6000",
         "read_length": "2x150", "n_per_group": null,
         "aligner": "STAR", "de_method": "edgeR"}

__FALLBACK__
- If a document is not a primary research article, return
  {"paper_id": "<id>", "error": "not_primary_research"}.

<paper id="1"> ... </paper>
<paper id="2"> ... </paper>
```

??? success "Why it's better"
    - Null-instead-of-guess is explicit and demonstrated.
    - Output can go straight into a spreadsheet for comparison and be spot-checked.

---

### Example 4: Troubleshooting a bench protocol

`TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT`

**Before**

```text
My qPCR isn't working. What should I do?
```

??? warning "What typically goes wrong"
    - A generic list of every possible cause.
    - No prioritization.
    - Nothing specific to what you observed.

**After**

```text
__TASK__
- Rank the most likely causes of the result below and suggest a test
  for each.

__CONTEXT__
- SYBR Green qPCR, 20 µL reactions, 40 cycles.
- Target gene: Cq 33–36 in all samples, including the positive
  control cDNA that gave Cq ~24 last month.
- Reference gene on the same plate: normal Cq (~18).
- No-template control: no amplification.
- Same primer aliquot as last month; new cDNA synthesis kit lot.
- Melt curve: single peak for both genes.

__FRAME__
- Reason from the observations given; explain which observation
  supports or rules out each cause.

__CONSTRAINTS__
- At most 5 causes, ranked by likelihood.
- Each test must be doable in one day with standard lab equipment.
- Do not suggest redesigning primers unless the evidence points there.

__OUTPUT_FORMAT__
- Numbered list: cause — evidence for/against — test.
```

**After, written as prose**

```text
I'm running SYBR Green qPCR (20 µL reactions, 40 cycles), and my
target gene is coming up late: Cq 33–36 in every sample, including
the positive control cDNA that gave a Cq of about 24 last month. The
reference gene on the same plate looks normal (Cq ~18), the
no-template control shows no amplification, and both genes give a
single melt peak. I'm using the same primer aliquot as last month,
but this is a new lot of the cDNA synthesis kit.

Based on those observations, what are the most likely causes? Rank
up to five. For each one, tell me which observations support or
argue against it, and suggest a test I can do in a day with standard
lab equipment. Please don't suggest redesigning primers unless the
evidence actually points there.
```

??? success "Why it's better"
    - The details that discriminate between causes are in the prompt: reference gene is fine, NTC is clean, primer aliquot is unchanged, the RT kit lot changed.
    - The model can reason about them instead of listing everything.
    - The structured and prose versions carry the same information and should get comparable answers. The prose version is how most people would naturally describe the problem to a colleague.

---

### Example 5: Annotating single-cell clusters

`TASK` `CONTEXT` `FRAME` `OUTPUT FORMAT` `FALLBACK` `NEGATIVE EXAMPLE`

**Before**

```text
What cell types are these clusters?
[marker table]
```

??? warning "What typically goes wrong"
    - Every cluster gets a confident label, including doublets, low-quality cells, and ambient-RNA artifacts.
    - Labels use mammalian marker logic that may not transfer.

**After**

```text
__TASK__
- Propose a cell type for each cluster from its top markers.

__CONTEXT__
- Single-nucleus RNA-seq, adult fish heart, 10x Chromium.
- Top 15 markers per cluster (avg_log2FC, pct.1, pct.2) below.
- Nuclear transcriptomes: expect more intronic signal and lower
  detection of some cytoplasmic markers than in single-cell data.

__FRAME__
- Base each call on the markers given; name the specific markers used.
- Consider doublets, ambient RNA, and low-quality nuclei as
  possibilities for every cluster, not only odd ones.

__OUTPUT_FORMAT__
- TSV: cluster | proposed_type | key_markers | confidence | concern

__FALLBACK__
- If markers point to two lineages, label "possible doublet: A/B".
- If markers are mostly mitochondrial or ribosomal, label "low quality".
- If unsure, label "unresolved". Do not force a label.

__NEGATIVE_EXAMPLE__
- Bad: "Cluster 7: Cardiomyocytes (high confidence)" when the top
  markers include both cardiomyocyte and endothelial genes.
```

??? success "Why it's better"
    - Unresolved clusters stay unresolved.
    - Nucleus-specific caveats are part of the reasoning.
    - Every label points to the evidence behind it.

---

### Example 6: Drafting a methods paragraph

`TASK` `CONTEXT` `AUDIENCE` `STYLE` `CONSTRAINTS`

**Before**

```text
Write a methods section for my RNA-seq analysis.
```

??? warning "What typically goes wrong"
    - Invents steps, parameters, and software versions you never used.
    - Reads plausibly enough to slip through review.

**After**

```text
__TASK__
- Write a methods paragraph from the analysis notes below.

__CONTEXT__
- My notes (complete; nothing else was done):
<notes>
- Trimmed with fastp 0.23.4, default settings
- Salmon 1.10.2 against Ensembl 110 transcriptome, --validateMappings
- tximport -> DESeq2 1.44, design ~ batch + condition
- padj < 0.05 (BH); apeglm shrinkage
- fgsea on shrunken LFC ranks, MSigDB Hallmark v2024.1
</notes>

__AUDIENCE__
- Reviewers at a molecular biology journal.

__STYLE__
- Past tense; one paragraph; software names with versions in parentheses.

__CONSTRAINTS__
- Include only steps and parameters present in my notes.
- Where a reviewer would expect a detail that's missing (e.g., read
  QC thresholds), insert [MISSING: description] rather than filling it.
```

??? success "Why it's better"
    - The model is restricted to what you actually did.
    - Gaps become visible placeholders instead of fabricated detail.
    
!!! tip "Takeaways"
	Think deeply about each prompt you write to an LLM. They are not omnicient, nor telepathic. 
	
	Misinformation is a symptom of miscomunication!

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
