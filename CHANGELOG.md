# Changelog -- AI Generated LinkedIn (Saptarshi's Tech Hub)

Format: `YYYY-MM-DD - what changed - why`
Append at the top. One line per structural change.

---

## 2026-10-17 - Google OAuth app moved to production (no more 7-day expiry); Retry On Fail on Generate Post Content; Pages site for OAuth

Trigger: no post 15/10 and 16/10 although the 04:15 trigger fired both days (11/10 restart fix confirmed working 12-17/10).
- 15/10 cause: Gemini API 503 "model experiencing high demand" at Generate Post Content (provider-side, transient).
- 16/10 cause: Google Sheets credential "needs to be reconnected" -- OAuth app in Testing mode, refresh tokens expire after 7 days (last reconnect ~08/10).
Fixes:
- GitHub Pages enabled on `saptarshis-tech-news` (master, `/docs`): `docs/index.md` (home) + `docs/privacy.md` (privacy policy) -- live at https://saptarshi-ai.github.io/saptarshis-tech-news/. Required by Google to publish an app using Gmail/Sheets scopes. Owner email deliberately left off the public pages.
- Google Cloud project gen-lang-client-0796267227 (named "Project Atlas" in GCP; holds client "n8n Google Sheets/Gmail"): Branding -> home page, privacy link, authorised domain `saptarshi-ai.github.io`; Audience -> Publish app -> status "In production" (unverified, personal use -- "unverified app" screen on sign-in is expected).
- Google Sheets + Gmail credentials reconnected in n8n after publishing (17/10), so tokens no longer expire weekly.
- Generate Post Content node: Settings -> Retry On Fail on, 3 tries, 5000 ms wait (n8n max). Covers short 503 blips only. Published with version note; verified in published version via DB. Not live-tested (Execute step would re-run upstream nodes and write a Sheet row).
- Local repo fast-forwarded to fe1ffd5 (the two docs/ commits).
Housekeeping: empty repo `saptarshi-ai.github.io` created by mistake 16/10 and deleted by user 17/10.
Open: workflow JSON in repo not re-exported since 09/10 (prompt + retry changes live only in n8n); uncommitted local changes (CHANGELOG, morning-wake-prep.ps1, session logs) not yet pushed.

---
## 2026-10-13

- 15:16 Added project-goal.md, architecture.md, guardrails.md from PROJECT_TEMPLATE. No existing file was overwritten.


## 2026-10-11 - Morning script now restarts n8n (fixes drifting 04:15 trigger); prompt de-hardcoded from "2025"; temp DNS probe

Trigger: no post on 11/10 -- no execution at all. Execution history showed every scheduled run failing or misfiring since 26/09 (posts only went out via manual runs), plus off-schedule runs (06/10 05:39, 10/10 03:55).
Root cause: n8n's Schedule Trigger arms a countdown to the next 04:15. That countdown freezes while the PC sleeps (WSL VM suspended) and resumes on wake, so each daytime sleep pushes the next run later by the sleep length (10/10: slept 05:42-13:53, so Sunday's 04:15 would have fired ~12:25). Clock resync after wake can also fire it early.
Fix: `_scripts\morning-wake-prep.ps1` line 15-16: `docker start n8n` -> `docker restart n8n`. n8n re-arms the trigger fresh at 03:45; PC is held awake 03:45-06:00 so nothing can freeze it before 04:15. Tested by restart (healthy in ~20s, healthz 200, DNS OK) before the edit; syntax check passed. Workflow, boot script and other tasks untouched.
Also this session:
- 09/10: Generate Post Content -- removed both hardcoded "2025" lines; "up-to-date" = last 3 months from machine date (Brisbane), facts from Post Description only, no year unless in source; removed Prompt 2 (User) message (its source-data injection moved into the prompt text); added "Include relevant lowercase hashtags." Published via n8n UI with version notes. Repo `workflows\AI_Generated_LinkedIn.json` NOT yet re-exported.
- 10/10: temp task `n8n-dns-probe-TEMP` (03:50-04:35, 11/10) probed container DNS/HTTPS; all 10 checks passed -- DNS not the cause of 11/10. Task auto-deletes 2 days after end. Log: `_scripts\logs\dns-probe.log`.
Open: container's outbound connection to Google is intermittently flaky (ECONNRESET on 10/10 04:15 and on a manual run 11/10 08:15 while Windows reached Google fine; recovered within ~3 min). Watch 12/10 04:15 run. User must Sleep (not Shut down) the PC overnight.

---
## 2026-10-03 - Daily trigger fixed: WSL keepalive added, wake moved to 03:45, all hibernate sources disabled; Google OAuth credentials found expired

Trigger: no post had fired for several days. Read-only diagnosis via Desktop Commander found three separate faults, none of them in the workflow itself:
(1) **n8n died ~60s after every start.** Both `boot-start-n8n.ps1` and `morning-wake-prep.ps1` ran `wsl -- docker start n8n` and exited. With no open WSL session, WSL idle-shuts the VM and Docker/n8n go with it. Broken since the 2026-09-25 migration. Errors were hidden by `| Out-Null`, so tasks still reported exit 0.
(2) **Wake-from-sleep never worked.** Wake timers can't wake a PC from hibernate, and three things hibernated it: `Atlas_MorningSleep` (`shutdown /h` at 04:45 -- also mid approval window), `SaptarshiOS_IdleSleep_6AM` (`SetSuspendState` hibernates when hibernate is enabled), and the power plan's AC hibernate-after = 2h. Event log showed the PC sleeping straight through 03:50 on 01/10 and 02/10.
(3) **Google Sheets (and likely Gmail) OAuth credential expired** -- found on manual run, "Read Day Schedule" failed with a revoked/expired refresh token. Consistent with the Google Cloud OAuth app being in Testing mode (7-day refresh-token expiry).

Fixes (scripts + tasks only; workflow untouched; Atlas files untouched):
- `boot-start-n8n.ps1`: now holds `wsl -- sleep infinity` after starting n8n; real logging to `_scripts\logs\n8n-tasks.log`. Task `n8n-boot-start` time limit 72h -> none.
- `morning-wake-prep.ps1`: no longer changes power settings. Sets a `SetThreadExecutionState` stay-awake lock, starts n8n, holds lock + WSL session until 06:00, then releases. Task `n8n-morning-wake` 03:50 -> 03:45, wake-to-run on, limit 3h.
- Disabled (not deleted): `n8n-restore-sleep` (no longer needed; set 10-min sleep, conflicting with user's 30), `Atlas_MorningSleep`, `SaptarshiOS_IdleSleep_6AM` -- both latter at the user's explicit request.
- Power plan AC: sleep after 30 min (was "never", left by old script), hibernate-after never (was 2h).
- One-off elevated script `_scripts\apply-fix-admin.ps1` applied the task/power changes via a single UAC click; full before/after logged locally.
- `.gitignore`: `_scripts/logs/` and `_scripts/_backup_*/` excluded (logs contain machine/user names; repo is public).

Verified: n8n stayed up 6+ min after the change (previously ~60s); `n8n-morning-wake` next run 04/10 03:45 with wake on. Not yet verified: an actual overnight wake, and the post after credentials are reconnected.

---

## 2026-09-25 - n8n host migrated from Docker Desktop to Docker Engine inside WSL (Ubuntu); unattended wake/sleep automation added

Trigger: the 04:15 daily run silently failed to fire on 2026-09-25. Root cause traced via Desktop Commander (event log, Docker logs, uptime) to a Windows Update reboot at ~20:30 the prior night -- Docker Desktop only starts inside a signed-in session, and nobody was signed in when the PC came back up, so Docker (and n8n) never restarted. This is a structural weakness (any forced reboot kills the trigger), not a one-off.

Fix chosen over simpler alternatives (auto sign-in, or just fixing Docker Desktop's auto-start): moved n8n's runtime entirely off Docker Desktop and onto Docker Engine (CE) running inside the existing Ubuntu WSL distro, with systemd enabling `docker.service`/`docker.socket` to start automatically at WSL boot -- no user sign-in required at all. Docker Desktop's own auto-start registry entry was removed and the app stopped; it remains installed, untouched, as a rollback path until several mornings run clean.

Migration steps, each verified before moving to the next: (1) backed up the `n8n_data` Docker volume to `_backups\n8n_data_pre-wsl-migration_2026-09-25\`, then restored it into a throwaway test volume and diffed file listings + `database.sqlite` size/timestamp + `config` (encryption key) byte-for-byte match against the original -- confirmed identical before touching anything real; (2) confirmed Docker CE was already installed and `docker.service` enabled inside the Ubuntu distro (from an earlier partial attempt), added the user to the `docker` group (required one interactive `sudo` command typed by the user directly in a terminal window -- Claude does not enter passwords under any circumstance); (3) restored the real volume into the WSL engine and brought n8n up via the existing `docker-compose.yml`, verified reachable as `http://localhost:5678` from both WSL and Windows (WSL2's built-in localhost forwarding carries the port through automatically); (4) stopped Docker Desktop entirely and re-confirmed n8n stayed up and reachable with zero dependency on it.

Added three Windows Scheduled Tasks (all registered with S4U logon + Limited run level, so they run whether or not anyone is signed in, without ever storing a password): `n8n-boot-start` (starts the WSL VM at Windows startup as a safety net), `n8n-morning-wake` (daily 03:50, wake-from-sleep capable, disables idle sleep for the approval window, ensures WSL/n8n are up), `n8n-restore-sleep` (daily 06:00, re-enables 10-minute idle sleep). Scripts live in `_scripts\`. Baseline AC idle-sleep timeout set to 10 minutes (was "never"). All three tasks functionally tested by manual trigger (exit code 0, correct power-setting changes observed) -- the one thing that can only be proven overnight is the actual wake-from-sleep at 03:50, since testing that live would have required sleeping the machine mid-session.

New `_scripts\` and `_docs\sessions\` folders added to the project.

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
