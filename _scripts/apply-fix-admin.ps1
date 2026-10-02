# One-off admin fix, 2026-10-03. Run elevated. Logs everything.
# Scope: n8n-* tasks, Atlas_MorningSleep (disable only), SaptarshiOS_IdleSleep_6AM
# (disable only), power plan AC sleep=30 min, AC hibernate-after=never.
$log = 'D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_scripts\logs\apply-fix-admin.log'
Start-Transcript -Path $log -Append | Out-Null
$names = 'n8n-boot-start','n8n-morning-wake','n8n-restore-sleep','Atlas_MorningSleep','SaptarshiOS_IdleSleep_6AM'
function Show {
    foreach ($n in $names) { $t = Get-ScheduledTask -TaskName $n
        "{0,-26} {1,-9} Wake={2,-5} Limit={3,-6} Trigger={4}" -f $n, $t.State, $t.Settings.WakeToRun, $t.Settings.ExecutionTimeLimit, (($t.Triggers | % { $_.StartBoundary }) -join ',') }
    powercfg /q SCHEME_CURRENT SUB_SLEEP STANDBYIDLE   | Select-String 'Current AC'
    powercfg /q SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE | Select-String 'Current AC'
}

"===== STEP 0 DIAGNOSTICS"; powercfg /waketimers; powercfg /a
"===== BEFORE"; Show

"===== CHANGES"
Disable-ScheduledTask -TaskName 'Atlas_MorningSleep'        | Out-Null; 'disabled Atlas_MorningSleep'
Disable-ScheduledTask -TaskName 'SaptarshiOS_IdleSleep_6AM' | Out-Null; 'disabled SaptarshiOS_IdleSleep_6AM'
Disable-ScheduledTask -TaskName 'n8n-restore-sleep'         | Out-Null; 'disabled n8n-restore-sleep'

$t = Get-ScheduledTask -TaskName 'n8n-boot-start'
$t.Settings.ExecutionTimeLimit = 'PT0S'
Set-ScheduledTask -InputObject $t | Out-Null; 'n8n-boot-start: no time limit'

$t = Get-ScheduledTask -TaskName 'n8n-morning-wake'
$t.Triggers[0].StartBoundary = (Get-Date).Date.AddDays(1).AddHours(3).AddMinutes(45).ToString('yyyy-MM-ddTHH:mm:ss')
$t.Settings.WakeToRun = $true
$t.Settings.ExecutionTimeLimit = 'PT3H'
Set-ScheduledTask -InputObject $t | Out-Null; 'n8n-morning-wake: 03:45 daily, wake on, 3h limit'

powercfg /change standby-timeout-ac 30;  'AC sleep: 30 min'
powercfg /change hibernate-timeout-ac 0; 'AC hibernate-after: never'

"===== AFTER"; Show
"===== WAKE TIMERS NOW"; powercfg /waketimers

Start-ScheduledTask -TaskName 'n8n-boot-start'; 'started n8n-boot-start (keepalive) now'
Stop-Transcript | Out-Null
