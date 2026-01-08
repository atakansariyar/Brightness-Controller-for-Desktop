# Brightness Controller for Desktop

Control your external monitor's brightness using DDC/CI with a beautiful Windows 11 style on-screen display (OSD).

![Demo](demo.gif)

## Why This Project?

I created this tool after discovering that the brightness keys on my **Logitech MX Keys S** keyboard don't work with external monitors. Windows only allows native brightness control for laptop displays, leaving external monitor users without a convenient solution.

This application bridges that gap by using DDC/CI protocol to communicate directly with your monitor, while providing a beautiful Windows 11-style on-screen display.

### Getting the Best Experience

**Keyboards with macro support** (like Logitech, Razer, Corsair, etc.) will provide the smoothest experience. Here's how to set it up:

1. Open your keyboard's software (e.g., **Logi Options+**, Razer Synapse, iCUE)
2. Find the non-functional brightness keys or any key you want to remap
3. Go to the macro/key assignment settings
4. While in "key listening" mode, use [**F-Key Sender**](https://github.com/ThioJoe/F-Key-Sender) to send F13-F24 keys
5. Assign F13 for brightness down and F14 for brightness up

### Why F13-F24?

I recommend using **F13 and above** because these keys are unused in virtually all applications. This means you won't accidentally trigger any shortcuts while adjusting your brightness.

## Features

- 🌞 **DDC/CI Support** - Works with external monitors that support DDC/CI protocol
- 🎨 **Windows 11 Style OSD** - Clean, modern popup with rounded corners and smooth animations
- 🌗 **Auto Theme Detection** - Automatically switches between light and dark themes
- ⌨️ **Customizable Hotkeys** - Configure any key combination
- 🚀 **Smooth Animations** - Hardware-accelerated slide animations with DWM sync
- 🔧 **Highly Configurable** - Customize popup size, colors, animation speed, and more

## Requirements

- **Windows 10/11**
- **AutoHotkey v2.0** - [Download here](https://www.autohotkey.com/) *(not needed if using pre-compiled EXE)*
- **DDC/CI compatible monitor** - Most external monitors support this (check your monitor's OSD settings)

### For F13-F24 Keys

If your keyboard doesn't have F13-F24 keys, you can use **F-Key Sender** to remap other keys:
- [F-Key Sender by ThioJoe](https://github.com/ThioJoe/F-Key-Sender)

## Installation

### Method 1: Download Pre-compiled EXE (Easiest)

1. Download `brightness_control.exe` from this repository
2. Double-click to run - **no installation required!**

### Method 2: Run as Script

1. Install [AutoHotkey v2.0](https://www.autohotkey.com/)
2. Download `brightness_control.ahk`
3. Double-click to run

### Method 3: Compile to EXE Yourself

**Quick way:** Right-click `brightness_control.ahk` → **Compile Script** *(may not work on some systems)*

**Using Ahk2Exe GUI (recommended):**

1. Open Start Menu, search **Ahk2Exe**
2. Set these options:
   - **Source:** Select `brightness_control.ahk`
   - **Destination:** Choose where to save the `.exe`
   - **Base File:** Select `AutoHotkey64.exe` (for 64-bit) or leave as default
3. Click **Convert**

## Auto-Start on Windows Boot

### Using Startup Folder (Recommended)

1. Press `Win + R`
2. Type `shell:startup` and press Enter
3. Create a shortcut to `brightness_control.ahk` (or `.exe`) in this folder

### Using Task Scheduler

1. Open Task Scheduler
2. Create Basic Task → Set trigger to "At startup"
3. Set action to start the script/exe

## Configuration

Edit the script file to customize:

```autohotkey
; Hotkeys (leave empty "" to disable)
hotkeyDecrease := "F13"       ; Decrease brightness
hotkeyIncrease := "F14"       ; Increase brightness

; Brightness Control
brightnessStep := 10          ; Change per key press (1-100)

; Popup Behavior
popupTimeout := 2000          ; Duration before popup closes (ms)

; Animation
animationEnabled := true
animationDuration := 200      ; Open animation (ms)
```

### Hotkey Examples

| Keys | Value |
|------|-------|
| F13 | `"F13"` |
| Ctrl + Minus | `"^-"` |
| Ctrl + Plus | `"^="` |
| Win + Up | `"#Up"` |
| Alt + F1 | `"!F1"` |

## Troubleshooting

### Monitor Not Detected

1. **Enable DDC/CI** in your monitor's OSD settings
2. Make sure you're using a **direct cable connection** (not through a KVM or dock)
3. Try a different cable (DisplayPort and HDMI both support DDC/CI)

### Brightness Not Changing

- Some monitor brands have limited DDC/CI support
- Try updating your graphics drivers
- Check if other DDC/CI tools work (e.g., ControlMyMonitor, Monitorian)

## Technical Details

- Uses Windows DDC/CI API via `Dxva2.dll`
- GDI+ for anti-aliased rendering with 4x supersampling
- Layered windows with per-pixel alpha for smooth rounded corners
- QueryPerformanceCounter for precise animation timing
- DwmFlush for VSync synchronization

## License

MIT License - See [LICENSE](LICENSE) file

## Credits

- Built with [AutoHotkey v2](https://www.autohotkey.com/)
- Inspired by Windows 11 volume/brightness OSD
