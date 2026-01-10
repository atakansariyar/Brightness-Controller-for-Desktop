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

global APP_VERSION := "2.1.0"

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
        "enable_popup", "Enable OSD Popup",
        "startup_mode", "Startup Mode:",
        "startup_disabled", "Disabled",
        "startup_normal", "Normal (Startup Folder)",
        "startup_high", "High Priority (Task Scheduler)",
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
        "searching", "Searching for DDC/CI monitor...",
        "menu_settings", "Settings",
        "menu_reload", "Reload Config",
        "menu_exit", "Exit",
        "config_error_title", "Config Error",
        "config_reloaded", "Configuration reloaded.",
        "config_repaired", "Configuration repaired.",
        "config_load_failed", "Warning: Config could not be loaded.",
        "config_startup_explain", "• Repair: Config will be reset to default values.`n• Continue: Config will not be read, new settings will not be saved.",
        "config_reload_explain", "• Repair: Config will be recreated with last cached or default values.`n• Continue: Config will not be read, new settings will not be saved.",
        "config_option_repair", "Repair",
        "config_option_default", "Continue",
        "config_confirm", "Are you sure?",
        "config_confirm_btn", "Confirm",
        "config_no_cache_warning", "No cached settings found. Your old settings will be lost and default values will be used. Are you sure?",
        "startup_invalid", "Invalid startup option. Please manually add the startup option or run the installer again.",
        "startup_help", "I need help.",
        "startup_admin_required", "Administrator permission is required to change high priority startup setting. Do you want to continue?"
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
        "enable_popup", "OSD Popup'u Etkinleştir",
        "startup_mode", "Başlangıç Modu:",
        "startup_disabled", "Devre Dışı",
        "startup_normal", "Normal (Başlangıç Klasörü)",
        "startup_high", "Yüksek Öncelikli (Task Scheduler)",
        "language", "Dil:",
        "save_restart", "Kaydet",
        "undo", "Geri Al",
        "cancel", "İptal",
        "restore_defaults", "Varsayılanlara Dön",
        "open_config", "Config Klasörünü Aç",
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
        "searching", "DDC/CI monitör aranıyor...",
        "menu_settings", "Ayarlar",
        "menu_reload", "Config'i Yenile",
        "menu_exit", "Çıkış",
        "config_error_title", "Config Hatası",
        "config_reloaded", "Yapılandırma yeniden yüklendi.",
        "config_repaired", "Yapılandırma onarıldı.",
        "config_load_failed", "Uyarı: Config yüklenemedi.",
        "config_startup_explain", "• Onar: Config varsayılan değerlere sıfırlanır.`n• Devam Et: Config okunmaz, yeni ayarlar kaydedilmez.",
        "config_reload_explain", "• Onar: Config son önbellek değerleri yada varsayılan değerlerle yeniden oluşturulur.`n• Devam Et: Config okunmaz, yeni ayarlar kaydedilmez.",
        "config_option_repair", "Onar",
        "config_option_default", "Devam Et",
        "config_confirm", "Emin misiniz?",
        "config_confirm_btn", "Onayla",
        "config_no_cache_warning", "Önbellekte kayıtlı ayar bulunmuyor. Eski ayarlarınız kaybolacak ve default değerler atanacak. Emin misiniz?",
        "startup_invalid", "Geçersiz başlatma seçeneği. Lütfen manuel olarak başlatma seçeneği ekleyin veya kurulumu yeniden başlatın.",
        "startup_help", "Yardıma ihtiyacım var.",
        "startup_admin_required", "Yüksek öncelikli başlatıcı ayarını değiştirmek için yönetici izni gereklidir. Devam etmek istiyor musunuz?"
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
        "enable_popup", "Включить OSD",
        "startup_mode", "Режим запуска:",
        "startup_disabled", "Отключено",
        "startup_normal", "Обычный (Папка автозагрузки)",
        "startup_high", "Высокий приоритет (Планировщик)",
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
        "searching", "Поиск DDC/CI монитора...",
        "menu_settings", "Настройки",
        "menu_reload", "Перезагрузить конфиг",
        "menu_exit", "Выход",
        "config_error_title", "Ошибка конфигурации",
        "config_reloaded", "Конфигурация перезагружена.",
        "config_repaired", "Конфигурация восстановлена.",
        "config_load_failed", "Предупреждение: не удалось загрузить конфиг.",
        "config_startup_explain", "• Восстановить: Конфиг будет сброшен к значениям по умолчанию.`n• Продолжить: Конфиг не будет считан, новые настройки не сохранятся.",
        "config_reload_explain", "• Восстановить: Конфиг будет восстановлен с кэшированными или стандартными значениями.`n• Продолжить: Конфиг не будет считан.",
        "config_option_repair", "Восстановить",
        "config_option_default", "Продолжить",
        "config_confirm", "Вы уверены?",
        "config_confirm_btn", "Подтвердить",
        "config_no_cache_warning", "Кэш настроек не найден. Старые настройки будут утеряны. Вы уверены?",
        "startup_invalid", "Недействительный параметр запуска. Добавьте его вручную или запустите установщик снова.",
        "startup_help", "Мне нужна помощь.",
        "startup_admin_required", "Для изменения параметра высокого приоритета запуска требуется права администратора. Продолжить?"
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
        "enable_popup", "启用OSD弹窗",
        "startup_mode", "启动模式:",
        "startup_disabled", "禁用",
        "startup_normal", "普通 (启动文件夹)",
        "startup_high", "高优先级 (任务计划)",
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
        "searching", "正在搜索DDC/CI监视器...",
        "menu_settings", "设置",
        "menu_reload", "重新加载配置",
        "menu_exit", "退出",
        "config_error_title", "配置错误",
        "config_reloaded", "配置已重新加载。",
        "config_repaired", "配置已修复。",
        "config_load_failed", "警告：无法加载配置。",
        "config_startup_explain", "• 修复：配置将重置为默认值。`n• 继续：配置将不会被读取，新设置也不会保存。",
        "config_reload_explain", "• 修复：配置将使用缓存或默认值重新创建。`n• 继续：配置将不会被读取。",
        "config_option_repair", "修复",
        "config_option_default", "继续",
        "config_confirm", "确定吗？",
        "config_confirm_btn", "确认",
        "config_no_cache_warning", "未找到缓存设置。旧设置将丢失，将使用默认值。确定吗？",
        "startup_invalid", "启动选项无效。请手动添加或重新运行安装程序。",
        "startup_help", "我需要帮助。",
        "startup_admin_required", "更改高优先级启动设置需要管理员权限。是否继续？"
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
        "enable_popup", "OSDポップアップを有効化",
        "startup_mode", "起動モード:",
        "startup_disabled", "無効",
        "startup_normal", "通常 (スタートアップフォルダ)",
        "startup_high", "高優先度 (タスクスケジューラ)",
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
        "searching", "DDC/CIモニターを検索中...",
        "menu_settings", "設定",
        "menu_reload", "設定を再読み込み",
        "menu_exit", "終了",
        "config_error_title", "設定エラー",
        "config_reloaded", "設定が再読み込みされました。",
        "config_repaired", "設定が修復されました。",
        "config_load_failed", "警告：設定を読み込めませんでした。",
        "config_startup_explain", "• 修復：設定がデフォルト値にリセットされます。`n• 続行：設定は読み込まれず、新しい設定も保存されません。",
        "config_reload_explain", "• 修復：設定がキャッシュまたはデフォルト値で再作成されます。`n• 続行：設定は読み込まれません。",
        "config_option_repair", "修復",
        "config_option_default", "続行",
        "config_confirm", "よろしいですか？",
        "config_confirm_btn", "確認",
        "config_no_cache_warning", "キャッシュ設定が見つかりません。古い設定は失われ、デフォルト値が使用されます。よろしいですか？",
        "startup_invalid", "無効な起動オプションです。手動で追加するか、インストーラーを再実行してください。",
        "startup_help", "ヘルプが必要です。",
        "startup_admin_required", "高優先度起動設定を変更するには管理者権限が必要です。続行しますか？"
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
global popupEnabled := true
global popupWidth := 193
global popupHeight := 50
global popupRadius := 10
global popupMarginBottom := 12

; Animation
global animationEnabled := true
global animationDuration := 200

; Startup Mode (0=disabled, 1=normal, 2=high priority)
global startupMode := 0
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
    popupEnabled := (IniRead(configFile, "Popup", "popupEnabled", "true") = "true")
    
    animationEnabled := (IniRead(configFile, "Animation", "animationEnabled", "true") = "true")
    
    currentLanguage := IniRead(configFile, "General", "language", "en")
}

SaveConfig() {
    global
    
    ; Don't write to config if it couldn't be read (user chose to continue with defaults)
    if (!configReadable)
        return
    
    IniWrite(hotkeyDecrease, configFile, "Hotkeys", "hotkeyDecrease")
    IniWrite(hotkeyIncrease, configFile, "Hotkeys", "hotkeyIncrease")
    
    IniWrite(brightnessStep, configFile, "Brightness", "brightnessStep")
    IniWrite(brightnessRampSpeed, configFile, "Brightness", "brightnessRampSpeed")
    
    IniWrite(monitorMode, configFile, "Monitor", "monitorMode")
    
    IniWrite(popupTimeout, configFile, "Popup", "popupTimeout")
    IniWrite(popupEnabled ? "true" : "false", configFile, "Popup", "popupEnabled")
    
    IniWrite(animationEnabled ? "true" : "false", configFile, "Animation", "animationEnabled")
    
    IniWrite(currentLanguage, configFile, "General", "language")
}

; ========================= CONFIG VALIDATION SYSTEM =========================

global configReadable := false      ; Config başarıyla okunabildi mi?
global configCached := Map()        ; Son başarılı okumadaki değerler

; Cache current config values
CacheConfig() {
    global configCached, hotkeyDecrease, hotkeyIncrease, brightnessStep
    global brightnessRampSpeed, monitorMode, popupTimeout, popupEnabled, animationEnabled, currentLanguage, startupMode
    
    configCached["hotkeyDecrease"] := hotkeyDecrease
    configCached["hotkeyIncrease"] := hotkeyIncrease
    configCached["brightnessStep"] := brightnessStep
    configCached["brightnessRampSpeed"] := brightnessRampSpeed
    configCached["monitorMode"] := monitorMode
    configCached["popupTimeout"] := popupTimeout
    configCached["popupEnabled"] := popupEnabled
    configCached["animationEnabled"] := animationEnabled
    configCached["language"] := currentLanguage
    configCached["startupMode"] := startupMode
}

; Restore config from cache
RestoreFromCache() {
    global configCached, hotkeyDecrease, hotkeyIncrease, brightnessStep
    global brightnessRampSpeed, monitorMode, popupTimeout, popupEnabled, animationEnabled, currentLanguage, startupMode
    
    if (configCached.Count = 0)
        return false
    
    hotkeyDecrease := configCached["hotkeyDecrease"]
    hotkeyIncrease := configCached["hotkeyIncrease"]
    brightnessStep := configCached["brightnessStep"]
    brightnessRampSpeed := configCached["brightnessRampSpeed"]
    monitorMode := configCached["monitorMode"]
    popupTimeout := configCached["popupTimeout"]
    popupEnabled := configCached["popupEnabled"]
    animationEnabled := configCached["animationEnabled"]
    currentLanguage := configCached["language"]
    startupMode := configCached["startupMode"]
    return true
}

; ========================= STARTUP MODE DETECTION =========================

global detectedStartupMode := 0  ; Detected state (not from config)

; Detect actual startup configuration
; Returns: 0=disabled, 1=normal (startup folder), 2=high priority (task scheduler)
DetectStartupMode() {
    global detectedStartupMode
    
    ; Check for Task Scheduler task (high priority) - using hidden command
    try {
        tempFile := A_Temp "\bc_schtask_check.txt"
        RunWait(A_ComSpec ' /c schtasks /Query /TN "BrightnessController" > "' tempFile '" 2>&1',, "Hide")
        if (FileExist(tempFile)) {
            result := FileRead(tempFile)
            FileDelete(tempFile)
            if (InStr(result, "BrightnessController")) {
                detectedStartupMode := 2
                return 2
            }
        }
    }
    
    ; Check for Startup folder shortcut (normal priority)
    startupShortcut := A_Startup "\Brightness Controller.lnk"
    if (FileExist(startupShortcut)) {
        detectedStartupMode := 1
        return 1
    }
    
    ; Neither found
    detectedStartupMode := 0
    return 0
}

; Apply startup mode changes
; Returns: true if successful, false if cancelled or failed
ApplyStartupMode(newMode, currentMode) {
    ; If no change needed, return success
    if (newMode = currentMode)
        return true
    
    startupShortcut := A_Startup "\Brightness Controller.lnk"
    
    ; Handle transitions
    if (newMode = 2) {
        ; Switching TO high priority - needs admin for schtasks
        ; First remove normal startup if exists
        if (FileExist(startupShortcut))
            FileDelete(startupShortcut)
        
        ; Create task scheduler entry (requires elevation)
        cmdLine := '\"' (A_IsCompiled ? A_ScriptFullPath : A_AhkPath) '\"'
        if (!A_IsCompiled)
            cmdLine .= ' \"' A_ScriptFullPath '\"'
        
        try {
            ; Use cmd with runas verb for admin elevation
            Run('*RunAs ' A_ComSpec ' /c schtasks /Create /TN "BrightnessController" /TR "' cmdLine '" /SC ONLOGON /RL HIGHEST /F')
            Sleep(1000)  ; Wait for command to complete
            return true
        } catch {
            return false
        }
    }
    else if (currentMode = 2) {
        ; Switching FROM high priority - needs admin to remove schtasks
        try {
            Run('*RunAs ' A_ComSpec ' /c schtasks /Delete /TN "BrightnessController" /F')
            Sleep(1000)  ; Wait for command to complete
        } catch {
            return false
        }
        
        ; Now apply new mode (normal or disabled)
        if (newMode = 1) {
            ; Create startup shortcut
            return CreateStartupShortcut()
        }
        return true  ; Disabled - nothing more to do
    }
    else if (newMode = 1) {
        ; Normal startup - create shortcut
        return CreateStartupShortcut()
    }
    else if (newMode = 0) {
        ; Disabled - remove shortcut if exists
        if (FileExist(startupShortcut))
            FileDelete(startupShortcut)
        return true
    }
    
    return true
}

; Create startup folder shortcut
CreateStartupShortcut() {
    try {
        startupShortcut := A_Startup "\Brightness Controller.lnk"
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(startupShortcut)
        if (A_IsCompiled) {
            shortcut.TargetPath := A_ScriptFullPath
        } else {
            shortcut.TargetPath := A_AhkPath
            shortcut.Arguments := '"' A_ScriptFullPath '"'
        }
        shortcut.WorkingDirectory := A_ScriptDir
        shortcut.Description := "Brightness Controller for Desktop"
        iconPath := A_ScriptDir "\assets\brightness_icon.ico"
        if (FileExist(iconPath))
            shortcut.IconLocation := iconPath
        shortcut.Save()
        return true
    } catch {
        return false
    }
}

; Check if config has errors
HasConfigErrors() {
    global configFile
    
    if (!FileExist(configFile))
        return false  ; No file = no errors
    
    try {
        fileContent := FileRead(configFile)
        
        ; Check if expected keys exist in config (exact names)
        expectedKeys := [
            ["Hotkeys", "hotkeyDecrease"],
            ["Hotkeys", "hotkeyIncrease"],
            ["Brightness", "brightnessStep"],
            ["Brightness", "brightnessRampSpeed"],
            ["Monitor", "monitorMode"],
            ["Popup", "popupTimeout"],
            ["Popup", "popupEnabled"],
            ["Animation", "animationEnabled"],
            ["General", "language"]
        ]
        
        for key in expectedKeys {
            ; Check if section and key name appear correctly in file
            if (!InStr(fileContent, key[2] "="))
                return true  ; Key not found or misspelled
        }
        
        ; Check numeric values
        numericKeys := [["Brightness", "brightnessStep"], ["Brightness", "brightnessRampSpeed"], ["Popup", "popupTimeout"]]
        for key in numericKeys {
            val := IniRead(configFile, key[1], key[2], "")
            if (val != "" && !RegExMatch(val, "^\d+$"))
                return true
        }
        
        ; Check boolean values (animationEnabled and popupEnabled)
        animVal := IniRead(configFile, "Animation", "animationEnabled", "")
        if (animVal != "" && animVal != "true" && animVal != "false")
            return true
        
        popupVal := IniRead(configFile, "Popup", "popupEnabled", "")
        if (popupVal != "" && popupVal != "true" && popupVal != "false")
            return true
        
        ; Check language
        langVal := IniRead(configFile, "General", "language", "")
        validLangs := ["en", "tr", "ru", "zh", "ja", ""]
        langValid := false
        for l in validLangs {
            if (langVal = l)
                langValid := true
        }
        if (!langValid)
            return true
        
        ; Check monitorMode - must be "all", "cursor", or a number
        modeVal := IniRead(configFile, "Monitor", "monitorMode", "")
        if (modeVal != "") {
            if (modeVal != "all" && modeVal != "cursor" && !RegExMatch(modeVal, "^\d+$"))
                return true
        }
            
    } catch {
        return true
    }
    
    return false
}

; Startup config validation
ValidateConfigOnStartup() {
    global configReadable, configFile
    
    if (!FileExist(configFile)) {
        ; No config file - create default
        SaveConfig()
        configReadable := true
        CacheConfig()
        return
    }
    
    if (HasConfigErrors()) {
        ; Show error dialog
        ShowStartupConfigError()
    } else {
        ; Config OK - load and cache
        LoadConfig()
        configReadable := true
        CacheConfig()
    }
}

ShowStartupConfigError() {
    global configReadable
    
    ; Create custom dialog GUI
    ; Content width: 340px, 3 buttons (100px each) + 2 gaps (10px) = 320px, margin 10px each side
    errorGui := Gui("+AlwaysOnTop -MinimizeBox", GetText("config_error_title"))
    errorGui.SetFont("s10", "Segoe UI")
    errorGui.MarginX := 20
    errorGui.MarginY := 15
    
    ; Warning icon and message
    errorGui.AddText("w320 Center", "⚠️ " GetText("config_load_failed"))
    errorGui.AddText("w320 y+15", GetText("config_startup_explain"))
    
    ; Centered buttons - 3 equal buttons (100px) with 10px gaps
    errorGui.AddButton("w100 y+20 x20", GetText("config_option_repair")).OnEvent("Click", (*) => StartupRepairClicked(errorGui))
    errorGui.AddButton("x+10 w100", GetText("config_option_default")).OnEvent("Click", (*) => StartupDefaultClicked(errorGui))
    errorGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => ExitApp())
    
    errorGui.OnEvent("Close", (*) => ExitApp())
    errorGui.Show()
    
    ; Wait for dialog to close
    WinWaitClose("ahk_id " errorGui.Hwnd)
}

StartupRepairClicked(errorGui) {
    global configReadable
    
    ; Confirm dialog - 2 buttons (100px each) + 1 gap (10px) = 210px, margin 15px each side = 240px content
    confirmGui := Gui("+AlwaysOnTop -MinimizeBox +Owner" errorGui.Hwnd, GetText("config_error_title"))
    confirmGui.SetFont("s10", "Segoe UI")
    confirmGui.MarginX := 15
    confirmGui.MarginY := 15
    confirmGui.AddText("w210 Center", GetText("config_confirm"))
    confirmGui.AddButton("w100 y+15 x15", GetText("config_confirm_btn")).OnEvent("Click", (*) => (
        configReadable := true,
        SaveConfig(),
        CacheConfig(),
        confirmGui.Destroy(),
        errorGui.Destroy()
    ))
    confirmGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => confirmGui.Destroy())
    confirmGui.Show()
}

StartupDefaultClicked(errorGui) {
    global configReadable
    
    ; Confirm dialog - 2 buttons (100px each) + 1 gap (10px) = 210px, margin 15px each side
    confirmGui := Gui("+AlwaysOnTop -MinimizeBox +Owner" errorGui.Hwnd, GetText("config_error_title"))
    confirmGui.SetFont("s10", "Segoe UI")
    confirmGui.MarginX := 15
    confirmGui.MarginY := 15
    confirmGui.AddText("w210 Center", GetText("config_confirm"))
    confirmGui.AddButton("w100 y+15 x15", GetText("config_confirm_btn")).OnEvent("Click", (*) => (
        configReadable := false,
        confirmGui.Destroy(),
        errorGui.Destroy()
    ))
    confirmGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => confirmGui.Destroy())
    confirmGui.Show()
}

; Reload config with validation
ReloadConfigWithValidation() {
    global configReadable, configCached
    
    if (HasConfigErrors()) {
        ShowReloadConfigError()
    } else {
        ; Config OK - reload
        LoadConfig()
        configReadable := true
        CacheConfig()
        BuildTrayMenu()
        ToolTip("✓ " GetText("config_reloaded"))
        SetTimer(() => ToolTip(), -2000)
    }
}

ShowReloadConfigError() {
    global configReadable, configCached
    
    ; Create custom dialog GUI
    ; Content width: 340px, 3 buttons (100px each) + 2 gaps (10px) = 320px, margin 10px each side
    errorGui := Gui("+AlwaysOnTop -MinimizeBox", GetText("config_error_title"))
    errorGui.SetFont("s10", "Segoe UI")
    errorGui.MarginX := 20
    errorGui.MarginY := 15
    
    ; Warning icon and message
    errorGui.AddText("w320 Center", "⚠️ " GetText("config_load_failed"))
    errorGui.AddText("w320 y+15", GetText("config_reload_explain"))
    
    ; Centered buttons - 3 equal buttons (100px) with 10px gaps
    errorGui.AddButton("w100 y+20 x20", GetText("config_option_repair")).OnEvent("Click", (*) => ReloadRepairClicked(errorGui))
    errorGui.AddButton("x+10 w100", GetText("config_option_default")).OnEvent("Click", (*) => ReloadDefaultClicked(errorGui))
    errorGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => errorGui.Destroy())
    
    errorGui.OnEvent("Close", (*) => errorGui.Destroy())
    errorGui.Show()
}

ReloadRepairClicked(errorGui) {
    global configReadable, configCached
    
    if (configCached.Count > 0) {
        ; Cache exists - confirm - 2 buttons (100px each) + 1 gap (10px) = 210px, margin 15px each side
        confirmGui := Gui("+AlwaysOnTop -MinimizeBox +Owner" errorGui.Hwnd, GetText("config_error_title"))
        confirmGui.SetFont("s10", "Segoe UI")
        confirmGui.MarginX := 15
        confirmGui.MarginY := 15
        confirmGui.AddText("w210 Center", GetText("config_confirm"))
        confirmGui.AddButton("w100 y+15 x15", GetText("config_confirm_btn")).OnEvent("Click", (*) => (
            RestoreFromCache(),
            configReadable := true,
            SaveConfig(),
            BuildTrayMenu(),
            ToolTip("✓ " GetText("config_repaired")),
            SetTimer(() => ToolTip(), -2000),
            confirmGui.Destroy(),
            errorGui.Destroy()
        ))
        confirmGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => confirmGui.Destroy())
        confirmGui.Show()
    } else {
        ; No cache - warn about losing settings - wider dialog for longer text
        confirmGui := Gui("+AlwaysOnTop -MinimizeBox +Owner" errorGui.Hwnd, GetText("config_error_title"))
        confirmGui.SetFont("s10", "Segoe UI")
        confirmGui.MarginX := 15
        confirmGui.MarginY := 15
        confirmGui.AddText("w320 Center", GetText("config_no_cache_warning"))
        ; 2 buttons centered in 320px: (320 - 210) / 2 + 15 = 70px x position
        confirmGui.AddButton("w100 y+15 x70", GetText("config_confirm_btn")).OnEvent("Click", (*) => (
            configReadable := true,
            SaveConfig(),
            CacheConfig(),
            BuildTrayMenu(),
            ToolTip("✓ " GetText("config_repaired")),
            SetTimer(() => ToolTip(), -2000),
            confirmGui.Destroy(),
            errorGui.Destroy()
        ))
        confirmGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => confirmGui.Destroy())
        confirmGui.Show()
    }
}

ReloadDefaultClicked(errorGui) {
    global configReadable
    
    ; Confirm dialog - 2 buttons (100px each) + 1 gap (10px) = 210px, margin 15px each side
    confirmGui := Gui("+AlwaysOnTop -MinimizeBox +Owner" errorGui.Hwnd, GetText("config_error_title"))
    confirmGui.SetFont("s10", "Segoe UI")
    confirmGui.MarginX := 15
    confirmGui.MarginY := 15
    confirmGui.AddText("w210 Center", GetText("config_confirm"))
    confirmGui.AddButton("w100 y+15 x15", GetText("config_confirm_btn")).OnEvent("Click", (*) => (
        configReadable := false,
        confirmGui.Destroy(),
        errorGui.Destroy()
    ))
    confirmGui.AddButton("x+10 w100", GetText("cancel")).OnEvent("Click", (*) => confirmGui.Destroy())
    confirmGui.Show()
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

ValidateConfigOnStartup()
EnumerateMonitors()

; Set custom tray icon (check assets folder first, then root)
iconFile := A_ScriptDir "\assets\brightness_icon.ico"
if (!FileExist(iconFile))
    iconFile := A_ScriptDir "\brightness_icon.ico"
if (FileExist(iconFile))
    TraySetIcon(iconFile)

; Create system tray menu (initial build)
BuildTrayMenu()

BuildTrayMenu() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add(GetText("menu_settings"), ShowSettingsGui)
    A_TrayMenu.Add(GetText("menu_reload"), (*) => ReloadConfigWithValidation())
    A_TrayMenu.Add()
    A_TrayMenu.Add(GetText("menu_exit"), (*) => ExitApp())
    ; No default - double-click will trigger popup slider
}

; Handle tray icon double-click
OnMessage(0x404, TrayIconClick)  ; WM_TRAYICON = 0x404

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
; ========================= BRIGHTNESS POPUP SLIDER =========================

global brightnessPopup := 0
global brightnessSlider := 0
global popupHwndSlider := 0

TrayIconClick(wParam, lParam, msg, hwnd) {
    if (lParam = 0x203) {  ; WM_LBUTTONDBLCLK (double-click)
        ; Close system tray notification area (send Escape)
        Send("{Escape}")
        Sleep(50)
        ShowBrightnessPopup()
    }
    ; Don't return 1 - let other messages pass through for right-click menu
}

ShowBrightnessPopup() {
    global brightnessPopup, brightnessSlider, monitorHandles, popupHwndSlider
    global popupSliderValue, popupProgressBar, popupSliderDragging
    
    ; Close existing popup if open
    if (brightnessPopup) {
        try brightnessPopup.Destroy()
        brightnessPopup := 0
    }
    
    ; Get current brightness
    popupSliderValue := GetCurrentBrightness()
    popupSliderDragging := false
    
    ; Modern dark rounded popup
    brightnessPopup := Gui("+AlwaysOnTop -Caption +ToolWindow")
    brightnessPopup.BackColor := "1A1A1A"
    
    ; Round corners using DWM
    try {
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", brightnessPopup.Hwnd, 
            "int", 33, "int*", 2, "int", 4)
    }
    
    brightnessPopup.AddProgress("x15 y18 w170 h12 Background333333 c60CDFF Range0-100 -Tabstop vSliderBar", popupSliderValue)
    popupProgressBar := brightnessPopup["SliderBar"]
    
    ; Get cursor position and center popup there
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    popupW := 200
    popupH := 48
    popupX := mouseX - (popupW // 2)
    popupY := mouseY - 25  ; Below cursor
    
    ; Keep on screen
    if (popupX < 10)
        popupX := 10
    if (popupX + popupW > A_ScreenWidth - 10)
        popupX := A_ScreenWidth - popupW - 10
    if (popupY < 10)
        popupY := mouseY + 20
    
    brightnessPopup.Show("x" popupX " y" popupY " w" popupW " h" popupH)
    popupHwndSlider := brightnessPopup.Hwnd
    
    ; Register global scroll hotkeys
    Hotkey("WheelUp", PopupScrollDown, "On")
    Hotkey("WheelDown", PopupScrollUp, "On")
    
    ; Start timer to check if popup lost focus and handle dragging
    SetTimer(CheckPopupFocus, 100)
    SetTimer(CheckPopupDrag, 16)
}

CheckPopupDrag() {
    global popupSliderDragging, brightnessPopup, popupHwndSlider
    
    if (!brightnessPopup)
        return
    
    ; Check if left mouse button is pressed
    if (GetKeyState("LButton", "P")) {
        ; Check if mouse is over our popup
        MouseGetPos(,, &winHwnd)
        if (winHwnd = popupHwndSlider) {
            popupSliderDragging := true
            UpdateSliderFromMouse()
        }
    } else {
        popupSliderDragging := false
    }
}

UpdateSliderFromMouse() {
    global popupSliderValue, popupProgressBar, brightnessPopup, currentTarget, rampTimer
    
    if (!brightnessPopup || !popupProgressBar)
        return
    
    ; Get mouse position relative to progress bar
    CoordMode("Mouse", "Client")
    MouseGetPos(&mx, &my, &winHwnd)
    
    if (winHwnd != brightnessPopup.Hwnd)
        return
    
    ; Progress bar is at x=15, w=170
    barX := 15
    barW := 170
    
    ; Calculate value from mouse X position
    relX := mx - barX
    newValue := Round((relX / barW) * 100)
    newValue := Max(0, Min(100, newValue))
    
    if (newValue != popupSliderValue) {
        popupSliderValue := newValue
        popupProgressBar.Value := newValue
        
        ; Update brightness
        currentTarget := newValue
        if (!rampTimer) {
            rampTimer := 1
            SetTimer(BrightnessRamp, 50)
        }
    }
}

PopupScrollDown(*) {
    global popupSliderValue, popupProgressBar, currentTarget, rampTimer
    if (popupProgressBar) {
        newVal := Min(100, popupSliderValue + 5)
        popupSliderValue := newVal
        popupProgressBar.Value := newVal
        currentTarget := newVal
        if (!rampTimer) {
            rampTimer := 1
            SetTimer(BrightnessRamp, 50)
        }
    }
}

PopupScrollUp(*) {
    global popupSliderValue, popupProgressBar, currentTarget, rampTimer
    if (popupProgressBar) {
        newVal := Max(0, popupSliderValue - 5)
        popupSliderValue := newVal
        popupProgressBar.Value := newVal
        currentTarget := newVal
        if (!rampTimer) {
            rampTimer := 1
            SetTimer(BrightnessRamp, 50)
        }
    }
}

CheckPopupFocus() {
    global brightnessPopup, popupHwndSlider
    
    if (!brightnessPopup || !popupHwndSlider)
        return
    
    ; Get the currently active window (with error handling)
    try {
        activeHwnd := WinGetID("A")
    } catch {
        ; No active window - close popup
        SetTimer(CheckPopupFocus, 0)
        CloseBrightnessPopup()
        return
    }
    
    ; If active window is not our popup, close it
    if (activeHwnd != popupHwndSlider) {
        SetTimer(CheckPopupFocus, 0)
        CloseBrightnessPopup()
    }
}

OnSliderChange(ctrl, *) {
    global currentTarget, rampTimer
    
    newValue := ctrl.Value
    currentTarget := newValue
    
    ; Start brightness ramping
    if (!rampTimer) {
        rampTimer := 1
        SetTimer(BrightnessRamp, 50)
    }
}

CloseBrightnessPopup() {
    global brightnessPopup, popupHwndSlider, popupProgressBar, popupSliderDragging
    
    SetTimer(CheckPopupFocus, 0)
    SetTimer(CheckPopupDrag, 0)
    
    ; Disable global scroll hotkeys
    try {
        Hotkey("WheelUp", "Off")
        Hotkey("WheelDown", "Off")
    }
    
    if (brightnessPopup) {
        try brightnessPopup.Destroy()
        brightnessPopup := 0
        popupHwndSlider := 0
        popupProgressBar := 0
        popupSliderDragging := false
    }
}

; ========================= SETTINGS GUI =========================

global captureTarget := ""
global captureEdit := 0

ShowSettingsGui(*) {
    global settingsGui, hotkeyDecrease, hotkeyIncrease, brightnessStep, monitorMode
    global animationEnabled, popupEnabled, monitorHandles, monitorNames, configFile, currentLanguage, APP_VERSION
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
    settingsGui.MarginX := 15  ; Center controls (default is ~15, +3px offset)
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
    guiEditDecrease := settingsGui.AddEdit("xm y+5 w" (ctrlWidth - 90) " vHotkeyDec ReadOnly", SymbolToReadable(hotkeyDecrease))
    btnCapDec := settingsGui.AddButton("x+5 w80", GetText("capture"))
    btnCapDec.OnEvent("Click", (*) => StartHotkeyCapture("dec", guiEditDecrease))
    
    ; Hotkey Increase
    settingsGui.AddText("xm y+10 w" ctrlWidth, GetText("hotkey_increase"))
    guiEditIncrease := settingsGui.AddEdit("xm y+5 w" (ctrlWidth - 90) " vHotkeyInc ReadOnly", SymbolToReadable(hotkeyIncrease))
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
    
    ; Startup Mode dropdown (detect actual startup state)
    settingsGui.AddText("xm y+15 w" ctrlWidth, GetText("startup_mode"))
    startupChoices := [GetText("startup_disabled"), GetText("startup_normal"), GetText("startup_high")]
    detectedMode := DetectStartupMode()  ; Detect actual state
    startupIdx := detectedMode + 1  ; Convert 0/1/2 to 1/2/3 for dropdown index
    if (startupIdx < 1 || startupIdx > 3)
        startupIdx := 1
    ddStartup := settingsGui.AddDropDownList("xm y+5 w" ctrlWidth " vStartupMode Choose" startupIdx, startupChoices)
    
    ; Animation checkbox
    settingsGui.AddCheckbox("xm y+15 vAnimEnabled" (animationEnabled ? " Checked" : ""), GetText("enable_animations"))
    
    ; Popup checkbox
    settingsGui.AddCheckbox("xm y+5 vPopupEnabled" (popupEnabled ? " Checked" : ""), GetText("enable_popup"))

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
    global popupEnabled := true
    
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
    fKeySenderGui.MarginX := 15  ; Match Settings margin
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
    ; Exclude modifier keys from triggering end - they should only modify
    ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{Ctrl}{Alt}{Shift}", "-E")
    ih.OnEnd := OnHotkeyCaptured
    ih.Start()
}

OnHotkeyCaptured(ih) {
    global captureTarget, captureEdit, hotkeyDecrease, hotkeyIncrease
    global guiEditDecrease, guiEditIncrease
    
    try {
        if (ih.EndReason = "EndKey" && captureEdit && IsObject(captureEdit)) {
            key := ih.EndKey
            
            ; Build modifier prefix by checking key states
            modifiers := ""
            if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
                modifiers .= "#"
            if GetKeyState("Ctrl", "P")
                modifiers .= "^"
            if GetKeyState("Alt", "P")
                modifiers .= "!"
            if GetKeyState("Shift", "P")
                modifiers .= "+"
            
            ; Combine modifiers with key
            newKey := modifiers . key
            
            ; Get current GUI values for dynamic validation
            otherKey := ""
            try {
                if (captureTarget = "dec" && IsObject(guiEditIncrease))
                    otherKey := ReadableToSymbol(guiEditIncrease.Value)
                else if (captureTarget = "inc" && IsObject(guiEditDecrease))
                    otherKey := ReadableToSymbol(guiEditDecrease.Value)
            }
            
            ; Validate: don't allow same key for both functions
            if (newKey = otherKey && otherKey != "") {
                ; Trying to set same key - ignore, restore original
                if (captureTarget = "dec")
                    captureEdit.Value := SymbolToReadable(hotkeyDecrease)
                else
                    captureEdit.Value := SymbolToReadable(hotkeyIncrease)
            } else {
                captureEdit.Value := SymbolToReadable(newKey)
            }
        } else if (captureEdit && IsObject(captureEdit)) {
            if (captureTarget = "dec")
                captureEdit.Value := SymbolToReadable(hotkeyDecrease)
            else
                captureEdit.Value := SymbolToReadable(hotkeyIncrease)
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

; Convert symbol format (#^Up) to readable format (Win+Ctrl+Up)
SymbolToReadable(hotkey) {
    if (hotkey = "")
        return ""
    
    readable := ""
    remaining := hotkey
    
    ; Check for modifier prefixes
    if (SubStr(remaining, 1, 1) = "#") {
        readable .= "Win+"
        remaining := SubStr(remaining, 2)
    }
    if (SubStr(remaining, 1, 1) = "^") {
        readable .= "Ctrl+"
        remaining := SubStr(remaining, 2)
    }
    if (SubStr(remaining, 1, 1) = "!") {
        readable .= "Alt+"
        remaining := SubStr(remaining, 2)
    }
    if (SubStr(remaining, 1, 1) = "+") {
        readable .= "Shift+"
        remaining := SubStr(remaining, 2)
    }
    
    ; Append the main key
    readable .= remaining
    return readable
}

; Convert readable format (Win+Ctrl+Up) to symbol format (#^Up)
ReadableToSymbol(readable) {
    if (readable = "")
        return ""
    
    symbol := ""
    remaining := readable
    
    ; Check for modifier names
    if (InStr(remaining, "Win+")) {
        symbol .= "#"
        remaining := StrReplace(remaining, "Win+", "")
    }
    if (InStr(remaining, "Ctrl+")) {
        symbol .= "^"
        remaining := StrReplace(remaining, "Ctrl+", "")
    }
    if (InStr(remaining, "Alt+")) {
        symbol .= "!"
        remaining := StrReplace(remaining, "Alt+", "")
    }
    if (InStr(remaining, "Shift+")) {
        symbol .= "+"
        remaining := StrReplace(remaining, "Shift+", "")
    }
    
    ; Append the main key
    symbol .= remaining
    return symbol
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
    global settingsGui, hotkeyDecrease, hotkeyIncrease, brightnessStep, monitorMode, animationEnabled, popupEnabled
    
    StopHotkeyCapture()
    saved := settingsGui.Submit()
    
    ; Convert readable format back to symbol format for storage
    hotkeyDecrease := ReadableToSymbol(saved.HotkeyDec)
    hotkeyIncrease := ReadableToSymbol(saved.HotkeyInc)
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
    popupEnabled := saved.PopupEnabled
    
    ; Validate startup mode - convert dropdown selection to integer
    startupModeVal := saved.StartupMode
    selectedStartupMode := 0
    if (startupModeVal = GetText("startup_disabled"))
        selectedStartupMode := 0
    else if (startupModeVal = GetText("startup_normal"))
        selectedStartupMode := 1
    else if (startupModeVal = GetText("startup_high"))
        selectedStartupMode := 2
    
    ; Detect current startup configuration
    currentStartupMode := DetectStartupMode()
    
    ; Check if high priority is involved (needs admin)
    if (selectedStartupMode = 2 || currentStartupMode = 2) {
        if (selectedStartupMode != currentStartupMode) {
            ; Show admin confirmation dialog only for AHK (EXE can run elevated automatically)
            if (!A_IsCompiled) {
                result := MsgBox(GetText("startup_admin_required"), "⚠️ " GetText("startup_mode"), 0x31)  ; OKCancel + Icon!
                if (result = "Cancel") {
                    ; User cancelled - keep current mode
                    startupMode := currentStartupMode
                    SaveConfig()
                    Reload()
                    return
                }
            }
            ; Apply with admin
            if (ApplyStartupMode(selectedStartupMode, currentStartupMode)) {
                startupMode := selectedStartupMode
            } else {
                ; Failed - keep current
                startupMode := currentStartupMode
            }
        } else {
            startupMode := selectedStartupMode
        }
    } else {
        ; No high priority involved - apply directly
        ApplyStartupMode(selectedStartupMode, currentStartupMode)
        startupMode := selectedStartupMode
    }
    
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
    global popupHwnd, popupVisible, popupTimeoutTimer, popupLastValue, popupEnabled
    global popupWidth, popupHeight, popupMarginBottom
    global animationEnabled, animStartTime, animStartY, animTargetY, animX, animActive, animClosing
    global animationDuration, animationStartOffset
    global popupBgColor, popupBgAlpha, barBgColor, barFillColor, iconColor
    
    ; Skip OSD if popup is disabled
    if (!popupEnabled)
        return
    
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
