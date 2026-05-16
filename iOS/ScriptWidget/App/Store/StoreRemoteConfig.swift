//
//  StoreRemoteConfig.swift
//  ScriptWidget
//

import Foundation

enum StoreRemoteConfig {
    /// GitHub raw base for the `store/` folder (no trailing slash).
    static let storeRawBaseURL = "https://raw.githubusercontent.com/qwertyyb/ScriptWidget/main/store"

    static func indexURL() -> URL {
        URL(string: "\(storeRawBaseURL)/index.json")!
    }

    static func scriptFileURL(scriptId: String, relativePath: String) -> URL? {
        let idPart = scriptId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? scriptId
        let pathPart = relativePath
            .split(separator: "/")
            .map { String($0).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? String($0) }
            .joined(separator: "/")
        return URL(string: "\(storeRawBaseURL)/scripts/\(idPart)/\(pathPart)")
    }
}
