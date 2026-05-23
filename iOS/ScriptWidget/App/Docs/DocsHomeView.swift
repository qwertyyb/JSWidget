//
//  DocsHomeView.swift
//  ScriptWidget
//

import SwiftUI

struct DocsHomeView: View {
    @State private var tabBar: UITabBar? = nil
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        DocsCatalogView(
            onNextAppear: { showTabBar(false) },
            onNextDisappear: { showTabBar(true) }
        )
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

struct DocsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DocsHomeView()
    }
}
