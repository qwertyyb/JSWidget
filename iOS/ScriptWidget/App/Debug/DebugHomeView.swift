//
//  DebugHomeView.swift
//  ScriptWidget
//

#if DEBUG
import SwiftUI

/// Debug-only entry: bundle **Components** and **APIs** sample lists under one tab.
struct DebugHomeView: View {
    @State private var tabBar: UITabBar?
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: bundleList(title: "Components", directory: "component")) {
                        Label("Components", systemImage: "chart.xyaxis.line")
                    }
                    NavigationLink(destination: bundleList(title: "APIs", directory: "api")) {
                        Label("APIs", systemImage: "pencil.line")
                    }
                } footer: {
                    Text("Bundle 内示例脚本，用于开发自测。")
                }
            }
            .navigationTitle("Debug")
        }
        .background(TabBarAccessor { tabbar in
            if idiom != .pad {
                self.tabBar = tabbar
            }
        })
    }

    private func showTabBar(_ visible: Bool) {
        guard let tabBar = tabBar else { return }
        tabBar.isHidden = !visible
    }

    private func bundleList(title: String, directory: String) -> some View {
        BundleScriptListView(
            navigationTitle: title,
            inlineTitle: false,
            dataObject: BundleScriptDataObject(bundleName: "Script", bundleDirectory: directory),
            onNextAppear: { showTabBar(false) },
            onNextDisappear: { showTabBar(true) }
        )
    }
}

struct DebugHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DebugHomeView()
    }
}
#endif
