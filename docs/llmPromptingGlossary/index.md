# Quick Reference & Glossary

Everything you need to write, check, and record a prompt, in one place. Keep this page open while you work.

<a href="quickref.pdf" download class="md-button md-button--primary">:material-download: Download Quick Reference (PDF)</a>

---

## Prompt Skeleton

Copy whichever version you find easier to write. Both carry the same information.

**Labeled sections**

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

**Prose**

```text
I'd like you to [task, and what form the answer should take]. This is
from [organism], [tissue or sample type], measured by [assay], using
[genome build / software versions]. Please [rules it should follow],
and don't [things it should avoid]. If [something doesn't fit], tell
me that rather than guessing.

[pasted data]
```

---

## Rubric

| Component | Ask yourself |
|-----------|--------------|
| **TASK** | Did I say what I want done, starting with a verb? |
| **CONTEXT** | Did I give every fact the model couldn't guess (organism, tissue, assay, versions)? |
| **FRAME** | Did I say how it should reason? |
| **AUDIENCE** | Did I say who will read it? |
| **STYLE / TONE** | Did I say how it should read? |
| **CONSTRAINTS** | Did I state the rules it would otherwise break? |
| **OUTPUT FORMAT** | If this goes into code or a spreadsheet, did I give the exact shape? |
| **EXAMPLES** | Would one worked example save a paragraph of explanation? |
| **FALLBACK** | Did I say what to do when the input doesn't fit, and prefer "unknown" to a guess? |

Examples of each component are in [Part 2](../llmPromptingComponents/index.md#what-each-component-looks-like).

---

## Common Pitfalls

Each row pairs a weak prompt with a stronger one. The notes column explains what makes the difference.

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

## Match the Check to the Claim

| Output type | Check against |
|-------------|---------------|
| Gene identity, function | Ensembl, NCBI Gene, UniProt, organism databases (ZFIN, FlyBase, WormBase, MGI) |
| Citations | Open the paper via PubMed or DOI and confirm it says what's claimed |
| Pathway or enrichment claims | A formal enrichment test on your data, not the model's narrative |
| Code | Run it on a small known dataset; inspect intermediate objects; check against package documentation |
| Numbers (fold changes, concentrations, sequences) | Your own data, the original protocol, datasheet, or primer database |
| Extractions from documents | Spot-check a random sample of records against the source |

---

## Minimum Record for Research Use

| Field | Example | Why |
|-------|---------|-----|
| Model and version | `Claude Opus 4.5`, `GPT-5.1`, accessed 2026-10-21 | Behavior changes between releases. |
| Interface | Web chat / API / Claude Code / local model | Chat interfaces often hide settings and may add their own system instructions. |
| Full prompt text | Saved verbatim, version-controlled with the analysis code | Paraphrases aren't reproducible. |
| Inputs | Exact gene list, file hash, or document version given to the model | Same prompt + different input = different experiment. |
| Iteration notes | What changed between versions and why | Your lab notebook entry for the prompt. |
| Validation | How outputs were checked (see [Match the check to the claim](#match-the-check-to-the-claim)) | Shows the output was not taken on trust. |

---

## Glossary

Terms that come up throughout this workshop and in most discussions of LLM best practices.

Terms that come up throughout this guide and in most discussions of LLM best practices.

### The model and how it is trained

| Term | Meaning |
|------|---------|
| **LLM (Large Language Model)** | A model trained on very large amounts of text to predict the next piece of text. ChatGPT, Claude, Gemini, and Llama are examples. |
| **Training data** | The text the model learned from. It determines what the model "knows" and what it knows well. |
| **Training cutoff** | The date after which the model saw no training data. Anything newer is unknown to it unless you provide it. |
| **Frontier model** | One of the largest, most capable current models, usually accessed through a company's website or API. |
| **Local model** | A model you download and run on your own hardware. Usually smaller and less capable, but data never leaves your machine. |
| **Token** | The unit of text a model reads and writes, roughly ¾ of an English word. Limits and pricing are counted in tokens. |

### Talking to the model

| Term | Meaning |
|------|---------|
| **Prompt** | Everything you send the model for a given request: instructions, background, and pasted data. |
| **System prompt** | Standing instructions applied to every request, set by the tool's developer or by you (e.g., a project instruction file). Often hidden in chat interfaces. |
| **Context / context window** | All the text the model can see at once: system prompt, conversation so far, pasted files, and your prompt. The window has a maximum size. |
| **In-context vs. from memory** | Information you paste into the prompt (in-context) is far more reliable than information the model recalls from training (from memory). |
| **Examples (few-shot prompting)** | Sample input/output pairs included in the prompt to show the model what you want. |
| **Chain of thought** | Asking the model to reason step by step before answering. |
| **Temperature** | A setting that controls randomness. Higher values give more varied output; lower values give more repeatable output. |

### Tools and interfaces

| Term | Meaning |
|------|---------|
| **Interface** | How you reach the model: web chat, API (code), a coding assistant, or a local application. |
| **API** | Programmatic access to a model, typically used in scripts and pipelines. Usually exposes settings that chat interfaces hide. |
| **Tool use / retrieval** | Letting the model search the web, query a database, or read files during a request, so it can look things up instead of recalling them. |
| **Agent** | A model that takes multiple actions on its own (running code, editing files, searching) to complete a task. |

### Failure modes

| Term | Meaning |
|------|---------|
| **Hallucination / confabulation** | Confident, fluent output that is wrong or invented. See [How LLMs Produce Answers](../llmPrompting/index.md#part-1-how-llms-produce-answers). |
| **Sycophancy** | The model's tendency to agree with the user, including with a wrong premise. See [Common Pitfalls](#common-pitfalls). |
| **Prompt hacking** | Rewording a prompt until the output says what you hoped, then reporting only the final version. See [Documenting Prompts](../llmPromptingVerification/index.md#part-5-documenting-prompts). |

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
