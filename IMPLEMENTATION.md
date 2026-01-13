# Anois — Implementation Guide

Starter code and patterns for building Anois.

## Project Setup

1. Xcode → New Project → **App** (macOS)
2. Product Name: `Anois`
3. Interface: **SwiftUI**
4. Language: **Swift**
5. Uncheck: Include Tests (not needed for MVP)

### Configure as Menu Bar App

In `Info.plist`, add:

```xml
<key>LSUIElement</key>
<true/>
```

Or in Xcode: Add row → "Application is agent (UIElement)" → YES

## Code Skeletons

### AnoisApp.swift

```swift
import SwiftUI

@main
struct AnoisApp: App {
    @AppStorage("currentFocus") private var currentFocus: String = ""
    
    var body: some Scene {
        MenuBarExtra {
            PopoverView()
        } label: {
            Text(menuBarLabel)
        }
        .menuBarExtraStyle(.window)
    }
    
    private var menuBarLabel: String {
        let trimmed = currentFocus.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "Focus?"
        }
        return trimmed.truncated(to: 20)
    }
}

// MARK: - String Extension

extension String {
    func truncated(to limit: Int) -> String {
        if count <= limit {
            return self
        }
        return String(prefix(limit - 1)) + "…"
    }
}
```

### PopoverView.swift

```swift
import SwiftUI

struct PopoverView: View {
    @AppStorage("currentFocus") private var currentFocus: String = ""
    @State private var draft: String = ""
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TextField("What's your focus?", text: $draft)
            .textFieldStyle(.plain)
            .font(.system(size: 14))
            .focused($isFocused)
            .onSubmit(save)
            .onExitCommand(cancel)
            .onAppear {
                draft = currentFocus
                isFocused = true
            }
            .padding()
            .frame(width: 240)
    }
    
    private func save() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        currentFocus = trimmed
        dismiss()
    }
    
    private func cancel() {
        dismiss()
    }
}
```

## Key Implementation Details

### MenuBarExtra Styles

```swift
.menuBarExtraStyle(.window)  // ← Use this: gives you a popover
.menuBarExtraStyle(.menu)    // Traditional dropdown menu (not what we want)
```

### Dismiss Behavior

`@Environment(\.dismiss)` works within MenuBarExtra's window style to close the popover.

### Focus State

`@FocusState` + `.focused()` ensures the text field is ready to type immediately when the popover opens.

### onExitCommand

Maps to the Esc key in SwiftUI on macOS. Perfect for cancel behavior.

## Testing Checklist

```
□ Build and run
□ App does NOT appear in dock
□ Menu bar shows "Focus?"
□ Click → popover opens
□ Type "Test" + Enter → menu bar shows "Test"
□ Quit and relaunch → still shows "Test"
□ Click → shows "Test" selected in field
□ Press Esc → popover closes, no change
□ Enter long text → truncates in menu bar with …
□ Clear text + Enter → shows "Focus?" again
```

## Gotchas

### Popover won't dismiss?

Make sure you're using `.menuBarExtraStyle(.window)`. The `.menu` style doesn't give you the dismiss environment.

### Text not selected on open?

SwiftUI doesn't auto-select TextField content. If you want select-all behavior, you'll need to dig into NSTextField via a custom wrapper. For MVP, just having the cursor at the end is fine.

### Menu bar label not updating?

`@AppStorage` should trigger updates automatically. If not, make sure you're modifying `currentFocus` (not just `draft`).
