Remove-Item 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_dockerinspect.ps1' -Force
Remove-Item 'D:\Saptarshi_OS\01_Content_Engine\_movefiles.ps1' -Force -ErrorAction SilentlyContinue
Remove-Item 'D:\Saptarshi_OS\01_Content_Engine\n8n-workflows' -Force -ErrorAction SilentlyContinue

cd 'D:\Saptarshi_OS\01_Content_Engine\05_content-engine_repo'
git remote set-url origin https://github.com/saptarshi-ai/content-engine.git
git remote -v

$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')
cd 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn'
git init
git add -A
git commit -m "Initial commit: AI Generated LinkedIn n8n workflow + Docker setup"
gh repo create saptarshi-ai/AI-Generated-LinkedIn --private --source=. --remote=origin --push