# CLAUDE.md -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Domain:** 01_Content_Engine
**Goal:** Daily automated LinkedIn posts to Saptarshi's Tech Hub -- n8n + Gemini API, human-in-the-loop approval via Gmail, sourced from Google Sheet queue with real RSS article grounding and a day-of-week subject schedule.
**Inherits:** Root `.claude\` -- all agents, skills, hooks, governance apply. No `.claude\` here.
**GitHub:** `github.com/saptarshi-ai/saptarshis-tech-news` (public)

## Project context

**Status as of 2026-09-24: working end-to-end, day-of-week scheduling live and tested, real post successfully published previously under the old model.**

The workflow (n8n, ID `bGwlVgAcfU1u2yDM`, Schedule Trigger 04:15 Brisbane time) does, on trigger:
1. Read `DaySchedule` tab -> determine today's weekday -> look up today's Subject.
2. Read `Config` tab -> match that Subject to its Publication/Feed URL.
3. **If Subject = GitHub** (Wednesdays): call the real GitHub Search API directly, ground the post in a real trending/highly-starred repo.
   **Otherwise:** fetch that subject's RSS feed, filter to articles <=30 days old.
4. Build a grounded post brief, add a `Pending` row to `LinkedinData`, log the pick to `History` (Date, Day, Subject, Label, Status).
5. Generate the actual post via Gemini (date/location-anchored, ~2,400 chars, structured/human writing style).
6. Email for approval (Gmail sendAndWait: Yes / No+feedback / Cancel).
7. On Yes: post to Saptarshi's Tech Hub (org URN `107520627`), update the Sheet row to Completed, write the actual approval decision to `Confirm  Content?` and a real post link.
8. On No: regenerate with the given feedback and loop back to step 5 (wiring verified correct, **not yet live-tested end-to-end**).

**Sheet (`1B3PlTi0ZIK15evn4SWy8wN8ycoKRIbPTzKDdo8pLljo`) tabs:**
| Tab | Purpose |
|---|---|
| `LinkedinData` | The approval queue (Post Description, Instructions, Status, `Confirm  Content?`, Label) |
| `Config` | Subject/Publication/Feed URL/Notes -- 25 rows, user edits this directly to add sources |
| `DaySchedule` | Day -> Subject mapping -- user edits this directly to change the weekly schedule |
| `History` | Audit log: Date, Day, Subject, Label, Status -- replaces the old single-counter model entirely |

Read SESSION.md for exactly where the last session left off -- it has live TODOs.
Read DECISIONS.md for why things are built the way they are, especially the redesign reasoning from 2026-09-24.

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
- **Never fully overwrite the n8n workflow via API without re-verifying every node's fields afterward** -- a full JSON PUT silently wiped `Data Formatting 1`'s field mappings once, undetected for several runs.
- **IF nodes built via the API need care:** boolean-type operators are easy to get wrong with no UI to catch it (`Wrong type` errors). Prefer string-equals comparisons with `typeValidation: "loose"` -- proven pattern, matches `Content Confirmation Logic`'s working design.
- Before any risky change, back up the workflow (n8n duplicate + local JSON export). Delete the backup only after the fix is confirmed working end-to-end.
- Deleting an n8n *execution* record does not undo real side effects (Sheet rows already written, emails already sent) -- clean those up separately.
- Verify LinkedIn node `Text` fields reference `Data Formatting 1`'s `Post Content`, never `Get Data from Sheets`'s `Post Description` (that's the AI's instructions, not its output).
- MCP connectors (GitHub, etc.) are for Claude's own conversational use -- n8n's unattended scheduled runs can't use them. Anything the workflow itself needs must be a direct HTTP call (credentials or public API) inside the workflow.
- Google Sheets "Get Row(s)" reads the *entire* used range using row 1 as headers regardless of a `range` option -- keep unrelated data (like counters) in their own tab, never a corner of a table-shaped tab.
