//
//  ScriptWidgetAttributeShadowModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/4/18.
//

import Foundation
import SwiftUI

/*
 shadow={{color: "#000000", radius: 2, x: 0, y: 4}}
 */
struct ScriptWidgetAttributeShadowModifier: ViewModifier {
    
    var color: Color?
    var radius: CGFloat = 3
    var x: CGFloat = 0
    var y: CGFloat = 3

    init(_ element: ScriptWidgetRuntimeElement) {
        if let dict = element.getPropDict("shadow") {
            if let colorValue = dict["color"] {
                self.color = ScriptWidgetAttributeColor(colorValue).color
            }
            if let r = dict["radius"] as? NSNumber { self.radius = CGFloat(r.doubleValue) }
            if let xVal = dict["x"] as? NSNumber { self.x = CGFloat(xVal.doubleValue) }
            if let yVal = dict["y"] as? NSNumber { self.y = CGFloat(yVal.doubleValue) }
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let color = self.color {
            content.shadow(color: color, radius: self.radius, x: self.x, y: self.y)
        } else {
            content
        }
    }
    
}
