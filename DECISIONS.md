# Decisions -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Format:** append at the top. One entry per significant decision. Never edit a past entry -- supersede it.

---

## Template

### YYYY-MM-DD - [ARCH|TECH|PROCESS|DATA] - Short title

**Decision:** What we decided.
**Why:** The reason -- constraints, evidence, or trade-off that drove it.
**Alternatives rejected:** What we considered and why we did not pick it.
**Supersedes:** (link to earlier decision if this overrides one, else delete this line)

---

### 2026-09-20 - ARCH - Project created as Type=Code

**Decision:** Use `Code` project scaffold.
**Why:** Daily automated LinkedIn posts to Saptarshi's Tech Hub -- n8n + Gemini API, human-in-the-loop approval via Gmail, sourced from Google Sheet queue.
**Alternatives rejected:** N/A -- initial setup.

### 2026-09-21 - ARCH - Subject rotation & article grounding built as a pre-pipeline stage

**Decision:** Add Read Config -> Read Counter -> Pick Subject -> Fetch Feed -> Build Post -> Add Row -> Update Counter as new nodes running *before* the existing (tested, working) Get Data from Sheets -> Generate Post Content -> approval chain, rather than restructuring that chain.
**Why:** Preserves everything already proven to work; the new stage's only job is to queue a well-formed Pending row, same shape as a human would add manually.
**Alternatives rejected:** Rewriting Get Data from Sheets to do rotation+fetch itself -- more invasive, higher risk to the tested approval flow.

### 2026-09-21 - DATA - Counter moved to its own Sheet tab, separate from Config

**Decision:** The rotation counter (`NextPostNumber`) lives in its own `Counter` tab, not in a corner of `Config`.
**Why:** n8n's Google Sheets "Get Row(s)" reads the *entire* used range using row 1 as headers regardless of a `range` option (confirmed this doesn't scope the read as expected) -- co-locating the counter in the same tab as the 24-row Config table caused it to be swept in as a fake 25th data row.
**Supersedes:** Original placement of the counter at Config!F1:G1, later Config!A27:B28 -- both broken for the same reason.

### 2026-09-21 - TECH - `Get Data from Sheets` uses `returnFirstMatch: true`

**Decision:** Always take only the first Pending row, never all matches.
**Why:** The rotation stage's own `Add Row` runs earlier in the *same* execution as `Get Data from Sheets` -- without a limit, any leftover unresolved row plus the freshly-added one get batched together, and `Generate Post Content` / `Data Formatting 1` are built for exactly one item, silently breaking on two.

### 2026-09-21 - PROCESS - Full-workflow JSON overwrites via n8n API are treated as dangerous

**Decision:** Prefer fetch-then-patch-then-verify over blind full re-serialization when editing the live workflow. After any full PUT, re-check the fields of every node that wasn't the direct target of the edit.
**Why:** `Data Formatting 1`'s field mappings were silently wiped by an earlier full overwrite this session and weren't caught for several runs -- root cause of both the empty-approval-email bug and indirectly the bad live post (since the wrong fallback field got used once the intended one broke).

### 2026-09-21 - CONTENT - Date footer format is `dd/MM/yyyy` (Australian), placed at the very bottom of the post

**Decision:** Every generated post ends with `\n\n- {{ date }}` in `dd/MM/yyyy` format, e.g. `21/09/2026`.
**Why:** User's explicit preference -- wanted the date kept (liked seeing it) but moved out of the body and into a clean footer, in Australian date order.

### 2026-09-24 - ARCH - Counter-based rotation replaced entirely with day-of-week scheduling

**Decision:** Remove the incrementing-counter rotation model completely. Replace with a `DaySchedule` tab (Day -> Subject, user-editable) that the workflow looks up fresh every run based on the actual current weekday.
**Why:** The counter model had a real, confirmed race condition -- traced directly from live Sheet data showing 6 consecutive runs all reading counter=1, caused by overlapping manual test/delete cycles during earlier debugging. Day-of-week lookup needs no persisted incrementing state at all, so this entire bug class becomes structurally impossible, not just patched.
**Alternatives rejected:** Adding locking/transactional writes to the counter -- more complex, still fragile, doesn't match how the user actually wants to plan content (by day, not by sequential rotation).
**Supersedes:** 2026-09-21 decision "`Get Data from Sheets` uses returnFirstMatch" (still true and still in place, but no longer the primary defense against repeats -- day-of-week lookup is).

### 2026-09-24 - DATA - Counter tab replaced with a History log tab

**Decision:** `Counter` tab (single NextPostNumber value) removed. `History` tab added: Date, Day, Subject, Label, Status -- one row appended per run.
**Why:** User wanted visibility into what subject ran on what date, not just a hidden counter. Also serves as a natural audit trail for debugging future "why did X happen" questions without needing to reconstruct history from execution logs.

### 2026-09-24 - ARCH - GitHub/Wednesday content sourced via direct API call, not MCP

**Decision:** Wednesday's GitHub-repo post is built by an HTTP Request node calling `api.github.com/search/repositories` directly (unauthenticated, well within free rate limits for one daily call) -- not via an MCP GitHub connector.
**Why:** MCP connectors are tools Claude uses in conversation; n8n's unattended 4:15am scheduled run has no Claude involvement and cannot invoke MCP tools. The workflow needs its own direct way to reach GitHub's API regardless of what's connected in chat.
**Alternatives rejected:** MCP GitHub connector (asked about by user, explained why it doesn't apply to this use case).

### 2026-09-24 - TECH - Confirm Content? and Post Link write-back bugs fixed

**Decision:** `Update Google Sheet` now writes the real approval decision (`$('Send Content Confirmation').item.json.data['Confirm  Content?']`) and a real constructed post URL (`https://www.linkedin.com/feed/update/{urn}`), replacing two long-standing no-ops (one column never written at all; the other a broken static string).
**Why:** Found while investigating the "same subject twice" complaint -- neither bug was the direct cause, but both were real, silent defects worth fixing while already deep in this part of the workflow.

<!-- Add new entries above this line -->
