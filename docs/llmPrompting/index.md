# Prompting LLMs for Biological Research

The structure of this guide is modeled on Carnegie Mellon University Libraries' *LLM Documentation Guide* (Gonzalez-Espinoza & Lan, 2026; <https://guides.library.cmu.edu/LLMDocumentationGuide>). The content has been rewritten and adapted for biological research: bench work, genomics and transcriptomics, literature review, and analysis code. It deliberately spends little time on how LLMs work internally and most of its time on what to include in prompts.

---

## 1. Key Terms

Terms that come up throughout this guide and in most discussions of LLM best practices.

**The model and how it is trained**

| Term | Meaning |
|------|---------|
| **LLM (Large Language Model)** | A model trained on very large amounts of text to predict the next piece of text. ChatGPT, Claude, Gemini, and Llama are examples. |
| **Training data** | The text the model learned from. It determines what the model "knows" and what it knows well. |
| **Training cutoff** | The date after which the model saw no training data. Anything newer is unknown to it unless you provide it. |
| **Frontier model** | One of the largest, most capable current models, usually accessed through a company's website or API. |
| **Local model** | A model you download and run on your own hardware. Usually smaller and less capable, but data never leaves your machine. |
| **Token** | The unit of text a model reads and writes, roughly ¾ of an English word. Limits and pricing are counted in tokens. |

**Talking to the model**

| Term | Meaning |
|------|---------|
| **Prompt** | Everything you send the model for a given request: instructions, background, and pasted data. |
| **System prompt** | Standing instructions applied to every request, set by the tool's developer or by you (e.g., a project instruction file). Often hidden in chat interfaces. |
| **Context / context window** | All the text the model can see at once: system prompt, conversation so far, pasted files, and your prompt. The window has a maximum size. |
| **In-context vs. from memory** | Information you paste into the prompt (in-context) is far more reliable than information the model recalls from training (from memory). |
| **Examples (few-shot prompting)** | Sample input/output pairs included in the prompt to show the model what you want. |
| **Chain of thought** | Asking the model to reason step by step before answering. |
| **Temperature** | A setting that controls randomness. Higher values give more varied output; lower values give more repeatable output. |

**Tools and interfaces**

| Term | Meaning |
|------|---------|
| **Interface** | How you reach the model: web chat, API (code), a coding assistant, or a local application. |
| **API** | Programmatic access to a model, typically used in scripts and pipelines. Usually exposes settings that chat interfaces hide. |
| **Tool use / retrieval** | Letting the model search the web, query a database, or read files during a request, so it can look things up instead of recalling them. |
| **Agent** | A model that takes multiple actions on its own (running code, editing files, searching) to complete a task. |

**Failure modes**

| Term | Meaning |
|------|---------|
| **Hallucination / confabulation** | Confident, fluent output that is wrong or invented. See [2. How LLMs Produce Answers](#2-how-llms-produce-answers). |
| **Sycophancy** | The model's tendency to agree with the user, including with a wrong premise. See [7. Common Pitfalls](#7-common-pitfalls). |
| **Prompt hacking** | Rewording a prompt until the output says what you hoped, then reporting only the final version. See [9. Prompts as Research Documentation](#9-prompts-as-research-documentation). |

---

## 2. How LLMs Produce Answers

!!! info "What LLMs are good at, and why"
	- LLMs are versatile tools for generating text, especially:
		- code generation
		- literature review
		- text formatting
	- Their strengths come from their **training data**. Code, optimization strategies, bug fixes, and package documentation are among the most abundant, freely available text on the internet.
	- Biological literature is the opposite: vast in total, but any one topic may be covered by only a handful of papers.

!!! tip "Takeaway"
	Prompts about biology need more care than prompts about more common topics, because the model has less to draw on.

### A working model of how answers are generated

- An LLM produces the **most plausible continuation** of your prompt, based on patterns in its training data.
- Your prompt steers it toward the right part of what it has learned.
- It does **not** look things up unless it has a search or database tool.
- It does **not** know when it has drifted outside what it knows well.

### Hallucinations

- A **hallucination** is confident, fluent output that is wrong or invented.
- They happen when a question reaches the edge of the model's training data.
- At that edge, the model's priority, producing an answer, wins out over admitting it doesn't know. It fills the gap with a plausible **confabulation**.

### An analogy: split-brain confabulation

The split-brain experiments of Roger Sperry and Michael Gazzaniga (1960s–70s) show the same behavior in people [8].

**The setup**

- A last-resort treatment for severe epilepsy is to cut the *corpus callosum*, the bundle of nerves connecting the two brain hemispheres (a corpus callosotomy).
- Afterward, each hemisphere works largely on its own. Speech is handled mostly by the **left** hemisphere.
- Each hemisphere sees the opposite half of the visual field and controls the opposite hand.

**The experiment**

- The left hemisphere (right visual field) was shown a **chicken claw**.
- The right hemisphere (left visual field) was shown a **snow shovel**.
- Asked to point to matching picture cards, the patient's right hand pointed to a chicken and the left hand pointed to a shovel.

**The confabulation**

- The experimenter asked, "Why is your left hand pointing to the shovel?"
- The speaking left hemisphere never saw the shovel, so it had no real answer.
- Instead of saying "I don't know," the patient confidently invented one: *"Oh, that's simple. The chicken claw goes with the chicken, and you need a shovel to clean out the chicken shed."*

**The parallel to LLMs**

- Like the speaking hemisphere, an LLM is expected to explain things it has no information about.
- LLMs are asked to answer *any* question. As on a standardized test, a wrong guess usually costs less than a blank answer.
- So models tend to confabulate details they couldn't possibly know rather than admit they've reached the end of their knowledge.

!!! tip "Your defense is the prompt"
    Supply the information the model lacks, and explicitly allow it to say "unknown."

---

## 3. What LLMs Can and Cannot Do in Biology

The long tail is where biology lives

Models are reliable on things that appear often in their training data and unreliable on things that appear rarely [1]. Biology is full of rarely-written-about things:

- **Non-model organisms.** A killifish, axolotl, or planarian gene will often be described as if it were the human ortholog, with human-specific functions, tissue expression, or disease links carried over.
- **Poorly characterized genes.** For an uncharacterized ORF, lncRNA, or `LOC` identifier, the model may invent a function rather than say "unknown."
- **Recent findings.** Anything after the training cutoff is missing, and the model won't flag the gap unless asked.
- **Specific numbers.** Fold changes, concentrations, primer sequences, Ensembl IDs, and coordinates are easy to generate plausibly and wrongly.
- **Citations.** Models produce references that look real (right journal, plausible authors and year) but do not exist or do not say what's claimed [2]. Never use an LLM-provided citation you haven't opened.

### Where they are genuinely strong

- Restructuring, summarizing, and extracting from text **you provide** (papers, protocols, notes)
- Drafting and debugging analysis code in R, Python, and shell, especially for widely used packages
- Explaining well-established concepts and methods
- Brainstorming alternative explanations, controls, and experimental designs
- Converting between formats (free-text notes to a structured sample sheet, prose to a table)

!!! tip "The practical rule"
    **The more of the answer you put in the context, the more you can trust the output.**

    - Asking a model to summarize a paper you pasted is far more reliable than asking what that paper says from memory.
    - Giving it your actual `sessionInfo()` produces better code than letting it guess your package versions.

The rest of this guide is about how to do that systematically.

---

## 4. Why Prompts Matter

### The model fills gaps with defaults

An LLM only knows what it has been trained on or given explicitly. It has not seen:

- your sample sheet
- which organism you work in
- which genome build your counts came from
- whether "the treated group" means drug, knockout, or age

When those details are missing, the model fills them in with whatever is most typical in its training data. For biology that usually means **human, mouse, or a generic textbook case**.

### Three failure modes

Most bad outputs come from one of three problems. Each is also a record-keeping problem.

| Failure mode | What happens | Why it is also a documentation problem |
|--------------|--------------|----------------------------------------|
| **Missing information** | The model assumes defaults (human, latest genome build, standard protocol) that may not match your system. | If the assumption isn't in the prompt, nobody reviewing the work can see it was made. |
| **Unclear output expectations** | You get the model's favorite format: a long essay when you wanted a table, or a table with invented columns. | There's no standard to judge the output against. |
| **Uncheckable quality criteria** | Instructions like "be thorough" or "be accurate" can't be tested. | Neither the model nor a reviewer can verify they were met. |

A prompt that covers each of these explicitly fixes all three at once.

### Structure is a checklist, not a syntax

Many prompts in this guide use labeled sections like `__TASK__`, `__CONTEXT__`, and `__CONSTRAINTS__`. Before you see one, know how to read them:

- **The labels are for you, not the model.** They are an organizing tool to make sure nothing is left out.
- **The model doesn't require them.** Current models read ordinary prose just as well.
- **The information is what counts.** A labeled prompt and a prose prompt with the same content should get comparable answers.
- **Each label is a component.** All of them are defined in the next section, [5. Prompt Components](#5-prompt-components).

### A first comparison

The same question asked two ways can produce answers that differ more in *correctness* than in polish.

=== "Vague"

    ```text
    What pathways are enriched in this list of genes?
    ```

=== "Specific (labeled)"

    ```text
    __TASK__
    - Summarize the biological themes in the 40 upregulated genes below.

    __CONTEXT__
    - Organism: Zebrafish (Danio rerio).
    - Tissue: Kidney
    - Comparison: Treated (drug) vs. Control (vehicle) males.
    - Gene symbols are human orthologs mapped by sequence similarity;
      some mappings are one-to-many.

    __CONSTRAINTS__
    - Group genes into at most 5 functional pathways; name the genes in each.
    - Do not claim a function for any gene you are not confident about;
      list those under "uncertain" instead.
    - Cite papers with evidence for claims made.
    - Cite papers with evidence in the contrary of claims made if any exist.
    ```

=== "Specific (prose)"

    ```text
    Below are 40 genes upregulated in kidney from treated (drug) versus
    control (vehicle) male zebrafish (Danio rerio). The gene symbols are
    human orthologs mapped by sequence similarity, so some mappings are
    one-to-many. Please group the genes into no more than five biological
    functional pathways and name the genes in each. If you aren't confident about a
    gene's function, don't assign it to a theme; list it under
    "uncertain" instead. Cite papers with evidence for the claims you
    make, and cite papers with contrary evidence if any exist.
    ```

**What you get back**

- The vague prompt gets a confident, generic paragraph.
- Both specific versions get an answer that is scoped to the right organism and tissue, states what it doesn't know, and can be checked line by line.
- The two specific versions carry the same information: organism, tissue, how the genes were mapped, and what "uncertain" should look like. These are exactly the details that are rare or absent in training data, and that the model would otherwise fill in with defaults.

### Prose or labeled sections?

Use whichever form you find easier to write and read. As a rough guide:

| Write it as prose when... | Use labeled sections when... |
|---------------------------|------------------------------|
| You're asking a one-off question in a chat window | The prompt is long, or mixes instructions with pasted data |
| The request is conversational or iterative | The prompt will be reused, shared, or run in a pipeline |
| Your readers aren't used to structured prompts | You want to compare versions of a prompt in a log or diff |

Either way, run through the components in the next section before you send a prompt and ask whether each one is covered.

---

## 5. Prompt Components

These are building blocks, not a mandatory checklist.

- Use the ones the task needs.
- Each one makes one dimension of the request explicit.
- Each one is something you can save and review later.
- Any of them can be written as an ordinary sentence instead of a labeled section.

### Components at a glance

The table turns each component into a question to ask yourself before sending a prompt, with a prose version of each.

| Component | Question to ask yourself | Written as prose |
|-----------|--------------------------|------------------|
| TASK | Have I said what I want done, and in what form? | "Please group these genes into themes..." |
| CONTEXT | Have I given every fact about my system the model couldn't guess? | "These are from adult zebrafish kidney, treated vs. control..." |
| FRAME | Have I said how it should reason? | "Keep what the data show separate from what you're inferring." |
| AUDIENCE | Have I said who will read this? | "This is for a wet-lab colleague who hasn't used DESeq2." |
| STYLE / TONE | Have I said how it should read? | "Write it as a methods paragraph, past tense, neutral." |
| CONSTRAINTS | Have I stated the rules it would otherwise break? | "No more than five functional pathways, and don't cite anything I didn't give you." |
| OUTPUT FORMAT | If this goes into code or a spreadsheet, have I given the exact shape? | "Return a table with columns cluster, cell type, markers, confidence." |
| EXAMPLES | Would one worked example save a paragraph of explanation? | "For instance, 'S7 WT 72' should become..." |
| FALLBACK | Have I said what to do when the input doesn't fit? | "If you can't identify a gene, say so rather than guessing." |

### TASK (required)

What you want done, starting with a verb and naming the output type.

```text
__TASK__
- Extract every reagent, concentration, and incubation time from the
  protocol text below into a table.
```

Useful verbs: *Summarize, Extract, Classify, Compare, Annotate, Draft, Debug, Critique, Propose.*

### CONTEXT (required whenever the model couldn't guess it)

Background facts about your system. For biology, this is where most quality gains come from.

```text
__CONTEXT__
- Organism: Danio rerio; genome build GRCz11, Ensembl release 110.
- Assay: bulk RNA-seq, poly-A selected, 150 bp PE, ~30M reads/sample.
- Design: 3 timepoints (24, 48, 72 hpf) x 2 genotypes, n = 4 per group.
- Counts produced by a sequencing vendor's pipeline; we have the raw count matrix only.
```

**Custom fields help for recurring work.** If you often work in one domain, invent sections that match it:

```text
__ORGANISM__      __TISSUE__       __ASSAY__
__GENOME_BUILD__  __SOFTWARE_ENV__ __DESIGN__
```

### FRAME (optional; use instead of "act as a...")

How to reason, rather than who to pretend to be.

- "You are an expert immunologist" doesn't give the model any expertise; it changes the style of the language.
- A frame states checkable reasoning rules instead.

```text
__FRAME__
- Reason as a reviewer of a methods section would: separate what the
  data show from what is being inferred.
- Treat any claim about gene function in a non-model organism as
  provisional unless supported by the data provided.
- Report uncertainty explicitly; do not smooth it over.
```

Self-check: if the line describes a *character*, rewrite it as a *rule*.

### AUDIENCE (often required)

Who will read the output. The same correct content fails if pitched at the wrong level.

```text
__AUDIENCE__
- A wet-lab postdoc who knows the biology well but has not used DESeq2.
- Explain statistical terms (shrinkage, padj) in one plain sentence each.
```

### STYLE and TONE (for anything a person reads)

- **Style** covers structure and vocabulary.
- **Tone** covers register.
- Specify them separately.

```text
__STYLE__
- Methods-section prose; past tense; passive voice acceptable.
__TONE__
- Neutral. Report; do not advocate for the hypothesis.
```

### CONSTRAINTS (required for anything you'll reuse)

Rules for content.

- Write them as separate "do" and "do not" lists.
- Keep each one measurable.
- Keep the list short (roughly 8 or fewer).

```text
__CONSTRAINTS__
- Do: use HGNC symbols for human genes and ZFIN conventions for zebrafish.
- Do: state which genes you could not identify.
- Do not: cite papers or databases you were not given.
- Do not: infer direction of change from gene names alone.
- Length: under 250 words.
```

### OUTPUT FORMAT (required when the output goes into code or a spreadsheet)

The shape of the response. Name fields and types.

```text
__OUTPUT_FORMAT__
- Return a TSV with columns: cluster_id, proposed_cell_type,
  supporting_markers, confidence (high/medium/low).
- No text before or after the table.
```

### EXAMPLES (strongly recommended)

One or more input/output pairs.

- A good example communicates format, level of detail, and edge-case handling at once, better than paragraphs of description [3].
- Include at least one awkward case.
- Put the most typical example last.

```text
__EXAMPLES__
Input:  "Sample 3 - 48hpf mut, re-extracted after low RIN (6.1)"
Output: {"timepoint": "48hpf", "genotype": "mut", "rin": 6.1,
         "notes": "re-extracted"}

Input:  "S7 WT 72"
Output: {"timepoint": "72hpf", "genotype": "WT", "rin": null,
         "notes": null}
```

### FALLBACK (required for pipelines and agents)

What to do when the input doesn't fit. Without it, the model invents something that fits the format.

```text
__FALLBACK__
- If a gene symbol cannot be mapped to a known gene, return it under
  "unmapped" rather than guessing.
- If markers suggest two cell types, report both with "mixed".
- Prefer "unknown" over a guess.
```

### NEGATIVE EXAMPLE (optional)

Show a bad output to rule out a failure mode precisely.

```text
__NEGATIVE_EXAMPLE__
- Bad: "These genes are involved in many important cellular processes."
  (Too vague; names no genes; untestable.)
```

### A note on "think step by step"

- Asking for explicit step-by-step reasoning (chain of thought) helped older models [4].
- Current frontier models reason internally, and requesting it adds little [5].
- It can still help with smaller or locally run models.
- Either way, record which you did.

---

## 6. Prompt Examples: Before and After

### How to read these examples

Each example shows:

- **Before:** a typical first attempt
- **After:** an improved version
- **What typically goes wrong** 
- **Why it's better**

The tags under each heading list the components used. The improved versions use labeled sections so the components are easy to pick out; Example 4 also shows the same prompt written as prose.

---

### Example 1: Interpreting a differential expression gene list

`TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

=== "Before"

    ```text
    Here are my top upregulated genes from old vs young fish heart.
    What's going on biologically?
    [gene list]
    ```

=== "After"

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

??? warning "What typically goes wrong"
    - Assumes human or mouse biology.
    - Produces a smooth narrative tying every gene to "aging" and "inflammation."
    - Invents functions for poorly characterized genes.
    - Doesn't separate strong from weak evidence.
    - May mention "studies have shown" with no basis.

??? success "Why it's better"
    - The organism, mapping caveat, and thresholds are on the record.
    - Alternatives (like composition shifts, a common confound in bulk tissue) are required.
    - Unassignable genes are surfaced instead of hidden.

---

### Example 2: Writing analysis code

`TASK` `CONTEXT` `CONSTRAINTS` `OUTPUT FORMAT` `FALLBACK`

=== "Before"

    ```text
    Write DESeq2 code to compare treatment vs control.
    ```

=== "After"

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

??? warning "What typically goes wrong"
    - Guesses file formats and column names.
    - Uses `~ condition` while ignoring your batch or paired structure.
    - Picks a contrast direction you didn't intend.
    - May use functions or arguments from a different package version.
    - Includes no checks.

??? success "Why it's better"
    - The pairing, reference level, and versions are explicit.
    - The script fails loudly on mismatched IDs.
    - The model is told to object rather than silently "fix" a bad design (for instance, if `batch` is nested within `animal_id`).

---

### Example 3: Extracting methods from papers into a table

`TASK` `CONSTRAINTS` `OUTPUT FORMAT` `EXAMPLES` `FALLBACK`

This example omits CONTEXT, AUDIENCE, and STYLE: it's a machine-readable extraction, so format and rules do the work.

=== "Before"

    ```text
    Summarize the methods of these papers.
    ```

=== "After"

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

??? warning "What typically goes wrong"
    - Inconsistent detail per paper.
    - Fills gaps with "typical" values (e.g., assumes a read length).
    - Merges papers together.

??? success "Why it's better"
    - Null-instead-of-guess is explicit and demonstrated.
    - Output can go straight into a spreadsheet for comparison and be spot-checked.

---

### Example 4: Troubleshooting a bench protocol

`TASK` `CONTEXT` `FRAME` `CONSTRAINTS` `OUTPUT FORMAT`

=== "Before"

    ```text
    My qPCR isn't working. What should I do?
    ```

=== "After"

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

=== "After (prose)"

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

??? warning "What typically goes wrong"
    - A generic list of every possible cause.
    - No prioritization.
    - Nothing specific to what you observed.

??? success "Why it's better"
    - The details that discriminate between causes are in the prompt: reference gene is fine, NTC is clean, primer aliquot is unchanged, the RT kit lot changed.
    - The model can reason about them instead of listing everything.
    - The structured and prose versions carry the same information and should get comparable answers. The prose version is how most people would naturally describe the problem to a colleague.

---

### Example 5: Annotating single-cell clusters

`TASK` `CONTEXT` `FRAME` `OUTPUT FORMAT` `FALLBACK` `NEGATIVE EXAMPLE`

=== "Before"

    ```text
    What cell types are these clusters?
    [marker table]
    ```

=== "After"

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

??? warning "What typically goes wrong"
    - Every cluster gets a confident label, including doublets, low-quality cells, and ambient-RNA artifacts.
    - Labels use mammalian marker logic that may not transfer.

??? success "Why it's better"
    - Unresolved clusters stay unresolved.
    - Nucleus-specific caveats are part of the reasoning.
    - Every label points to the evidence behind it.

---

### Example 6: Drafting a methods paragraph

`TASK` `CONTEXT` `AUDIENCE` `STYLE` `CONSTRAINTS`

=== "Before"

    ```text
    Write a methods section for my RNA-seq analysis.
    ```

=== "After"

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

??? warning "What typically goes wrong"
    - Invents steps, parameters, and software versions you never used.
    - Reads plausibly enough to slip through review.

??? success "Why it's better"
    - The model is restricted to what you actually did.
    - Gaps become visible placeholders instead of fabricated detail.

---

## 7. Common Pitfalls

Each row pairs a weak prompt with a stronger one. The notes column explains what makes the difference.

### General pitfalls

| Pitfall | Weak prompt | Stronger prompt | Notes |
|---------|-------------|-----------------|-------|
| **Vague quantities** | "Give me a short summary." | "Summarize in 3 sentences, under 80 words." | "Short" means different things to different readers, and the model will pick its own default. A number can be checked; an adjective can't. |
| **Too many instructions** | "Be accurate. Be clear. Use correct grammar. Don't make mistakes. Be thorough. Be concise. Use simple language. Be scientific..." | "List any genes you can't identify. Don't cite papers I haven't provided." | Past roughly 8 rules, compliance drops. Generic virtues ("be accurate") add nothing the model wasn't already trying to do. Keep only rules it would break without being told. |
| **Contradictory instructions** | "Be comprehensive but brief." | "Cover all four figures. Two sentences per figure." | The weak version forces the model to decide which instruction to break, and you won't know which it chose. The stronger one shows how both goals can be met at once. |
| **Uncheckable quality criteria** | "Make sure everything is correct." | "Mark any statement not directly supported by the data I pasted with [inferred]." | Neither you nor the model can verify "correct." Tagging inferences gives you something concrete to check, and tells you where to focus your review. |
| **Sycophancy: the model agrees with your premise** | "Explain why the upregulation of these inflammatory genes shows that aging drives cardiac inflammation." | "Here are the upregulated genes. What biological themes are present? Give at least two explanations besides inflammation, and say what data would distinguish them." | Models trained on human feedback tend to agree with the user [6]. The weak prompt has the conclusion built in, so you will get a defense of it. In research this is the most dangerous pitfall, because the premise is usually your own hypothesis. |
| **Sycophancy: a general fix** | (any prompt that states an interpretation) | Add: "Don't assume claims in my question are correct. If my interpretation isn't supported by the data, say so first." | A sentence you can add to almost any prompt that contains a hypothesis. It gives the model explicit permission to disagree. |

### Biology-specific pitfalls

| Pitfall | Weak prompt | Stronger prompt | Notes |
|---------|-------------|-----------------|-------|
| **Unstated organism** | "What does SOX9 do?" | "What is known about sox9a and sox9b in zebrafish fin regeneration? Separate zebrafish evidence from what's inferred from mammals." | With no organism named, you'll get human biology. The stronger prompt names the species, the paralogs, and the biological context, and asks the model to label where mammalian knowledge is being borrowed. |
| **Ortholog and paralog collapse** | "Here are my killifish DEGs: SOX9, COL1A1, ..." | "These are human orthologs mapped by BLAST from killifish genes. Genes marked \_dup are two killifish paralogs that map to one human symbol; keep them separate." | Teleosts have duplicated genomes, and human-ortholog mapping is often one-to-many. If the model doesn't know the symbols are mapped, it treats them as the human genes and may merge paralogs that behave differently. |
| **Gene symbol ambiguity** | A gene list copied from a spreadsheet, symbols only | "Gene IDs are Ensembl (ENSDARG...). Report both the ID and the current ZFIN symbol." | Symbols are reused across species, renamed over time, and mangled by spreadsheets (the well-known SEPT2-to-date problem [7]). Stable IDs remove the ambiguity, and asking for the convention you want back keeps the output consistent. |
| **Unstated genome build** | "Give me the coordinates of the tert promoter." | "Write code that extracts the region 2 kb upstream of tert from the GRCz11 / Ensembl 110 GTF I'm using." | Coordinates differ between builds, and the model won't say which one it assumed. The stronger version also avoids asking for coordinates from memory: it gets the model to write code that reads them from your annotation. |
| **Unstated software versions** | "Write Seurat code to integrate my samples." | "Write Seurat code to integrate my samples. I'm on Seurat 5.1 and R 4.4; sessionInfo() is pasted below." | Package APIs change between versions (Seurat's integration workflow changed substantially in v5). Without versions, the model may write code for whichever release dominated its training data. |
| **Asking for references from memory** | "Give me 5 papers showing X." | "Here are 5 abstracts I found on PubMed. Summarize what each shows about X and note where they disagree." | Models produce references that look real but don't exist or don't say what's claimed [2]. Find papers with a search tool or database; use the model to read and compare them. Verify every citation by opening it. |
| **Asking for numbers from memory** | "What primers should I use for zebrafish actb1?" | "Here's a primer pair from PrimerBank and the transcript sequence. Check GC content, self-complementarity, and whether the amplicon spans an exon junction." | Primer sequences, dilutions, and concentrations are easy to generate plausibly and wrongly. The model is much more reliable checking numbers you provide than supplying them. |
| **Treating fluent interpretation as analysis** | "What pathways are enriched in this gene list?" | "Here are my fgsea results (NES, padj) for Hallmark gene sets. Help me interpret the top five and note which leading-edge genes overlap." | A model can tell a convincing story about any gene list, including a random one. Enrichment is a statistical test: run it, then use the model to help interpret the results. |
| **Sharing data you shouldn't** | Pasting patient identifiers, clinical metadata, or a collaborator's unpublished results | Paste de-identified data with sample codes only, after confirming that hosted AI tools are allowed for this dataset. | Check your institution's policy and any data use agreements first. Prompt quality doesn't matter if the data shouldn't have been shared. |

---

## 8. Verifying Output

A well-written prompt makes output *checkable*. You still have to check it.

### Match the check to the claim

| Output type | Check against |
|-------------|---------------|
| Gene identity, function | Ensembl, NCBI Gene, UniProt, organism databases (ZFIN, FlyBase, WormBase, MGI) |
| Citations | Open the paper via PubMed or DOI and confirm it says what's claimed |
| Pathway or enrichment claims | A formal enrichment test on your data, not the model's narrative |
| Code | Run it on a small known dataset; inspect intermediate objects; check against package documentation |
| Numbers (concentrations, sequences) | Original protocol, datasheet, or primer database |
| Extractions from documents | Spot-check a random sample of records against the source |

### For repeated or pipeline use

- Run the same prompt over a representative set of inputs, including awkward ones.
- Check that the outputs are consistent before trusting the prompt at scale.
- Record that you did (see the next section).

---

## 9. Prompts as Research Documentation

If an LLM touches your research, the prompt is part of your methods. Treat it like a protocol or an analysis script. This applies when you use an LLM for:

- annotating cell clusters
- summarizing literature
- drafting code
- extracting metadata
- interpreting enrichment results

!!! warning "The prompt-hacking problem"
    - Rewording a prompt until the output says what you hoped, then reporting only the final version, is the LLM equivalent of trying analyses until p \< 0.05.
    - If you iterated, record the iterations.

### Minimum record for any research use

| Field | Example | Why |
|-------|---------|-----|
| Model and version | `Claude Opus 4.5`, `GPT-5.1`, accessed 2026-10-21 | Behavior changes between releases. |
| Interface | Web chat / API / Claude Code / local model | Chat interfaces often hide settings and may add their own system instructions. |
| Full prompt text | Saved verbatim, version-controlled with the analysis code | Paraphrases aren't reproducible. |
| Inputs | Exact gene list, file hash, or document version given to the model | Same prompt + different input = different experiment. |
| Iteration notes | What changed between versions and why | Your lab notebook entry for the prompt. |
| Validation | How outputs were checked (see [8. Verifying Output](#8-verifying-output)) | Shows the output was not taken on trust. |

### A prompt log template

Keep something like this next to your analysis scripts (e.g., `prompts/2026-10-21_cluster_annotation.md`):

```markdown
## Prompt log: snRNA-seq cluster annotation, v3
- Date: 2026-10-21
- Model: <name, version>   Interface: <web/API>   Temp: <value or "not exposed">
- Input: top 20 markers per cluster, file markers_res0.6.csv (md5: ...)
- Change from v2: added __FALLBACK__ for clusters with mixed markers;
  v2 forced a label on every cluster, including obvious doublets.
- Validation: labels compared against canonical markers in panglaoDB and
  manual review; 2 of 14 clusters disagreed, kept as "unresolved".
- Prompt: (full text below)
```

### System instructions and project files

The same rules apply, at greater scale, to anything that shapes every response:

- a system prompt for a lab chatbot
- a project instruction file
- an `AGENTS.md` or `CLAUDE.md` for a coding agent

Version and archive these like code. They define what the tool was designed to do, and what it does when input falls outside that design.

---

### Minimal reusable skeleton

```text
__TASK__
-

__CONTEXT__
- Organism:
- Sample / tissue:
- Assay / data type:
- Genome build / software versions:

__CONSTRAINTS__
- Do:
- Do not:

__OUTPUT_FORMAT__
-

__FALLBACK__
- If ..., return ... rather than guessing.

<data>
...
</data>
```

### The same skeleton as prose

```text
I'd like you to [task, and what form the answer should take]. This is
from [organism], [tissue or sample type], measured by [assay], using
[genome build / software versions]. Please [rules it should follow],
and don't [things it should avoid]. If [something doesn't fit], tell
me that rather than guessing.

[pasted data]
```

### Citing LLM use

Follow your target journal's policy and see CMU Libraries' guide to citing generative AI: <https://guides.library.cmu.edu/CitationManagement/GenerativeAI>

---

## 10. References

**Guide this document is modeled on**

- Gonzalez-Espinoza, A., & Lan, H. (2026). *LLM Documentation Guide*. Carnegie Mellon University Libraries. <https://guides.library.cmu.edu/LLMDocumentationGuide>

**Cited works**

1. Mallen, A., et al. (2023). When Not to Trust Language Models: Investigating Effectiveness of Parametric and Non-Parametric Memories. ACL 2023. [arXiv:2212.10511](https://arxiv.org/abs/2212.10511)
2. Walters, W. H., & Wilder, E. I. (2023). Fabrication and errors in the bibliographic citations generated by ChatGPT. *Scientific Reports*, 13, 14045. [doi:10.1038/s41598-023-41032-5](https://doi.org/10.1038/s41598-023-41032-5)
3. Brown, T. B., et al. (2020). Language Models are Few-Shot Learners. NeurIPS 2020. [arXiv:2005.14165](https://arxiv.org/abs/2005.14165)
4. Wei, J., et al. (2022). Chain-of-Thought Prompting Elicits Reasoning in Large Language Models. NeurIPS 2022. [arXiv:2201.11903](https://arxiv.org/abs/2201.11903)
5. Meincke, L., et al. (2025). Prompting Science Report 2: The Decreasing Value of Chain of Thought. Wharton. [SSRN:5285532](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5285532)
6. Sharma, M., et al. (2023). Towards Understanding Sycophancy in Language Models. ICLR 2024. [arXiv:2310.13548](https://arxiv.org/abs/2310.13548)
7. Ziemann, M., Eren, Y., & El-Osta, A. (2016). Gene name errors are widespread in the scientific literature. *Genome Biology*, 17, 177. [doi:10.1186/s13059-016-1044-7](https://doi.org/10.1186/s13059-016-1044-7)
8. Volz, L. J., & Gazzaniga, M. S. (2017). Interaction in isolation: 50 years of insights from split-brain research. *Brain*, 140(7), 2051–2060. [doi:10.1093/brain/awx139](https://doi.org/10.1093/brain/awx139)

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
