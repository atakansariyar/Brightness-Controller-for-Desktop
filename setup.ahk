; ============================================================================
; Brightness Controller - Setup Installer
; Copies files to Program Files and optionally creates startup shortcut
; ============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; Configuration
global appName := "Brightness Controller"
global installDir := "C:\Program Files\" appName
global sourceDir := A_ScriptDir
global ahkName := "brightness_control.ahk"
global exeName := "brightness_control.exe"
global iconName := "assets\\brightness_icon.ico"
global assetsFolder := "assets"
global configName := "config.ini"

; Localization
global setupLang := Map()
setupLang["en"] := Map(
    "title", "Brightness Controller - Setup",
    "welcome", "Welcome to Brightness Controller Setup",
    "install_to", "Files will be installed to:",
    "install_type", "Installation Type:",
    "ahk_script", "AHK Script (requires AutoHotkey)",
    "exe_compiled", "EXE Compiled (standalone)",
    "startup_options", "Startup Options:",
    "no_startup", "Do not add to startup",
    "normal_startup", "Normal startup",
    "high_startup", "High priority startup (starts before other apps)",
    "install", "Install",
    "cancel", "Cancel",
    "ahk_note", "Note: AutoHotkey v2.0 must be installed to run .ahk files.",
    "success", "Installation complete!",
    "launch_now", "Launch now?",
    "error_not_found", "not found in",
    "error_create_dir", "Failed to create installation directory.",
    "error_copy", "Failed to copy files:",
    "error_shortcut", "Failed to create startup shortcut:",
    "error_task", "Failed to create scheduled task:"
)
setupLang["tr"] := Map(
    "title", "Parlaklık Denetleyicisi - Kurulum",
    "welcome", "Parlaklık Denetleyicisi Kurulumuna Hoş Geldiniz",
    "install_to", "Dosyalar şuraya kurulacak:",
    "install_type", "Kurulum Tipi:",
    "ahk_script", "AHK Script (AutoHotkey gerekli)",
    "exe_compiled", "EXE Derlenmiş (bağımsız)",
    "startup_options", "Başlangıç Seçenekleri:",
    "no_startup", "Başlangıca ekleme",
    "normal_startup", "Normal başlangıç",
    "high_startup", "Yüksek öncelikli başlangıç (diğer uygulamalardan önce başlar)",
    "install", "Kur",
    "cancel", "İptal",
    "ahk_note", "Not: .ahk dosyalarını çalıştırmak için AutoHotkey v2.0 kurulu olmalı.",
    "success", "Kurulum tamamlandı!",
    "launch_now", "Şimdi başlatılsın mı?",
    "error_not_found", "bulunamadı:",
    "error_create_dir", "Kurulum dizini oluşturulamadı.",
    "error_copy", "Dosyalar kopyalanamadı:",
    "error_shortcut", "Başlangıç kısayolu oluşturulamadı:",
    "error_task", "Zamanlanmış görev oluşturulamadı:"
)
setupLang["ru"] := Map(
    "title", "Контроллер яркости - Установка",
    "welcome", "Добро пожаловать в установку",
    "install_to", "Файлы будут установлены в:",
    "install_type", "Тип установки:",
    "ahk_script", "AHK Скрипт (требуется AutoHotkey)",
    "exe_compiled", "EXE Скомпилированный (автономный)",
    "startup_options", "Параметры запуска:",
    "no_startup", "Не добавлять в автозагрузку",
    "normal_startup", "Обычный запуск",
    "high_startup", "Высокий приоритет (запуск до других приложений)",
    "install", "Установить",
    "cancel", "Отмена",
    "ahk_note", "Примечание: для запуска .ahk требуется AutoHotkey v2.0.",
    "success", "Установка завершена!",
    "launch_now", "Запустить сейчас?",
    "error_not_found", "не найден в",
    "error_create_dir", "Не удалось создать каталог.",
    "error_copy", "Не удалось скопировать файлы:",
    "error_shortcut", "Не удалось создать ярлык:",
    "error_task", "Не удалось создать задачу:"
)
setupLang["zh"] := Map(
    "title", "亮度控制器 - 安装",
    "welcome", "欢迎使用亮度控制器安装程序",
    "install_to", "文件将安装到:",
    "install_type", "安装类型:",
    "ahk_script", "AHK脚本 (需要AutoHotkey)",
    "exe_compiled", "EXE编译版 (独立运行)",
    "startup_options", "启动选项:",
    "no_startup", "不添加到启动",
    "normal_startup", "正常启动",
    "high_startup", "高优先级启动 (在其他应用之前启动)",
    "install", "安装",
    "cancel", "取消",
    "ahk_note", "注意: 运行.ahk文件需要安装AutoHotkey v2.0。",
    "success", "安装完成!",
    "launch_now", "现在启动?",
    "error_not_found", "未找到于",
    "error_create_dir", "无法创建安装目录。",
    "error_copy", "无法复制文件:",
    "error_shortcut", "无法创建启动快捷方式:",
    "error_task", "无法创建计划任务:"
)
setupLang["ja"] := Map(
    "title", "明るさコントローラー - セットアップ",
    "welcome", "明るさコントローラーへようこそ",
    "install_to", "インストール先:",
    "install_type", "インストールタイプ:",
    "ahk_script", "AHKスクリプト (AutoHotkey必要)",
    "exe_compiled", "EXEコンパイル版 (スタンドアロン)",
    "startup_options", "起動オプション:",
    "no_startup", "スタートアップに追加しない",
    "normal_startup", "通常起動",
    "high_startup", "高優先度起動 (他のアプリより先に起動)",
    "install", "インストール",
    "cancel", "キャンセル",
    "ahk_note", "注意: .ahkファイルを実行するにはAutoHotkey v2.0が必要です。",
    "success", "インストール完了!",
    "launch_now", "今すぐ起動しますか?",
    "error_not_found", "は見つかりません:",
    "error_create_dir", "インストールディレクトリを作成できませんでした。",
    "error_copy", "ファイルをコピーできませんでした:",
    "error_shortcut", "ショートカットを作成できませんでした:",
    "error_task", "タスクを作成できませんでした:"
)

global currentLang := "en"
GetSetupText(key) {
    global setupLang, currentLang
    if (setupLang.Has(currentLang) && setupLang[currentLang].Has(key))
        return setupLang[currentLang][key]
    return setupLang["en"][key]
}

; Run as admin if needed
if (!A_IsAdmin) {
    try {
        Run('*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"')
        ExitApp
    } catch {
        MsgBox("This installer requires administrator privileges.", "Error", "Icon!")
        ExitApp
    }
}

; Main installer GUI
global installerGui, rbNoStartup, rbNormalStartup, rbHighStartup, rbAhk, rbExe, ddLang, noteText

installerGui := Gui("+AlwaysOnTop", GetSetupText("title"))
installerGui.SetFont("s10", "Segoe UI")

; Language selection at top
installerGui.AddText("xm", "Language:")
langChoices := ["English", "Türkçe", "Русский", "中文", "日本語"]
ddLang := installerGui.AddDropDownList("x+10 w120 Choose1", langChoices)
ddLang.OnEvent("Change", OnSetupLangChange)

installerGui.AddText("xm y+20", GetSetupText("welcome"))
installerGui.AddText("xm y+10 cGray", GetSetupText("install_to"))
installerGui.AddText("xm y+5", installDir)

; Install type selection
installerGui.AddText("xm y+20", GetSetupText("install_type"))
rbAhk := installerGui.AddRadio("xm y+5 Checked", GetSetupText("ahk_script"))
rbExe := installerGui.AddRadio("xm y+5", GetSetupText("exe_compiled"))
noteText := installerGui.AddText("xm y+5 cGray w300", GetSetupText("ahk_note"))

; Startup options as radio buttons (separate group)
installerGui.AddText("xm y+20", GetSetupText("startup_options"))
rbNoStartup := installerGui.AddRadio("xm y+5 Group", GetSetupText("no_startup"))
rbNormalStartup := installerGui.AddRadio("xm y+5", GetSetupText("normal_startup"))
rbHighStartup := installerGui.AddRadio("xm y+5 Checked", GetSetupText("high_startup"))

; Centered buttons - content width 300px, 2 buttons (120px each) + 1 gap (20px) = 260px
; Left offset = (300 - 260) / 2 = 20px from xm
installerGui.AddButton("w120 y+30 xm+20", GetSetupText("install")).OnEvent("Click", DoInstall)
installerGui.AddButton("x+20 w120", GetSetupText("cancel")).OnEvent("Click", (*) => ExitApp())

installerGui.Show()
return

OnSetupLangChange(*) {
    global currentLang, installerGui, ddLang
    langCodes := ["en", "tr", "ru", "zh", "ja"]
    currentLang := langCodes[ddLang.Value]
    installerGui.Destroy()
    ShowSetupGui()
}

ShowSetupGui() {
    global installerGui, cbStartup, rbAhk, rbExe, ddLang, noteText, currentLang
    
    langIdx := 1
    langCodes := ["en", "tr", "ru", "zh", "ja"]
    for i, code in langCodes {
        if (code = currentLang)
            langIdx := i
    }
    
    installerGui := Gui("+AlwaysOnTop", GetSetupText("title"))
    installerGui.SetFont("s10", "Segoe UI")
    
    installerGui.AddText("xm", "Language:")
    langChoices := ["English", "Türkçe", "Русский", "中文", "日本語"]
    ddLang := installerGui.AddDropDownList("x+10 w120 Choose" langIdx, langChoices)
    ddLang.OnEvent("Change", OnSetupLangChange)
    
    installerGui.AddText("xm y+20", GetSetupText("welcome"))
    installerGui.AddText("xm y+10 cGray", GetSetupText("install_to"))
    installerGui.AddText("xm y+5", installDir)
    
    installerGui.AddText("xm y+20", GetSetupText("install_type"))
    rbAhk := installerGui.AddRadio("xm y+5 Checked", GetSetupText("ahk_script"))
    rbExe := installerGui.AddRadio("xm y+5", GetSetupText("exe_compiled"))
    noteText := installerGui.AddText("xm y+5 cGray w300", GetSetupText("ahk_note"))
    
    ; Startup options as radio buttons (separate group)
    installerGui.AddText("xm y+20", GetSetupText("startup_options"))
    rbNoStartup := installerGui.AddRadio("xm y+5 Group", GetSetupText("no_startup"))
    rbNormalStartup := installerGui.AddRadio("xm y+5", GetSetupText("normal_startup"))
    rbHighStartup := installerGui.AddRadio("xm y+5 Checked", GetSetupText("high_startup"))
    
    ; Centered buttons - content width 300px, 2 buttons (120px each) + 1 gap (20px) = 260px
    ; Left offset = (300 - 260) / 2 = 20px from xm
    installerGui.AddButton("w120 y+30 xm+20", GetSetupText("install")).OnEvent("Click", DoInstall)
    installerGui.AddButton("x+20 w120", GetSetupText("cancel")).OnEvent("Click", (*) => ExitApp())
    
    installerGui.Show()
}

DoInstall(*) {
    global installerGui, installDir, sourceDir, ahkName, exeName, iconName, configName
    global rbNoStartup, rbNormalStartup, rbHighStartup, rbAhk
    
    installerGui.Hide()
    
    ; Determine which file to install
    useAhk := rbAhk.Value
    targetName := useAhk ? ahkName : exeName
    sourcePath := sourceDir "\" targetName
    
    if (!FileExist(sourcePath)) {
        MsgBox(targetName " " GetSetupText("error_not_found") " " sourceDir, "Error", "Icon!")
        ExitApp
    }
    
    ; Create install directory
    if (!DirExist(installDir)) {
        try {
            DirCreate(installDir)
        } catch {
            MsgBox(GetSetupText("error_create_dir"), "Error", "Icon!")
            ExitApp
        }
    }
    
    ; Terminate running instance if exists
    try {
        if (!useAhk) {
            ; Kill EXE process if running
            RunWait('taskkill /F /IM brightness_control.exe',, "Hide")
            Sleep(500)
        }
    }
    
    ; Copy files
    try {
        FileCopy(sourcePath, installDir "\" targetName, true)
        
        ; Create assets folder in install directory
        assetsInstallDir := installDir "\assets"
        if (!DirExist(assetsInstallDir))
            DirCreate(assetsInstallDir)
        
        ; Copy assets folder contents if exists
        assetsSrcDir := sourceDir "\assets"
        if (DirExist(assetsSrcDir)) {
            ; Copy all files from assets folder
            Loop Files, assetsSrcDir "\*.*" {
                try FileCopy(A_LoopFileFullPath, assetsInstallDir "\" A_LoopFileName, true)
            }
        }
        
        ; Handle config: merge existing values with new features or create fresh
        installConfigPath := installDir "\" configName
        if (FileExist(installConfigPath)) {
            ; Merge: read existing values and recreate with new features
            MergeConfig(installConfigPath, currentLang)
        } else {
            ; Create new config with selected language
            CreateDefaultConfig(installConfigPath, currentLang)
        }
        
        ; Copy utility files if they exist (uninstall, ps1 scripts, docs)
        utilityFiles := ["uninstall.exe", "uninstall.ahk", "install_startup_task.ps1", "make_normal_startup.ps1", "uninstall_startup_task.ps1", "README.md", "README_TR.md", "CHANGELOG.md", "CHANGELOG_TR.md"]
        for utilFile in utilityFiles {
            utilPath := sourceDir "\" utilFile
            if (FileExist(utilPath))
                try FileCopy(utilPath, installDir "\" utilFile, true)
        }
    } catch as e {
        MsgBox(GetSetupText("error_copy") " " e.Message, "Error", "Icon!")
        ExitApp
    }
    
    ; Create startup based on selection
    targetPath := installDir "\" targetName
    
    if (rbHighStartup.Value) {
        ; High priority: Use Task Scheduler (starts before other apps)
        try {
            taskName := "BrightnessController"
            
            ; Remove old startup shortcut if exists
            startupShortcut := A_Startup "\Brightness Controller.lnk"
            if (FileExist(startupShortcut))
                FileDelete(startupShortcut)
            
            ; Remove existing task if exists
            RunWait('schtasks /Delete /TN "' taskName '" /F',, "Hide")
            
            ; Create scheduled task - use cmd /c to handle quotes properly
            if (useAhk) {
                cmdLine := '\"' A_AhkPath '\" \"' targetPath '\"'
            } else {
                cmdLine := '\"' targetPath '\"'
            }
            
            result := RunWait('schtasks /Create /TN "' taskName '" /TR "' cmdLine '" /SC ONLOGON /RL HIGHEST /F')
        } catch as e {
            MsgBox(GetSetupText("error_task") " " e.Message, "Warning", "Icon!")
        }
    } else if (rbNormalStartup.Value) {
        ; Normal priority: Use startup folder shortcut
        startupFolder := A_Startup
        shortcutPath := startupFolder "\Brightness Controller.lnk"
        iconPath := installDir "\assets\brightness_icon.ico"
        
        ; Remove scheduled task if exists (switching from high to normal)
        try {
            RunWait('schtasks /Delete /TN "BrightnessController" /F',, "Hide")
        }
        
        try {
            shell := ComObject("WScript.Shell")
            shortcut := shell.CreateShortcut(shortcutPath)
            
            if (useAhk) {
                shortcut.TargetPath := A_AhkPath
                shortcut.Arguments := '"' targetPath '"'
            } else {
                shortcut.TargetPath := targetPath
            }
            
            shortcut.WorkingDirectory := installDir
            shortcut.Description := "Brightness Controller for Desktop"
            if (FileExist(iconPath))
                shortcut.IconLocation := iconPath
            shortcut.Save()
        } catch as e {
            MsgBox(GetSetupText("error_shortcut") " " e.Message, "Warning", "Icon!")
        }
    } else {
        ; No startup selected - clean up any existing startup methods
        try {
            startupShortcut := A_Startup "\Brightness Controller.lnk"
            if (FileExist(startupShortcut))
                FileDelete(startupShortcut)
            RunWait('schtasks /Delete /TN "BrightnessController" /F',, "Hide")
        }
    }
    
    ; Launch application
    targetPath := installDir "\" targetName
    if (useAhk) {
        Run('"' A_AhkPath '" "' targetPath '"', installDir)
    } else {
        Run('"' targetPath '"', installDir)
    }
    
    MsgBox(GetSetupText("success"), appName, "Iconi")
    ExitApp
}

; Create default config.ini with selected language
CreateDefaultConfig(configPath, lang) {
    configContent := "[Hotkeys]`n"
    configContent .= "hotkeyDecrease=F13`n"
    configContent .= "hotkeyIncrease=F14`n`n"
    configContent .= "[Brightness]`n"
    configContent .= "brightnessStep=10`n"
    configContent .= "brightnessRampSpeed=8`n`n"
    configContent .= "[Monitor]`n"
    configContent .= "monitorMode=all`n`n"
    configContent .= "[Popup]`n"
    configContent .= "popupTimeout=2000`n"
    configContent .= "popupEnabled=true`n`n"
    configContent .= "[Animation]`n"
    configContent .= "animationEnabled=true`n`n"
    configContent .= "[General]`n"
    configContent .= "language=" lang "`n"
    
    try {
        FileAppend(configContent, configPath)
    }
}

; Merge existing config with new features (preserves user values, adds missing keys)
MergeConfig(configPath, defaultLang) {
    ; Read existing values with defaults for missing keys
    hotkeyDec := IniRead(configPath, "Hotkeys", "hotkeyDecrease", "F13")
    hotkeyInc := IniRead(configPath, "Hotkeys", "hotkeyIncrease", "F14")
    brightStep := IniRead(configPath, "Brightness", "brightnessStep", "10")
    brightRamp := IniRead(configPath, "Brightness", "brightnessRampSpeed", "8")
    monMode := IniRead(configPath, "Monitor", "monitorMode", "all")
    popupTime := IniRead(configPath, "Popup", "popupTimeout", "2000")
    popupOn := IniRead(configPath, "Popup", "popupEnabled", "true")
    animOn := IniRead(configPath, "Animation", "animationEnabled", "true")
    lang := IniRead(configPath, "General", "language", defaultLang)
    
    ; Delete old file and create new with all values
    try FileDelete(configPath)
    
    configContent := "[Hotkeys]`n"
    configContent .= "hotkeyDecrease=" hotkeyDec "`n"
    configContent .= "hotkeyIncrease=" hotkeyInc "`n`n"
    configContent .= "[Brightness]`n"
    configContent .= "brightnessStep=" brightStep "`n"
    configContent .= "brightnessRampSpeed=" brightRamp "`n`n"
    configContent .= "[Monitor]`n"
    configContent .= "monitorMode=" monMode "`n`n"
    configContent .= "[Popup]`n"
    configContent .= "popupTimeout=" popupTime "`n"
    configContent .= "popupEnabled=" popupOn "`n`n"
    configContent .= "[Animation]`n"
    configContent .= "animationEnabled=" animOn "`n`n"
    configContent .= "[General]`n"
    configContent .= "language=" lang "`n"
    
    try {
        FileAppend(configContent, configPath)
    }
}
