# Changelog -- AI Generated LinkedIn (Saptarshi's Tech Hub)

Format: `YYYY-MM-DD - what changed - why`
Append at the top. One line per structural change.

---

## 2026-09-21 - Full pipeline built end-to-end; 6 real bugs found and fixed; first live post published successfully

Credentials connected; Sheet recreated after original was permanently deleted (Config/LinkedinData/Counter tabs); subject-rotation + real RSS article-fetch stage built (30-day freshness filter); content-writing-style skill built from a real humanizer-repo review; date/location anchor added to fix stale-year generation; content length/structure improved to match a user-provided reference post; GitHub Blog added as 25th source; repo renamed to `saptarshis-tech-news` and made public (verified safe).

Real bugs fixed, in order found: (1) missing `columns.schema` on Sheets write nodes, (2) unbounded Get Data from Sheets caused duplicate-item batching, (3) `Data Formatting 1` field mappings silently wiped by an earlier full-workflow overwrite -- root cause of empty approval emails, (4) `returnFirstMatch` added as the permanent fix for (2), (5) `Post Without Image` was posting the AI's instructions instead of its generated output -- caused one bad post that had to be manually deleted from the real company page, (6) date footer format changed to `dd/MM/yyyy` per user preference.

Verified live: a real, correctly-formatted post was published to Saptarshi's Tech Hub (`urn:li:share:7507717139245826048`). See DECISIONS.md for the reasoning behind each fix and SESSION.md for the one open TODO (live-testing the "No" regeneration path).

---

## 2026-09-20 - Project created
