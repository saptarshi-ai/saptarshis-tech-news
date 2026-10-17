# Architecture — AI Generated LinkedIn

**ID:** TODO
**Status:** draft

This file must match the folder. If they disagree, fix this file in the same session.

## What this bloom is

One paragraph. How it is built, and what calls it.

## Folders

```
01_Content_Engine\AI_Generated_LinkedIn/
  project-goal.md
  architecture.md
  guardrails.md
  CHANGELOG.md
  TASKS.md
  SESSION.md
  HYPOTHESIS.md
  DECISIONS.md
  README.md
  _docs/
  _outputs/
  _archive/
```

A code bloom also has `src/`, `tests/`, `_data/`, and `.env.example`. Secrets live in `.env`. `.env` is never committed.

Add `.mcp.json` only when this bloom needs a server the OS root does not already have. Add `harness/` only when a scheduled run exists.

## Data flow

1. In: {{SOURCE}}
2. Through: {{STEP}}
3. Out: {{DESTINATION}}
4. Recorded in: `CHANGELOG.md`

## Must not touch

- Atlas workflows, scrapers, Notion sync, finance processing, and scheduled tasks under `D:\Saptarshi\claude_ProjectAtlas`. From this OS, `91_ProjectAtlas_Link` is read-only. Three separate approvals before any change there.
- Shared skills, agents, hooks, and guardrails in `D:\Saptarshi_OS\.claude`.
- Another bloom's files. The owner is in `00_GOVERNANCE\OWNERSHIP_MAP.md`.
- {{BLOOM_SPECIFIC_PROTECTED_THING}}

## Model routing

Use the cheapest rung that can do the step.

| Step | Rung |
|---|---|
| Sort, tag, filter, score | Ollama, then cheap OpenRouter |
| A typed choice or score | Jev, once it is installed. Jev does not write the plan or the code |
| A draft a person will publish or rely on | Claude or Grok |

Start at the top of this table. Escalate when the rung cannot do the job.

A scheduled run on this OS is registered by extending `00_GOVERNANCE\scripts\_registertasks.ps1`. Atlas scheduled tasks stay on Atlas. A VS Code study lab uses this same page. The editor is VS Code.

## Tools

Cite GH- ids. Do not keep a second list. A repo is required here only when `repos.json` says `install_state: installed`.

| GH- id | Use in this bloom |
|---|---|
| GH-0013 | Headroom on every run, including a scheduled task and a VS Code lab |
| GH-0010 | Caveman on model output |
| GH-0015 | Markitdown before reading a PDF or Office file |
| GH-0020 | Ponytail. Least code that works |
| GH-0023 | Superpowers. Session discipline |
| {{GH_ID}} | {{WHY_THIS_BLOOM}} |

Candidates, not required until a deep review: OmniRoute (GH-0028) as the local gateway to the cheap rung, and archify (GH-0041) as a diagram of this file. This file stays the record.

## Shared and local

| OS root | This bloom |
|---|---|
| Skills, agents, hooks, guardrails | The work |
| `00_GOVERNANCE` | This page, the goal, the changelog, the tasks |
| Idea registry and GitHub library | A row in the registry |

Bloom-specific rules go in this file. A `.claude` folder inside the bloom is not created. That ban is in `NAMING_STANDARD.md`.

## When a run fails

A failed scheduled run writes one recovery line at the top of `CHANGELOG.md`. Silent failure is a defect.
