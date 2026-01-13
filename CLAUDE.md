# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Anois ("now" in Irish) is a native macOS menu bar app that displays a single-word focus reminder. Built with Swift and SwiftUI, targeting macOS 13+ (Ventura).

## Build & Run

```bash
# Open in Xcode
open Anois.xcodeproj

# Build from command line
xcodebuild -project Anois.xcodeproj -scheme Anois -configuration Debug build

# Run the built app
open build/Debug/Anois.app
```

## Architecture

### Core Pattern
- Menu bar-only app (no dock icon via `LSUIElement = YES`)
- Single `@AppStorage` string for persistence
- SwiftUI `MenuBarExtra` with `.menuBarExtraStyle(.window)` for popover behavior

### File Structure
```
Anois/
├── AnoisApp.swift        # @main entry, MenuBarExtra setup
├── PopoverView.swift     # Text field + save/cancel logic
├── Info.plist            # LSUIElement = YES
└── Assets.xcassets/
```

### Data Model
```swift
@AppStorage("currentFocus") var currentFocus: String = ""
```
Single string in UserDefaults. Display truncates to 20 characters with ellipsis.

## Key Implementation Details

- `MenuBarExtra` with `.window` style (not `.menu`) for popover dismiss support
- `@FocusState` for auto-focus on text field
- `onExitCommand` maps to Esc key for cancel
- `@Environment(\.dismiss)` closes the popover
- Empty/whitespace-only input shows placeholder "Focus?"

## Testing Checklist

- App does NOT appear in dock
- Menu bar shows current focus (or "Focus?" when empty)
- Click opens popover with focused text field
- Enter saves and closes
- Esc cancels and closes
- Focus persists across restarts
- Long text truncates with ellipsis in menu bar
