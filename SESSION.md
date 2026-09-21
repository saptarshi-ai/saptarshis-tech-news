# Session Log -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Inherits:** Root `.claude\` -- all governance, agents, skills, hooks apply here.

---

## Last session

**Date:** 2026-09-21
**What was done (major session -- full pipeline built and debugged end-to-end):**

- **Credentials:** Google Sheets, Gmail, LinkedIn OAuth all connected and wired into the workflow's 5 credential-requiring nodes.
- **Original Google Sheet was permanently deleted (real finding).** Recreated at `1B3PlTi0ZIK15evn4SWy8wN8ycoKRIbPTzKDdo8pLljo` with tabs: `LinkedinData` (queue), `Config` (25 subject/publication/feed rows, user-editable), `Counter` (rotation counter, separate tab to avoid header-row collision with Config).
- **Built real subject rotation + article-fetch feature:** Read Config -> Read Counter -> Pick Subject -> Fetch Feed (real RSS, 30-day freshness filter) -> Build Post -> Add Row -> Update Counter, feeding into the existing tested approval pipeline unchanged.
- **`content-writing-style` skill built** from a real review of chi-feng/humanizer + blader/humanizer -- self-audit pass, fix-by-subtraction, frequency-on-two-axes. Linked from `content-writer` agent and root CLAUDE.md.
- **Real bugs found and fixed (in order found):**
  1. `Add Row` / `Update Counter` missing `columns.schema` (n8n resourceMapper requirement when built via API, not UI).
  2. `Get Data from Sheets` had no row limit -> batched leftover + newly-added rows together, causing `Generate Post Content` to run twice per execution.
  3. **Root cause of empty approval emails:** `Data Formatting 1`'s field mappings (Post Content / Post Description / Instructions) had been silently wiped during an earlier full-workflow API overwrite. Restored.
  4. `Get Data from Sheets` fixed with `returnFirstMatch: true` (prevents the duplicate-row batching regardless of leftover rows).
  5. **Real live-post bug:** `Post Without Image` was posting the AI *instructions* (`Post Description`) instead of the AI-*generated* text (`Post Content`) -- this is what produced the garbage post that had to be manually deleted from the real company page. Fixed to reference `Data Formatting 1`'s `Post Content`, matching `Post With Image` (which was already correct).
  6. Model was defaulting to a stale internal "current year" (wrote "2025") separate from the real fetched-article date. Fixed with an explicit `$now` (Brisbane) date/location anchor injected into the prompt.
- **Content quality fixes:** length target raised to ~2,400 chars, structured writing style added (short paragraphs, arrow/dash breakdowns, one-line takeaway -- modelled on a real example post the user liked), date moved to a clean footer (`dd/MM/yyyy`, e.g. `21/09/2026`), GitHub Blog (`github.blog/feed/`) added as a 25th Config source.
- **Repo renamed public:** `AI-Generated-LinkedIn` -> `saptarshis-tech-news`, made public (verified safe first -- only `.env.example` was ever tracked, real secrets never left `.env`).
- **A real, clean post was successfully published** to Saptarshi's Tech Hub and verified live (`urn:li:share:7507717139245826048`, 21/09/2026, correct content, correct date format).
- Full safety-critical debugging discipline used throughout: backed up the working workflow (both as a local file and a separate n8n workflow copy) before any risky fix, deleted only after every fix was confirmed working.

**Decisions made:**
- See DECISIONS.md (this session added several -- read it before touching the workflow again).

**What broke / surprises:**
- All 6 real bugs listed above. The biggest lesson: full-workflow JSON overwrites via the API are dangerous -- a `Data Formatting 1` node's fields got silently wiped this way and wasn't caught until a live post went out with the wrong text. Prefer targeted patches over full re-serialization where possible; always verify field-by-field after any full overwrite before trusting a run.

---

## Next session -- start here

1. **TODO (explicitly deferred by user this session): run a live end-to-end test of the "No + feedback" regeneration path.** The wiring was verified correct via API (`Content Confirmation Logic` -> `Regenerate Post Content` -> `Data Formatting 1` -> back to `Send Content Confirmation`), and the `Data Formatting 1` fix should have fixed this path too since it's shared with the first-pass path -- but this has **not** been confirmed with a real click-through. Trigger a run, wait for the approval email, reply "No" with feedback, and confirm a *second* email arrives with genuinely regenerated content.
2. Continue monitoring daily 4:30am scheduled runs once the above is confirmed -- currently still requires manual "Execute workflow" trigger, not yet relying on the schedule alone for a full unattended day.
3. Consider verifying/expanding RSS feed coverage for the Config subjects still marked "reasonably confident" rather than directly confirmed (Data Science, Machine Learning, AI, PySpark alias, Data Engineering) -- see Config tab Notes column.
4. Microsoft Purview still has no working RSS feed (confirmed broken even on Microsoft's own side) -- falls back to description-only generation for that one subject.

**Blockers:**
- None currently. Workflow is in a known-good, tested state as of end of this session.

---

## Open questions

| Question | Owner | Status |
|----------|-------|--------|
| Does the "No" regeneration path actually resend a working email end-to-end? | User to test next session (or ask Claude to trigger) | Open -- see Next session #1 |

---

Rolling scratchpad -- overwrite each session. Permanent decisions go to DECISIONS.md. Permanent log goes to CHANGELOG.md.
