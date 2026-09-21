cd 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn'
git add -A
git commit -m "Close session: update SESSION.md, CLAUDE.md, DECISIONS.md, TASKS.md, CHANGELOG.md with full session summary and next-session TODO"
git push
git log --oneline -6
Remove-Item 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_closesync.ps1' -Force
