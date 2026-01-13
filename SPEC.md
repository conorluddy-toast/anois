# Anois — Spec v1

> A single-word focus reminder that lives in your macOS menu bar. ("Anois" is Irish for "now")

## Goal

Help you stay focused by showing one thing—the task you're working on right now—always visible in your menu bar. Nothing more.

## User Experience

### Menu Bar Display

- Shows a short text label (your current focus)
- Truncates to **20 characters** max (with ellipsis if needed)
- Empty state: `Focus?` or `—`

### Interaction

| Action | Result |
|--------|--------|
| Click menu bar item | Opens popover with text field |
| Type + Enter | Saves focus, closes popover |
| Esc | Cancels edit, closes popover |
| Click outside popover | Cancels edit, closes popover |

### Popover UI

- Single-line text field
- Pre-filled with current focus (selected for easy replacement)
- Minimal chrome—just the input

## Technical Requirements

### Platform

- macOS 13+ (Ventura)
- SwiftUI with `MenuBarExtra`

### App Behavior

- **Menu bar only** — no dock icon (`LSUIElement = YES`)
- Launch and it's just there
- No main window

### Data Model

```swift
@AppStorage("currentFocus") var currentFocus: String = ""
```

That's the entire model. One string in UserDefaults.

### Truncation Rules

- Display: max 20 characters, append `…` if longer
- Storage: full string (no limit, but UI naturally discourages novels)
- Trim whitespace before saving
- Empty/whitespace-only → treat as cleared

## File Structure

```
Anois/
├── AnoisApp.swift        # @main entry, MenuBarExtra setup
├── PopoverView.swift     # Text field + save/cancel logic
├── Info.plist            # LSUIElement = YES
└── Assets.xcassets/      # App icon (optional for menu bar-only)
```

## Implementation Notes

### AnoisApp.swift

- Use `MenuBarExtra` with `label:` showing the truncated focus text
- Use `.menuBarExtraStyle(.window)` to get popover behavior

### PopoverView.swift

- `@AppStorage` to read/write the focus
- `@State` for the draft text while editing
- `@FocusState` to auto-focus the text field
- `onSubmit` → save and dismiss
- `onExitCommand` → cancel and dismiss

### Info.plist

```xml
<key>LSUIElement</key>
<true/>
```

This hides the app from the dock.

## Acceptance Criteria

- [ ] App appears only in menu bar (no dock icon)
- [ ] Menu bar shows current focus text, truncated appropriately
- [ ] Empty state shows placeholder text
- [ ] Click opens popover with editable text field
- [ ] Text field is focused and selected on open
- [ ] Enter saves and closes
- [ ] Esc cancels and closes
- [ ] Focus persists across app restarts
- [ ] Whitespace-only input treated as empty

## Out of Scope (v1)

- Global hotkey
- History/recent items
- Timer/pomodoro
- Settings UI
- iCloud sync
- Launch at login toggle (user can set this in System Settings)

## Future Considerations (v2+)

If this proves useful, potential additions:

- Global hotkey to open editor
- Last 5-10 items for quick re-select
- Keyboard shortcut to clear
- Optional emoji prefix toggle
