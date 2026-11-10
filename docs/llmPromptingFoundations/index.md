# Part 1: How LLMs Produce Answers

> **Workshop Part 1** &nbsp;·&nbsp; ~25 minutes &nbsp;·&nbsp; [Back to the workshop overview](../llmPrompting/index.md)

---

## Before the Workshop

- **Get access to an LLM** your institution has approved for research use. You'll run prompts throughout the session.
- **Check your institution's AI and data-sharing policy**, and any data use agreements that cover your data. Never paste patient identifiers, clinical metadata, or a collaborator's unpublished results into a hosted AI tool unless you've confirmed it's allowed. Prompt quality doesn't matter if the data shouldn't have been shared.
- **Download the case-study files.** They are simulated for teaching, so they're safe to paste anywhere:
    - [`killifish_heart_DEGs.csv`](../llmPrompting/data/killifish_heart_DEGs.csv): upregulated genes, *Nothobranchius furzeri* heart, 20-week vs 6-week males
    - [`samples.tsv`](../llmPrompting/data/samples.tsv): the sample sheet
    - [`methods_notes.txt`](../llmPrompting/data/methods_notes.txt): the analysis notes
    - [`llm_answer_to_verify.txt`](../llmPrompting/data/llm_answer_to_verify.txt): used in Part 4
    - [`README.txt`](../llmPrompting/data/README.txt): what each file contains

---

## Why This Matters

!!! abstract ":material-timer-outline: 10 minutes — Before reading on..."
    Open [`killifish_heart_DEGs.csv`](../llmPrompting/data/killifish_heart_DEGs.csv) and pick `LOC_SIM_001`, or a poorly characterized gene from the organism you study. Ask your LLM:

    ```text
    What does LOC_SIM_001 do in the turquoise killifish heart?
    ```

    - How confident does the answer sound?
    - Does it say "unknown" anywhere?
    - Can you verify any of it?

    Keep the answer open. We'll come back to it at the end of Part 1.

---

## How LLMs Produce Answers

> ~15 minutes

An LLM produces the **most plausible continuation** of your prompt, based on patterns in its training data.

- It does **not** look things up unless it has a search or database tool.
- It does **not** know when it has drifted outside what it knows well.
- At that edge, the drive to produce an answer wins out over admitting it doesn't know. It fills the gap with a confident, fluent **confabulation** (often called a **hallucination**).

Models are reliable on things that appear often in their training data and unreliable on things that appear rarely [\[1\]](../llmPrompting/index.md#references). Code and package documentation are abundant online. Any one biology topic may be covered by only a handful of papers.

| Where LLMs are weak in biology | Where they are genuinely strong |
|---|---|
| **Non-model organisms:** a killifish gene is described as if it were the human ortholog | Summarizing and extracting from text **you provide** |
| **Poorly characterized genes:** an uncharacterized ORF or `LOC` gene gets an invented function | Drafting and debugging analysis code for widely used packages |
| **Recent findings:** anything after the training cutoff is missing | Explaining well-established concepts and methods |
| **Specific numbers:** fold changes, primer sequences, Ensembl IDs, coordinates | Brainstorming alternative explanations and controls |
| **Citations:** references that look real but don't exist or don't say what's claimed [\[2\]](../llmPrompting/index.md#references) | Converting between formats (notes to a sample sheet, prose to a table) |

### An analogy: split-brain confabulation

In split-brain patients, the bundle of nerves connecting the two brain hemispheres has been cut, so each hemisphere works largely on its own and speech comes mostly from the left [\[8\]](../llmPrompting/index.md#references). In one experiment, the left hemisphere was shown a **chicken claw** and the right a **snow shovel**. The patients were asked to point to images of what they saw, and their hands pointed to a chicken and a shovel. When asked why the left hand chose the shovel, the speaking hemisphere, which never saw the shovel, didn't say "I don't know." It confidently invented a reason: *"The chicken claw goes with the chicken, and you need a shovel to clean out the chicken shed."*

!!! abstract "Discussion — The speaking hemisphere and the LLM"
    Talk about these with a partner or think through them on your own:

    1. In what way is an LLM in the same position as the speaking hemisphere?
    2. Why might a model be rewarded for guessing rather than saying "I don't know"? (Think of a standardized test.)
    3. Go back to your answer from [Why This Matters](#why-this-matters). **Whose LLM got the killifish gene wrong? What did it assume?**

    ??? success "Discussion points"
        - Both are asked to explain something they have no information about, and both produce a fluent, confident story instead of admitting the gap.
        - As on a standardized test, a wrong guess usually costs less than a blank answer, so models learn to answer *any* question.
        - `LOC_SIM_001` is a simulated gene with no ortholog, so any specific function is invented. Answers often borrow a human or mouse gene's function, or describe a plausible-sounding cardiac protein.

!!! tip "Your defense is the prompt"
    **The more of the answer you put in the context, the more you can trust the output.** Supply the information the model lacks, and explicitly allow it to say "unknown."

???+ question "Check Your Understanding"
    Which is more reliable, and why: asking the model what a paper says, or pasting the abstract and asking for a summary?

    ??? success "Answer"
        Pasting the abstract. A summary of text in the prompt (in context) draws on information the model can see. Asking what a paper says relies on recall from training data, where the paper may be absent, confused with another, or invented outright.

!!! success "Key Points — How LLMs Produce Answers"
    - An LLM predicts plausible text; It doesn't look things up or know when it's guessing.
    - Biology is full of rare topics (non-model organisms, uncharacterized genes, specific numbers), which is exactly where confabulation happens.
    - Put the information in the prompt instead of relying on the model's memory.

[:octicons-arrow-right-24: Continue to Part 2: Anatomy of a Prompt](../llmPromptingComponents/index.md){ .md-button .md-button--primary }

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
