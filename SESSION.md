# Session Log -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Inherits:** Root `.claude\` -- all governance, agents, skills, hooks apply here.

---

## Last session

**Date:** 2026-09-24
**What was done (major redesign -- rotation model replaced entirely):**

- **Diagnosed why two posts came out on the same subject:** the old counter-based rotation had a real race condition (from repeated manual test/delete cycles during earlier debugging) that kept resetting to index 0 (Microsoft Fabric). Root cause traced directly from the live Sheet data, not guessed.
- **Full redesign, agreed with user, then built and tested end-to-end:**
  - New `DaySchedule` tab (Day -> Subject, user-editable): Sun=Power BI, Mon=AI, Tue=Microsoft Fabric, Wed=GitHub, Thu=Data Engineering, Fri=Machine Learning, Sat=System Design.
  - `Counter` tab replaced entirely with a `History` tab (Date, Day, Subject, Label, Status) -- a real audit log instead of a single fragile number. Removes the whole class of race-condition bug, since day-of-week lookup needs no incrementing state at all.
  - New Wednesday/GitHub branch: calls the real GitHub Search API directly (`api.github.com/search/repositories`, sorted by stars, filtered to recently pushed) -- no MCP connector needed, since n8n's unattended 4:15am run can't use MCP tools (those are for Claude's own conversational use only). Grounds the post in a real repo (name, stars, description, URL).
  - Fixed two real pre-existing bugs found while investigating: `Add Row`/`Update Google Sheet` never wrote to `Confirm  Content?` at all (now writes the user's actual Yes/No/feedback decision back); `Post Link` was a broken static string literal, not a real link (now builds a real URL from the post's LinkedIn URN).
- **Nodes added:** Read Day Schedule, Get Today Subject, Match Config Row, Is GitHub Day? (IF), Fetch GitHub Top Repo, Build GitHub Post, Log History. **Nodes removed:** Read Counter, Pick Subject, Update Counter.
- **Real bugs hit and fixed during testing (both caught by actually running it, not assumed):**
  1. `Is GitHub Day?` IF node: malformed boolean-operator schema (`Wrong type: '' is a string but was expecting a boolean`) -- switched to a string-equals comparison matching the proven pattern used elsewhere in this workflow.
  2. Same node, second pass: strict type validation rejected a real JS boolean against a string `"true"` -- switched `typeValidation` to `loose`.
- **Verified live, end-to-end:** a full run correctly identified today as Thursday, correctly routed to the RSS branch (not GitHub), picked Data Engineering per the new DaySchedule mapping, generated real grounded content (James Serra blog, dash-structured, no repeats), and logged a correct row to History (`2026-09-24 | Thursday | Data Engineering | Queued`). Sitting in Gmail for approval, unchanged from before.
- Browser tooling was flaky for a stretch this session (third-party cookies blocking the extension); resolved once the user allowed them.

**Decisions made:**
- See DECISIONS.md -- several new entries this session, all under 2026-09-24.

**What broke / surprises:**
- The counter-based rotation's race condition (root cause of the "same subject twice" complaint) -- fully explained and resolved by removing the counter model entirely, not by patching it.
- IF node schema for boolean conditions is easy to get wrong via the API (no UI validation to catch it) -- string-comparison + loose type validation is the safer pattern for future IF nodes built this way.

---

## Next session -- start here

1. **Still open from last session:** live end-to-end test of the "No + feedback" regeneration path specifically (wiring confirmed correct, never actually clicked through). Low priority now given how much else has been verified working, but still genuinely untested.
2. **Wednesday/GitHub branch has not yet been triggered live** (today was Thursday) -- worth a manual test run once the day rolls around, or a one-off manual trigger, to confirm the GitHub Search API call and Build GitHub Post logic work as designed.
3. Same open items as before: verify/expand "reasonably confident" (not individually confirmed) RSS feeds in Config for Data Science, Machine Learning, AI, PySpark; Microsoft Purview still has no working feed (falls back to description-only generation).
4. Confirm Content?/Post Link fixes haven't been observed on a real approved post yet (today's run is still pending approval as of session end) -- worth checking the Sheet after approval to confirm both write correctly in practice, not just in theory.

**Blockers:**
- None. Workflow is active, tested, and in a known-good state.

---

## Open questions

| Question | Owner | Status |
|----------|-------|--------|
| Does "No" + feedback regeneration actually resend a working email end-to-end? | User/Claude to test | Still open |
| Does the GitHub/Wednesday branch actually work when it fires for real? | Untested live | Open -- built and reviewed, not yet run |

---

Rolling scratchpad -- overwrite each session. Permanent decisions go to DECISIONS.md. Permanent log goes to CHANGELOG.md.
