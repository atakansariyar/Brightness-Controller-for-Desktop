# Brightness Controller - Task Scheduler Uninstaller
# Run as Administrator

$taskName = "BrightnessController"

# Check if running as admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator!" -ForegroundColor Red
    pause
    exit
}

# Check if task exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if (-NOT $existingTask) {
    Write-Host "Task '$taskName' not found." -ForegroundColor Yellow
    pause
    exit
}

# Remove task
Write-Host "Removing scheduled task..." -ForegroundColor Cyan
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

Write-Host ""
Write-Host "Success! Brightness Controller will no longer start at login." -ForegroundColor Green
Write-Host ""
pause
