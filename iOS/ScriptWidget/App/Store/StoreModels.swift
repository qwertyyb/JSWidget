//
//  StoreModels.swift
//  ScriptWidget
//

import Foundation

struct StoreIndexPayload: Codable {
    let version: Int
    let updatedAt: String
    let scripts: [StoreScriptListItem]
}

struct StoreScriptListItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let author: String
    let category: String
    let platforms: [String]
    let version: String
    let minAppVersion: String?
    let hasResources: Bool?
    let previewScreenshot: String?
}

struct StoreScriptMetaPayload: Codable {
    let id: String
    let name: String
    let description: String
    let author: String
    let category: String
    let platforms: [String]
    let version: String
    let widgetSizes: [String]?
    let tags: [String]?
    let screenshots: [String]?
    let resources: [String]?
    let createdAt: String?
    let updatedAt: String?
}

extension JSONDecoder {
    static let storeDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}
