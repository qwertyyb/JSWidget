//
//  ScriptWidgetElementGradient.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI

/*
 backgroundGradient={{type: "linear", colors: ["blue","white","pink"], startPoint: "topLeading", endPoint: "bottomTrailing"}}
 backgroundGradient={{type: "radial", colors: ["orange", "red", "white"], center: "center", startRadius: 100, endRadius: 470}}
 backgroundGradient={{type: "angular", colors: ["green", "blue", "black", "green", "blue", "black", "green"], center: "center"}}
 */

class ScriptWidgetElementGradient {
    
    static func getGradientFromDict(_ dict: [String: Any]) -> AnyView? {
        guard let type = dict["type"] as? String else { return nil }
        
        let colors = parseColors(dict["colors"])
        guard !colors.isEmpty else { return nil }
        
        switch type {
        case "linear":
            let startPoint = ScriptWidgetElementPoint.getPointFromPointValue(dict["startPoint"] as? String ?? "leading")
            let endPoint = ScriptWidgetElementPoint.getPointFromPointValue(dict["endPoint"] as? String ?? "trailing")
            return AnyView(LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint))
            
        case "radial":
            let center = ScriptWidgetElementPoint.getPointFromPointValue(dict["center"] as? String ?? "center")
            let startRadius = (dict["startRadius"] as? NSNumber)?.doubleValue ?? 0
            let endRadius = (dict["endRadius"] as? NSNumber)?.doubleValue ?? 100
            return AnyView(RadialGradient(gradient: Gradient(colors: colors), center: center, startRadius: CGFloat(startRadius), endRadius: CGFloat(endRadius)))
            
        case "angular":
            let center = ScriptWidgetElementPoint.getPointFromPointValue(dict["center"] as? String ?? "center")
            return AnyView(AngularGradient(gradient: Gradient(colors: colors), center: center))
            
        default:
            print("unknown gradient type: \(type)")
            return nil
        }
    }
    
    private static func parseColors(_ colorsValue: Any?) -> [Color] {
        guard let colorArray = colorsValue as? [Any] else { return [] }
        // Each item may be any supported color form: string ("#fff"/"red"/...),
        // { value, opacity }, or { light, dark } dynamic color object.
        return colorArray.compactMap { ScriptWidgetAttributeColor($0).color }
    }
}
