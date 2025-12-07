# Teleprompter

A simple, transparent, always-on-top teleprompter application for macOS built with SwiftUI.

## Features

- **Overlay Mode**: Window stays on top of other applications.
- **Ghost Mode**: Makes the window fully transparent and click-through, allowing you to interact with windows behind the teleprompter while still reading the text.
- **Auto-Scroll**: Adjustable scrolling speed.
- **Customizable**: Adjust font size and opacity.
- **Global Hotkeys**: Control the teleprompter even when it's not the active window.

## Installation

### Build from Source

Requirements:

- macOS 12.0 or later
- Xcode 15 or later (for Swift 5.9 support)

1. Clone the repository:

   ```bash
   git clone <repository_url>
   cd teleprompter
   ```

2. Open the project in Xcode or build via command line:

   ```bash
   swift build -c release
   ```

3. Run the executable:
   ```bash
   .build/release/Teleprompter
   ```

## Usage

### Controls

Hover over the bottom of the teleprompter window to reveal the control panel:

- **Play/Pause**: Toggle auto-scrolling.
- **Reset**: Reset text to the beginning.
- **Speed**: Adjust scroll speed.
- **Size**: Adjust text font size.
- **Opacity**: Adjust background opacity.
- **Ghost Mode**: Toggle click-through transparency.
- **On Top**: Toggle "Always on Top" behavior.
- **Paste from Clipboard**: Quickly load text from your clipboard.

### Hotkeys

The application supports global hotkeys so you can control it while presenting:

- **Cmd + Option + S**: Toggle Auto-Scroll
- **Cmd + Option + G**: Toggle Ghost Mode

> **Note**: Accessibility permissions are required for global hotkeys to work. The app will prompt you to enable them in System Settings > Privacy & Security > Accessibility upon first launch.
