//
//  ScriptWidgetAttributeFontModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI

/*
 font="title"
 font={17}
 font={{name: "body", weight: "bold"}}
 font={{name: "body", weight: "bold", design: "rounded"}}
 font={{custom: "Helvetica-Bold", size: 14}}
 */
struct ScriptWidgetAttributeFontModifier: ViewModifier {
    
    let font: Font?
    
    init(_ element: ScriptWidgetRuntimeElement, fontField: String) {
        switch element.getPropValue(fontField) {
        case .string(let name):
            self.font = ScriptWidgetAttributeFontModifier.getFontFromStringName(name, nil)
        case .number(let size):
            self.font = .system(size: CGFloat(size))
        case .dict(let dict):
            self.font = ScriptWidgetAttributeFontModifier.getFontFromDict(dict)
        case nil:
            self.font = nil
        }
    }
    
    init(_ element: ScriptWidgetRuntimeElement) {
        self.init(element, fontField: "font")
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let font = self.font {
            content.font(font)
        } else {
            content
        }
    }
    
    // { name: "body", weight: "bold", design: "rounded" }
    // { custom: "Helvetica-Bold", size: 14 }
    static func getFontFromDict(_ dict: [String: Any]) -> Font? {
        if let customName = dict["custom"] as? String {
            let size = (dict["size"] as? NSNumber)?.doubleValue ?? 10
            return .custom(customName, size: CGFloat(size))
        }
        
        guard let name = dict["name"] as? String else { return nil }
        let designName = dict["design"] as? String
        var font = getFontFromStringName(name, designName)
        
        if let weightName = dict["weight"] as? String,
           let weight = getFontWeightFromStringName(weightName) {
            font = font?.weight(weight)
        }
        
        return font
    }
    
    static func getFontFromStringName(_ name: String, _ designName: String?) -> Font? {
        var font: Font? = nil
        switch name {
        case "largeTitle": font = .largeTitle
        case "title" : font = .title
        case "title2": font = .title2
        case "title3": font = .title3
        case "headline": font = .headline
        case "subheadline": font = .subheadline
        case "body": font = .body
        case "callout": font = .callout
        case "footnote": font = .footnote
        case "caption": font = .caption
        case "caption2": font = .caption2
        default: font = nil
        }
        
        if font == nil {
            if let fontSize = Double(name) {
                if let designName = designName, let design = getFontDesignFromStringName(designName)  {
                    font = .system(size: CGFloat(fontSize), weight: .regular, design: design)
                } else {
                    font = .system(size: CGFloat(fontSize))
                }
            }
        }
        
        return font
    }
    
    static func getFontWeightFromStringName(_ name: String) -> Font.Weight? {
        switch name {
        case "ultraLight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return nil
        }
    }
    
    static func getFontDesignFromStringName(_ name: String) -> Font.Design? {
        switch name {
        case "monospaced": return .monospaced
        case "rounded": return .rounded
        case "serif": return .serif
        case "default": return .`default`
        default: return nil
        }
    }
}
