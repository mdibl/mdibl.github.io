# Glossary

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
| **Hallucination / confabulation** | Confident, fluent output that is wrong or invented. See [How LLMs Produce Answers](../llmPrompting/index.md#how-llms-produce-answers). |
| **Sycophancy** | The model's tendency to agree with the user, including with a wrong premise. See [Common Pitfalls](../llmPromptingExamples/index.md#common-pitfalls). |
| **Prompt hacking** | Rewording a prompt until the output says what you hoped, then reporting only the final version. See [Prompts as Research Documentation](../llmPromptingVerification/index.md#prompts-as-research-documentation). |

---

*Questions? Contact the CGDS Core — [CGDS@mdibl.org](mailto:CGDS@mdibl.org)*
