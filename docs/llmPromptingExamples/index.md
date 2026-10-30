# Part 3: Biology-Specific Pitfalls

> **Workshop Part 3** &nbsp;·&nbsp; ~25 minutes &nbsp;·&nbsp; [Back to the workshop overview](../llmPrompting/index.md)

Small gaps in a prompt lead to large errors in the output. In this part you'll learn to spot common pitfalls, then rewrite weak prompts from the killifish case study. The full pitfall tables are in the [Quick Reference](../llmPromptingGlossary/index.md#common-pitfalls).

---

## Spotting Pitfalls

???+ question "Exercise 3.1 — Name the pitfall"
    Each prompt below has one main problem. Name it, and say what you'd add or change.

    1. "Give me a short summary of this paper."
    2. "What does SOX9 do?"
    3. "Here are my killifish DEGs: SOX9, COL1A1, FN1, ..."
    4. "Give me 5 papers showing that complement activation drives heart aging."
    5. "What primers should I use for zebrafish actb1?"
    6. "What pathways are enriched in this gene list?"

    ??? success "Answers"
        | # | Pitfall | Fix |
        |---|---------|-----|
        | 1 | **Vague quantity:** "short" means different things to different readers. | Give a number: "3 sentences, under 80 words." |
        | 2 | **Unstated organism:** you'll get human biology. | Name the species, paralogs, and context, e.g. *sox9a* and *sox9b* in zebrafish fin regeneration. |
        | 3 | **Ortholog and paralog collapse:** the model treats mapped symbols as the human genes. | Say the symbols are human orthologs and which ones are merged paralogs. |
        | 4 | **References from memory:** models produce citations that look real but don't exist [\[2\]](../llmPrompting/index.md#references). | Find papers in PubMed yourself; paste the abstracts and ask the model to compare them. |
        | 5 | **Numbers from memory:** sequences are easy to generate plausibly and wrongly. | Paste a primer pair from a database and ask the model to *check* it. |
        | 6 | **Fluent interpretation as analysis:** a model can tell a story about any gene list, even a random one. | Run an enrichment test first, then ask for help interpreting the results. |

???+ question "Exercise 3.2 — The model agrees with you"
    Run each prompt in a **new chat**, pasting [`killifish_heart_DEGs.csv`](../llmPrompting/data/killifish_heart_DEGs.csv) underneath. Compare the two answers.

    ```text
    Explain why the upregulation of these inflammatory genes shows that
    aging drives cardiac inflammation in the killifish heart.
    ```

    ```text
    Here are the genes upregulated in 20-week vs 6-week killifish hearts.
    What biological themes are present? Give at least two explanations
    besides inflammation, and say what data would distinguish them.
    ```

    ??? success "What to look for"
        The first prompt has its conclusion built in, so you'll usually get a confident defense of it. Models trained on human feedback tend to agree with the user [\[6\]](../llmPrompting/index.md#references). The second prompt typically surfaces alternatives, such as fibrosis and matrix remodeling, cardiac stress (*NPPA*, *NPPB*), or a shift in cell-type composition rather than per-cell expression.

        This is the most dangerous pitfall in research, because the premise is usually your own hypothesis. Add this to any prompt that states an interpretation: *"Don't assume claims in my question are correct. If my interpretation isn't supported by the data, say so first."*

???+ question "Check Your Understanding"
    Your prompt ends with "Be thorough." Why is that a weak constraint, and what would you write instead?

    ??? success "Answer"
        Neither you nor the model can check whether "thorough" was met, and the model was already trying to be helpful. Replace it with something testable: "Cover every gene in the list," "Mark any statement not supported by the data with [inferred]," or "List genes you couldn't place under 'unassigned'."

---

## Rewriting Weak Prompts

Each exercise shows a typical first attempt. Write your own version, run **both** in your LLM, and compare the answers. Check your version with the [rubric](../llmPromptingComponents/index.md#rubric) before opening the suggested version.

???+ question "Exercise 3.3 — Interpret the gene list"
    `TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

    **Before**

    ```text
    Here are my top upregulated genes from old vs young fish heart.
    What's going on biologically?
    [paste killifish_heart_DEGs.csv]
    ```

    ??? warning "What typically goes wrong"
        - Assumes human or mouse biology.
        - Produces a smooth narrative tying every gene to "aging" and "inflammation."
        - Invents functions for poorly characterized genes such as `LOC_SIM_001`.
        - Doesn't separate strong from weak evidence.

    **Your turn:** start from the prompt you saved in Exercise 2.2. Run it and the Before prompt, then compare.

    ??? example "One possible version"
        ```text
        __TASK__
        - Group the upregulated genes below into biological themes and
          assess how strongly each theme is supported.

        __CONTEXT__
        - Organism: Nothobranchius furzeri (turquoise killifish).
        - Tissue: whole heart; bulk RNA-seq.
        - Comparison: 20-week vs. 6-week males, n = 5 per group; DESeq2,
          padj < 0.05, log2FC > 1. All 40 upregulated genes are listed.
        - Symbols are human orthologs from a sequence-similarity mapping;
          "_dup" marks genes with two killifish paralogs mapping to one symbol.
          LOC_SIM genes have no human ortholog.

        __FRAME__
        - Distinguish what the gene list shows from what is inferred.
        - Treat mammalian functional knowledge as a hypothesis for killifish,
          not a fact.

        __CONSTRAINTS__
        - At most 5 themes; each must contain at least 3 listed genes.
        - For each theme, give one alternative explanation (e.g., change in
          cell-type composition rather than per-cell expression).
        - Do not cite literature.

        __OUTPUT_FORMAT__
        - Markdown table: theme | genes | support (strong/moderate/weak) |
          alternative explanation.
        - Then a list titled "Not assigned" with genes you could not
          confidently place.

        __FALLBACK__
        - Do not guess a function for LOC_SIM genes; list them under
          "Not assigned".

        <genes>
        [paste killifish_heart_DEGs.csv]
        </genes>
        ```

    ??? success "Why it's better"
        - The organism, mapping caveat, and thresholds are on the record.
        - Alternatives (like composition shifts, a common confound in bulk tissue) are required.
        - Unassignable genes are surfaced instead of hidden.

!!! abstract "Pair activity — Prompt swap"
    Swap your Exercise 3.3 prompt with a partner. Score each other's prompt against the [rubric](../llmPromptingComponents/index.md#rubric): which component is missing or weakest? Then run both prompts and compare the answers. Did the better-scoring prompt get the better answer?

???+ question "Exercise 3.4 — Write the analysis code"
    `TASK` `CONTEXT` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

    **Before**

    ```text
    Write DESeq2 code to compare old vs young.
    ```

    ??? warning "What typically goes wrong"
        - Guesses file formats and column names.
        - Uses `~ condition` while ignoring the batch structure.
        - Picks a contrast direction you didn't intend.
        - May use functions or arguments from a different package version.
        - Includes no checks.

    **Your turn:** write a better prompt using [`samples.tsv`](../llmPrompting/data/samples.tsv) and [`methods_notes.txt`](../llmPrompting/data/methods_notes.txt). You don't need a count matrix or to run the code; read what comes back and check it against what you asked for.

    ??? example "One possible version"
        ```text
        __TASK__
        - Write an R script that runs DESeq2 on the count matrix and sample
          table described below and exports results for 20 vs. 6 weeks.

        __CONTEXT__
        - counts.tsv: genes x samples, first column "gene_id", integers.
        - samples.tsv: columns sample_id, age_weeks (6/20), sex (all M),
          batch (A/B). Pasted below.
        - Environment: R 4.4, DESeq2 1.44, apeglm installed.

        __CONSTRAINTS__
        - The design must account for batch; explain the formula in one
          comment line.
        - Reference level for age is 6 weeks.
        - Stop with an informative error if sample IDs don't match between files.
        - Use lfcShrink with apeglm for the exported fold changes.
        - No tidyverse; base R plus DESeq2 only.

        __OUTPUT_FORMAT__
        - One R code block, then a short list of any assumptions you made.

        __FALLBACK__
        - If the design as described is not full rank, say so and explain why
          instead of writing code that will fail.

        <samples>
        [paste samples.tsv]
        </samples>
        ```

    ??? success "Why it's better"
        - The batch term, reference level, and versions are explicit.
        - The script fails loudly on mismatched IDs.
        - The model is told to object rather than silently "fix" a bad design (for instance, if batch were completely confounded with age).

???+ question "Exercise 3.5 — Draft the methods paragraph"
    `TASK` `CONTEXT` `AUDIENCE` `STYLE` `CONSTRAINTS`

    **Before**

    ```text
    Write a methods section for my RNA-seq analysis.
    ```

    ??? warning "What typically goes wrong"
        - Invents steps, parameters, and software versions you never used.
        - Reads plausibly enough to slip through review.

    **Your turn:** write a better prompt using [`methods_notes.txt`](../llmPrompting/data/methods_notes.txt). Check the result line by line against the notes. Did anything appear that isn't in them?

    ??? example "One possible version"
        ```text
        __TASK__
        - Write a methods paragraph from the analysis notes below.

        __CONTEXT__
        - My notes are complete; nothing else was done.

        __AUDIENCE__
        - Reviewers at a molecular biology journal.

        __STYLE__
        - Past tense; one paragraph; software names with versions in parentheses.

        __CONSTRAINTS__
        - Include only steps and parameters present in my notes.
        - Where a reviewer would expect a detail that's missing (e.g., read
          QC thresholds), insert [MISSING: description] rather than filling it.

        <notes>
        [paste methods_notes.txt]
        </notes>
        ```

    ??? success "Why it's better"
        - The model is restricted to what you actually did.
        - Gaps become visible placeholders instead of fabricated detail.

---

!!! success "Key Points — Biology-Specific Pitfalls"
    - Name the organism, the mapping, the versions, and the design; otherwise the model assumes them.
    - Don't ask for citations or numbers from memory. Give the model sources and ask it to check them.
    - Phrase questions neutrally, or ask the model to challenge your premise.
    - Think carefully about each prompt you write. LLMs are neither omniscient nor telepathic: misinformation is a symptom of miscommunication!

[:octicons-arrow-right-24: Continue to Parts 4–5: Verify & Document](../llmPromptingVerification/index.md){ .md-button .md-button--primary }

---

## Extra Practice (optional)

More before-and-after prompts from other areas of biology, for independent study.

???+ question "Extracting methods from papers into a table"
    `TASK` `CONSTRAINTS` `OUTPUT FORMAT` `EXAMPLES` `FALLBACK`

    **Before**

    ```text
    Summarize the methods of these papers.
    ```

    ??? warning "What typically goes wrong"
        - Inconsistent detail per paper.
        - Fills gaps with "typical" values (e.g., assumes a read length).
        - Merges papers together.

    ??? example "One possible version"
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

???+ question "Troubleshooting a bench protocol"
    `TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT`

    **Before**

    ```text
    My qPCR isn't working. What should I do?
    ```

    ??? warning "What typically goes wrong"
        - A generic list of every possible cause.
        - No prioritization.
        - Nothing specific to what you observed.

    ??? example "One possible version"
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

    ??? example "The same prompt, written as prose"
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
        - The structured and prose versions carry the same information and should get comparable answers.

???+ question "Annotating single-cell clusters"
    `TASK` `CONTEXT` `FRAME` `OUTPUT FORMAT` `FALLBACK` `NEGATIVE EXAMPLE`

    **Before**

    ```text
    What cell types are these clusters?
    [marker table]
    ```

    ??? warning "What typically goes wrong"
        - Every cluster gets a confident label, including doublets, low-quality cells, and ambient-RNA artifacts.
        - Labels use mammalian marker logic that may not transfer.

    ??? example "One possible version"
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

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
