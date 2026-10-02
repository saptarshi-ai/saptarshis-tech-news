# Runs at Windows startup, no sign-in required (task: n8n-boot-start).
# Starts the WSL VM (systemd starts Docker; n8n has restart=unless-stopped),
# then HOLDS a WSL session open indefinitely. Without this, WSL idle-shuts
# the VM ~60s after the last wsl.exe exits and n8n dies with it.
# Task must have no execution time limit.
$log = 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_scripts\logs\n8n-tasks.log'
New-Item -ItemType Directory -Force -Path (Split-Path $log) | Out-Null
function Log($m) { Add-Content -Path $log -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [boot] $m" }

Start-Sleep -Seconds 10
$out = (wsl.exe -d Ubuntu -- docker start n8n 2>&1) -join ' '
Log "docker start n8n: $out"
Start-Sleep -Seconds 5
$state = (wsl.exe -d Ubuntu -- docker inspect -f '{{.State.Status}}' n8n 2>&1) -join ' '
Log "n8n state: $state"

Log 'keepalive: holding WSL session open'
wsl.exe -d Ubuntu -- sleep infinity
Log "keepalive ended unexpectedly (exit $LASTEXITCODE)"
