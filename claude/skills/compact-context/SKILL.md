---
name: compact-context
description: >-
  Analyze and compress long conversation histories into structured summaries for context management.
  Use when conversation is getting long, user requests to compact or summarize the session,
  mentions context window filling up, or says compact, summarize conversation, compress context,
  or create conversation summary. Preserves critical decisions, progress, and next steps while
  removing verbose details.
---

# Compact Context

Compress conversation history into a structured summary that preserves essential information while dramatically reducing token usage.

## When to Use

Trigger compaction when:
- Conversation has covered multiple phases (planning, implementation, debugging)
- User mentions context filling up or Claude seeming "forgetful"
- Natural milestone reached (feature complete, major bug fixed, research phase done)
- User requests: "compact", "summarize conversation", "compress context"
- Preparing to start a major new task after extended session

## Workflow

### Step 1: Analyze Conversation Scope

Review the entire conversation to understand:
- **Duration**: How many exchanges? How many phases?
- **Topics**: What major areas were covered?
- **Completeness**: Are we mid-task or at a natural boundary?

Optional: Ask user for focus areas if not specified:
"Should I focus the summary on any specific aspects? (e.g., API changes, architecture decisions, open issues)"

### Step 2: Extract Critical Information

Systematically identify and extract:

#### A. Project Context
- Overall goal of the session
- Tech stack and major dependencies
- Architectural patterns or constraints

#### B. Technical Decisions Made
- **What was decided**: Specific choice or approach
- **Why it was chosen**: Reasoning and trade-offs considered
- **Alternatives rejected**: What was considered but not chosen

#### C. Work Completed
- Features implemented
- Bugs fixed
- Files created or significantly modified
- Tests written or updated
- Documentation added

#### D. Current State
- What is currently being worked on
- Last action taken
- Partial implementations or work-in-progress

#### E. Issues and Blockers
- Open problems
- Known bugs or limitations
- Technical debt introduced
- Questions awaiting answers

#### F. Next Steps
- Immediate next actions
- Outstanding tasks
- Future considerations

See [references/summary-template.md](references/summary-template.md) for detailed structure.

### Step 3: Generate Structured Summary

Create a comprehensive but concise summary using this format:

```markdown
# Session Summary

## Project Overview
[1-2 sentences: What is being built/fixed and why]

## Technical Stack
- Language/Framework: [...]
- Key Dependencies: [...]
- Architecture: [...]

## Session Timeline

### Phase 1: [Name] (e.g., Initial Investigation)
- **Focus**: [What was being done]
- **Findings**: [Key discoveries]
- **Outcome**: [Result or decision]

### Phase 2: [Name] (e.g., Implementation)
- **Focus**: [...]
- **Changes**: [Key files and modifications]
- **Outcome**: [...]

[Continue for each major phase]

## Key Technical Decisions

### Decision 1: [Title]
- **Choice**: [What was decided]
- **Rationale**: [Why]
- **Impact**: [Implications]

[Continue for each major decision]

## Files Modified
- `path/to/file1.ext` - [Brief description of changes]
- `path/to/file2.ext` - [Brief description of changes]

## Current State
[Current status: What was just completed, what is in progress]

## Open Issues
- [ ] [Issue description and context]
- [ ] [Issue description and context]

## Next Steps
1. [Immediate next action with context]
2. [Following action]
3. [Future consideration]

## Important Context to Preserve
- [Any domain knowledge or constraints that must not be lost]
- [Edge cases or gotchas discovered]
- [User preferences or requirements]
```

### Step 4: Optimize for Token Efficiency

Review the summary and:
- **Remove redundancy**: Eliminate repeated information
- **Use concise language**: Replace verbose phrases
- **Preserve specifics**: Keep file paths, function names, error messages intact
- **Cut noise**: Remove tangential discussions that did not lead anywhere

Target: 70-85% token reduction from original conversation while retaining all critical information.

### Step 5: Present Summary and Guidance

Provide the summary followed by usage instructions:

```
## How to Use This Summary

1. Copy the summary above
2. Use /clear to reset the conversation
3. Paste the summary as your first message
4. Continue from where you left off

## Preserved Information
- [X] Technical decisions and rationale
- [X] Files modified and current state
- [X] Open issues and next steps
- [X] [Any user-requested focus areas]

## What Was Removed
- Verbose back-and-forth dialogue
- Exploratory code that was discarded
- Debugging output that is no longer relevant
- Redundant explanations
```

## Focus Instructions

When user provides focus (e.g., "compact with focus on API changes"):
1. Give extra weight to the specified topic in the summary
2. Include more detail about that area
3. Ensure related decisions and context are fully preserved
4. Mention the focus in the summary header

## Best Practices

- **Capture the "why"**: Decisions without reasoning are less valuable
- **Be specific**: "Fixed cache bug" < "Changed ehcache capacity from 10 to 1000 to fix 0.36% hit ratio"
- **Preserve continuity**: Reader should understand the story without the original conversation
- **List modified files**: Essential for resuming work
- **Flag uncertainties**: Note anything that needs revisiting

## Context Advisor Mode

If user asks "should I compact?" analyze:
- Current conversation length (rough token estimate)
- Coherence of recent responses (has quality degraded?)
- Task boundary (is now a good stopping point?)

Advise:
- **Yes, compact now** if at natural boundary and length is significant
- **Not yet** if mid-task or conversation is still manageable
- **Consider after [milestone]** if close to good stopping point

## Example Output

See [references/example-summary.md](references/example-summary.md) for a complete example of a well-structured session summary.