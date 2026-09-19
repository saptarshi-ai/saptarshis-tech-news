# CLAUDE.md -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Domain:** 01_Content_Engine
**Goal:** Daily automated LinkedIn posts to Saptarshi's Tech Hub -- n8n + Gemini API, human-in-the-loop approval via Gmail, sourced from Google Sheet queue.
**Inherits:** Root `.claude\` -- all agents, skills, hooks, governance apply. No `.claude\` here.

## Project context
TODO: fill in project-specific context, decisions, constraints.
Read SESSION.md for where the last session left off.
Read DECISIONS.md for architectural decisions.

## Key files
| File | Purpose |
|------|---------|
| SESSION.md | Where the last session left off. Read this first. |
| DECISIONS.md | Why things are the way they are. |
| TASKS.md | What is open right now. |
| CHANGELOG.md | Permanent record of structural changes. || src\ | Source code -- main module lives here. |
| tests\ | Test suite. |
| _data\ | Local data files. Never commit secrets. |
## Domain agents / skills
Any domain-specific agent or skill for this project lives in root `.claude\agents\` or `.claude\skills\`
with the prefix `ai-generated-linkedin-`. Never create a `.claude\` folder here.
