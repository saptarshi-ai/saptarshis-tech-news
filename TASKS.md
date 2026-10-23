# Tasks -- AI Generated LinkedIn (Saptarshi's Tech Hub)

[ ] open  [done] complete. Used by the activity rollup -- keep these markers.

---

## Active

| # | Task | Notes | Target | Done |
|---|------|-------|--------|------|
| 2 | [ ] Live end-to-end test of "No + feedback" regeneration path | Wiring verified correct, never actually clicked through live | Next session | |
| 5 | [ ] Live test of the GitHub/Wednesday branch | Built and code-reviewed, not yet actually triggered (last test session was a Thursday) | Next Wednesday, or manual trigger | |
| 6 | [ ] Confirm Confirm Content?/Post Link fixes work on a real approved post | Fixed in code, not yet observed on an actually-approved row | Once today's pending post is approved | |
| 7 | [ ] Rebuild Generate Post Content's structure/rhythm to match the Leon Gordon reference style | Short, near one-sentence lines, heavy whitespace, contrarian opening, honest-nuance beat, reframe, close -- a real rhythm shift from current 2-4 sentence paragraphs | User-provided reference posts (2 screenshots) | |
| 8 | [ ] Build weekly manual-publish Newsletter draft (Option B) | Native LinkedIn Pulse/Newsletter article creation has no public write API (confirmed) -- Claude prepares a draft in the editorial voice/structure, user pastes into LinkedIn's own "Write an article" editor and adds the banner image themselves. Gives daily posts' close a real "read more" destination to point to. | Weekly cadence, TBD day | |

## Pending

| # | Task | Trigger | Done |
|---|------|---------|------|
| 3 | [ ] Verify/expand RSS feed coverage for "reasonably confident" Config subjects | Data Science, Machine Learning, AI, PySpark, Data Engineering currently use platform-standard guesses, not individually confirmed | |
| 4 | [ ] Find a working Microsoft Purview feed, or accept description-only generation permanently for that subject | Currently falls back gracefully | |
| 12 | [ ] Post length runs ~3,000 chars vs 2,600-2,800 target | Model treats the range as a guide | |
| 13 | [ ] System message date anchor is a fixed (non-expression) field, so its $now expression is sent as literal text | Prompt text carries the live date since 09/10; fix only if posts drift on dates again | |
| 14 | [ ] Confirm 25/10 04:15 run after 24/10 container recreate; if container loses its network again, plan a 03:45 self-check | Causes found: VPN (20/10), lost container network (21-23/10) | |

## Done

| # | Task | Completed |
|---|------|-----------|
| 1 | [done] Initial setup | 2026-09-20 |
| 9 | [done] Overnight wake automation fires unattended (04:15 on time 12-18/10 after 11/10 docker restart fix) | 2026-10-12 |
| 10 | [done] Reconnect Google Sheets + Gmail credentials (after production publish) | 2026-10-17 |
| 11 | [done] Publish Google OAuth app to In production (Pages home/privacy in this repo) | 2026-10-16 |
