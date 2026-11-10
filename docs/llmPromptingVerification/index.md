# Parts 4–5: Verify & Document

> **Workshop Parts 4–5 and Capstone** &nbsp;·&nbsp; ~45 minutes &nbsp;·&nbsp; [Back to the workshop overview](../llmPrompting/index.md)

---

## Part 4: Verifying Output

> ~20 minutes

One of the most important tasks of any scientist is ensuring that experiments are reproducible. The same applies when you use LLMs in research. A well-written prompt makes output *checkable*, but you still have to check it.

???+ question "Exercise 4.1 — Same prompt, different answer?"
    Open a **new chat** and run your Exercise 3.3 prompt again, with the same gene list. Put the two answers side by side.

    - Are the themes the same? Are the same genes assigned to each theme?
    - Did any confidence level or "Not assigned" gene change?

    ??? success "What to look for"
        The wording almost always changes, and often some gene assignments or confidence levels do too. A calculator is deterministic: every time you enter 2+2, it returns 4. LLMs are probabilistic: they choose each next token by sampling from a probability distribution, so the same prompt can give different answers. That's why every output needs checking, and why most chat interfaces show a notice such as "[Model] is AI and can make mistakes. Please double-check responses."

### Match the check to the claim

| Output type | Check against |
|-------------|---------------|
| Gene identity, function | Ensembl, NCBI Gene, UniProt, organism databases (ZFIN, FlyBase, WormBase, MGI) |
| Citations | Open the paper via PubMed or DOI and confirm it says what's claimed |
| Pathway or enrichment claims | A formal enrichment test on your data, not the model's narrative |
| Code | Run it on a small known dataset; inspect intermediate objects; check against package documentation |
| Numbers (fold changes, concentrations, sequences) | Your own data, the original protocol, datasheet, or primer database |
| Extractions from documents | Spot-check a random sample of records against the source |

???+ question "Exercise 4.2 — Verify this output"
    **This is the most important exercise in the workshop.** The answer below was written for this exercise and contains several deliberate errors. Use the table above, the case-study files, and public databases to check each numbered claim. For each one, decide: **correct**, **wrong**, or **can't be verified**.

    Also available as [`llm_answer_to_verify.txt`](../llmPrompting/data/llm_answer_to_verify.txt).

    ```text
    Prompt: "Summarize the biology of the upregulated genes in
    killifish_heart_DEGs.csv."

    The aging killifish heart shows a clear shift toward inflammation,
    fibrosis, and cardiac stress.

    1. Cardiac stress. The natriuretic peptides are the strongest signal.
       NPPB is the top gene (log2FC = 6.8) and NPPA is also strongly
       induced, consistent with increased wall stress in the older heart.
    2. Complement and inflammation. C1QA, C1QB, and C3 are upregulated.
       Gene set enrichment analysis shows significant enrichment of the
       Hallmark Inflammatory Response pathway (padj = 0.003), confirming
       that inflammation drives cardiac aging in killifish.
    3. Fibrosis. COL1A1, POSTN, LUM, and FN1 point to extracellular matrix
       remodeling. COL1A1 behaves as a single gene in killifish, just as in
       humans, where COL1A1 mutations cause osteogenesis imperfecta; the
       older fish are therefore likely to have more fragile bones.
    4. Senescence. CDKN1A (p21; Ensembl ENSG00000141510) is upregulated,
       a classic marker of cellular senescence.
    5. Uncharacterized genes. LOC_SIM_001 encodes a fish-specific cardiac
       troponin variant that compensates for reduced contractility with age.

    These findings agree with a recent study of the turquoise killifish
    heart (Kowalczyk, R., Brandt, M., & Osei, K. (2021). Complement
    activation drives cardiac aging in the turquoise killifish. Aging Cell,
    20(7), e13399).
    ```

    ??? success "Solution"
        | Claim | Verdict | How to catch it |
        |-------|---------|-----------------|
        | 1. NPPB is the top gene, NPPA strongly induced | **Partly wrong** | NPPB is the top gene, but the CSV gives log2FC = 5.12, not 6.8. Always check numbers against your own data. |
        | 2. C1QA, C1QB, C3 upregulated | **Mostly correct** | All are in the list, but C3 is `C3_dup`: two killifish paralogs share that symbol. |
        | 2. Enrichment, padj = 0.003 | **Wrong** | `methods_notes.txt` says no enrichment analysis was run. The statistic is invented, and "confirming that inflammation drives" is a causal claim the data can't support. |
        | 3. ECM remodeling genes | **Correct** | POSTN and LUM are in the list; COL1A1 and FN1 are listed as `_dup`. |
        | 3. COL1A1 is a single gene; fragile bones | **Wrong** | The CSV marks `COL1A1_dup`: two killifish paralogs (Ensembl or ZFIN show teleosts carry *col1a1a* and *col1a1b*). The human disease link and the conclusion about bones from heart RNA are borrowed from mammals. |
        | 4. CDKN1A, ENSG00000141510 | **Wrong ID** | Search the ID in Ensembl: ENSG00000141510 is human *TP53*. Human *CDKN1A* is ENSG00000124762, and neither is a killifish ID. |
        | 5. LOC_SIM_001 is a troponin variant | **Can't be verified (invented)** | The CSV says it has no human ortholog, and it's a simulated gene. Any specific function is a confabulation. |
        | Citation | **Wrong** | Search PubMed for the title and authors: there's no such paper. If the journal, volume, and article number exist, they belong to a different paper. Never use a citation you haven't opened. |

        How many did you catch? Notice that the confident, well-organized tone was the same for the correct and the invented claims.

For repeated or pipeline use, run the same prompt over a representative set of inputs (including awkward ones) and check that the outputs are consistent before trusting it at scale.

!!! success "Key Points — Verifying Output"
    - The same prompt can give different answers, so treat every output as a draft.
    - Match each type of claim to a primary source: databases for genes, PubMed for citations, your own data for numbers, a statistical test for enrichment.
    - Invented claims sound exactly as confident as correct ones.

---

## Part 5: Documenting Prompts

> ~10 minutes

If an LLM touches your research, the prompt is part of your methods. Treat it like a protocol or an analysis script, whether you used the LLM to annotate clusters, summarize literature, draft code, extract metadata, or interpret results.

!!! warning "The prompt-hacking problem"
    Rewording a prompt until the output says what you hoped, then reporting only the final version, is the LLM equivalent of trying analyses until p < 0.05. If you iterated, record the iterations.

### Minimum record for any research use

| Field | Example | Why |
|-------|---------|-----|
| Model and version | `Claude Opus 4.5`, `GPT-5.1`, accessed 2026-10-21 | Behavior changes between releases. |
| Interface | Web chat / API / Claude Code / local model | Chat interfaces often hide settings and may add their own system instructions. |
| Full prompt text | Saved verbatim, version-controlled with the analysis code | Paraphrases aren't reproducible. |
| Inputs | Exact gene list, file hash, or document version given to the model | Same prompt + different input = different experiment. |
| Iteration notes | What changed between versions and why | Your lab notebook entry for the prompt. |
| Validation | How outputs were checked (see [Verifying Output](#part-4-verifying-output)) | Shows the output was not taken on trust. |

???+ question "Exercise 5.1 — Log it"
    Fill in this template for the prompt you wrote in Exercise 3.3. Save it next to your analysis files, for example as `prompts/2026-10-29_killifish_gene_themes.md`.

    ```markdown
    ## Prompt log: <short description>, v<number>
    - Date:
    - Model: <name, version>   Interface: <web/API>   Temp: <value or "not exposed">
    - Input: <file name and version, or md5>
    - Change from previous version: <what changed and why>
    - Validation: <how you checked the output>
    - Prompt: (full text below)
    ```

    ??? tip "No answer key, but a checklist"
        Compare your log with the [minimum record](#minimum-record-for-any-research-use). Could a colleague rerun your prompt on the same input from your log alone? Did you record the Before prompt and the Exercise 4.1 rerun as iterations?

    ??? example "One possible log"
        ```markdown
        ## Prompt log: killifish heart gene themes, v2
        - Date: 2026-10-29
        - Model: <name, version>   Interface: web chat   Temp: not exposed
        - Input: killifish_heart_DEGs.csv (40 genes, simulated workshop data)
        - Change from v1: v1 was "What's going on biologically?" and assumed
          human biology; v2 adds organism, _dup/LOC_SIM handling, an output
          table, and a FALLBACK for unassigned genes.
        - Validation: reran in a new chat (themes stable, 2 genes moved);
          checked gene identities in Ensembl; no citations requested.
        - Prompt: (full text below)
        ```

**System prompts and project files.** The same rules apply, at greater scale, to anything that shapes every response: a system prompt for a lab chatbot, a project instruction file, or an `AGENTS.md` or `CLAUDE.md` for a coding agent. Version and archive these like code.

**Citing LLM use.** Follow your target journal's policy and see CMU Libraries' guide to citing generative AI: <https://guides.library.cmu.edu/CitationManagement/GenerativeAI>

!!! success "Key Points — Documenting Prompts"
    - The prompt, model, version, date, inputs, and validation are part of your methods.
    - Record your iterations, not just the version that worked.
    - Any miscommunication to an LLM may lead to misinformation being generated. If that miscommunication isn't recorded, you'll have no way to trace and fix the problems it causes!

---

## Capstone: Bring Your Own Prompt

> ~15 minutes

???+ question "Capstone — From question to logged prompt"
    Take a real question from your own research and work through the whole workshop on it:

    1. **Write** the prompt using the [prompt skeleton](../llmPromptingGlossary/index.md#prompt-skeleton).
    2. **Check** it against the [rubric](../llmPromptingComponents/index.md#rubric) and the [pitfall tables](../llmPromptingGlossary/index.md#common-pitfalls).
    3. **Run** it, ideally twice in separate chats.
    4. **Verify** at least one specific claim using [Match the check to the claim](#match-the-check-to-the-claim).
    5. **Log** it with the Exercise 5.1 template.

    Remember to follow your institution's data policy: use public, de-identified, or simulated data if you're not sure.

### One Thing to Try This Week

| If you... | Do this |
|-----------|---------|
| Ask LLMs biology questions without context | Add organism, tissue, and assay to your next prompt. |
| Use LLM-suggested papers | Open every citation before you use it. |
| Get gene functions from an LLM | Check one claim in Ensembl or your organism database. |
| Don't keep your prompts | Start a `prompts/` folder next to your analysis scripts. |
| Ask leading questions | Add: "If my interpretation isn't supported, say so first." |

[:octicons-arrow-right-24: Open the Quick Reference](../llmPromptingGlossary/index.md){ .md-button .md-button--primary }

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
