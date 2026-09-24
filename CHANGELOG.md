# Changelog -- AI Generated LinkedIn (Saptarshi's Tech Hub)

Format: `YYYY-MM-DD - what changed - why`
Append at the top. One line per structural change.

---

## 2026-09-24 - Rotation model replaced with day-of-week scheduling; Counter tab replaced with History log; GitHub branch added; two silent write-back bugs fixed

Diagnosed the "same subject posted twice" complaint by reading the live Sheet data directly: a race condition in the old counter-based rotation (from overlapping manual test/delete cycles during earlier debugging) kept resetting the pick to index 0. Rather than patch the counter, removed it entirely.

New `DaySchedule` tab (user-editable Day -> Subject mapping: Sun=Power BI, Mon=AI, Tue=Fabric, Wed=GitHub, Thu=Data Engineering, Fri=Machine Learning, Sat=System Design) drives subject selection every run -- no persisted counter, so the whole bug class is now structurally impossible. `Counter` tab replaced with a `History` audit log (Date, Day, Subject, Label, Status).

New Wednesday/GitHub branch calls the real GitHub Search API directly (not MCP -- n8n's unattended run can't use MCP tools, only Claude's own conversation can) to ground posts in a real trending/highly-starred repo.

Also fixed two real, previously-silent bugs found while investigating: `Confirm  Content?` column was never written at all; `Post Link` was a broken static string instead of a real URL.

7 nodes added (Read Day Schedule, Get Today Subject, Match Config Row, Is GitHub Day?, Fetch GitHub Top Repo, Build GitHub Post, Log History), 3 removed (Read Counter, Pick Subject, Update Counter).

Verified live end-to-end: correctly identified Thursday, routed to the RSS branch, picked Data Engineering per the new schedule, generated real grounded content, logged a correct History row. One real bug hit and fixed during this test (IF node boolean-operator schema issue, then a type-validation mismatch) -- both caught by actually running it.

---

## 2026-09-21 - Full pipeline built end-to-end; 6 real bugs found and fixed; first live post published successfully

Credentials connected; Sheet recreated after original was permanently deleted (Config/LinkedinData/Counter tabs); subject-rotation + real RSS article-fetch stage built (30-day freshness filter); content-writing-style skill built from a real humanizer-repo review; date/location anchor added to fix stale-year generation; content length/structure improved to match a user-provided reference post; GitHub Blog added as 25th source; repo renamed to `saptarshis-tech-news` and made public (verified safe).

Real bugs fixed, in order found: (1) missing `columns.schema` on Sheets write nodes, (2) unbounded Get Data from Sheets caused duplicate-item batching, (3) `Data Formatting 1` field mappings silently wiped by an earlier full-workflow overwrite -- root cause of empty approval emails, (4) `returnFirstMatch` added as the permanent fix for (2), (5) `Post Without Image` was posting the AI's instructions instead of its generated output -- caused one bad post that had to be manually deleted from the real company page, (6) date footer format changed to `dd/MM/yyyy` per user preference.

Verified live: a real, correctly-formatted post was published to Saptarshi's Tech Hub (`urn:li:share:7507717139245826048`). See DECISIONS.md for the reasoning behind each fix and SESSION.md for the one open TODO (live-testing the "No" regeneration path).

---

## 2026-09-20 - Project created
