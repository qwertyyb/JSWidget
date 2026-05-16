//
//  ComponentsHomeView.swift
//  ScriptWidget
//
//  Created by everettjf on 2022/9/9.
//

#if DEBUG
import SwiftUI

struct ComponentsHomeView: View {
    @State private var tabBar: UITabBar! = nil
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        NavigationView {
            BundleScriptListView(
                navigationTitle: "Components",
                inlineTitle: false,
                dataObject: BundleScriptDataObject(bundleName: "Script", bundleDirectory: "component")) {
                    showTabBar(false)
                } onNextDisappear: {
                    showTabBar(true)
                }
        }
        .background(TabBarAccessor { tabbar in
            if idiom != .pad {
                self.tabBar = tabbar
            }
        })
    }

    func showTabBar(_ visible: Bool) {
        guard let tabBar = tabBar else { return }
        tabBar.isHidden = !visible
    }
}

struct ComponentsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsHomeView()
    }
}
#endif
