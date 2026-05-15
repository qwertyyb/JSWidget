//
//  ScriptWidgetAttributeRotation3DEffectModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/4/18.
//

import SwiftUI

/*
 rotation3d={{degrees: 45, x: 1, y: 0, z: 0}}
 */
struct ScriptWidgetAttributeRotation3DEffectModifier: ViewModifier {

    var degree: Double?
    var x: CGFloat = 1
    var y: CGFloat = 0
    var z: CGFloat = 0

    init(_ element: ScriptWidgetRuntimeElement) {
        if let dict = element.getPropDict("rotation3d") {
            if let d = dict["degrees"] as? NSNumber { self.degree = d.doubleValue }
            if let xVal = dict["x"] as? NSNumber { self.x = CGFloat(xVal.doubleValue) }
            if let yVal = dict["y"] as? NSNumber { self.y = CGFloat(yVal.doubleValue) }
            if let zVal = dict["z"] as? NSNumber { self.z = CGFloat(zVal.doubleValue) }
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let degree = self.degree {
            content.rotation3DEffect(Angle(degrees: degree), axis: (x: self.x, y: self.y, z: self.z))
        } else {
            content
        }
    }
}
