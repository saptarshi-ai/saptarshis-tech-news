# Session -- 2026-09-25 -- n8n infra migration (Docker Desktop -> WSL Docker Engine)

## Trigger

User reported the daily automation did not fire at 04:15 or 04:30 on the morning of 2026-09-25. First request was explicitly diagnosis-only -- no changes.

## Diagnosis (read-only)

Checked, in order: Docker container status, Docker Desktop backend logs, Windows uptime/reboot history, power/sleep event logs, logon sessions, Docker auto-start settings, and the workflow's own schedule trigger config.

Finding: Windows Update forced a reboot at ~20:30 on 2026-09-24. Docker Desktop only launches inside a signed-in Windows session. Nobody signed in overnight (first sign-in was 06:21 the next morning), so Docker -- and therefore n8n -- never came back up. The 04:15 schedule trigger itself was correctly configured; it simply had nothing to run on.

## Design discussion

User's requirement: PC should wake ~03:50, bring Docker/n8n up, stay awake through the 04:30-05:00 approval window, then sleep again if idle >10 minutes after 06:00. Explicitly rejected the simpler "just start Docker Desktop and enable its auto-start" fix in favour of running Docker Engine directly inside WSL (Ubuntu), removing the sign-in dependency at the root.

## Migration (each stage tested before the next)

1. **Backup + verify.** `n8n_data` volume backed up to `_backups\n8n_data_pre-wsl-migration_2026-09-25\n8n_data_backup.tar.gz`. Verified by restoring into a disposable test volume and diffing: file listing identical, `database.sqlite` identical size/timestamp, `config` (encryption key, 56 bytes) identical. Test volume deleted; real volume untouched throughout.
2. **Docker Engine in WSL.** Found Docker CE 29.8.1 already installed inside the Ubuntu distro with `docker.service`/`docker.socket` enabled (leftover from an earlier attempt) -- systemd was already on. Missing piece: the user's account wasn't in the `docker` group. This needed one `sudo` command; Claude opened a visible WSL terminal window and the user typed the command and their own password directly into it. When the user then asked Claude to store that password, Claude refused and explained it never stores credentials, in memory or otherwise.
3. **Volume restore + n8n up.** Real volume restored into the WSL engine's `n8n_data`. n8n brought up via the existing `docker-compose.yml` (copied into `~/n8n-deploy/` inside WSL). Verified `http://localhost:5678` reachable from both WSL directly and from Windows PowerShell (WSL2's automatic localhost forwarding carries the port through without any extra config).
4. **Docker Desktop decommissioned.** Its Run-key auto-start entry removed; the running app stopped entirely. Re-tested n8n immediately after -- stayed up, stayed reachable, zero dependency confirmed. Docker Desktop remains installed (not uninstalled) as an explicit rollback path.

## Automation

Three PowerShell scripts in `_scripts\` (`boot-start-n8n.ps1`, `morning-wake-prep.ps1`, `restore-sleep.ps1`), each registered as a Windows Scheduled Task with S4U logon + Limited run level -- runs whether or not anyone is signed in, with no password ever stored:

| Task | Trigger | Wake-capable |
|---|---|---|
| `n8n-boot-start` | At Windows startup | n/a |
| `n8n-morning-wake` | Daily 03:50 | Yes |
| `n8n-restore-sleep` | Daily 06:00 | No |

Registering the tasks itself needed Administrator rights (one UAC consent click -- the account is already a local Administrator, so no password prompt). Baseline AC idle-sleep timeout set to 10 minutes (was "never"). All three tasks manually triggered once each to confirm the scripts themselves run cleanly (exit code 0 for all three; power-setting changes observed correctly). n8n confirmed still reachable after each test run.

## What's proven vs. not

**Proven:** volume integrity, WSL engine stability, n8n reachability with Docker Desktop fully off, all three scripts' internal logic, task registration correctness (wake flag, S4U, trigger times).

**Not provable in this session:** the actual unattended wake-from-sleep at 03:50 -- doing so would have required sleeping the machine mid-session, which would have dropped every tool connection Claude was using. This is the first thing to check next session.

## Documents updated this session

`CHANGELOG.md`, `DECISIONS.md` (4 new entries), `SESSION.md` (overwritten), `TASKS.md` (+1 verification task), this file.
