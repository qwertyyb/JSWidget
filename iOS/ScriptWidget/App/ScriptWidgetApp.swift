//
//  ScriptWidgetApp.swift
//  ScriptWidget
//
//  Created by everettjf on 2020/10/4.
//

import SwiftUI
import WidgetKit

@main
struct ScriptWidgetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate;
    @State private var pendingImport: ScriptImportData?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print("onOpenURL \(url)")
                    
                    guard let host = url.host() else {
                        return
                    }
                    
                    if let scheme = url.scheme {
                        if scheme == "scriptwidget" {
                            dealWithSelfScheme(host: host, url: url)
                            return
                        }
                    }
                    
                    if host == "xnu.app/scriptwidget" {
                        print("ignore open url for : xnu.app/scriptwidget")
                        UIApplication.shared.open(url)
                        return
                    }
                    
                    DeepLinkManager.openDeepLink(url: url)
                })
                .sheet(item: $pendingImport) { data in
                    ScriptImportView(
                        importData: data,
                        onConfirm: { pendingImport = nil },
                        onCancel: { pendingImport = nil }
                    )
                }
        }
    }
    
    
    func dealWithSelfScheme(host: String, url: URL) {
        if host == "reload-all" {
            WidgetCenter.shared.reloadAllTimelines()
            return
        }
        
        if host == "import" {
            handleImport(url: url)
            return
        }
    }
    
    private func handleImport(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("import: invalid URL")
            return
        }
        
        let queryItems = components.queryItems ?? []
        let name = queryItems.first(where: { $0.name == "name" })?.value ?? "Imported Script"
        
        guard let codeBase64 = queryItems.first(where: { $0.name == "code" })?.value,
              let codeData = Data(base64Encoded: codeBase64),
              let code = String(data: codeData, encoding: .utf8) else {
            print("import: missing or invalid code parameter")
            return
        }
        
        pendingImport = ScriptImportData(name: name, code: code)
    }
}
