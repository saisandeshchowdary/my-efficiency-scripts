---
name: skill-ideas
description: "Analyze the current conversation context to identify opportunities for extracting reusable skills. Use this skill when the user asks for skill ideas, skill suggestions, or wants to know if any part of the current conversation could be abstracted into a new skill. Triggers on: /skill-ideas, 'suggest a skill', 'any skill opportunities', 'extract a skill', 'what skills can I create from this', or any request to analyze context for potential skill creation."
---

# Skill Ideas

Analyze conversation context to identify opportunities for abstracting reusable skills.

## Workflow

### Step 1: Gather Context

Collect all available context from the current conversation:
- User messages and requests
- Code being worked on (languages, frameworks, patterns)
- Files read, edited, or created
- Tools and workflows used
- Domain knowledge applied
- Repetitive patterns observed

### Step 2: Identify Skill Opportunities

Evaluate the context against these criteria. A good skill opportunity exists when:

| Signal | Example |
|--------|---------|
| **Repetitive workflow** | Same multi-step process applied across tasks (e.g., always unpack XML, edit, repack) |
| **Domain-specific knowledge** | Specialized schemas, APIs, business rules repeatedly referenced |
| **Boilerplate generation** | Same code structure or template reused with minor variations |
| **Tool integration pattern** | Consistent way of invoking external tools with specific flags/options |
| **File format handling** | Recurring read/edit/write pattern for a specific file type |
| **Convention enforcement** | Coding standards, naming conventions, or architectural patterns applied consistently |
| **Multi-step transformation** | Data or content going through a predictable pipeline |

### Step 3: Evaluate Feasibility

For each candidate, assess:

1. **Reusability** - Will this be needed again across different sessions/projects? If it is a one-off task, it is NOT a good skill.
2. **Complexity** - Is there enough non-obvious procedural knowledge to justify a skill? Trivial tasks do not need skills.
3. **Scope** - Is it focused enough to be a single skill? If too broad, suggest splitting.
4. **What Claude lacks** - Does it add knowledge Claude does not already have? General programming knowledge is not a skill opportunity.
5. **Bundled resources** - Would scripts, references, or assets make execution more reliable/efficient?

### Step 4: Present Suggestions

For each viable skill opportunity, present:

```
### Skill: <proposed-name>

**What it does:** One-sentence description.

**Why it is useful:** What repetitive work or specialized knowledge it captures.

**Trigger examples:**
- "Example user message 1"
- "Example user message 2"

**Proposed contents:**
- `SKILL.md` - Core workflow and instructions
- `scripts/` - [list any scripts, or "none needed"]
- `references/` - [list any reference docs, or "none needed"]
- `assets/` - [list any assets, or "none needed"]

**Key instructions it would encode:**
- Bullet 1
- Bullet 2
```

### Step 5: Handle No Opportunities

When no skill can be reasonably extracted, say so clearly:

> "Based on the current conversation context, I do not see a strong opportunity for a new skill. The work here is [too general / a one-off task / already covered by existing skills / not complex enough to justify abstraction]."

Do NOT force a suggestion. A bad skill suggestion is worse than none.

## Rules

- **Never force a suggestion.** If the context does not support a skill, say so.
- **Be specific.** Vague suggestions like "a coding skill" are useless. Name concrete workflows, file types, or domains.
- **Check existing skills.** Before suggesting, verify the idea is not already covered by an installed skill. List existing skills and compare.
- **Prefer fewer, better suggestions.** One well-reasoned suggestion beats five vague ones.
- **Consider the full skill lifecycle.** A skill that is hard to maintain or rarely triggered is not worth creating.
- **Suggest skill contents.** Always specify what scripts, references, or assets would be included and why.
