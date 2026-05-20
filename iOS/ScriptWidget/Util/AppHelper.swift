//
//  AppUtility.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/13.
//

import SwiftUI
import UIKit
import StoreKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class AppHelper {
    static func getAlternateIconNames() -> [String] {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any] else { return [] }
        guard let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] else { return [] }
        
        var iconNames = [String]()
        for (_, value) in alternateIcons {
            guard let iconList = value as? Dictionary<String,Any> else { break }
            guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else{ break }
            guard let icon = iconFiles.first else { break }
            
            iconNames.append(icon)
        }
        
        return iconNames
    }
    
    static func getCurrentIconName() -> String {
        if let name = UIApplication.shared.alternateIconName {
            return name
        }
        return "color4"
    }
    
    static let aboutAuthorName = "qwertyyb"
    static let aboutAuthorURL = "https://github.com/qwertyyb"
    static let aboutWebsiteURL = "https://qwertyyb.github.io/JSWidget/"
    static let aboutRepositoryURL = "https://github.com/qwertyyb/JSWidget"
    
    static func getAppDisplayName() -> String {
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, !name.isEmpty {
            return name
        }
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, !name.isEmpty {
            return name
        }
        return "JSWidget"
    }
    
    static func getMarketingVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    static func getBuildVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
    
    static func getAppVersion() -> String {
        "\(getMarketingVersion()).\(getBuildVersion())"
    }
    
    @MainActor
    static func appIconImage() -> UIImage? {
        if let name = UIApplication.shared.alternateIconName,
           let image = UIImage(named: name) {
            return image
        }
        return UIImage(named: "MainAppIcon")
    }
    
    @MainActor static func requestReview() {
        if let windowScene = UIApplication.shared.firstKeyWindow?.windowScene {
            AppStore.requestReview(in: windowScene)
        }
    }
    
    static func isdarkmode() -> Bool {
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
    
}
