# Model Selection Guide

Detailed guidance for choosing the optimal model for subagents.

## Model Characteristics

### Haiku (Cheapest)
**Best for:** Fast, simple tasks with clear scope

- File listing and organization
- Simple text transformations
- Pattern-based searches
- Formatting and cleanup tasks
- Boilerplate generation
- Simple Q&A from context

**Avoid when:** Task requires nuanced judgment, complex reasoning, or multi-step planning.

### Sonnet (Balanced)
**Best for:** Most development tasks

- Code review and analysis
- Bug identification and fixes
- Documentation writing
- Refactoring suggestions
- Test generation
- API design feedback
- General development assistance

**Default choice** when unsure.

### Opus (Most Capable)
**Best for:** Complex reasoning and critical decisions

- Architecture design and review
- Security vulnerability analysis
- Complex debugging sessions
- Research and investigation
- Multi-system integration planning
- Performance optimization strategies
- Critical production decisions

**Use sparingly** due to cost.

## Decision Matrix

| Task Complexity | Context Size | Criticality | Recommended Model |
|-----------------|--------------|-------------|-------------------|
| Low | Small | Low | haiku |
| Low | Large | Low | haiku |
| Medium | Any | Medium | sonnet |
| High | Small | High | sonnet or opus |
| High | Large | High | opus |
| Any | Any | Critical | opus |

## Cost Optimization Tips

1. **Start with sonnet** - upgrade to opus only if quality insufficient
2. **Use haiku for validation** - quick checks before complex operations
3. **Scope narrowly** - smaller, focused agents can use cheaper models
4. **Limit tools** - fewer capabilities = simpler decisions = cheaper model works

## Examples by Agent Type

| Agent Purpose | Recommended Model | Reasoning |
|---------------|-------------------|-----------|
| Log analyzer | haiku | Pattern matching, simple extraction |
| Code formatter | haiku | Deterministic transformations |
| PR reviewer | sonnet | Judgment required, not critical |
| Test writer | sonnet | Creative but bounded scope |
| Security auditor | opus | Critical, requires deep analysis |
| Architecture reviewer | opus | Complex reasoning, high impact |
| Documentation writer | sonnet | Creative but straightforward |
| Bug investigator | sonnet or opus | Depends on codebase complexity |
