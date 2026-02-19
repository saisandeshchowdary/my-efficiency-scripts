---
name: agent-creator
description: >-
  Create specialized subagents with optimal configuration. Use when user wants
  to create a new agent, subagent, AI worker, or automated task handler.
  Triggers include: create an agent, make a subagent, I need an agent for X,
  build me an agent, or any request to automate a specific workflow via a
  dedicated AI worker. This skill handles agent naming, description writing,
  tool selection, skill assignment, and model optimization.
---

# Agent Creator

Create optimized subagent configurations at `C:\Users\ssandesh\.copilot\agents`.

## Workflow

### Step 1: Understand the Agent's Purpose

Ask clarifying questions if needed:
- What specific task should this agent handle?
- Will it need to read/write files, run commands, search code?
- Is it a simple automation or complex reasoning task?

### Step 2: Discover Available Resources

**CRITICAL: Always discover dynamically. Never assume what skills/tools exist.**

#### Discover Available Skills

List the skills directory and read each skill's frontmatter:

```powershell
Get-ChildItem "C:\Users\ssandesh\.copilot\skills" -Directory | ForEach-Object { $_.Name }
```

For each skill found, read the first 15 lines of its SKILL.md to extract name and description:

```powershell
Get-Content "C:\Users\ssandesh\.copilot\skills\{skill-name}\SKILL.md" -First 15
```

Build a mental inventory of available skills before selecting any.

#### Discover Available Tools

Use `tool_search_tool_regex` with broad patterns to discover tools:

```
pattern: ".*"  (lists all tools, use sparingly)
pattern: "mcp_"  (MCP server tools)
pattern: "git|github"  (version control tools)
pattern: "file|read|write"  (file operation tools)
```

Common tool categories to search for:
- File operations: `read|write|edit|create_file`
- Search: `grep|glob|semantic_search`
- Terminal: `run_in_terminal|bash|powershell`
- Git: `git|github|mcp_gitkraken`
- Web: `fetch|browser`

### Step 3: Determine Agent Configuration

#### Naming Convention

Use kebab-case, descriptive names:
- `code-reviewer` (not CodeReviewer or code_reviewer)
- `test-generator`
- `doc-writer`
- `security-auditor`

#### Description Writing

The description is CRITICAL - it determines when Claude delegates to this agent.

**Good description pattern:**
`[Role] that [primary action]. Use for [specific triggers/scenarios].`

Example: `Senior security engineer that audits code for vulnerabilities. Use when reviewing PRs for security issues, scanning for secrets in code, or checking authentication flows.`

#### Model Selection

| Complexity | Model | Use When | Cost |
|------------|-------|----------|------|
| Simple | `haiku` | File organization, simple searches, formatting tasks | Lowest |
| Standard | `sonnet` | Code review, refactoring, documentation, most dev tasks | Medium |
| Complex | `opus` | Architecture decisions, security audits, complex debugging, research | Highest |

**Decision guide:**
- Reading files + simple output -> haiku
- Code analysis + suggestions -> sonnet
- Multi-step reasoning + critical decisions -> opus

See [references/model-selection.md](references/model-selection.md) for detailed guidance.

#### Tool Selection

Select ONLY tools the agent actually needs from the discovered tools.

Common tool mappings:
| Need | Tools to Consider |
|------|-------------------|
| Read files | Read, read_file |
| Find files | Glob, file_search |
| Search content | Grep, grep_search, semantic_search |
| Run commands | Bash, PowerShell, run_in_terminal |
| Modify files | Write, Edit, create_file, replace_string_in_file |
| Web access | Fetch, fetch_webpage |
| Git operations | mcp_gitkraken_* tools |

**Principle:** Fewer tools = more focused agent. Do not grant Bash if Read suffices.

#### Skill Selection

From the discovered skills, match to agent purpose:
- PDF processing agent -> pdf skill (if available)
- Presentation builder -> pptx skill (if available)
- Documentation agent -> docx, doc-coauthoring skills (if available)
- Data analysis agent -> xlsx skill (if available)
- UI builder agent -> frontend-design skill (if available)

Only assign skills that were discovered and are relevant.

### Step 4: Generate Agent File

Create the agent at: `C:\Users\ssandesh\.copilot\agents\{agent-name}.agent.md`

Template:
```markdown
---
name: {agent-name}
description: {comprehensive-description}
tools: {comma-separated-tools}
model: {haiku|sonnet|opus}
skills: {comma-separated-skills-if-needed}
---

{System prompt with role, responsibilities, and guidelines}
```

### Step 5: Output Enhancement Suggestions

After creating the agent, ALWAYS evaluate and suggest:

1. **Missing Tools**: Tools not currently available that would enhance the agent
2. **Missing Skills**: Skills not installed that would benefit the agent
3. **MCP Servers**: Any MCP servers that could extend capabilities

Format suggestions as:

```
## Recommendations for Enhanced Performance

### Suggested Tools (Not Currently Available)
- **tool-name**: Why this would help

### Suggested Skills (Not Installed)
- **skill-name**: What capability this would add

### Suggested MCP Servers
- **server-name**: Integration benefit
```

Only suggest if genuinely beneficial - do not force suggestions.

## Discovery Commands Reference

### List All Skills
```powershell
Get-ChildItem "C:\Users\ssandesh\.copilot\skills" -Directory | ForEach-Object { $_.Name }
```

### Get Skill Details
```powershell
Get-Content "C:\Users\ssandesh\.copilot\skills\{name}\SKILL.md" -First 20
```

### List Existing Agents
```powershell
Get-ChildItem "C:\Users\ssandesh\.copilot\agents" -Filter "*.agent.md" | ForEach-Object { $_.Name }
```

### Search for Tools
Use tool_search_tool_regex with relevant patterns based on agent needs.

## Examples

### Example 1: PR Reviewer Agent

**User request:** Create an agent to review my pull requests

**Discovery step:**
1. List skills -> found: doc-coauthoring, docx, pdf, etc.
2. Search tools for `git|review` -> found: mcp_gitkraken_* tools
3. None of the skills are directly relevant
4. Git tools would be useful for PR context

**Output:**

```markdown
---
name: pr-reviewer
description: Senior engineer that reviews pull requests for code quality, bugs, and best practices. Use when reviewing PRs, checking code changes, or validating implementations before merge.
tools: Read, Grep, Glob, mcp_gitkraken_pull_request_get_detail
model: sonnet
---

You are a senior software engineer conducting code reviews.

## Review Focus
- Code correctness and logic errors
- Performance implications
- Security considerations
- Code style and maintainability
- Test coverage gaps

## Review Format
Provide structured feedback with:
1. Summary of changes
2. Critical issues (must fix)
3. Suggestions (nice to have)
4. Questions for the author
```

### Example 2: Documentation Agent

**User request:** I need an agent to write technical documentation

**Discovery step:**
1. List skills -> found: doc-coauthoring, docx (both relevant!)
2. Search tools for `write|file` -> found: Write, create_file
3. Assign both documentation skills

**Output:**

```markdown
---
name: doc-writer
description: Technical writer that creates and maintains documentation. Use for writing READMEs, API docs, architecture docs, or any technical documentation needs.
tools: Read, Glob, Write
model: sonnet
skills: doc-coauthoring, docx
---

You are a technical documentation specialist.

## Documentation Standards
- Clear, concise language
- Code examples for all APIs
- Consistent formatting
- Proper markdown structure

## Output Formats
- Markdown for repos
- DOCX for formal documents
```