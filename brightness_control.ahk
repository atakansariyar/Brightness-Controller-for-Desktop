; ============================================================================
; Brightness Controller for Desktop v2.0
; Control external monitor brightness via DDC/CI with a Windows 11 style OSD
; https://github.com/atakansariyar/Brightness-Controller-for-Desktop
; ============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

InstallKeybdHook
InstallMouseHook

DllCall("winmm\timeBeginPeriod", "uint", 1)
OnExit((*) => DllCall("winmm\timeEndPeriod", "uint", 1))

; ========================= VERSION =========================

global APP_VERSION := "2.0.0"

; ========================= GLOBAL CONFIG VARIABLES =========================

global configFile := A_ScriptDir "\config.ini"

; Language
global currentLanguage := "en"

; ========================= LOCALIZATION =========================

global L := Map()

InitLocalization() {
    global L
    
    ; English (default)
    L["en"] := Map(
        "settings_title", "Brightness Controller Settings",
        "hotkey_decrease", "Hotkey (Decrease):",
        "hotkey_increase", "Hotkey (Increase):",
        "capture", "Capture",
        "brightness_step", "Brightness Step:",
        "monitor_mode", "Monitor Mode:",
        "mode_all", "All Monitors",
        "mode_all_hint", "Adjusts all connected monitors simultaneously",
        "mode_cursor", "Cursor Position",
        "mode_cursor_hint", "Adjusts the monitor where mouse cursor is",
        "enable_animations", "Enable Animations",
        "language", "Language:",
        "save_restart", "Save",
        "undo", "Undo",
        "cancel", "Cancel",
        "restore_defaults", "Restore Defaults",
        "open_config", "Open Config Folder",
        "fkey_tool", "F-Key Sender Tool",
        "fkey_title", "F-Key Sender Tool",
        "select_fkey", "Select F-Key:",
        "delay_ms", "Delay (ms):",
        "status", "Status:",
        "ready", "Ready",
        "sending", "Sending...",
        "send", "Send",
        "version", "Version",
        "monitor_detected", "monitor(s) detected!",
        "searching", "Searching for DDC/CI monitor..."
    )
    
    ; Turkish
    L["tr"] := Map(
        "settings_title", "Parlaklık Denetleyici Ayarları",
        "hotkey_decrease", "Kısayol (Azalt):",
        "hotkey_increase", "Kısayol (Arttır):",
        "capture", "Yakala",
        "brightness_step", "Parlaklık Adımı:",
        "monitor_mode", "Monitör Modu:",
        "mode_all", "Tüm Monitörler",
        "mode_all_hint", "Bağlı tüm monitörleri aynı anda ayarlar",
        "mode_cursor", "İmleç Konumu",
        "mode_cursor_hint", "Fare imlecinin bulunduğu monitörü ayarlar",
        "enable_animations", "Animasyonları Etkinleştir",
        "language", "Dil:",
        "save_restart", "Kaydet",
        "undo", "Geri Al",
        "cancel", "İptal",
        "restore_defaults", "Varsayılanlara Dön",
        "open_config", "Ayar Klasörünü Aç",
        "fkey_tool", "F-Tuşu Gönderici",
        "fkey_title", "F-Tuşu Gönderici",
        "select_fkey", "F-Tuşu Seç:",
        "delay_ms", "Gecikme (ms):",
        "status", "Durum:",
        "ready", "Hazır",
        "sending", "Gönderiliyor...",
        "send", "Gönder",
        "version", "Sürüm",
        "monitor_detected", "monitör algılandı!",
        "searching", "DDC/CI monitör aranıyor..."
    )
    
    ; Russian
    L["ru"] := Map(
        "settings_title", "Настройки контроллера яркости",
        "hotkey_decrease", "Клавиша (Уменьшить):",
        "hotkey_increase", "Клавиша (Увеличить):",
        "capture", "Захват",
        "brightness_step", "Шаг яркости:",
        "monitor_mode", "Режим монитора:",
        "mode_all", "Все мониторы",
        "mode_all_hint", "Регулирует все подключенные мониторы одновременно",
        "mode_cursor", "Позиция курсора",
        "mode_cursor_hint", "Регулирует монитор под курсором мыши",
        "enable_animations", "Включить анимации",
        "language", "Язык:",
        "save_restart", "Сохранить",
        "undo", "Отменить",
        "cancel", "Отмена",
        "restore_defaults", "По умолчанию",
        "open_config", "Открыть папку настроек",
        "fkey_tool", "Отправка F-клавиш",
        "fkey_title", "Отправка F-клавиш",
        "select_fkey", "Выберите F-клавишу:",
        "delay_ms", "Задержка (мс):",
        "status", "Статус:",
        "ready", "Готово",
        "sending", "Отправка...",
        "send", "Отправить",
        "version", "Версия",
        "monitor_detected", "монитор(ов) обнаружено!",
        "searching", "Поиск DDC/CI монитора..."
    )
    
    ; Chinese (Simplified)
    L["zh"] := Map(
        "settings_title", "亮度控制器设置",
        "hotkey_decrease", "快捷键 (降低):",
        "hotkey_increase", "快捷键 (增加):",
        "capture", "捕获",
        "brightness_step", "亮度步进:",
        "monitor_mode", "监视器模式:",
        "mode_all", "所有监视器",
        "mode_all_hint", "同时调节所有连接的监视器",
        "mode_cursor", "光标位置",
        "mode_cursor_hint", "调节鼠标光标所在的监视器",
        "enable_animations", "启用动画",
        "language", "语言:",
        "save_restart", "保存",
        "undo", "撤销",
        "cancel", "取消",
        "restore_defaults", "恢复默认",
        "open_config", "打开配置文件夹",
        "fkey_tool", "F键发送工具",
        "fkey_title", "F键发送工具",
        "select_fkey", "选择F键:",
        "delay_ms", "延迟 (毫秒):",
        "status", "状态:",
        "ready", "就绪",
        "sending", "发送中...",
        "send", "发送",
        "version", "版本",
        "monitor_detected", "个监视器已检测!",
        "searching", "正在搜索DDC/CI监视器..."
    )
    
    ; Japanese
    L["ja"] := Map(
        "settings_title", "明るさコントローラー設定",
        "hotkey_decrease", "ホットキー (減少):",
        "hotkey_increase", "ホットキー (増加):",
        "capture", "キャプチャ",
        "brightness_step", "明るさステップ:",
        "monitor_mode", "モニターモード:",
        "mode_all", "すべてのモニター",
        "mode_all_hint", "接続されているすべてのモニターを同時に調整",
        "mode_cursor", "カーソル位置",
        "mode_cursor_hint", "マウスカーソルのあるモニターを調整",
        "enable_animations", "アニメーションを有効化",
        "language", "言語:",
        "save_restart", "保存",
        "undo", "元に戻す",
        "cancel", "キャンセル",
        "restore_defaults", "デフォルトに戻す",
        "open_config", "設定フォルダを開く",
        "fkey_tool", "Fキー送信ツール",
        "fkey_title", "Fキー送信ツール",
        "select_fkey", "Fキーを選択:",
        "delay_ms", "遅延 (ミリ秒):",
        "status", "ステータス:",
        "ready", "準備完了",
        "sending", "送信中...",
        "send", "送信",
        "version", "バージョン",
        "monitor_detected", "台のモニターが検出されました!",
        "searching", "DDC/CIモニターを検索中..."
    )
}

GetText(key) {
    global L, currentLanguage
    if (L.Has(currentLanguage) && L[currentLanguage].Has(key))
        return L[currentLanguage][key]
    if (L.Has("en") && L["en"].Has(key))
        return L["en"][key]
    return key
}

InitLocalization()

; Hotkeys
global hotkeyDecrease := "F13"
global hotkeyIncrease := "F14"

; Brightness
global minBrightness := 0
global maxBrightness := 100
global brightnessStep := 10
global brightnessRampSpeed := 8

; Monitor
global monitorMode := "all"  ; "all", "cursor", or "1", "2", etc.

; Popup
global popupTimeout := 2000
global popupWidth := 193
global popupHeight := 50
global popupRadius := 10
global popupMarginBottom := 12

; Animation
global animationEnabled := true
global animationDuration := 200
global animationCloseDuration := 200
global animationStartOffset := 60

; Progress Bar
global barWidth := 138
global barHeight := 4
global barRadius := 3
global barMarginTop := 22
global barMarginLeft := 38
global barFillRadius := 3

; Sun Icon
global showIcon := true
global iconMarginLeft := 12
global iconMarginTop := 17
global sunCenterRadius := 3
global sunRayLength := 2
global sunRayGap := 2
global sunRayThickness := 1.5
global sunRayCount := 8

; Render
global renderScale := 4

; Key Repeat
global repeatDelay := 400
global repeatRate := 50

; ========================= CONFIG FILE =========================

LoadConfig() {
    global
    
    if (!FileExist(configFile)) {
        SaveConfig()
        return
    }
    
    hotkeyDecrease := IniRead(configFile, "Hotkeys", "hotkeyDecrease", "F13")
    hotkeyIncrease := IniRead(configFile, "Hotkeys", "hotkeyIncrease", "F14")
    
    brightnessStep := Integer(IniRead(configFile, "Brightness", "brightnessStep", "10"))
    brightnessRampSpeed := Integer(IniRead(configFile, "Brightness", "brightnessRampSpeed", "8"))
    
    monitorMode := IniRead(configFile, "Monitor", "monitorMode", "all")
    
    popupTimeout := Integer(IniRead(configFile, "Popup", "popupTimeout", "2000"))
    
    animationEnabled := (IniRead(configFile, "Animation", "animationEnabled", "true") = "true")
    
    currentLanguage := IniRead(configFile, "General", "language", "en")
}

SaveConfig() {
    global
    
    IniWrite(hotkeyDecrease, configFile, "Hotkeys", "hotkeyDecrease")
    IniWrite(hotkeyIncrease, configFile, "Hotkeys", "hotkeyIncrease")
    
    IniWrite(brightnessStep, configFile, "Brightness", "brightnessStep")
    IniWrite(brightnessRampSpeed, configFile, "Brightness", "brightnessRampSpeed")
    
    IniWrite(monitorMode, configFile, "Monitor", "monitorMode")
    
    IniWrite(popupTimeout, configFile, "Popup", "popupTimeout")
    
    IniWrite(animationEnabled ? "true" : "false", configFile, "Animation", "animationEnabled")
    
    IniWrite(currentLanguage, configFile, "General", "language")
}

; ========================= MULTI-MONITOR SUPPORT =========================

global monitorHandles := []
global monitorNames := []

EnumerateMonitors() {
    global monitorHandles, monitorNames
    monitorHandles := []
    monitorNames := []
    
    ; First, get WMI monitor names for display
    wmiNames := GetWMIMonitorNames()
    
    monCount := MonitorGetCount()
    
    Loop monCount {
        try {
            ; Get monitor info using index
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            
            ; Get HMONITOR from point in this monitor
            midX := left + (right - left) // 2
            midY := top + (bottom - top) // 2
            
            hMon := DllCall("user32\MonitorFromPoint",
                "int", midX, "int", midY, "uint", 2, "ptr")
            
            if (hMon) {
                numPhys := 0
                DllCall("Dxva2\GetNumberOfPhysicalMonitorsFromHMONITOR", 
                    "ptr", hMon, "uint*", &numPhys)
                
                if (numPhys > 0) {
                    buf := Buffer(numPhys * 264, 0)
                    result := DllCall("Dxva2\GetPhysicalMonitorsFromHMONITOR",
                        "ptr", hMon, "uint", numPhys, "ptr", buf, "int")
                    
                    if (result) {
                        Loop numPhys {
                            offset := (A_Index - 1) * 264
                            hPhys := NumGet(buf, offset, "ptr")
                            if (hPhys) {
                                monitorHandles.Push(hPhys)
                                ; Use WMI name if available, otherwise fallback
                                idx := monitorHandles.Length
                                if (wmiNames.Has(idx))
                                    monitorNames.Push(wmiNames[idx])
                                else
                                    monitorNames.Push("Monitor " idx)
                            }
                        }
                    }
                }
            }
        }
    }
    
    ; Fallback: try primary monitor
    if (monitorHandles.Length = 0) {
        hPhys := GetFirstPhysicalMonitor()
        if (hPhys) {
            monitorHandles.Push(hPhys)
            monitorNames.Push(wmiNames.Has(1) ? wmiNames[1] : "Primary Monitor")
        }
    }
}

GetWMIMonitorNames() {
    names := Map()
    try {
        objWMI := ComObject("WbemScripting.SWbemLocator").ConnectServer(".", "root\cimv2")
        for monitor in objWMI.ExecQuery("SELECT * FROM Win32_DesktopMonitor") {
            idx := names.Count + 1
            monName := ""
            try monName := monitor.Name
            if (monName = "" || monName = "Generic PnP Monitor")
                try monName := monitor.Caption
            if (monName = "" || monName = "Generic PnP Monitor")
                try monName := monitor.Description
            if (monName != "" && monName != "Generic PnP Monitor")
                names[idx] := monName
        }
        ; Also try WmiMonitorID for more accurate names
        try {
            objWMI2 := ComObject("WbemScripting.SWbemLocator").ConnectServer(".", "root\wmi")
            idx := 0
            for monitor in objWMI2.ExecQuery("SELECT * FROM WmiMonitorID") {
                idx++
                try {
                    modelBytes := monitor.UserFriendlyName
                    if (modelBytes) {
                        modelName := ""
                        for byte in modelBytes {
                            if (byte > 0)
                                modelName .= Chr(byte)
                        }
                        if (modelName != "")
                            names[idx] := modelName
                    }
                }
            }
        }
    }
    return names
}

GetFirstPhysicalMonitor() {
    try {
        hMon := DllCall("MonitorFromWindow", "ptr", DllCall("GetDesktopWindow", "ptr"), "uint", 1, "ptr")
        if (!hMon)
            return 0
        buf := Buffer(264, 0)
        result := DllCall("Dxva2\GetPhysicalMonitorsFromHMONITOR", "ptr", hMon, "uint", 1, "ptr", buf, "int")
        return result ? NumGet(buf, 0, "ptr") : 0
    } catch {
        return 0
    }
}

GetTargetMonitors() {
    global monitorMode, monitorHandles
    
    if (monitorHandles.Length = 0)
        EnumerateMonitors()
    
    if (monitorMode = "all") {
        return monitorHandles
    } else if (monitorMode = "cursor") {
        ; Get cursor position
        pt := Buffer(8, 0)
        DllCall("GetCursorPos", "ptr", pt)
        curX := NumGet(pt, 0, "int")
        curY := NumGet(pt, 4, "int")
        
        ; Find monitor at cursor
        hMon := DllCall("user32\MonitorFromPoint", "int", curX, "int", curY, "uint", 2, "ptr")
        if (hMon) {
            buf := Buffer(264, 0)
            result := DllCall("Dxva2\GetPhysicalMonitorsFromHMONITOR", "ptr", hMon, "uint", 1, "ptr", buf, "int")
            if (result) {
                hPhys := NumGet(buf, 0, "ptr")
                if (hPhys)
                    return [hPhys]
            }
        }
        ; Fallback to first monitor
        return monitorHandles.Length > 0 ? [monitorHandles[1]] : []
    } else {
        ; Specific index
        try {
            idx := Integer(monitorMode)
            if (idx >= 1 && idx <= monitorHandles.Length)
                return [monitorHandles[idx]]
        }
        return monitorHandles.Length > 0 ? [monitorHandles[1]] : []
    }
}

; ========================= THEME DETECTION =========================

GetThemeColors() {
    isLight := false
    try {
        value := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme")
        isLight := (value = 1)
    }
    
    if (isLight) {
        return {
            popupBg: "F3F3F3",
            popupAlpha: 250,
            barBg: "D1D1D1",
            barFill: "0067C0",
            icon: "1A1A1A"
        }
    } else {
        return {
            popupBg: "2C2C2C",
            popupAlpha: 245,
            barBg: "4D4D4D",
            barFill: "60CDFF",
            icon: "FFFFFF"
        }
    }
}

global themeColors := GetThemeColors()
global popupBgColor := themeColors.popupBg
global popupBgAlpha := themeColors.popupAlpha
global barBgColor := themeColors.barBg
global barFillColor := themeColors.barFill
global iconColor := themeColors.icon

; ========================= INTERNAL STATE =========================

global currentTarget := -1
global currentValue := -1
global rampTimer := 0
global repeatTimer := 0
global currentDirection := 0
global pressStart := 0

global popupHwnd := 0
global popupVisible := false
global popupTimeoutTimer := 0
global popupLastValue := -1

global animStartTime := 0
global animStartY := 0
global animTargetY := 0
global animX := 0
global animActive := false
global animClosing := false

global settingsGui := 0

; ========================= INITIALIZATION =========================

LoadConfig()
EnumerateMonitors()

; Set custom tray icon (check assets folder first, then root)
iconFile := A_ScriptDir "\assets\brightness_icon.ico"
if (!FileExist(iconFile))
    iconFile := A_ScriptDir "\brightness_icon.ico"
if (FileExist(iconFile))
    TraySetIcon(iconFile)

; Create system tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Settings", ShowSettingsGui)
A_TrayMenu.Add("Reload Config", (*) => (LoadConfig(), EnumerateMonitors()))
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Default := "Settings"

; Show startup tooltip
try {
    if (monitorHandles.Length > 0) {
        ToolTip("✓ " monitorHandles.Length " monitor(s) detected!`n`n" hotkeyDecrease ": Decrease | " hotkeyIncrease ": Increase`nMode: " monitorMode)
        SetTimer(() => ToolTip(), -3000)
    } else {
        ToolTip("⏳ Searching for DDC/CI monitor...")
        SetTimer(() => ToolTip(), -2000)
    }
} catch as err {
    MsgBox("Initialization error: " err.Message, "Error", 16)
}

; ========================= HOTKEY REGISTRATION =========================

RegisterHotkeys()

RegisterHotkeys() {
    global hotkeyDecrease, hotkeyIncrease
    
    try {
        if (hotkeyDecrease != "") {
            Hotkey("*" hotkeyDecrease, OnKeyDecrease)
            Hotkey("*" hotkeyDecrease " up", OnKeyUp)
        }
        
        if (hotkeyIncrease != "") {
            Hotkey("*" hotkeyIncrease, OnKeyIncrease)
            Hotkey("*" hotkeyIncrease " up", OnKeyUp)
        }
    }
}

OnKeyDecrease(*) {
    global pressStart, repeatTimer, currentDirection, repeatDelay, brightnessStep
    pressStart := A_TickCount
    currentDirection := -1
    AdjustTarget(-brightnessStep)
    if (!repeatTimer) {
        repeatTimer := 1
        SetTimer(RepeatAdjust, -repeatDelay)
    }
}

OnKeyIncrease(*) {
    global pressStart, repeatTimer, currentDirection, repeatDelay, brightnessStep
    pressStart := A_TickCount
    currentDirection := 1
    AdjustTarget(brightnessStep)
    if (!repeatTimer) {
        repeatTimer := 1
        SetTimer(RepeatAdjust, -repeatDelay)
    }
}

OnKeyUp(*) {
    global repeatTimer
    SetTimer(RepeatAdjust, 0)
    repeatTimer := 0
}

; ========================= SETTINGS GUI =========================

global captureTarget := ""
global captureEdit := 0

ShowSettingsGui(*) {
    global settingsGui, hotkeyDecrease, hotkeyIncrease, brightnessStep, monitorMode
    global animationEnabled, monitorHandles, monitorNames, configFile, currentLanguage, APP_VERSION
    global guiEditDecrease, guiEditIncrease
    
    if (settingsGui) {
        try settingsGui.Destroy()
    }
    
    ; Refresh monitor list with WMI names
    EnumerateMonitors()
    
    ; Fixed width for consistent layout
    guiWidth := 349
    ctrlWidth := guiWidth - 30  ; 320px total content width
    gap := 5
    ; Row 1: 3 buttons + 2 gaps (10px total) = ctrlWidth
    thirdWidth := (ctrlWidth - gap * 2) // 3  ; (320-10)/3 = 103
    ; Row 2: 2 buttons + 1 gap (5px) = ctrlWidth  
    halfWidth := (ctrlWidth - gap) // 2       ; (320-5)/2 = 157
    
    settingsGui := Gui("+AlwaysOnTop -MinimizeBox", GetText("settings_title"))
    settingsGui.MarginX := 18  ; Center controls (default is ~15, +3px offset)
    settingsGui.SetFont("s10", "Segoe UI")
    settingsGui.OnEvent("Close", (*) => CloseSettingsAndFKeyTool())
    
    ; Language selection
    settingsGui.AddText("xm w" ctrlWidth, GetText("language"))
    langChoices := ["English", "Türkçe", "Русский", "中文", "日本語"]
    langValues := ["en", "tr", "ru", "zh", "ja"]
    langIdx := 1
    for i, val in langValues {
        if (val = currentLanguage)
            langIdx := i
    }
    ddLang := settingsGui.AddDropDownList("xm y+5 w" ctrlWidth " vLangChoice Choose" langIdx, langChoices)
    ddLang.OnEvent("Change", (*) => OnLanguageChange(ddLang))
    
    ; Hotkey Decrease
    settingsGui.AddText("xm y+15 w" ctrlWidth, GetText("hotkey_decrease"))
    guiEditDecrease := settingsGui.AddEdit("xm y+5 w" (ctrlWidth - 90) " vHotkeyDec ReadOnly", hotkeyDecrease)
    btnCapDec := settingsGui.AddButton("x+5 w80", GetText("capture"))
    btnCapDec.OnEvent("Click", (*) => StartHotkeyCapture("dec", guiEditDecrease))
    
    ; Hotkey Increase
    settingsGui.AddText("xm y+10 w" ctrlWidth, GetText("hotkey_increase"))
    guiEditIncrease := settingsGui.AddEdit("xm y+5 w" (ctrlWidth - 90) " vHotkeyInc ReadOnly", hotkeyIncrease)
    btnCapInc := settingsGui.AddButton("x+5 w80", GetText("capture"))
    btnCapInc.OnEvent("Click", (*) => StartHotkeyCapture("inc", guiEditIncrease))
    
    ; Brightness Step
    settingsGui.AddText("xm y+15 w" ctrlWidth, GetText("brightness_step"))
    settingsGui.AddEdit("xm y+5 w" ctrlWidth " vBrightStep Number", brightnessStep)
    
    ; Monitor Mode with names
    settingsGui.AddText("xm y+15 w" (ctrlWidth - 30), GetText("monitor_mode"))
    hintBtn := settingsGui.AddButton("x+5 w25 h20", "?")
    hintBtn.OnEvent("Click", (*) => ShowModeHint())
    
    modeChoices := [GetText("mode_all"), GetText("mode_cursor")]
    modeValues := ["all", "cursor"]
    
    Loop monitorHandles.Length {
        displayName := A_Index ": " (monitorNames.Has(A_Index) ? monitorNames[A_Index] : "Monitor " A_Index)
        modeChoices.Push(displayName)
        modeValues.Push(String(A_Index))
    }
    
    currentIdx := 1
    for i, val in modeValues {
        if (val = monitorMode)
            currentIdx := i
    }
    ddMode := settingsGui.AddDropDownList("xm y+5 w" ctrlWidth " vMonMode Choose" currentIdx, modeChoices)
    
    ; Animation checkbox
    settingsGui.AddCheckbox("xm y+15 vAnimEnabled" (animationEnabled ? " Checked" : ""), GetText("enable_animations"))
    
    ; Buttons row 1
    settingsGui.AddButton("xm y+20 w" thirdWidth, GetText("save_restart")).OnEvent("Click", SaveAndRestart)
    settingsGui.AddButton("x+5 w" thirdWidth, GetText("undo")).OnEvent("Click", (*) => UndoChanges())
    settingsGui.AddButton("x+5 w" thirdWidth, GetText("cancel")).OnEvent("Click", (*) => (StopHotkeyCapture(), settingsGui.Destroy()))
    
    ; Buttons row 2
    settingsGui.AddButton("xm y+5 w" halfWidth, GetText("restore_defaults")).OnEvent("Click", (*) => RestoreDefaults())
    settingsGui.AddButton("x+5 w" halfWidth, GetText("open_config")).OnEvent("Click", (*) => Run('explorer.exe /select,"' configFile '"'))
    
    ; Buttons row 3
    settingsGui.AddButton("xm y+5 w" ctrlWidth, GetText("fkey_tool")).OnEvent("Click", (*) => ShowFKeySenderGui())
    
    ; Footer with version and GitHub link
    settingsGui.AddText("xm y+15 w" (ctrlWidth // 2) " cGray", GetText("version") ": v" APP_VERSION)
    githubLink := settingsGui.AddLink("x+5 w" (ctrlWidth // 2) " Right", '<a href="https://github.com/atakansariyar/Brightness-Controller-for-Desktop">GitHub</a>')
    
    settingsGui.Show("w" guiWidth)
}

ShowModeHint() {
    global settingsGui, fKeySenderGui
    
    ; Disable parent windows
    try settingsGui.Opt("+Disabled")
    try if (fKeySenderGui)
        fKeySenderGui.Opt("+Disabled")
    
    ; Create always-on-top hint GUI (no minimize button)
    hintGui := Gui("+AlwaysOnTop +Owner -MinimizeBox", "Monitor Mode")
    hintGui.SetFont("s10", "Segoe UI")
    hintGui.OnEvent("Close", (*) => CloseHintGui(hintGui))
    
    hintGui.AddText("xm w300", "• " GetText("mode_all") ":")
    hintGui.AddText("xm y+3 w300 cGray", "   " GetText("mode_all_hint"))
    hintGui.AddText("xm y+15 w300", "• " GetText("mode_cursor") ":")
    hintGui.AddText("xm y+3 w300 cGray", "   " GetText("mode_cursor_hint"))
    
    hintGui.AddButton("xm y+20 w300", "OK").OnEvent("Click", (*) => CloseHintGui(hintGui))
    
    hintGui.Show()
}

CloseHintGui(hintGui) {
    global settingsGui, fKeySenderGui
    
    hintGui.Destroy()
    
    ; Re-enable parent windows
    try settingsGui.Opt("-Disabled")
    try if (fKeySenderGui)
        fKeySenderGui.Opt("-Disabled")
}

OnLanguageChange(ctrl) {
    global currentLanguage, settingsGui
    langValues := ["en", "tr", "ru", "zh", "ja"]
    idx := ctrl.Value
    if (idx >= 1 && idx <= langValues.Length) {
        currentLanguage := langValues[idx]
        ; Refresh settings GUI with new language
        settingsGui.Destroy()
        ShowSettingsGui()
    }
}

UndoChanges() {
    global settingsGui, hotkeyDecrease, hotkeyIncrease, brightnessStep, monitorMode, animationEnabled
    global monitorHandles, monitorNames
    
    ; Reload from config file
    LoadConfig()
    
    ; Refresh GUI - just reopen
    settingsGui.Destroy()
    ShowSettingsGui()
}

RestoreDefaults() {
    global settingsGui
    
    ; Set default values
    global hotkeyDecrease := "F13"
    global hotkeyIncrease := "F14"
    global brightnessStep := 10
    global monitorMode := "all"
    global animationEnabled := true
    
    ; Refresh GUI
    settingsGui.Destroy()
    ShowSettingsGui()
}

; ========================= F-KEY SENDER TOOL =========================

global fKeySenderGui := 0
global fKeyStatusText := 0

ShowFKeySenderGui() {
    global settingsGui, fKeySenderGui, fKeyStatusText
    
    ; Don't hide settings - both windows stay open for capture workflow
    
    if (fKeySenderGui) {
        try fKeySenderGui.Destroy()
    }
    
    ; Fixed width layout
    guiWidth := 250
    ctrlWidth := guiWidth - 30
    
    fKeySenderGui := Gui("+AlwaysOnTop -MinimizeBox", GetText("fkey_title"))
    fKeySenderGui.MarginX := 18  ; Match Settings margin
    fKeySenderGui.SetFont("s10", "Segoe UI")
    fKeySenderGui.OnEvent("Close", (*) => CloseFKeySender())
    
    ; F-Key selection
    fKeySenderGui.AddText("xm w" ctrlWidth, GetText("select_fkey"))
    fKeyChoices := ["F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24"]
    fKeySenderGui.AddDropDownList("xm y+5 w" ctrlWidth " vSelectedFKey Choose1", fKeyChoices)
    
    ; Delay input
    fKeySenderGui.AddText("xm y+15 w" ctrlWidth, GetText("delay_ms"))
    fKeySenderGui.AddEdit("xm y+5 w" ctrlWidth " vFKeyDelay Number", "2000")
    
    ; Status text (grey)
    fKeySenderGui.AddText("xm y+15 w" ctrlWidth, GetText("status"))
    fKeyStatusText := fKeySenderGui.AddText("xm y+5 w" ctrlWidth " cGray", GetText("ready"))
    
    ; Send button
    fKeySenderGui.AddButton("xm y+20 w" ctrlWidth, GetText("send")).OnEvent("Click", (*) => SendFKey())
    
    fKeySenderGui.Show("w" guiWidth)
}

SendFKey() {
    global fKeySenderGui, fKeyStatusText
    
    saved := fKeySenderGui.Submit(false)
    selectedKey := saved.SelectedFKey
    delayMs := Integer(saved.FKeyDelay)
    
    ; Update status
    fKeyStatusText.Value := GetText("sending")
    
    ; Schedule the key send after delay
    SetTimer(() => DoSendFKey(selectedKey), -delayMs)
}

DoSendFKey(keyName) {
    global fKeyStatusText
    
    ; Use SendInput mode for better compatibility with InputHook
    prevMode := A_SendMode
    SendMode("Input")
    
    ; Send key with 50ms hold duration
    Send("{" keyName " down}")
    Sleep(50)
    Send("{" keyName " up}")
    
    SendMode(prevMode)
    
    ; Update status back to ready
    try fKeyStatusText.Value := GetText("ready")
}

CloseFKeySender() {
    global fKeySenderGui
    
    try fKeySenderGui.Destroy()
    fKeySenderGui := 0
}

CloseSettingsAndFKeyTool() {
    global settingsGui, fKeySenderGui
    
    StopHotkeyCapture()
    
    try fKeySenderGui.Destroy()
    fKeySenderGui := 0
    
    try settingsGui.Destroy()
    settingsGui := 0
}

StartHotkeyCapture(target, editCtrl) {
    global captureTarget, captureEdit, hotkeyDecrease, hotkeyIncrease
    
    StopHotkeyCapture()
    
    ; Suspend ALL brightness hotkeys during capture (both down and up)
    try {
        if (hotkeyDecrease != "") {
            Hotkey("*" hotkeyDecrease, "Off")
            Hotkey("*" hotkeyDecrease " up", "Off")
        }
        if (hotkeyIncrease != "") {
            Hotkey("*" hotkeyIncrease, "Off")
            Hotkey("*" hotkeyIncrease " up", "Off")
        }
    }
    
    captureTarget := target
    captureEdit := editCtrl
    try editCtrl.Value := "Press a key..."
    
    ih := InputHook("L1 T10")
    ih.KeyOpt("{All}", "E")
    ih.OnEnd := OnHotkeyCaptured
    ih.Start()
}

OnHotkeyCaptured(ih) {
    global captureTarget, captureEdit, hotkeyDecrease, hotkeyIncrease
    global guiEditDecrease, guiEditIncrease
    
    try {
        if (ih.EndReason = "EndKey" && captureEdit && IsObject(captureEdit)) {
            newKey := ih.EndKey
            
            ; Get current GUI values for dynamic validation
            otherKey := ""
            try {
                if (captureTarget = "dec" && IsObject(guiEditIncrease))
                    otherKey := guiEditIncrease.Value
                else if (captureTarget = "inc" && IsObject(guiEditDecrease))
                    otherKey := guiEditDecrease.Value
            }
            
            ; Validate: don't allow same key for both functions
            if (newKey = otherKey && otherKey != "") {
                ; Trying to set same key - ignore, restore original
                if (captureTarget = "dec")
                    captureEdit.Value := hotkeyDecrease
                else
                    captureEdit.Value := hotkeyIncrease
            } else {
                captureEdit.Value := newKey
            }
        } else if (captureEdit && IsObject(captureEdit)) {
            if (captureTarget = "dec")
                captureEdit.Value := hotkeyDecrease
            else
                captureEdit.Value := hotkeyIncrease
        }
    }
    
    ; Re-enable brightness hotkeys (both down and up)
    try {
        if (hotkeyDecrease != "") {
            Hotkey("*" hotkeyDecrease, "On")
            Hotkey("*" hotkeyDecrease " up", "On")
        }
        if (hotkeyIncrease != "") {
            Hotkey("*" hotkeyIncrease, "On")
            Hotkey("*" hotkeyIncrease " up", "On")
        }
    }
    
    captureTarget := ""
    captureEdit := 0
}

StopHotkeyCapture() {
    global captureTarget, captureEdit, hotkeyDecrease, hotkeyIncrease
    
    try {
        if (captureEdit && IsObject(captureEdit) && captureTarget) {
            if (captureTarget = "dec")
                captureEdit.Value := hotkeyDecrease
            else
                captureEdit.Value := hotkeyIncrease
        }
    }
    
    ; Re-enable brightness hotkeys (both down and up, in case capture was cancelled)
    try {
        if (hotkeyDecrease != "") {
            Hotkey("*" hotkeyDecrease, "On")
            Hotkey("*" hotkeyDecrease " up", "On")
        }
        if (hotkeyIncrease != "") {
            Hotkey("*" hotkeyIncrease, "On")
            Hotkey("*" hotkeyIncrease " up", "On")
        }
    }
    
    captureTarget := ""
    captureEdit := 0
}

SaveAndRestart(*) {
    global settingsGui, hotkeyDecrease, hotkeyIncrease, brightnessStep, monitorMode, animationEnabled
    
    StopHotkeyCapture()
    saved := settingsGui.Submit()
    
    hotkeyDecrease := saved.HotkeyDec
    hotkeyIncrease := saved.HotkeyInc
    brightnessStep := Integer(saved.BrightStep)
    
    ; Parse monitor mode from display name
    modeVal := saved.MonMode
    if (modeVal = "All Monitors")
        monitorMode := "all"
    else if (modeVal = "Cursor Position")
        monitorMode := "cursor"
    else {
        if (RegExMatch(modeVal, "^(\d+):", &m))
            monitorMode := m[1]
        else
            monitorMode := "all"
    }
    
    animationEnabled := saved.AnimEnabled
    
    SaveConfig()
    Reload()
}

; ========================= BRIGHTNESS CONTROL =========================

AdjustTarget(delta) {
    global currentTarget, minBrightness, maxBrightness, rampTimer
    global animClosing
    
    if (animClosing) {
        SetTimer(AnimateSlideUp, 0)
        animClosing := false
    }
    
    if (currentTarget < 0)
        currentTarget := GetCurrentBrightness()
    currentTarget := Clamp(currentTarget + delta, minBrightness, maxBrightness)
    ShowPopup(currentTarget)
    if (!rampTimer) {
        rampTimer := 1
        SetTimer(BrightnessRamp, 50)
    }
}

RepeatAdjust() {
    global currentDirection, brightnessStep, repeatTimer, repeatRate
    if (!repeatTimer)
        return
    AdjustTarget(currentDirection * brightnessStep)
    SetTimer(RepeatAdjust, -repeatRate)
}

BrightnessRamp() {
    global currentTarget, currentValue, rampTimer, brightnessRampSpeed
    global animActive
    
    if (animActive)
        return
    
    try {
        monitors := GetTargetMonitors()
        if (monitors.Length = 0) {
            SetTimer(BrightnessRamp, 0)
            rampTimer := 0
            return
        }
        
        if (currentValue < 0) {
            currentValue := GetBrightness(monitors[1])
        }
        
        diff := currentTarget - currentValue
        if (diff = 0) {
            SetTimer(BrightnessRamp, 0)
            rampTimer := 0
            return
        }
        
        step := Min(brightnessRampSpeed, Abs(diff))
        currentValue += step * (diff > 0 ? 1 : -1)
        
        for hPhys in monitors {
            SetBrightness(hPhys, currentValue)
        }
    } catch {
        SetTimer(BrightnessRamp, 0)
        rampTimer := 0
    }
}

; ========================= DDC/CI API =========================

GetBrightness(hPhys) {
    try {
        min := 0, cur := 0, max := 0
        DllCall("Dxva2\GetMonitorBrightness", "ptr", hPhys, "uint*", &min, "uint*", &cur, "uint*", &max, "int")
        return cur
    } catch {
        return 50
    }
}

GetCurrentBrightness() {
    global monitorHandles
    monitors := GetTargetMonitors()
    if (monitors.Length > 0)
        return GetBrightness(monitors[1])
    return 50
}

SetBrightness(hPhys, value) {
    try {
        DllCall("Dxva2\SetMonitorBrightness", "ptr", hPhys, "uint", value, "int")
    }
}

; ========================= TASKBAR DETECTION =========================

GetTaskbarTop() {
    hTaskbar := DllCall("FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr")
    if (!hTaskbar)
        return A_ScreenHeight - 48
    
    rect := Buffer(16, 0)
    DllCall("GetWindowRect", "ptr", hTaskbar, "ptr", rect)
    
    taskbarTop := NumGet(rect, 4, "int")
    taskbarBottom := NumGet(rect, 12, "int")
    
    if (taskbarTop > A_ScreenHeight // 2)
        return taskbarTop
    else if (taskbarBottom < A_ScreenHeight // 2)
        return taskbarBottom
    else
        return A_ScreenHeight - 48
}

; ========================= GDI+ INITIALIZATION =========================

global pToken := 0
DllCall("LoadLibrary", "str", "gdiplus")
DllCall("LoadLibrary", "str", "winmm")
DllCall("LoadLibrary", "str", "dwmapi")
si := Buffer(24, 0)
NumPut("uint", 1, si, 0)
DllCall("gdiplus\GdiplusStartup", "ptr*", &pToken, "ptr", si, "ptr", 0)

; ========================= POPUP DISPLAY =========================

ShowPopup(value) {
    global popupHwnd, popupVisible, popupTimeoutTimer, popupLastValue
    global popupWidth, popupHeight, popupMarginBottom
    global animationEnabled, animStartTime, animStartY, animTargetY, animX, animActive, animClosing
    global animationDuration, animationStartOffset
    global popupBgColor, popupBgAlpha, barBgColor, barFillColor, iconColor
    
    themeColors := GetThemeColors()
    popupBgColor := themeColors.popupBg
    popupBgAlpha := themeColors.popupAlpha
    barBgColor := themeColors.barBg
    barFillColor := themeColors.barFill
    iconColor := themeColors.icon
    
    if (popupTimeoutTimer)
        SetTimer(popupTimeoutTimer, 0)
    
    taskbarTop := GetTaskbarTop()
    animX := (A_ScreenWidth - popupWidth) // 2
    animTargetY := taskbarTop - popupHeight - popupMarginBottom
    
    if (!popupVisible) {
        popupHwnd := CreateLayeredPopup()
        DrawPopupContent(value)
        
        if (animationEnabled) {
            animStartY := animTargetY + animationStartOffset
            animStartTime := GetPerfCounter()
            animActive := true
            animClosing := false
            
            DllCall("SetWindowPos", "ptr", popupHwnd, "ptr", -1, 
                "int", animX, "int", animStartY, "int", 0, "int", 0, "uint", 0x0041)
            
            SetTimer(AnimateSlideUp, 6)
        } else {
            DllCall("SetWindowPos", "ptr", popupHwnd, "ptr", -1,
                "int", animX, "int", animTargetY, "int", 0, "int", 0, "uint", 0x0041)
        }
        
        popupVisible := true
        popupLastValue := value
        
    } else if (value != popupLastValue) {
        DrawPopupContent(value)
        popupLastValue := value
    }
    
    popupTimeoutTimer := StartCloseAnimation
    SetTimer(popupTimeoutTimer, -popupTimeout)
}

StartCloseAnimation() {
    global popupHwnd, popupVisible, animStartTime, animStartY, animTargetY, animX
    global animActive, animClosing, popupHeight
    global animationEnabled, animationCloseDuration, animationStartOffset
    
    if (!popupVisible || !popupHwnd)
        return
    
    if (animationEnabled) {
        rect := Buffer(16, 0)
        DllCall("GetWindowRect", "ptr", popupHwnd, "ptr", rect)
        currentY := NumGet(rect, 4, "int")
        
        animStartY := currentY
        animTargetY := currentY + animationStartOffset
        animStartTime := GetPerfCounter()
        animActive := true
        animClosing := true
        
        SetTimer(AnimateSlideUp, 6)
    } else {
        DestroyPopup()
    }
}

CreateLayeredPopup() {
    global popupWidth, popupHeight
    
    exStyle := 0x80000 | 0x8 | 0x80 | 0x20 | 0x8000000
    style := 0x80000000
    
    hWnd := DllCall("CreateWindowEx",
        "uint", exStyle, "str", "Static", "str", "",
        "uint", style, "int", 0, "int", 0, "int", popupWidth, "int", popupHeight,
        "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr")
    
    return hWnd
}

; ========================= POPUP RENDERING =========================

DrawPopupContent(value) {
    global popupHwnd, popupWidth, popupHeight, popupBgColor, popupBgAlpha, popupRadius
    global barWidth, barHeight, barBgColor, barRadius, barMarginTop, barMarginLeft
    global barFillColor, barFillRadius, minBrightness, maxBrightness
    global showIcon, iconColor, iconMarginLeft, iconMarginTop
    global sunCenterRadius, sunRayLength, sunRayGap, sunRayThickness, sunRayCount
    global renderScale
    
    sw := popupWidth * renderScale
    sh := popupHeight * renderScale
    sr := popupRadius * renderScale
    
    pBmpLarge := 0
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", sw, "int", sh, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBmpLarge)
    
    pG := 0
    DllCall("gdiplus\GdipGetImageGraphicsContext", "ptr", pBmpLarge, "ptr*", &pG)
    DllCall("gdiplus\GdipSetSmoothingMode", "ptr", pG, "int", 4)
    DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", pG, "int", 4)
    DllCall("gdiplus\GdipSetCompositingQuality", "ptr", pG, "int", 4)
    
    DllCall("gdiplus\GdipGraphicsClear", "ptr", pG, "uint", 0x00000000)
    
    bgARGB := (popupBgAlpha << 24) | HexToInt(popupBgColor)
    pBrushBg := 0
    DllCall("gdiplus\GdipCreateSolidFill", "uint", bgARGB, "ptr*", &pBrushBg)
    pPathBg := 0
    DllCall("gdiplus\GdipCreatePath", "int", 0, "ptr*", &pPathBg)
    AddRoundedRectPath(pPathBg, 0, 0, sw, sh, sr)
    DllCall("gdiplus\GdipFillPath", "ptr", pG, "ptr", pBrushBg, "ptr", pPathBg)
    DllCall("gdiplus\GdipDeleteBrush", "ptr", pBrushBg)
    DllCall("gdiplus\GdipDeletePath", "ptr", pPathBg)
    
    if (showIcon) {
        iconSize := (sunCenterRadius + sunRayGap + sunRayLength) * 2 * renderScale
        ix := iconMarginLeft * renderScale
        iy := iconMarginTop * renderScale
        sc := sunCenterRadius * renderScale
        srl := sunRayLength * renderScale
        srg := sunRayGap * renderScale
        srt := sunRayThickness * renderScale
        cx := ix + iconSize / 2
        cy := iy + iconSize / 2
        
        iconARGB := 0xFF000000 | HexToInt(iconColor)
        
        pBrush := 0
        DllCall("gdiplus\GdipCreateSolidFill", "uint", iconARGB, "ptr*", &pBrush)
        DllCall("gdiplus\GdipFillEllipse", "ptr", pG, "ptr", pBrush,
            "float", cx - sc, "float", cy - sc, "float", sc * 2, "float", sc * 2)
        DllCall("gdiplus\GdipDeleteBrush", "ptr", pBrush)
        
        pPen := 0
        DllCall("gdiplus\GdipCreatePen1", "uint", iconARGB, "float", srt, "int", 2, "ptr*", &pPen)
        DllCall("gdiplus\GdipSetPenStartCap", "ptr", pPen, "int", 2)
        DllCall("gdiplus\GdipSetPenEndCap", "ptr", pPen, "int", 2)
        
        pi := 3.14159265358979
        Loop sunRayCount {
            angle := (A_Index - 1) * (2 * pi / sunRayCount)
            startD := sc + srg
            endD := sc + srg + srl
            x1 := cx + Cos(angle) * startD
            y1 := cy + Sin(angle) * startD
            x2 := cx + Cos(angle) * endD
            y2 := cy + Sin(angle) * endD
            DllCall("gdiplus\GdipDrawLine", "ptr", pG, "ptr", pPen,
                "float", x1, "float", y1, "float", x2, "float", y2)
        }
        DllCall("gdiplus\GdipDeletePen", "ptr", pPen)
    }
    
    bx := barMarginLeft * renderScale
    by := barMarginTop * renderScale
    bw := barWidth * renderScale
    bh := barHeight * renderScale
    br := barRadius * renderScale
    bfr := barFillRadius * renderScale
    
    barBgARGB := 0xFF000000 | HexToInt(barBgColor)
    pBrushBar := 0
    DllCall("gdiplus\GdipCreateSolidFill", "uint", barBgARGB, "ptr*", &pBrushBar)
    pPathBar := 0
    DllCall("gdiplus\GdipCreatePath", "int", 0, "ptr*", &pPathBar)
    AddRoundedRectPath(pPathBar, bx, by, bw, bh, br)
    DllCall("gdiplus\GdipFillPath", "ptr", pG, "ptr", pBrushBar, "ptr", pPathBar)
    DllCall("gdiplus\GdipDeleteBrush", "ptr", pBrushBar)
    DllCall("gdiplus\GdipDeletePath", "ptr", pPathBar)
    
    percentage := ((value - minBrightness) / (maxBrightness - minBrightness)) * 100
    fillW := Round((bw * percentage) / 100)
    if (fillW > 0) {
        if (fillW < (2 * renderScale) && value > minBrightness)
            fillW := 2 * renderScale
        fillARGB := 0xFF000000 | HexToInt(barFillColor)
        pBrushFill := 0
        DllCall("gdiplus\GdipCreateSolidFill", "uint", fillARGB, "ptr*", &pBrushFill)
        pPathFill := 0
        DllCall("gdiplus\GdipCreatePath", "int", 0, "ptr*", &pPathFill)
        effR := Min(bfr, fillW // 2, bh // 2)
        AddRoundedRectPath(pPathFill, bx, by, fillW, bh, effR)
        DllCall("gdiplus\GdipFillPath", "ptr", pG, "ptr", pBrushFill, "ptr", pPathFill)
        DllCall("gdiplus\GdipDeleteBrush", "ptr", pBrushFill)
        DllCall("gdiplus\GdipDeletePath", "ptr", pPathFill)
    }
    
    DllCall("gdiplus\GdipDeleteGraphics", "ptr", pG)
    
    pBmpFinal := 0
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", popupWidth, "int", popupHeight, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBmpFinal)
    
    pG2 := 0
    DllCall("gdiplus\GdipGetImageGraphicsContext", "ptr", pBmpFinal, "ptr*", &pG2)
    DllCall("gdiplus\GdipSetInterpolationMode", "ptr", pG2, "int", 7)
    DllCall("gdiplus\GdipSetPixelOffsetMode", "ptr", pG2, "int", 4)
    DllCall("gdiplus\GdipSetCompositingQuality", "ptr", pG2, "int", 4)
    DllCall("gdiplus\GdipSetSmoothingMode", "ptr", pG2, "int", 4)
    DllCall("gdiplus\GdipDrawImageRectI", "ptr", pG2, "ptr", pBmpLarge, "int", 0, "int", 0, "int", popupWidth, "int", popupHeight)
    DllCall("gdiplus\GdipDeleteGraphics", "ptr", pG2)
    DllCall("gdiplus\GdipDisposeImage", "ptr", pBmpLarge)
    
    hBmp := 0
    DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pBmpFinal, "ptr*", &hBmp, "uint", 0)
    DllCall("gdiplus\GdipDisposeImage", "ptr", pBmpFinal)
    
    hDC := DllCall("GetDC", "ptr", 0, "ptr")
    hMemDC := DllCall("CreateCompatibleDC", "ptr", hDC, "ptr")
    hOldBmp := DllCall("SelectObject", "ptr", hMemDC, "ptr", hBmp, "ptr")
    
    sz := Buffer(8, 0)
    NumPut("int", popupWidth, sz, 0)
    NumPut("int", popupHeight, sz, 4)
    
    ptSrc := Buffer(8, 0)
    
    blend := Buffer(4, 0)
    NumPut("uchar", 0, blend, 0)
    NumPut("uchar", 0, blend, 1)
    NumPut("uchar", 255, blend, 2)
    NumPut("uchar", 1, blend, 3)
    
    DllCall("UpdateLayeredWindow",
        "ptr", popupHwnd, "ptr", hDC, "ptr", 0, "ptr", sz,
        "ptr", hMemDC, "ptr", ptSrc, "uint", 0, "ptr", blend, "uint", 2)
    
    DllCall("SelectObject", "ptr", hMemDC, "ptr", hOldBmp)
    DllCall("DeleteDC", "ptr", hMemDC)
    DllCall("DeleteObject", "ptr", hBmp)
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
}

; ========================= ANIMATION =========================

GetPerfCounter() {
    qpc := 0
    DllCall("QueryPerformanceCounter", "int64*", &qpc)
    return qpc
}

GetPerfFreq() {
    static freq := 0
    if (!freq)
        DllCall("QueryPerformanceFrequency", "int64*", &freq)
    return freq
}

AnimateSlideUp() {
    global popupHwnd, animActive, animStartTime, animStartY, animTargetY, animX
    global animationDuration, animationCloseDuration, popupWidth, popupHeight
    global animClosing
    
    if (!animActive || !popupHwnd) {
        SetTimer(AnimateSlideUp, 0)
        animActive := false
        return
    }
    
    duration := animClosing ? animationCloseDuration : animationDuration
    elapsed := (GetPerfCounter() - animStartTime) * 1000 / GetPerfFreq()
    
    if (elapsed >= duration) {
        if (animClosing) {
            SetTimer(AnimateSlideUp, 0)
            animActive := false
            DestroyPopup()
        } else {
            DllCall("SetWindowPos", "ptr", popupHwnd, "ptr", -1,
                "int", animX, "int", animTargetY, "int", 0, "int", 0, "uint", 0x0001)
            SetTimer(AnimateSlideUp, 0)
            animActive := false
        }
        try DllCall("dwmapi\DwmFlush")
        return
    }
    
    t := elapsed / duration
    if (t < 0.5)
        eased := 4 * t * t * t
    else
        eased := 1 - ((-2 * t + 2) ** 3) / 2
    
    currentY := animStartY + (animTargetY - animStartY) * eased
    
    DllCall("SetWindowPos", "ptr", popupHwnd, "ptr", -1,
        "int", animX, "int", Round(currentY), "int", 0, "int", 0, "uint", 0x0001)
    
    try DllCall("dwmapi\DwmFlush")
}

DestroyPopup() {
    global popupHwnd, popupVisible, popupTimeoutTimer, popupLastValue, animActive, animClosing
    
    SetTimer(AnimateSlideUp, 0)
    animActive := false
    animClosing := false
    
    if (popupHwnd) {
        DllCall("DestroyWindow", "ptr", popupHwnd)
        popupHwnd := 0
    }
    
    popupVisible := false
    popupLastValue := -1
    popupTimeoutTimer := 0
}

ClosePopup() {
    StartCloseAnimation()
}

; ========================= UTILITIES =========================

AddRoundedRectPath(pPath, x, y, w, h, r) {
    if (r <= 0) {
        DllCall("gdiplus\GdipAddPathRectangle", "ptr", pPath, "float", x, "float", y, "float", w, "float", h)
        return
    }
    
    r := Min(r, w / 2.0, h / 2.0)
    d := r * 2.0
    
    DllCall("gdiplus\GdipStartPathFigure", "ptr", pPath)
    DllCall("gdiplus\GdipAddPathArc", "ptr", pPath, "float", x, "float", y, "float", d, "float", d, "float", 180.0, "float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "ptr", pPath, "float", x + w - d, "float", y, "float", d, "float", d, "float", 270.0, "float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "ptr", pPath, "float", x + w - d, "float", y + h - d, "float", d, "float", d, "float", 0.0, "float", 90.0)
    DllCall("gdiplus\GdipAddPathArc", "ptr", pPath, "float", x, "float", y + h - d, "float", d, "float", d, "float", 90.0, "float", 90.0)
    DllCall("gdiplus\GdipClosePathFigure", "ptr", pPath)
}

HexToInt(hex) {
    hex := StrReplace(hex, "#", "")
    return Integer("0x" hex)
}

Clamp(val, min, max) {
    return val < min ? min : (val > max ? max : val)
}
