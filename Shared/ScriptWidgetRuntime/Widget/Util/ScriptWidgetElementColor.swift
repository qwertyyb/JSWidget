//
//  ScriptWidgetElementHelper.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/19.
//

import Foundation
import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct ScriptWidgetAttributeColor {
    
    let color: Color?
    
    init() {
        self.color = nil
    }
    
    init(_ colorValue: String) {
        self.color = ScriptWidgetAttributeColor.getColorFromColorValue(colorValue)
    }
    
    init(_ colorValue: Any?) {
        guard let colorValue = colorValue else {
            self.color = nil
            return
        }
        if let str = colorValue as? String {
            self.color = ScriptWidgetAttributeColor.getColorFromColorValue(str)
        } else if let dict = colorValue as? [String: Any] {
            self.color = ScriptWidgetAttributeColor.getColorFromDict(dict)
        } else {
            self.color = nil
        }
    }
    
    static func getThemeDynamicColor(light: Color, dark: Color) -> Color {
        if ScriptWidgetRuntimeDevice.isdarkmode() {
            return dark
        } else {
            return light
        }
    }
    
    // { value: "red", opacity: 0.5 }
    static func getColorFromDict(_ dict: [String: Any]) -> Color? {
        guard let value = dict["value"] as? String else { return nil }
        guard var color = getColorFromColorValue(value) else { return nil }
        if let opacity = dict["opacity"] as? Double {
            color = color.opacity(opacity)
        } else if let opacity = dict["opacity"] as? NSNumber {
            color = color.opacity(opacity.doubleValue)
        }
        return color
    }
    
    static func getColorFromColorValue(_ colorValue: String) -> Color? {
        let trimmed = colorValue.trimmingCharacters(in: .whitespaces)
        
        if trimmed.hasPrefix("#") {
            return Color(hex: trimmed)
        }
        
        if trimmed.hasPrefix("rgb(") || trimmed.hasPrefix("rgba(") {
            return Color.fromCSSFunction(trimmed)
        }
        
        return getBuiltinColorFromName(trimmed)
    }
    
    static func getBuiltinColorFromName(_ name: String) -> Color? {
        switch name {
        case "clear": return .clear
        case "black": return .black
        case "white": return .white
        case "gray": return .gray
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "yellow": return .yellow
        case "pink": return .pink
        case "purple": return .purple
        case "primary": return .primary
        case "secondary": return .secondary
        default: return nil
        }
    }
}

extension Color {
    
    /*
     Supported hex formats:
     #RGB        -> 3-digit shorthand
     #RGBA       -> 4-digit shorthand with alpha
     #RRGGBB     -> 6-digit standard
     #RRGGBBAA   -> 8-digit with alpha (CSS standard RGBA order)
     */
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit) -> expand to 24-bit
            let rr = (int >> 8) & 0xF
            let gg = (int >> 4) & 0xF
            let bb = int & 0xF
            (r, g, b, a) = (rr * 17, gg * 17, bb * 17, 255)
        case 4: // RGBA (16-bit) -> expand to 32-bit
            let rr = (int >> 12) & 0xF
            let gg = (int >> 8) & 0xF
            let bb = (int >> 4) & 0xF
            let aa = int & 0xF
            (r, g, b, a) = (rr * 17, gg * 17, bb * 17, aa * 17)
        case 6: // RRGGBB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // RRGGBBAA (32-bit, CSS standard RGBA order)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // rgb(255, 0, 0) or rgba(255, 0, 0, 0.5)
    static func fromCSSFunction(_ css: String) -> Color? {
        let inner: String
        if css.hasPrefix("rgba(") && css.hasSuffix(")") {
            inner = String(css.dropFirst(5).dropLast(1))
        } else if css.hasPrefix("rgb(") && css.hasSuffix(")") {
            inner = String(css.dropFirst(4).dropLast(1))
        } else {
            return nil
        }
        
        let parts = inner.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard parts.count >= 3,
              let r = Double(parts[0]),
              let g = Double(parts[1]),
              let b = Double(parts[2]) else {
            return nil
        }
        
        let opacity: Double
        if parts.count >= 4, let a = Double(parts[3]) {
            opacity = a
        } else {
            opacity = 1.0
        }
        
        return Color(
            .sRGB,
            red: r / 255,
            green: g / 255,
            blue: b / 255,
            opacity: opacity
        )
    }
}
