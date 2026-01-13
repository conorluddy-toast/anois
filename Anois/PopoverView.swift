//
//  PopoverView.swift
//  Anois
//

import SwiftUI

struct PopoverView: View {
    @AppStorage("currentFocus") private var currentFocus: String = ""
    @State private var draft: String = ""
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            TextField("What's your focus?", text: $draft)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .focused($isFocused)
                .onSubmit(save)
                .onExitCommand(perform: cancel)
                .onAppear {
                    draft = currentFocus
                    isFocused = true
                }
                .padding()

            Divider()

            HStack {
                Button("Clear") {
                    currentFocus = ""
                    draft = ""
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
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
