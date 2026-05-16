//
//  StoreManager.swift
//  ScriptWidget
//

import Foundation
import SwiftUI

private let installedStoreIdsKey = "ScriptWidgetStoreInstalledScriptIds"
private let indexCacheDataKey = "ScriptWidgetStoreIndexCacheData"
private let indexCacheDateKey = "ScriptWidgetStoreIndexCacheDate"

@MainActor
final class StoreManager: ObservableObject {
    @Published private(set) var index: StoreIndexPayload?
    @Published private(set) var scripts: [StoreScriptListItem] = []
    @Published var isLoading = false
    @Published var lastError: String?

    private var installedIds: Set<String> {
        get {
            let arr = UserDefaults.standard.stringArray(forKey: installedStoreIdsKey) ?? []
            return Set(arr)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: installedStoreIdsKey)
        }
    }

    private static var currentOSPlatform: String {
        #if os(iOS)
        return "ios"
        #elseif os(macOS)
        return "macos"
        #else
        return "ios"
        #endif
    }

    func filteredScripts(search: String, category: String?) -> [StoreScriptListItem] {
        let os = Self.currentOSPlatform
        var list = scripts.filter { item in
            if item.platforms.isEmpty { return true }
            return item.platforms.contains { $0.lowercased() == os }
        }
        if let cat = category, !cat.isEmpty, cat != "all" {
            list = list.filter { $0.category.lowercased() == cat.lowercased() }
        }
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            list = list.filter { s in
                s.name.lowercased().contains(q)
                    || s.description.lowercased().contains(q)
                    || s.author.lowercased().contains(q)
                    || s.id.lowercased().contains(q)
            }
        }
        return list
    }

    func categories() -> [String] {
        let cats = Set(scripts.map { $0.category }).sorted()
        return ["all"] + cats
    }

    func isInstalled(scriptId: String) -> Bool {
        installedIds.contains(scriptId)
    }

    func markInstalled(scriptId: String) {
        var s = installedIds
        s.insert(scriptId)
        installedIds = s
    }

    func refresh() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: StoreRemoteConfig.indexURL())
            let decoded = try JSONDecoder.storeDecoder.decode(StoreIndexPayload.self, from: data)
            index = decoded
            scripts = decoded.scripts
            UserDefaults.standard.set(data, forKey: indexCacheDataKey)
            UserDefaults.standard.set(Date(), forKey: indexCacheDateKey)
        } catch {
            lastError = error.localizedDescription
            if let cached = UserDefaults.standard.data(forKey: indexCacheDataKey),
               let decoded = try? JSONDecoder.storeDecoder.decode(StoreIndexPayload.self, from: cached) {
                index = decoded
                scripts = decoded.scripts
            }
        }
    }

    func loadCachedIfNeeded() {
        guard scripts.isEmpty, let cached = UserDefaults.standard.data(forKey: indexCacheDataKey),
              let decoded = try? JSONDecoder.storeDecoder.decode(StoreIndexPayload.self, from: cached) else {
            return
        }
        index = decoded
        scripts = decoded.scripts
    }

    func fetchMeta(scriptId: String) async throws -> StoreScriptMetaPayload {
        guard let url = StoreRemoteConfig.scriptFileURL(scriptId: scriptId, relativePath: "meta.json") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder.storeDecoder.decode(StoreScriptMetaPayload.self, from: data)
    }

    func fetchMainJsx(scriptId: String) async throws -> String {
        guard let url = StoreRemoteConfig.scriptFileURL(scriptId: scriptId, relativePath: "main.jsx") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let text = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return text
    }

    func fetchResourceData(scriptId: String, relativePath: String) async throws -> Data {
        guard let url = StoreRemoteConfig.scriptFileURL(scriptId: scriptId, relativePath: relativePath) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
        return data
    }

    /// Installs script; returns final package folder name on success.
    func install(script: StoreScriptListItem) async throws -> String {
        let meta = try await fetchMeta(scriptId: script.id)
        let mainJsx = try await fetchMainJsx(scriptId: script.id)

        let recommendName = meta.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let packageName = sharedScriptManager.getValidPackageName(recommendPackageName: recommendName.isEmpty ? script.name : recommendName)

        let saveResult = sharedScriptManager.saveScript(packageName: packageName, content: mainJsx, imageCopyPath: nil)
        guard saveResult.0 else {
            throw NSError(domain: "StoreManager", code: 1, userInfo: [NSLocalizedDescriptionKey: saveResult.1])
        }

        let package = sharedScriptManager.getScriptPackage(packageName: packageName)
        let resources = meta.resources ?? []
        for rel in resources {
            let trimmed = rel.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmed.isEmpty else { continue }
            let data = try await fetchResourceData(scriptId: script.id, relativePath: trimmed)
            try writeResource(data: data, to: package, relativePath: trimmed)
        }

        _ = sharedScriptManager.buildScriptPackage(package: package)
        markInstalled(scriptId: script.id)

        NotificationCenter.default.post(name: ScriptWidgetHomeViewDataObject.scriptCreateNotification, object: nil)

        return packageName
    }

    private func writeResource(data: Data, to package: ScriptWidgetPackage, relativePath: String) throws {
        let dest = package.path.appendingPathComponent(relativePath)
        let parent = dest.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true, attributes: [
            .protectionKey: FileProtectionType.none
        ])
        try data.write(to: dest)
        try FileManager.default.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: dest.path)
    }

    func previewImageURL(scriptId: String, relativePath: String) -> URL? {
        StoreRemoteConfig.scriptFileURL(scriptId: scriptId, relativePath: relativePath)
    }
}
