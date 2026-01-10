; ============================================================================
; Brightness Controller - Uninstaller
; Removes files, startup entries, and scheduled tasks
; ============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

global appName := "Brightness Controller"
global installDir := "C:\Program Files\" appName
global taskName := "BrightnessController"

; Localization
global uninstLang := Map()
uninstLang["en"] := Map(
    "title", "Brightness Controller - Uninstall",
    "confirm", "Are you sure you want to uninstall Brightness Controller?",
    "uninstalling", "Uninstalling...",
    "success", "Uninstall complete!",
    "not_found", "Brightness Controller installation not found.",
    "yes", "Yes",
    "no", "No"
)
uninstLang["tr"] := Map(
    "title", "Parlaklık Denetleyicisi - Kaldırma",
    "confirm", "Parlaklık Denetleyicisi'ni kaldırmak istediğinizden emin misiniz?",
    "uninstalling", "Kaldırılıyor...",
    "success", "Kaldırma tamamlandı!",
    "not_found", "Parlaklık Denetleyicisi kurulumu bulunamadı.",
    "yes", "Evet",
    "no", "Hayır"
)

global currentLang := "tr"
GetUninstText(key) {
    global uninstLang, currentLang
    if (uninstLang.Has(currentLang) && uninstLang[currentLang].Has(key))
        return uninstLang[currentLang][key]
    return uninstLang["en"][key]
}

; Run as admin if needed
if (!A_IsAdmin) {
    try {
        Run('*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"')
        ExitApp
    } catch {
        MsgBox("This uninstaller requires administrator privileges.", "Error", "Icon!")
        ExitApp
    }
}

; Check if installed
if (!DirExist(installDir)) {
    MsgBox(GetUninstText("not_found"), GetUninstText("title"), "Iconi")
    ExitApp
}

; Confirm uninstall
result := MsgBox(GetUninstText("confirm"), GetUninstText("title"), "YesNo Icon?")
if (result = "No")
    ExitApp

; Terminate running instance
try {
    RunWait('taskkill /F /IM brightness_control.exe',, "Hide")
    Sleep(500)
}

; Remove scheduled task
try {
    RunWait('schtasks /Delete /TN "' taskName '" /F',, "Hide")
}

; Remove startup shortcut
try {
    startupShortcut := A_Startup "\Brightness Controller.lnk"
    if (FileExist(startupShortcut))
        FileDelete(startupShortcut)
}

; Remove installation directory
try {
    DirDelete(installDir, true)
}

MsgBox(GetUninstText("success"), GetUninstText("title"), "Iconi")
ExitApp
