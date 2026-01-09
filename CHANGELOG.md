# Changelog

All notable changes to Brightness Controller for Desktop.

## [2.0.0] - 2026-01-09

### Major Release - Complete Rewrite

A major update with a completely rewritten codebase and many new features.

### New Features

- **Settings GUI** - Full graphical settings interface accessible from system tray
- **Multi-Monitor Support**
  - All monitors mode
  - Cursor position mode (adjusts only the monitor where mouse is located)
  - Specific monitor selection by index
  - Real monitor names from Windows (e.g., "XG2405")
- **External Configuration** - Settings saved to `config.ini` file
- **Multi-Language Support** - 5 languages:
  - English
  - Türkçe
  - Русский
  - 中文
  - 日本語
- **F-Key Sender Tool** - Built-in utility to send F13-F24 virtual keys for hotkey capture
- **Hotkey Capture** - Click "Capture" and press any key to assign hotkeys
- **Setup Installer** - One-click installation:
  - Auto-copy to Program Files
  - Optional Windows startup shortcut
  - Custom icon application
- **Custom System Tray Icon** - Sun icon
- **Restore Defaults** - One-click reset to factory settings
- **Undo** - Revert unsaved changes
- **Open Config Folder** - Quick access to configuration file

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
