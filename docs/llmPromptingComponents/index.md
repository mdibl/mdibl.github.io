# Prompt Components

- Use the ones the task needs.
- Each one makes one dimension of the request explicit.
- Each one is something you can save and review later.
- Any of them can be written as an ordinary sentence instead of a labeled section.

!!! tip "Explain like I'm five"
	Imagine the LLM you prompt as a student with years of experience behind them, but none of the specifics you know. 
	What information would they need to search for an answer that you trust?

## Components at a glance

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

## TASK

**Required**

What you want done, starting with a verb and naming the output type.

```text
__TASK__
- Extract every reagent, concentration, and incubation time from the
  protocol text below into a table.
```

Useful verbs: *Summarize, Extract, Classify, Compare, Annotate, Draft, Debug, Critique, Propose.*

## CONTEXT

**Required whenever the model couldn't guess it**

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

## FRAME 

**Optional**

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

!!! warning "Act as a..."
	Giving instructions to an LLM on how to act may help sometimes. 
	However, this line of prompt engineering may be most useful for agentic workflows rather than one-shot prompting.

## AUDIENCE 

**Optional - framing device**

Who will read the output. The same correct content fails if pitched at the wrong level.

```text
__AUDIENCE__
- A wet-lab postdoc who knows the biology well but has not used DESeq2.
- Explain statistical terms (shrinkage, padj) in one plain sentence each.
```

## STYLE and TONE 

**Optional - framing device**

- **Style** covers structure and vocabulary.
- **Tone** covers register.
- Specify them separately.
- Both can be replaced or supplemented by providing examples.

```text
__STYLE__
- Methods-section prose; past tense; passive voice acceptable.
__TONE__
- Neutral. Report; do not advocate for the hypothesis.
```

## CONSTRAINTS 

**Required for anything you'll reuse**

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

## OUTPUT FORMAT 

**Required when the output goes into code or a spreadsheet**

The shape of the response. Name fields and types.

```text
__OUTPUT_FORMAT__
- Return a TSV with columns: cluster_id, proposed_cell_type,
  supporting_markers, confidence (high/medium/low).
- No text before or after the table.
```

## EXAMPLES 

**Strongly recommended**

One or more input/output pairs.

- A good example communicates format, level of detail, and edge-case handling at once, better than paragraphs of description [\[3\]](../llmPrompting/index.md#references).
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

## FALLBACK 

**Required for pipelines and agents**

What to do when the input doesn't fit. Without it, the model invents something that fits the format.

```text
__FALLBACK__
- If a gene symbol cannot be mapped to a known gene, return it under
  "unmapped" rather than guessing.
- If markers suggest two cell types, report both with "mixed".
- Prefer "unknown" over a guess.
```

## NEGATIVE EXAMPLE 

**Optional**

Show a bad output to rule out a failure mode precisely.

```text
__NEGATIVE_EXAMPLE__
- Bad: "These genes are involved in many important cellular processes."
  (Too vague; names no genes; untestable.)
```

## A note on "think step by step"

- Asking for explicit step-by-step reasoning (chain of thought) helped older models [\[4\]](../llmPrompting/index.md#references).
- Current frontier models reason internally, and requesting it adds little [\[5\]](../llmPrompting/index.md#references).
- It can still help with smaller or locally run models.
- Either way, record which you did.

---

## Minimal reusable skeleton

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

## The same skeleton as prose

```text
I'd like you to [task, and what form the answer should take]. This is
from [organism], [tissue or sample type], measured by [assay], using
[genome build / software versions]. Please [rules it should follow],
and don't [things it should avoid]. If [something doesn't fit], tell
me that rather than guessing.

[pasted data]
```

!!! tip "Takeaways"
	Structuring prompts is helpful for individuals to ensure they include all the necessary information an LLM needs to avoid guessing as much as possible.

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
