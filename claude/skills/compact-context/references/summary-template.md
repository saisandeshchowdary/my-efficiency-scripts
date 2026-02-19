# Summary Template

Detailed template for structuring conversation summaries. Use this as a guide for extracting and organizing information.

## Full Template Structure

```markdown
# Session Summary
[Optional: Add focus qualifier if user requested, e.g., "with focus on API changes"]

## Project Overview
**Goal**: [What is being built, fixed, or investigated - be specific]
**Context**: [Why this work matters, business/technical driver]

## Technical Stack
- **Primary Language**: [e.g., Scala, Java, Python]
- **Framework**: [e.g., Play Framework, Spring Boot, React]
- **Key Dependencies**: [e.g., Couchbase, Kafka, PostgreSQL]
- **Architecture**: [e.g., Microservices, Event-driven, Monolithic]
- **Infrastructure**: [e.g., AWS, Kubernetes, Docker]

## Session Timeline

### Phase 1: [Descriptive Name]
**Duration**: [Approx message count or time if relevant]
**Focus**: [What was being done in this phase]
**Key Activities**:
- [Activity 1]
- [Activity 2]
**Findings/Discoveries**:
- [Finding 1]
- [Finding 2]
**Outcome**: [How this phase concluded, what was decided]

### Phase 2: [Descriptive Name]
[Repeat structure above]

### Phase N: [Current Phase]
**Status**: [In progress / Just completed]
**Focus**: [...]
**Last Action**: [Most recent thing done]

## Key Technical Decisions

### Decision 1: [Decision Title]
**Context**: [What problem prompted this decision]
**Choice**: [Specific approach chosen]
**Rationale**: [Why this was chosen - include trade-offs]
**Alternatives Considered**: [What else was evaluated and why rejected]
**Impact**: [How this affects the system/codebase]
**Reversibility**: [Easy to change / Significant refactor needed]

### Decision 2: [Decision Title]
[Repeat structure above]

## Implementation Details

### Files Created
- `path/to/new/file.ext` - [Purpose and key contents]

### Files Modified
- `path/to/modified/file.ext` - [What changed and why]
  - [Specific change 1]
  - [Specific change 2]

### Files Deleted
- `path/to/deleted/file.ext` - [Why removed]

### Code Patterns Introduced
- [Pattern name]: [Brief description and location]

### Tests Added/Modified
- [Test file]: [What is tested]

### Documentation Updates
- [Doc file]: [What was documented]

## Current State

### Just Completed
[What was finished in the most recent exchange]

### In Progress
[What is partially done - include enough context to resume]

### Verified Working
- [Feature/fix 1]
- [Feature/fix 2]

### Known to be Broken
- [Issue 1]
- [Issue 2]

## Open Issues & Blockers

### Critical Issues
- [ ] **[Issue Title]**: [Description, impact, and context]

### Non-Critical Issues
- [ ] **[Issue Title]**: [Description and context]

### Technical Debt
- [Description of shortcuts taken and why]

### Questions Awaiting Answers
- [Question 1]
- [Question 2]

## Next Steps

### Immediate (Top Priority)
1. **[Action]**: [Why this is next, what success looks like]

### Near-Term
2. **[Action]**: [Context and dependencies]
3. **[Action]**: [Context and dependencies]

### Future Considerations
- [Longer-term item 1]
- [Longer-term item 2]

## Important Context to Preserve

### Domain Knowledge
- [Business rule or constraint discovered during session]

### Edge Cases
- [Edge case 1]: [How to handle]
- [Edge case 2]: [How to handle]

### User Preferences
- [Coding style preference]
- [Architectural preference]
- [Tool preference]

### Gotchas & Pitfalls
- [Thing to avoid and why]
- [Common mistake and solution]

### Performance Considerations
- [Metric or concern discovered]

### Security Considerations
- [Security implication or requirement]

## External References
- [API docs]: [URL or location]
- [Related PR/Issue]: [Link]
- [Design doc]: [Location]
```

## Section Usage Guide

### Include When...
- **Project Overview**: Always
- **Technical Stack**: Always for new projects; omit if trivial stack
- **Session Timeline**: When conversation had distinct phases
- **Key Technical Decisions**: When architectural or design choices were made
- **Implementation Details**: When code was written/modified
- **Current State**: Always - critical for resuming
- **Open Issues**: When problems are unresolved
- **Next Steps**: Always - provides continuity
- **Important Context**: When domain knowledge was discovered
- **External References**: When external docs were consulted

### Omit When...
- Section has no content (e.g., no files were deleted)
- Information is obvious or trivial
- Content was exploratory and discarded

## Tone and Style

**Do**:
- Use present tense for current state: "The cache is configured..."
- Use past tense for completed work: "Changed ehcache capacity..."
- Be specific with numbers: "0.36% hit ratio" not "low hit ratio"
- Include file paths: `conf/ehcache.xml` not "the config file"
- Capture reasoning: "...because 711 programs exceeded 10 slots"

**Don't**:
- Use vague language: "fixed stuff", "updated things"
- Repeat information across sections
- Include conversational back-and-forth
- Describe how the conversation went (meta-commentary)