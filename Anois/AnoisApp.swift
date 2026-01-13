//
//  AnoisApp.swift
//  Anois
//

import SwiftUI

@main
struct AnoisApp: App {
    @AppStorage("currentFocus") private var currentFocus: String = ""

    var body: some Scene {
        MenuBarExtra {
            PopoverView()
        } label: {
            if currentFocus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Image(systemName: "scope")
            } else {
                Text("[\(currentFocus.trimmingCharacters(in: .whitespacesAndNewlines).truncated(to: 20))]")
                    .font(.system(.body, design: .monospaced))
            }
        }
        .menuBarExtraStyle(.window)
    }
}

extension String {
    func truncated(to limit: Int) -> String {
        if count <= limit {
            return self
        }
        return String(prefix(limit - 1)) + "…"
    }
}
