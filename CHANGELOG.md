# Changelog

All notable changes to Brightness Controller for Desktop.

## [2.1.0] - 2026-01-10

### New Features

- Quick Brightness Popup - Double-click tray icon to open modern slider popup
  - Drag or scroll to adjust brightness
- Multi-Key Hotkey Capture - Support for modifier key combinations
  - Capture Ctrl+Alt+Key, Win+Shift+Key, etc.
- Localized Tray Menu - System tray menu translates to selected language
- Reload Config with Validation - Shows error message if config.ini has issues
- Standalone Setup Installer - `setup.exe` no longer requires AutoHotkey to install
- High Priority Startup - Task Scheduler option to start before other apps
- Startup Mode in Settings - View and validate startup configuration directly from Settings
- OSD Popup Toggle - Option to disable Windows 11 style popup in settings
- Uninstaller - `uninstall.exe` or `uninstall.ahk` (requires AutoHotkey) to cleanly remove the application

---

## [2.0.0] - 2026-01-09

### Major Release - Complete Rewrite

A major update with a completely rewritten codebase and many new features.

### New Features

- Settings GUI - Full graphical settings interface accessible from system tray
- Multi-Monitor Support
  - All monitors mode
  - Cursor position mode (adjusts only the monitor where mouse is located)
  - Specific monitor selection by index
  - Real monitor names from Windows (e.g., "XG2405")
- External Configuration - Settings saved to `config.ini` file
- Multi-Language Support - 5 languages: English, Türkçe, Русский, 中文, 日本語
- F-Key Sender Tool - Built-in utility to send F13-F24 virtual keys for hotkey capture
- Hotkey Capture - Click "Capture" and press any key to assign hotkeys
- Setup Installer - One-click installation with startup shortcut option
- Custom System Tray Icon - Sun icon for easy identification
- Restore Defaults / Undo / Open Config Folder buttons

### New Files

- `setup.ahk` - Installation script
- `brightness_icon.ico` - Custom tray icon
- `config.ini` - Configuration file (auto-generated)

---

## [1.0.0] - Initial Release

### Features
- Basic brightness control via DDC/CI
- Windows 11 style animated OSD popup
- Configurable hotkeys (F13/F14 default)
- Smooth brightness ramping
- Light/Dark theme detection
