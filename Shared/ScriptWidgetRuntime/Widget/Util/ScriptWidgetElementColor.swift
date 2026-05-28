//
//  ScriptWidgetElementHelper.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/19.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

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
            // Theme dynamic color: { light: <colorValue>, dark: <colorValue> }
            // Each side accepts any supported color form (string / dict).
            // The resulting platform dynamic color reacts to appearance changes
            // without re-running the JSX.
            if let lightValue = dict["light"], let darkValue = dict["dark"] {
                let light = ScriptWidgetAttributeColor(lightValue).color
                let dark = ScriptWidgetAttributeColor(darkValue).color
                self.color = ScriptWidgetAttributeColor.makeDynamicColor(light: light, dark: dark)
                return
            }
            self.color = ScriptWidgetAttributeColor.getColorFromDict(dict)
        } else {
            self.color = nil
        }
    }
    
    static func getThemeDynamicColor(light: Color, dark: Color) -> Color {
        return makeDynamicColor(light: light, dark: dark) ?? light
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
        default:
            return getPlatformSemanticColor(name)
        }
    }
    
#if os(macOS)
    
    private static func getPlatformSemanticColor(_ name: String) -> Color? {
        switch name {
        case "label": return Color(nsColor: .labelColor)
        case "secondaryLabel": return Color(nsColor: .secondaryLabelColor)
        case "tertiaryLabel": return Color(nsColor: .tertiaryLabelColor)
        case "quaternaryLabel": return Color(nsColor: .quaternaryLabelColor)
        case "placeholderText": return Color(nsColor: .placeholderTextColor)
        case "link": return Color(nsColor: .linkColor)
            
        case "systemBackground": return Color(nsColor: .windowBackgroundColor)
        case "secondarySystemBackground": return Color(nsColor: .underPageBackgroundColor)
        case "tertiarySystemBackground": return Color(nsColor: .controlBackgroundColor)
        case "systemGroupedBackground": return Color(nsColor: .windowBackgroundColor)
        case "secondarySystemGroupedBackground": return Color(nsColor: .controlBackgroundColor)
        case "tertiarySystemGroupedBackground": return Color(nsColor: .underPageBackgroundColor)
            
        // macOS doesn't expose dedicated fill colors; fall back to label-derived
        // semi-transparent variants which are also dynamic.
        case "systemFill": return Color(nsColor: .quaternaryLabelColor)
        case "secondarySystemFill": return Color(nsColor: .tertiaryLabelColor)
        case "tertiarySystemFill": return Color(nsColor: .secondaryLabelColor)
        case "quaternarySystemFill": return Color(nsColor: .quaternaryLabelColor)
            
        case "separator": return Color(nsColor: .separatorColor)
        case "opaqueSeparator": return Color(nsColor: .separatorColor)
            
        case "accent", "tint": return Color(nsColor: .controlAccentColor)
            
        case "systemRed": return Color(nsColor: .systemRed)
        case "systemOrange": return Color(nsColor: .systemOrange)
        case "systemYellow": return Color(nsColor: .systemYellow)
        case "systemGreen": return Color(nsColor: .systemGreen)
        case "systemMint":
            if #available(macOS 12.0, *) { return Color(nsColor: .systemMint) }
            return Color(nsColor: .systemGreen)
        case "systemTeal": return Color(nsColor: .systemTeal)
        case "systemCyan":
            if #available(macOS 12.0, *) { return Color(nsColor: .systemCyan) }
            return Color(nsColor: .systemBlue)
        case "systemBlue": return Color(nsColor: .systemBlue)
        case "systemIndigo": return Color(nsColor: .systemIndigo)
        case "systemPurple": return Color(nsColor: .systemPurple)
        case "systemPink": return Color(nsColor: .systemPink)
        case "systemBrown": return Color(nsColor: .systemBrown)
            
        // macOS only ships a single .systemGray; map all step variants to it
        // so cross-platform scripts don't break.
        case "systemGray", "systemGray2", "systemGray3", "systemGray4", "systemGray5", "systemGray6":
            return Color(nsColor: .systemGray)
            
        default: return nil
        }
    }
    
    static func makeDynamicColor(light: Color?, dark: Color?) -> Color? {
        guard light != nil || dark != nil else { return nil }
        let lightNS = light.map { NSColor($0) } ?? NSColor.clear
        let darkNS = dark.map { NSColor($0) } ?? NSColor.clear
        let dynamic = NSColor(name: nil) { appearance in
            let match = appearance.bestMatch(from: [.aqua, .darkAqua])
            return match == .darkAqua ? darkNS : lightNS
        }
        return Color(nsColor: dynamic)
    }
    
#else
    
    private static func getPlatformSemanticColor(_ name: String) -> Color? {
        switch name {
        case "label": return Color(uiColor: .label)
        case "secondaryLabel": return Color(uiColor: .secondaryLabel)
        case "tertiaryLabel": return Color(uiColor: .tertiaryLabel)
        case "quaternaryLabel": return Color(uiColor: .quaternaryLabel)
        case "placeholderText": return Color(uiColor: .placeholderText)
        case "link": return Color(uiColor: .link)
            
        case "systemBackground": return Color(uiColor: .systemBackground)
        case "secondarySystemBackground": return Color(uiColor: .secondarySystemBackground)
        case "tertiarySystemBackground": return Color(uiColor: .tertiarySystemBackground)
        case "systemGroupedBackground": return Color(uiColor: .systemGroupedBackground)
        case "secondarySystemGroupedBackground": return Color(uiColor: .secondarySystemGroupedBackground)
        case "tertiarySystemGroupedBackground": return Color(uiColor: .tertiarySystemGroupedBackground)
            
        case "systemFill": return Color(uiColor: .systemFill)
        case "secondarySystemFill": return Color(uiColor: .secondarySystemFill)
        case "tertiarySystemFill": return Color(uiColor: .tertiarySystemFill)
        case "quaternarySystemFill": return Color(uiColor: .quaternarySystemFill)
            
        case "separator": return Color(uiColor: .separator)
        case "opaqueSeparator": return Color(uiColor: .opaqueSeparator)
            
        case "accent", "tint": return Color(uiColor: .tintColor)
            
        case "systemRed": return Color(uiColor: .systemRed)
        case "systemOrange": return Color(uiColor: .systemOrange)
        case "systemYellow": return Color(uiColor: .systemYellow)
        case "systemGreen": return Color(uiColor: .systemGreen)
        case "systemMint": return Color(uiColor: .systemMint)
        case "systemTeal": return Color(uiColor: .systemTeal)
        case "systemCyan": return Color(uiColor: .systemCyan)
        case "systemBlue": return Color(uiColor: .systemBlue)
        case "systemIndigo": return Color(uiColor: .systemIndigo)
        case "systemPurple": return Color(uiColor: .systemPurple)
        case "systemPink": return Color(uiColor: .systemPink)
        case "systemBrown": return Color(uiColor: .systemBrown)
            
        case "systemGray": return Color(uiColor: .systemGray)
        case "systemGray2": return Color(uiColor: .systemGray2)
        case "systemGray3": return Color(uiColor: .systemGray3)
        case "systemGray4": return Color(uiColor: .systemGray4)
        case "systemGray5": return Color(uiColor: .systemGray5)
        case "systemGray6": return Color(uiColor: .systemGray6)
            
        default: return nil
        }
    }
    
    static func makeDynamicColor(light: Color?, dark: Color?) -> Color? {
        guard light != nil || dark != nil else { return nil }
        let lightUI = light.map { UIColor($0) } ?? UIColor.clear
        let darkUI = dark.map { UIColor($0) } ?? UIColor.clear
        let dynamic = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? darkUI : lightUI
        }
        return Color(uiColor: dynamic)
    }
    
#endif
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
