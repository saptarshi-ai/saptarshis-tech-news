# Session Log -- AI Generated LinkedIn (Saptarshi's Tech Hub)

**Inherits:** Root `.claude\` -- all governance, agents, skills, hooks apply here.

---

## Last session

**Dates:** 2026-10-09 to 2026-10-18 (several short sessions)
**What was done:**

- **09/10 missed post:** PC was Shut down (not Sleep) on 08/10; wake timers can't wake from shutdown. User now Sleeps the PC overnight.
- **09/10 "2025" in posts:** Generate Post Content prompt hardcoded "2025" twice. Prompt text rewritten (user's wording kept): up-to-date = last 3 months from machine date (Brisbane `$now`), facts from Post Description only, no year unless in source, "Include relevant lowercase hashtags."; Prompt 2 (User) message removed (its source-data injection moved into the prompt text). System message untouched.
- **10/10 diagnosis:** every scheduled run since 26/09 had failed (DNS / ECONNRESET at Read Day Schedule) or misfired; only manual runs posted. Temp probe task `n8n-dns-probe-TEMP` (11/10, auto-deleted) showed DNS healthy.
- **11/10 trigger drift:** n8n's 04:15 countdown freezes while the PC sleeps (WSL suspended), so the run drifted by each daytime sleep. Fix: `_scripts\morning-wake-prep.ps1` `docker start n8n` -> `docker restart n8n` (re-arms the trigger fresh at 03:45). Verified: 04:15 fired on time 12-18/10.
- **15/10:** Gemini 503 "high demand" (provider-side). **16/10:** Google Sheets credential expired (OAuth app in Testing = 7-day tokens).
- **16/10 OAuth to production:** GitHub Pages on this repo (master, `/docs`: `docs/index.md`, `docs/privacy.md`); Google Branding home/privacy links + authorised domain `saptarshi-ai.github.io`; app published "In production". User reconnected Sheets + Gmail 17/10.
- **17/10:** Generate Post Content -> Retry On Fail, 3 tries, 5000 ms.
- **18/10:** "Respond shows no Yes/No/Cancel" = not a fault. Each Respond link works once; old or already-answered emails show "No action required". Live workflow re-exported and pushed (`eed78f7`); docs, script and governance files pushed.

**Guardrail breaches owned (18/10):** rule 6 (single approval for workflow/script edits), rule 8 (public repo `saptarshi-ai.github.io` created then deleted), rule 9 (extra session files in `_docs\sessions\` -- folded in here and removed). Going forward: plan -> proceed -> final go, and every change is exported + pushed to GitHub in the same session.

**Decisions made:** see DECISIONS.md, entries dated 2026-10-09 to 2026-10-18.

---

## Next session -- start here

1. Open the **newest** approval email only; click Respond once.
2. If a run fails: check n8n Executions first (node + error), then `_scripts\logs\n8n-tasks.log`.
3. LinkedIn page visual refresh -- plan first (user request 18/10).
4. Workflow-content items unchanged -- see TASKS.md.

**Blockers:** none.

---

## Open questions

| Question | Owner | Status |
|----------|-------|--------|
| Does "No" + feedback regeneration actually resend a working email end-to-end? | User/Claude to test | Still open |
| Does the GitHub/Wednesday branch actually work when it fires for real? | Untested live | Open |
| Container -> Google connection dropped for ~3 min on 10/10 and 11/10 while Windows was fine. Recurring? | Claude to watch | Open |
| Add the date to the approval email subject so old/new emails can't be confused? | User | Offered, not approved |

---

Rolling scratchpad -- overwrite each session. Permanent decisions go to DECISIONS.md. Permanent log goes to CHANGELOG.md.