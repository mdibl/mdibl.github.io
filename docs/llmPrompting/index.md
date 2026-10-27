# Prompting LLMs for Biological Research

This guide aims to instruct individuals on best practices to using the burgeoning technology of Large Language Models effectively and safely. 
Tere is deliberately little information on the specific mathematical opperations underlaying how LLMs function. 
Instead, topics discussed include:

- How LLMs work.
- What information LLMs are confident about.
- What that means for LLM usage in biological research.
- How best to avoid misinformation.

!!! info "Orignial Resources"
	The structure of this guide is modeled on Carnegie Mellon University Libraries' *LLM Documentation Guide* (Gonzalez-Espinoza & Lan, 2026; 
	<https://guides.library.cmu.edu/LLMDocumentationGuide>). The content has been rewritten and adapted for biological research: bench work, genomics and transcriptomics, literature review, and analysis code. 
	It deliberately spends little time on how LLMs work internally and most of its time on what to include in prompts.

---

<div class="grid cards" markdown>

-   :material-book-alphabet:{ .lg .middle } **Glossary**

    ---

    Definitions of the terms used throughout this guide: how models are trained, how you talk to them, the tools they use, and the ways they fail.

    [:octicons-arrow-right-24: Read the glossary](../llmPromptingGlossary/index.md){ .md-button .md-button--primary }

-   :material-puzzle-outline:{ .lg .middle } **Prompt Components**

    ---

    The building blocks of a good prompt (task, context, frame, audience, constraints, output format, examples, and fallback), plus a reusable prompt skeleton.

    [:octicons-arrow-right-24: Read about components](../llmPromptingComponents/index.md){ .md-button .md-button--primary }

-   :material-compare-horizontal:{ .lg .middle } **Prompt Examples**

    ---

    Before-and-after rewrites of six common biology prompts, what goes wrong with each first attempt, and a table of common pitfalls.

    [:octicons-arrow-right-24: See the examples](../llmPromptingExamples/index.md){ .md-button .md-button--primary }

-   :material-check-decagram:{ .lg .middle } **Checking and Verification**

    ---

    How to verify LLM output against trusted sources, and how to record prompts as part of your research methods.

    [:octicons-arrow-right-24: Check and record](../llmPromptingVerification/index.md){ .md-button .md-button--primary }

</div>

---

## How LLMs Produce Answers

LLMs are versatile tools for generating text, especially:

- Code generation.
- Literature review.
- Text formatting.

Their strengths come from their **training data**. Code, optimization strategies, bug fixes, and package documentation are among the most abundant, freely available text on the internet. 
Biological literature is the opposite: vast in total, but any one topic may be covered by only a handful of papers.

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

The split-brain experiments of Roger Sperry and Michael Gazzaniga (1960s–70s) show the same behavior in people [\[8\]](#references).

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

## What LLMs Can and Cannot Do in Biology

The long tail is where biology lives

Models are reliable on things that appear often in their training data and unreliable on things that appear rarely [\[1\]](#references). Biology is full of rarely-written-about things:

- **Non-model organisms.** A killifish, axolotl, or planarian gene will often be described as if it were the human ortholog, with human-specific functions, tissue expression, or disease links carried over.
- **Poorly characterized genes.** For an uncharacterized ORF, lncRNA, or `LOC` identifier, the model may invent a function rather than say "unknown."
- **Recent findings.** Anything after the training cutoff is missing, and the model won't flag the gap unless asked.
- **Specific numbers.** Fold changes, concentrations, primer sequences, Ensembl IDs, and coordinates are easy to generate plausibly and wrongly.
- **Citations.** Models produce references that look real (right journal, plausible authors and year) but do not exist or do not say what's claimed [\[2\]](#references). Never use an LLM-provided citation you haven't opened.

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

## Why Prompts Matter

### The model fills gaps with defaults

An LLM only knows what it has been trained on or given explicitly. It has not seen:

- Your sample sheet
- Which organism you work in
- Which genome build your counts came from
- Whether "the treated group" means drug, knockout, or age

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
- **Each label is a component.** All of them are defined on the [Prompt Components](../llmPromptingComponents/index.md).

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

## References

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
