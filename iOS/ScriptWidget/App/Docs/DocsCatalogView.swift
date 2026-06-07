//
//  DocsCatalogView.swift
//  ScriptWidget
//

import SwiftUI

struct DocsCatalogView: View {
    var onNextAppear: (() -> Void)?
    var onNextDisappear: (() -> Void)?

    var body: some View {
        List {
            ForEach(DocsCatalog.sections) { section in
                Section(header: Text(LocalizedStringKey(section.title))) {
                    ForEach(section.items) { item in
                        NavigationLink(destination:
                            DocDetailView(title: item.title, markdownFile: item.file, anchor: item.anchor)
                                .onAppear { onNextAppear?() }
                                .onDisappear { onNextDisappear?() }
                        ) {
                            Label {
                                Text(LocalizedStringKey(item.title))
                            } icon: {
                                Image(systemName: item.icon)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Docs"), displayMode: .automatic)
    }
}

struct DocsCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DocsCatalogView()
        }
    }
}
