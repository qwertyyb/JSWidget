//
//  ScriptWidgetAttributeClippedModifier.swift
//  ScriptWidgetMac
//
//  Created by everettjf on 2022/3/1.
//

import SwiftUI

/*
 clip="circle"
 clip={{shape: "circle"}}
 */
struct ScriptWidgetAttributeClippedModifier: ViewModifier {
    
    let shape: String?
    
    init(_ element: ScriptWidgetRuntimeElement) {
        switch element.getPropValue("clip") {
        case .string(let value):
            self.shape = value
        case .dict(let dict):
            self.shape = dict["shape"] as? String
        case .number, nil:
            self.shape = nil
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let shape = self.shape {
            switch shape {
            case "circle": content.clipShape(Circle())
            case "rect": content.clipShape(Rectangle())
            case "capsule": content.clipShape(Capsule())
            case "ellipse": content.clipShape(Ellipse())
            default: content.clipped()
            }
        } else {
            content
        }
    }
    
}
