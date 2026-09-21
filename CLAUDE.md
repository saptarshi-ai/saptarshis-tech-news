# CLAUDE.md -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Domain:** 01_Content_Engine
**Goal:** Daily automated LinkedIn posts to Saptarshi's Tech Hub -- n8n + Gemini API, human-in-the-loop approval via Gmail, sourced from Google Sheet queue with real RSS article grounding.
**Inherits:** Root `.claude\` -- all agents, skills, hooks, governance apply. No `.claude\` here.
**GitHub:** `github.com/saptarshi-ai/saptarshis-tech-news` (public)

## Project context

**Status as of 2026-09-21: working end-to-end, one real post successfully published and verified live.**

The workflow (n8n, ID `bGwlVgAcfU1u2yDM`) does, on trigger:
1. Read `Config` tab (25 subject/publication/feed rows) + `Counter` tab (rotation position).
2. Pick the next subject in rotation, fetch its RSS feed, filter to articles <=30 days old.
3. Build a grounded post brief, add a `Pending` row to `LinkedinData`.
4. Generate the actual post via Gemini (date/location-anchored prompt, ~2,400 char target, structured/human writing style).
5. Email for approval (Gmail sendAndWait: Yes / No+feedback / Cancel).
6. On Yes: post to Saptarshi's Tech Hub (LinkedIn org URN `107520627`), update the Sheet row to Completed.
7. On No: regenerate with the given feedback and loop back to step 5 (wiring verified, **not yet live-tested end-to-end -- see SESSION.md**).

The Google Sheet (`1B3PlTi0ZIK15evn4SWy8wN8ycoKRIbPTzKDdo8pLljo`) is the **live source of truth for subjects and publications** -- the user edits the `Config` tab directly to add/remove sources; Claude should read whatever is there each session rather than assume a fixed list.

Read SESSION.md for exactly where the last session left off -- it has a live TODO.
Read DECISIONS.md for why things are built the way they are, especially around the real bugs found this session.

## Key files
| File | Purpose |
|------|---------|
| SESSION.md | Where the last session left off. Read this first. |
| DECISIONS.md | Why things are the way they are. |
| TASKS.md | What is open right now. |
| CHANGELOG.md | Permanent record of structural changes. |
| workflows/AI_Generated_LinkedIn.json | Exported copy of the live n8n workflow -- re-export after every change made via the n8n editor or API. |
| .env | Real credentials, gitignored. `.env.example` is the tracked template. |

## Domain agents / skills
Any domain-specific agent or skill for this project lives in root `.claude\agents\` or `.claude\skills\`
with the prefix `ai-generated-linkedin-`. Never create a `.claude\` folder here.
`content-writing-style` skill (root `.claude\skills\`) governs the writing/humanizer rules this project's prompt is built on.

## Hard-won operating notes (read before editing the workflow again)
- **Never fully overwrite the n8n workflow via API without re-verifying every node's fields afterward** -- a full JSON PUT silently wiped `Data Formatting 1`'s field mappings once this session and it went undetected for several runs. Prefer `str_replace`-style targeted patches on a freshly-fetched copy.
- Before any risky change, back up the workflow (n8n duplicate + local JSON export). Delete the backup only after the fix is confirmed working end-to-end.
- Deleting an n8n *execution* record does not undo real side effects (Sheet rows already written, emails already sent) -- clean those up separately.
- Verify LinkedIn node `Text` fields reference `Data Formatting 1`'s `Post Content`, never `Get Data from Sheets`'s `Post Description` (that's the AI's instructions, not its output) -- this was the cause of the one bad live post this session.
