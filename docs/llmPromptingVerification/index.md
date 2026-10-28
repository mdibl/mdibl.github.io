# Checking and Verification

One of the most important tasks of any scientist is ensuring reproducibility of experiments. 
There is no difference when it comes to using LLMs for research or generation. 

Determinism is the term to describe the ability to produce the same output from the same input every time. 
A calculator is deterministic, every time you check 2+2, it will report the answer as 4. 
LLMs are probabilistic by nature, not following a rigid set of instructions, instead predicting the next most likely token from a probability distribution. 

Therefore, every output needs to be verified or checked. It says so at the bottom of the LLM web UI at all times, "__ is AI and can make mistakes. Please double-check responses."

## Verifying Output

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

## Prompts as Research Documentation

If an LLM touches your research, the prompt is part of your methods. Treat it like a protocol or an analysis script. This applies when you use an LLM for:

- annotating cell clusters
- summarizing literature
- drafting code
- extracting metadata
- interpreting enrichment results

!!! warning "The prompt-hacking problem"
    - Rewording a prompt until the output says what you hoped, then reporting only the final version, is the LLM equivalent of trying analyses until p < 0.05.
    - If you iterated, record the iterations.

### Minimum record for any research use

| Field | Example | Why |
|-------|---------|-----|
| Model and version | `Claude Opus 4.5`, `GPT-5.1`, accessed 2026-10-21 | Behavior changes between releases. |
| Interface | Web chat / API / Claude Code / local model | Chat interfaces often hide settings and may add their own system instructions. |
| Full prompt text | Saved verbatim, version-controlled with the analysis code | Paraphrases aren't reproducible. |
| Inputs | Exact gene list, file hash, or document version given to the model | Same prompt + different input = different experiment. |
| Iteration notes | What changed between versions and why | Your lab notebook entry for the prompt. |
| Validation | How outputs were checked (see [Verifying Output](#verifying-output)) | Shows the output was not taken on trust. |

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

### Citing LLM use

Follow your target journal's policy and see CMU Libraries' guide to citing generative AI: <https://guides.library.cmu.edu/CitationManagement/GenerativeAI>


!!! tip "Takeaways"
	Any miscomunication to an LLM may lead to misinformation being generated. 
	
	If that miscomunication isn't recorded, there will be no way to know how to fix any problem that arises because of it!

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
