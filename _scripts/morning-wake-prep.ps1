# Runs daily at 03:50 (wakes the PC from sleep if needed).
# 1. Disables idle sleep so the PC stays awake through the approval window.
# 2. Makes sure WSL/Docker/n8n are up in time for the 04:15 trigger.
powercfg /change standby-timeout-ac 0

Start-Sleep -Seconds 10
wsl.exe -d Ubuntu -- true
Start-Sleep -Seconds 5
wsl.exe -d Ubuntu -- docker start n8n 2>&1 | Out-Null
