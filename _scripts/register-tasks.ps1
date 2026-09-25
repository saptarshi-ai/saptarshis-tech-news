$base = "D:\Saptarshi_OS\01_Content_Engine\AI_Generated_LinkedIn\_scripts"
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Limited

$action1 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$base\boot-start-n8n.ps1`""
$trigger1 = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "n8n-boot-start" -Action $action1 -Trigger $trigger1 -Principal $principal -Force

$action2 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$base\morning-wake-prep.ps1`""
$trigger2 = New-ScheduledTaskTrigger -Daily -At 3:50AM
$settings2 = New-ScheduledTaskSettingsSet -WakeToRun -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -TaskName "n8n-morning-wake" -Action $action2 -Trigger $trigger2 -Principal $principal -Settings $settings2 -Force

$action3 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$base\restore-sleep.ps1`""
$trigger3 = New-ScheduledTaskTrigger -Daily -At 6:00AM
Register-ScheduledTask -TaskName "n8n-restore-sleep" -Action $action3 -Trigger $trigger3 -Principal $principal -Force

Write-Host ""
Write-Host "--- Registered tasks ---"
Get-ScheduledTask -TaskName "n8n-*" | Select-Object TaskName, State
Write-Host ""
Write-Host "Done. You can close this window."
Read-Host "Press Enter to close"
