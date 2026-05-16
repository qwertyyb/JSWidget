//
//  StoreHomeView.swift
//  ScriptWidget
//

import SwiftUI

struct StoreHomeView: View {
    @StateObject private var store = StoreManager()
    @State private var searchText = ""
    @State private var category: String = "all"
    @State private var tabBar: UITabBar?
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        NavigationView {
            listContent
                .navigationTitle("Store")
                .searchable(text: $searchText, prompt: "Search scripts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task { await store.refresh() }
                        } label: {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        .disabled(store.isLoading)
                    }
                }
                .overlay {
                    if store.isLoading && store.scripts.isEmpty {
                        ProgressView()
                    }
                }
                .refreshable {
                    await store.refresh()
                }
        }
        .background(TabBarAccessor { tabbar in
            if idiom != .pad {
                self.tabBar = tabbar
            }
        })
        .environmentObject(store)
        .onAppear {
            store.loadCachedIfNeeded()
            if store.scripts.isEmpty {
                Task { await store.refresh() }
            }
        }
    }

    func showTabBar(_ visible: Bool) {
        guard let tabBar = tabBar else { return }
        tabBar.isHidden = !visible
    }

    @ViewBuilder
    private var listContent: some View {
        let cats = store.categories()
        let filtered = store.filteredScripts(search: searchText, category: category == "all" ? nil : category)

        List {
            if let err = store.lastError, store.scripts.isEmpty {
                Section {
                    Text(err)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Section {
                Picker("Category", selection: $category) {
                    ForEach(cats, id: \.self) { c in
                        Text(c == "all" ? "All" : c.capitalized).tag(c)
                    }
                }
                .pickerStyle(.menu)
            }

            Section {
                ForEach(filtered) { item in
                    NavigationLink(destination: StoreDetailView(script: item)
                        .onAppear { showTabBar(false) }
                        .onDisappear { showTabBar(true) }
                    ) {
                        StoreRowView(item: item)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct StoreRowView: View {
    @EnvironmentObject private var store: StoreManager
    let item: StoreScriptListItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let rel = item.previewScreenshot,
               let url = store.previewImageURL(scriptId: item.id, relativePath: rel) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.secondary.opacity(0.15)
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(Image(systemName: "doc.text").foregroundColor(.secondary))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    if store.isInstalled(scriptId: item.id) {
                        Text("Installed")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StoreHomeView_Previews: PreviewProvider {
    static var previews: some View {
        StoreHomeView()
    }
}
