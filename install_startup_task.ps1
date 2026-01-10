# Brightness Controller - Task Scheduler Installer
# Run as Administrator

$taskName = "BrightnessController"
$exePath = "C:\Program Files\Brightness Controller\brightness_control.exe"
$workDir = "C:\Program Files\Brightness Controller"

# Check if running as admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator!" -ForegroundColor Red
    pause
    exit
}

# Check if exe exists
if (-NOT (Test-Path $exePath)) {
    Write-Host "Error: $exePath not found!" -ForegroundColor Red
    Write-Host "Please install Brightness Controller first using setup.exe" -ForegroundColor Yellow
    pause
    exit
}

# Remove existing task if exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Remove startup shortcut if exists (upgrading from old method)
$startupShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Brightness Controller.lnk"
if (Test-Path $startupShortcut) {
    Write-Host "Removing old startup shortcut..." -ForegroundColor Yellow
    Remove-Item $startupShortcut -Force
}

# Create new task
Write-Host "Creating scheduled task..." -ForegroundColor Cyan

$action = New-ScheduledTaskAction -Execute $exePath -WorkingDirectory $workDir
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Days 0)

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Brightness Controller for Desktop Monitors" | Out-Null

Write-Host ""
Write-Host "Success! Brightness Controller will start at login." -ForegroundColor Green
Write-Host ""
Write-Host "Task Name: $taskName" -ForegroundColor Gray
Write-Host "Executable: $exePath" -ForegroundColor Gray
Write-Host ""
pause
