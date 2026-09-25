# Runs at Windows startup, no sign-in required.
# Starts the WSL VM (systemd auto-starts Docker inside it), then
# makes sure the n8n container is up.
Start-Sleep -Seconds 10
wsl.exe -d Ubuntu -- true
Start-Sleep -Seconds 5
wsl.exe -d Ubuntu -- docker start n8n 2>&1 | Out-Null
