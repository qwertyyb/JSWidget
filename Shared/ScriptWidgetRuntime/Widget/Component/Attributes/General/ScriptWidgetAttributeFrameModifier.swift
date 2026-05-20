//
//  ScriptWidgetAttributeFrameModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI

/*
 size="max"
 size={{width: 100, height: 50}}
 size={{width: "fill", height: "fill"}}
 size={{width: "fill", height: 50}}
 size={{minWidth: 100, maxHeight: 200}}
 
 justify="start"   // horizontal alignment within size box
 align="center"    // vertical alignment within size box
 */
struct ScriptWidgetAttributeFrameModifier: ViewModifier {
    
    enum FrameMode {
        case none
        case fixed(width: CGFloat?, height: CGFloat?, alignment: Alignment)
        case flexible(minWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, maxHeight: CGFloat?, alignment: Alignment)
    }
    
    let frameMode: FrameMode
    
    init(_ element: ScriptWidgetRuntimeElement) {
        let defaultAlign: Alignment = .center
        let alignment = Self.resolveAlignment(element)
        
        switch element.getPropValue("size") {
        case .string(let value):
            if value == "max" {
                self.frameMode = .flexible(
                    minWidth: nil, maxWidth: .infinity,
                    minHeight: nil, maxHeight: .infinity,
                    alignment: alignment ?? defaultAlign
                )
            } else {
                self.frameMode = .none
            }
        case .dict(let dict):
            self.frameMode = Self.parseDictSize(dict, alignment: alignment ?? defaultAlign)
        case .number, nil:
            self.frameMode = .none
        }
    }
    
    private static func resolveAlignment(_ element: ScriptWidgetRuntimeElement) -> Alignment? {
        let justifyStr = element.getPropString("justify")
        let alignStr = element.getPropString("align")
        
        guard justifyStr != nil || alignStr != nil else { return nil }
        
        let h = horizontalFromJustify(justifyStr ?? "center")
        let v = verticalFromAlign(alignStr ?? "center")
        return Alignment(horizontal: h, vertical: v)
    }
    
    private static func horizontalFromJustify(_ value: String) -> HorizontalAlignment {
        switch value {
        case "start": return .leading
        case "end": return .trailing
        case "center": return .center
        default: return .center
        }
    }
    
    private static func verticalFromAlign(_ value: String) -> VerticalAlignment {
        switch value {
        case "start": return .top
        case "end": return .bottom
        case "center": return .center
        default: return .center
        }
    }
    
    private static func parseDictSize(_ dict: [String: Any], alignment: Alignment) -> FrameMode {
        let widthVal = dict["width"]
        let heightVal = dict["height"]
        let hasExplicitMax = dict["maxWidth"] != nil || dict["maxHeight"] != nil
        let hasExplicitMin = dict["minWidth"] != nil || dict["minHeight"] != nil
        
        let widthIsFill = (widthVal as? String) == "fill"
        let heightIsFill = (heightVal as? String) == "fill"
        
        if hasExplicitMax || hasExplicitMin || widthIsFill || heightIsFill {
            let minWidth = dimensionValue(dict["minWidth"])
            var maxWidth = dimensionValue(dict["maxWidth"])
            let minHeight = dimensionValue(dict["minHeight"])
            var maxHeight = dimensionValue(dict["maxHeight"])
            
            if widthIsFill { maxWidth = .infinity }
            if heightIsFill { maxHeight = .infinity }
            
            return .flexible(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        }
        
        let width = numberValue(widthVal)
        let height = numberValue(heightVal)
        
        if width != nil || height != nil {
            return .fixed(width: width, height: height, alignment: alignment)
        }
        
        return .none
    }
    
    private static func dimensionValue(_ value: Any?) -> CGFloat? {
        guard let value = value else { return nil }
        if let str = value as? String {
            if str == "fill" || str == "infinity" { return .infinity }
            if let num = Double(str) { return CGFloat(num) }
            return nil
        }
        if let num = value as? NSNumber {
            return CGFloat(num.doubleValue)
        }
        return nil
    }
    
    private static func numberValue(_ value: Any?) -> CGFloat? {
        if let num = value as? NSNumber { return CGFloat(num.doubleValue) }
        if let str = value as? String, let d = Double(str) { return CGFloat(d) }
        return nil
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch frameMode {
        case .none:
            content
        case .fixed(let width, let height, let alignment):
            content.frame(width: width, height: height, alignment: alignment)
        case .flexible(let minWidth, let maxWidth, let minHeight, let maxHeight, let alignment):
            content.frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        }
    }
}
