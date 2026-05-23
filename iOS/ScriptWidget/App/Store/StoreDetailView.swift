//
//  StoreDetailView.swift
//  ScriptWidget
//

import SwiftUI

struct StoreDetailView: View {
    @EnvironmentObject private var store: StoreManager
    let script: StoreScriptListItem

    @State private var meta: StoreScriptMetaPayload?
    @State private var mainJsx: String?
    @State private var loadError: String?
    @State private var isInstalling = false
    @State private var installError: String?
    @State private var showInstallError = false
    @State private var installedPackageName: String?

    var body: some View {
        Group {
            if let err = loadError {
                Text(err)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                content
            }
        }
        .navigationTitle(script.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadContent()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                installButton
            }
        }
        .alert("Install failed", isPresented: $showInstallError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(installError ?? "")
        }
        .sheet(isPresented: Binding(
            get: { installedPackageName != nil },
            set: { if !$0 { installedPackageName = nil } }
        )) {
            if let packageName = installedPackageName {
                NavigationView {
                    ScriptCodeEditorView(
                        mode: .editor,
                        scriptModel: ScriptModel(package: sharedScriptManager.getScriptPackage(packageName: packageName))
                    )
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { installedPackageName = nil }
                        }
                    }
                }
                .navigationViewStyle(.stack)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                screenshotsSection
                metaSection
                codeSection
            }
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var screenshotsSection: some View {
        let shots = meta?.screenshots ?? []
        if !shots.isEmpty {
            TabView {
                ForEach(shots, id: \.self) { rel in
                    if let url = store.previewImageURL(scriptId: script.id, relativePath: rel) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                Color.secondary.opacity(0.12)
                                    .overlay(Image(systemName: "photo").foregroundColor(.secondary))
                            default:
                                ProgressView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                    }
                }
            }
            .frame(height: 240)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var metaSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text((meta ?? fallbackMeta).description)
                .font(.body)

            HStack {
                Label((meta ?? fallbackMeta).author, systemImage: "person")
                Spacer()
                Text("v\((meta ?? fallbackMeta).version)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .font(.caption)

            if let tags = meta?.tags, !tags.isEmpty {
                FlowTagsView(tags: tags)
            }

            if let sizes = meta?.widgetSizes, !sizes.isEmpty {
                Text("Sizes: " + sizes.joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }

    private var fallbackMeta: StoreScriptMetaPayload {
        StoreScriptMetaPayload(
            id: script.id,
            name: script.name,
            description: script.description,
            author: script.author,
            category: script.category,
            platforms: script.platforms,
            version: script.version,
            widgetSizes: nil,
            tags: nil,
            screenshots: script.previewScreenshot.map { [$0] },
            resources: nil,
            createdAt: nil,
            updatedAt: nil
        )
    }

    @ViewBuilder
    private var codeSection: some View {
        if let code = mainJsx {
            VStack(alignment: .leading, spacing: 6) {
                Text("main.jsx")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: true) {
                    Text(code)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .frame(maxHeight: 280)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }

    private var installButton: some View {
        Group {
            if store.isInstalled(scriptId: script.id) {
                Text("Installed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else if isInstalling {
                ProgressView()
            } else {
                Button("Install") {
                    Task { await runInstall() }
                }
            }
        }
    }

    private func loadContent() async {
        loadError = nil
        do {
            async let m = store.fetchMeta(scriptId: script.id)
            async let j = store.fetchMainJsx(scriptId: script.id)
            meta = try await m
            mainJsx = try await j
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func runInstall() async {
        isInstalling = true
        installError = nil
        defer { isInstalling = false }
        do {
            let packageName = try await store.install(script: script)
            installedPackageName = packageName
        } catch {
            installError = error.localizedDescription
            showInstallError = true
        }
    }
}

private struct FlowTagsView: View {
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Tags")
                .font(.caption2)
                .foregroundColor(.secondary)
            TagFlowLayout(spacing: 6, lineSpacing: 6) {
                ForEach(tags, id: \.self) { t in
                    Text(t)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

private struct TagFlowLayout: Layout {
    var spacing: CGFloat
    var lineSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, origin) in result.origins.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var usedWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > maxWidth {
                x = 0
                y += rowHeight + lineSpacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            usedWidth = max(usedWidth, x - spacing)
        }

        return (CGSize(width: usedWidth, height: y + rowHeight), origins)
    }
}

struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StoreDetailView(script: StoreScriptListItem(
                id: "x",
                name: "Sample",
                description: "Desc",
                author: "A",
                category: "utility",
                platforms: ["ios"],
                version: "1",
                minAppVersion: nil,
                hasResources: false,
                previewScreenshot: nil
            ))
            .environmentObject(StoreManager())
        }
    }
}
