; ============================================================================
; Brightness Controller for Desktop
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

; ========================= CONFIGURATION =========================

; Brightness Control
minBrightness := 0
maxBrightness := 100
brightnessStep := 10          ; Change per key press
brightnessRampSpeed := 8      ; DDC/CI update speed (higher = faster)

; Hotkeys (leave empty "" to disable)
hotkeyDecrease := "F13"       ; Decrease brightness
hotkeyIncrease := "F14"       ; Increase brightness

; Popup Behavior
popupTimeout := 2000          ; Duration before popup closes (ms)

; Popup Appearance
popupWidth := 193
popupHeight := 50
popupRadius := 10
popupMarginBottom := 12       ; Distance above taskbar

; Animation
animationEnabled := true
animationDuration := 200      ; Open animation (ms)
animationCloseDuration := 200 ; Close animation (ms)
animationStartOffset := 60    ; Slide distance (pixels)

; Progress Bar
barWidth := 138
barHeight := 4
barRadius := 3
barMarginTop := 22
barMarginLeft := 38
barFillRadius := 3

; Sun Icon
showIcon := true
iconMarginLeft := 12
iconMarginTop := 17
sunCenterRadius := 3
sunRayLength := 2
sunRayGap := 2
sunRayThickness := 1.5
sunRayCount := 8

; Render Quality (higher = better anti-aliasing, more CPU)
renderScale := 4

; Key Repeat
repeatDelay := 400            ; Initial delay before repeat (ms)
repeatRate := 50              ; Repeat interval (ms)

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

themeColors := GetThemeColors()
popupBgColor := themeColors.popupBg
popupBgAlpha := themeColors.popupAlpha
barBgColor := themeColors.barBg
barFillColor := themeColors.barFill
iconColor := themeColors.icon

; ========================= INTERNAL STATE =========================

currentTarget := -1
currentValue := -1
rampTimer := 0
hPhys := 0
repeatTimer := 0
currentDirection := 0
pressStart := 0

popupHwnd := 0
popupVisible := false
popupTimeoutTimer := 0
popupLastValue := -1

animStartTime := 0
animStartY := 0
animTargetY := 0
animX := 0
animActive := false
animClosing := false

; ========================= INITIALIZATION =========================

try {
    Sleep(500)
    testHandle := GetFirstPhysicalMonitor()
    if (testHandle) {
        ToolTip("✓ Monitor detected!`n`n" hotkeyDecrease ": Decrease | " hotkeyIncrease ": Increase")
        SetTimer(() => ToolTip(), -3000)
    } else {
        ToolTip("⏳ Searching for DDC/CI monitor...")
        SetTimer(() => ToolTip(), -2000)
    }
} catch as err {
    MsgBox("Initialization error: " err.Message, "Error", 16)
}

; ========================= HOTKEY REGISTRATION =========================

if (hotkeyDecrease != "") {
    Hotkey("*" hotkeyDecrease, OnKeyDecrease)
    Hotkey("*" hotkeyDecrease " up", OnKeyUp)
}

if (hotkeyIncrease != "") {
    Hotkey("*" hotkeyIncrease, OnKeyIncrease)
    Hotkey("*" hotkeyIncrease " up", OnKeyUp)
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
    global currentTarget, currentValue, hPhys, rampTimer, brightnessRampSpeed
    global animActive
    
    if (animActive)
        return
    
    try {
        if (!hPhys)
            hPhys := GetFirstPhysicalMonitor()
        if (!hPhys) {
            SetTimer(BrightnessRamp, 0)
            rampTimer := 0
            return
        }
        if (currentValue < 0)
            currentValue := GetBrightness(hPhys)
        diff := currentTarget - currentValue
        if (diff = 0) {
            SetTimer(BrightnessRamp, 0)
            rampTimer := 0
            return
        }
        
        step := Min(brightnessRampSpeed, Abs(diff))
        currentValue += step * (diff > 0 ? 1 : -1)
        SetBrightness(hPhys, currentValue)
    } catch {
        SetTimer(BrightnessRamp, 0)
        rampTimer := 0
    }
}

; ========================= DDC/CI API =========================

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
    global hPhys
    if (!hPhys)
        hPhys := GetFirstPhysicalMonitor()
    return hPhys ? GetBrightness(hPhys) : 50
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

pToken := 0
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
