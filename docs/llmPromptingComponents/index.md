# Part 2: Anatomy of a Prompt

> **Workshop Part 2** &nbsp;·&nbsp; ~25 minutes &nbsp;·&nbsp; [Back to the workshop overview](../llmPrompting/index.md)

---

## Why Prompts Matter

An LLM has never seen your sample sheet, doesn't know which organism you work in, and can't guess which genome build your counts came from. When those details are missing, it fills them in with whatever is most typical in its training data, which for biology usually means **human, mouse, or a generic textbook case**.

Most bad outputs come from one of three gaps. Each is also a record-keeping problem:

| Failure mode | What happens | Why it is also a documentation problem |
|--------------|--------------|----------------------------------------|
| **Missing information** | The model assumes defaults (human, latest genome build, standard protocol). | If the assumption isn't in the prompt, nobody reviewing the work can see it was made. |
| **Unclear output expectations** | You get the model's favorite format, not the one you need. | There's no standard to judge the output against. |
| **Uncheckable quality criteria** | "Be thorough" or "be accurate" can't be tested. | Neither the model nor a reviewer can verify they were met. |

---

## The Components

A prompt is built from components. Each one makes one part of your request explicit, and each is something you can save and review later. Use the ones the task needs.

!!! tip "Think of it as a new colleague"
    Imagine the LLM as an experienced colleague who knows none of the specifics of your project. What would they need from you to give an answer you can trust?

Labels like `__TASK__` and `__CONTEXT__` are a checklist **for you**, not a syntax the model needs. A labeled prompt and a plain-prose prompt with the same information should get comparable answers, so write whichever you find easier.

### Rubric

Use this table to check any prompt you write in this workshop.

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

### What each component looks like

Open any component to see an example.

??? example "TASK — required"
    What you want done, starting with a verb (*Summarize, Extract, Classify, Compare, Annotate, Draft, Debug, Critique*) and naming the output.

    ```text
    __TASK__
    - Extract every reagent, concentration, and incubation time from the
      protocol text below into a table.
    ```

??? example "CONTEXT — required whenever the model couldn't guess it"
    Background facts about your system. For biology, this is where most quality gains come from.

    ```text
    __CONTEXT__
    - Organism: Danio rerio; genome build GRCz11, Ensembl release 110.
    - Assay: bulk RNA-seq, poly-A selected, 150 bp PE, ~30M reads/sample.
    - Design: 3 timepoints (24, 48, 72 hpf) x 2 genotypes, n = 4 per group.
    ```

??? example "FRAME — optional"
    How to reason, written as checkable rules rather than a character to play.

    ```text
    __FRAME__
    - Separate what the data show from what is being inferred.
    - Treat any claim about gene function in a non-model organism as
      provisional unless supported by the data provided.
    ```

??? example "AUDIENCE, STYLE and TONE — optional"
    Who will read the output and how it should read. The same correct content fails if pitched at the wrong level.

    ```text
    __AUDIENCE__
    - A wet-lab postdoc who knows the biology but has not used DESeq2.
    __STYLE__
    - Methods-section prose; past tense.
    __TONE__
    - Neutral. Report; do not advocate for the hypothesis.
    ```

??? example "CONSTRAINTS — required for anything you'll reuse"
    Separate "do" and "do not" rules. Keep each one measurable and the list short (roughly 8 or fewer).

    ```text
    __CONSTRAINTS__
    - Do: state which genes you could not identify.
    - Do not: cite papers or databases you were not given.
    - Length: under 250 words.
    ```

??? example "OUTPUT FORMAT — required when the output goes into code or a spreadsheet"
    The shape of the response. Name the fields.

    ```text
    __OUTPUT_FORMAT__
    - Return a TSV with columns: cluster_id, proposed_cell_type,
      supporting_markers, confidence (high/medium/low).
    - No text before or after the table.
    ```

??? example "EXAMPLES — strongly recommended"
    One or more input/output pairs. A good example shows format, detail, and edge cases at once [\[3\]](../llmPrompting/index.md#references). Include at least one awkward case.

    ```text
    __EXAMPLES__
    Input:  "Sample 3 - 48hpf mut, re-extracted after low RIN (6.1)"
    Output: {"timepoint": "48hpf", "genotype": "mut", "rin": 6.1,
             "notes": "re-extracted"}
    ```

??? example "FALLBACK — required for pipelines and agents"
    What to do when the input doesn't fit. Without it, the model invents something that fits the format.

    ```text
    __FALLBACK__
    - If a gene symbol cannot be mapped to a known gene, return it under
      "unmapped" rather than guessing.
    - Prefer "unknown" over a guess.
    ```

!!! note "What about \"think step by step\"?"
    Asking for step-by-step reasoning helped older models [\[4\]](../llmPrompting/index.md#references), but current frontier models reason internally and gain little from it [\[5\]](../llmPrompting/index.md#references). It can still help smaller or locally run models. Either way, record which you did.

---

???+ question "Exercise 2.1 — Label the components"
    Read this prompt and decide which components from the [rubric](#rubric) are present and which are missing.

    ```text
    Below are 40 genes upregulated in kidney from treated (drug) versus
    control (vehicle) male zebrafish (Danio rerio). The gene symbols are
    human orthologs mapped by sequence similarity, so some mappings are
    one-to-many. Please group the genes into no more than five
    functional pathways and name the genes in each. If you aren't confident
    about a gene's function, don't assign it to a theme; list it under
    "uncertain" instead. Cite papers with evidence for the claims you
    make, and cite papers with contrary evidence if any exist.
    ```

    ??? success "Solution"
        **Present**

        - **TASK:** group the genes into functional pathways and name the genes in each.
        - **CONTEXT:** organism, tissue, comparison, and the ortholog-mapping caveat.
        - **CONSTRAINTS:** no more than five pathways; cite supporting and contrary evidence.
        - **FALLBACK:** genes it isn't confident about go under "uncertain".

        **Missing or weak**

        - **OUTPUT FORMAT:** no shape is given, so you'll get the model's favorite format.
        - **The data:** it says "below are 40 genes" but nothing is pasted.
        - **AUDIENCE, FRAME, STYLE:** not stated. That's fine for a quick question, but worth adding if the output is going into a report.
        - The citation request asks the model to recall papers from memory, which is a pitfall you'll meet in [Part 3](../llmPromptingExamples/index.md).

???+ question "Check Your Understanding"
    A colleague starts every prompt with "Act as an expert immunologist." Why doesn't that make the answer more accurate?

    ??? success "Answer"
        A role doesn't give the model any knowledge it didn't already have; it mainly changes the style of the response. Write the expertise as rules instead (a **FRAME**), such as "separate what the data show from what you infer." Role instructions are most useful in agentic workflows, not one-off prompts.

???+ question "Exercise 2.2 — Write the case-study prompt"
    Open [`killifish_heart_DEGs.csv`](../llmPrompting/data/killifish_heart_DEGs.csv) and [`methods_notes.txt`](../llmPrompting/data/methods_notes.txt). Using the [prompt skeleton](../llmPromptingGlossary/index.md#prompt-skeleton), write a prompt asking your LLM to summarize the biological themes in the gene list. Paste the gene list into the prompt and run it.

    **Save your prompt.** You'll compare it with a weaker version in Part 3 and log it in Part 5.

    ??? tip "No answer key, but a rubric"
        Go down the [rubric](#rubric). For this data, check in particular that you:

        - named the organism (*Nothobranchius furzeri*), the tissue, and the comparison (20 vs 6 weeks, males, n = 5);
        - explained that symbols are human orthologs and that `_dup` marks two killifish paralogs;
        - said what to do with the `LOC_SIM` genes that have no ortholog (a **FALLBACK**);
        - asked for an output shape you could check line by line.

---

!!! success "Key Points — Anatomy of a Prompt"
    - Missing details become guesses, usually human or mouse defaults.
    - Components are a checklist for you; the model reads plain prose just as well.
    - CONTEXT and FALLBACK do the most work for biology prompts.
    - Structuring your prompts helps you include everything the model needs, so it has to guess as little as possible.

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
