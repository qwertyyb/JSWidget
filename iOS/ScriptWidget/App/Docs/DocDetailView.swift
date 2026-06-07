//
//  DocDetailView.swift
//  ScriptWidget
//

import SwiftUI

struct DocDetailView: View {
    let title: String
    let markdownFile: String
    let anchor: String?

    init(title: String, markdownFile: String, anchor: String? = nil) {
        self.title = title
        self.markdownFile = markdownFile
        self.anchor = anchor
    }

    var body: some View {
        DocWebView(markdownFile: markdownFile, anchor: anchor)
            .navigationBarTitle(Text(LocalizedStringKey(title)), displayMode: .inline)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct DocDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DocDetailView(title: "Quick Start", markdownFile: "getting-started.md")
        }
    }
}
