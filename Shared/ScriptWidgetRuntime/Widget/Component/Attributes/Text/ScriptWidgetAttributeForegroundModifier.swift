//
//  ScriptWidgetAttributeForegroundModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI


extension View {
    
    public func gradientForeground<Overlay>(_ overlay: Overlay) -> some View where Overlay : View {
        self.overlay(overlay)
            .mask(self)
    }
    
    public func gradientForegroundColors(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}


struct ScriptWidgetAttributeForegroundModifier: ViewModifier {
    
    let color: Color?
    
    init(_ element: ScriptWidgetRuntimeElement, colorField: String) {
        let rawValue = element.props?[colorField]
        self.color = ScriptWidgetAttributeColor(rawValue).color
    }
    
    init(_ element: ScriptWidgetRuntimeElement) {
        self.init(element, colorField: "color")
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let foregroundColor = self.color {
            content.foregroundColor(foregroundColor)
        } else {
            content
        }
    }
    
}
