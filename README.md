# <img src="assets/brightness_icon.png" width="32" height="32"> Brightness Controller for Desktop

Control your external monitor's brightness using keyboard shortcuts with a Windows 11-style OSD.

![Demo](assets/demo.gif)

## Features

- DDC/CI brightness control for external monitors
- Windows 11 style animated OSD popup
- Multi-monitor support (all / cursor position / specific monitor)
- Customizable hotkeys via Settings GUI
- F-Key Sender Tool for keyboard macro integration
- Multi-language: English, Türkçe, Русский, 中文, 日本語
- System tray integration

## Requirements

- Windows 10/11
- External monitor with DDC/CI support
- AutoHotkey v2.0 (only for .ahk version)

## Installation

### Using Setup
1. Run `setup.ahk` as administrator
2. Choose installation type (AHK or EXE)
3. Choose whether to add to Windows startup

**Recommendation:** Use the EXE version for convenience. If you prefer customization, you can create your own EXE by deleting the included `brightness_control.exe` and compiling the `brightness_control.ahk` file yourself.

### Manual
1. Copy files to your preferred location
2. Run `brightness_control.exe` (or `.ahk` with AutoHotkey)

## Hotkey Configuration

Open **Settings** from the system tray to configure hotkeys:

![Settings](assets/settings.png)

1. Click the **Capture** button next to any hotkey field
2. Press your desired key
3. The key is assigned immediately
4. Click **Save** to apply and restart

## F-Key Sender Tool

This utility helps you assign virtual F13-F24 keys as brightness hotkeys when using keyboard macro software (like Logi Options+, Razer Synapse, etc.).

![F-Key Sender Tool](assets/f-key_tool.png)

**Use cases:**
- Assign F13-F24 as brightness hotkeys in this app
- Configure keyboard software buttons to send F13-F24 (use this tool to verify the key is being sent)

**How it works:**
1. Configure your keyboard software to send F13-F24 on a button
2. Open Settings → F-Key Sender Tool
3. Click **Capture** in Settings for the hotkey you want to assign
4. Use F-Key Sender to send the key so you can capture it
5. The virtual key is now assigned as your brightness hotkey

## Creating Your Own EXE

If you want to customize the script and create your own compiled version:

1. Install [AutoHotkey v2.0](https://www.autohotkey.com/)
2. Make your modifications to `brightness_control.ahk`
3. Right-click the .ahk file → **Compile Script**
   - Alternatively: Start menu → AutoHotkey → **Ahk2Exe**
4. Select your .ahk file as source
5. Optionally set a custom icon (.ico file)
6. Click **Convert**
7. Delete the old EXE and use your new compiled version

## Files

| File | Description |
|------|-------------|
| `brightness_control.exe` | Main application (compiled) |
| `brightness_control.ahk` | Main application (source) |
| `setup.ahk` | Installer script |
| `assets/` | Icons and media files |
| `config.ini` | Configuration (auto-generated) |

## Troubleshooting

**Monitor not detected?**
- Enable DDC/CI in your monitor's OSD menu
- Reconnect monitor cable

**Hotkeys not working?**
- Check for conflicting applications
- Run as administrator

## License

MIT License

## Credits

Developed by [@atakansariyar](https://github.com/atakansariyar)
