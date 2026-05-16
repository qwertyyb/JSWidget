//
//  ScriptImportView.swift
//  ScriptWidget
//

import SwiftUI

struct ScriptImportData: Identifiable {
    let id = UUID()
    let name: String
    let code: String
}

struct ScriptImportView: View {
    let importData: ScriptImportData
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var scriptName: String

    init(importData: ScriptImportData, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.importData = importData
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        self._scriptName = State(initialValue: importData.name)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Name")
                        .fontWeight(.medium)
                    TextField("Script Name", text: $scriptName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                Text("Code Preview")
                    .fontWeight(.medium)
                    .padding(.horizontal)

                ScrollView {
                    Text(importData.code)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

                Spacer()

                HStack(spacing: 16) {
                    Button(role: .cancel) {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        let name = scriptName.trimmingCharacters(in: .whitespaces)
                        let finalName = name.isEmpty ? importData.name : name
                        let result = sharedScriptManager.createScript(
                            content: importData.code,
                            recommendPackageName: finalName,
                            imageCopyPath: nil
                        )
                        if result.0 {
                            NotificationCenter.default.post(
                                name: ScriptWidgetHomeViewDataObject.scriptCreateNotification,
                                object: nil
                            )
                        }
                        onConfirm()
                    } label: {
                        Text("Import")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
            .navigationTitle("Import Script")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
