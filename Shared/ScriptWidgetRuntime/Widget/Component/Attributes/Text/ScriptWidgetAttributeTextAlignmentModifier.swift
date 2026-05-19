//
//  ScriptWidgetAttributeTextAlignmentModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/3/14.
//

import SwiftUI

struct ScriptWidgetAttributeTextAlignmentModifier: ViewModifier {
    
    let textAlignment: TextAlignment?
    
    init(_ element: ScriptWidgetRuntimeElement) {
        if let value = element.getPropString("textAlign") {
            self.textAlignment = Self.parse(value)
        } else {
            self.textAlignment = nil
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let textAlignment = self.textAlignment {
            content.multilineTextAlignment(textAlignment)
        } else {
            content
        }
    }
    
    private static func parse(_ name: String) -> TextAlignment? {
        switch name {
        case "start", "left": return .leading
        case "center": return .center
        case "end", "right": return .trailing
        default: return nil
        }
    }
}
