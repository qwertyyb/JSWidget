//
//  ContentView.swift
//  ScriptWidget
//
//  Created by everettjf on 2020/10/4.
//

import SwiftUI


struct TabLabel: View {
   let imageName: String
   let label: String
   
   var body: some View {
       HStack {
           Image(systemName: imageName)
           Text(LocalizedStringKey(label))
       }
   }
}


struct ContentView: View {
    
    var body: some View {
        TabView {
            ScriptWidgetHomeView()
                .tabItem({ TabLabel(imageName: "chevron.left.forwardslash.chevron.right", label: "Scripts")})
            StoreHomeView()
                .tabItem({ TabLabel(imageName: "square.grid.2x2", label: "Store")})
            #if DEBUG
            DebugHomeView()
                .tabItem({ TabLabel(imageName: "ladybug", label: "Debug")})
            #endif
            DocsHomeView()
                .tabItem({ TabLabel(imageName: "book.fill", label: "Docs")})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
