# Brightness Controller - Normal Startup Installer
# Removes high priority task and creates startup folder shortcut
# Run as Administrator

$taskName = "BrightnessController"
$exePath = "C:\Program Files\Brightness Controller\brightness_control.exe"
$workDir = "C:\Program Files\Brightness Controller"
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = "$startupFolder\Brightness Controller.lnk"

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

# Remove scheduled task if exists (high priority startup)
Write-Host "Removing high priority startup task..." -ForegroundColor Yellow
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "High priority task removed." -ForegroundColor Gray
}

# Create startup folder shortcut
Write-Host "Creating startup shortcut..." -ForegroundColor Cyan

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $exePath
$Shortcut.WorkingDirectory = $workDir
$Shortcut.Description = "Brightness Controller for Desktop"
$iconPath = "$workDir\assets\brightness_icon.ico"
if (Test-Path $iconPath) {
    $Shortcut.IconLocation = $iconPath
}
$Shortcut.Save()

Write-Host ""
Write-Host "Success! Normal priority startup configured." -ForegroundColor Green
Write-Host ""
Write-Host "Method: Startup folder shortcut" -ForegroundColor Gray
Write-Host "Path: $shortcutPath" -ForegroundColor Gray
Write-Host ""
pause
