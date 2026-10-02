# Runs daily at 03:45 and wakes the PC (task: n8n-morning-wake).
# 1. Sets a stay-awake lock (no power settings changed).
# 2. Makes sure n8n is up for the 04:15 trigger.
# 3. Holds the lock + a WSL session until 06:00, then exits.
# After 06:00 Windows' normal 30-min idle sleep takes over.
$log = 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_scripts\logs\n8n-tasks.log'
New-Item -ItemType Directory -Force -Path (Split-Path $log) | Out-Null
function Log($m) { Add-Content -Path $log -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [morning] $m" }

Add-Type -Namespace Win32 -Name Power -MemberDefinition '[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);'
# ES_CONTINUOUS (0x80000000) | ES_SYSTEM_REQUIRED (0x1)
[void][Win32.Power]::SetThreadExecutionState([uint32]2147483649)
Log 'awake; stay-awake lock set'

$out = (wsl.exe -d Ubuntu -- docker start n8n 2>&1) -join ' '
Log "docker start n8n: $out"
Start-Sleep -Seconds 5
$state = (wsl.exe -d Ubuntu -- docker inspect -f '{{.State.Status}}' n8n 2>&1) -join ' '
Log "n8n state: $state"

$secs = [int]((Get-Date).Date.AddHours(6) - (Get-Date)).TotalSeconds
if ($secs -gt 0) {
    Log "holding awake + WSL for $secs s (until 06:00)"
    wsl.exe -d Ubuntu -- sleep $secs
}

[void][Win32.Power]::SetThreadExecutionState([uint32]2147483648)
Log 'released stay-awake lock; done'
