//
//  ScriptWidgetAttributeFrameModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI

/*
 frame="max"
 frame={{width: 100, height: 50}}
 frame={{width: 100, height: 50, alignment: "topLeading"}}
 frame={{maxWidth: "infinity", height: 50}}
 frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}
 */
struct ScriptWidgetAttributeFrameModifier: ViewModifier {
    
    enum FrameMode {
        case none
        case max(alignment: Alignment)
        case fixed(width: CGFloat?, height: CGFloat?, alignment: Alignment)
        case flexible(minWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, maxHeight: CGFloat?, alignment: Alignment)
    }
    
    let frameMode: FrameMode
    
    init(_ element: ScriptWidgetRuntimeElement) {
        switch element.getPropValue("frame") {
        case .string(let value):
            if value == "max" {
                self.frameMode = .max(alignment: .center)
            } else {
                self.frameMode = .none
            }
        case .dict(let dict):
            self.frameMode = ScriptWidgetAttributeFrameModifier.parseDictFrame(dict)
        case .number, nil:
            self.frameMode = .none
        }
    }
    
    private static func parseDictFrame(_ dict: [String: Any]) -> FrameMode {
        let alignment = getAlignmentFromName(dict["alignment"] as? String ?? "center")
        
        let hasMax = dict["maxWidth"] != nil || dict["maxHeight"] != nil
        let hasMin = dict["minWidth"] != nil || dict["minHeight"] != nil
        
        if hasMax || hasMin {
            let minWidth = dimensionValue(dict["minWidth"])
            let maxWidth = dimensionValue(dict["maxWidth"])
            let minHeight = dimensionValue(dict["minHeight"])
            let maxHeight = dimensionValue(dict["maxHeight"])
            return .flexible(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        }
        
        let width = numberValue(dict["width"])
        let height = numberValue(dict["height"])
        
        if width != nil || height != nil {
            return .fixed(width: width, height: height, alignment: alignment)
        }
        
        return .none
    }
    
    private static func dimensionValue(_ value: Any?) -> CGFloat? {
        guard let value = value else { return nil }
        if let str = value as? String, str == "infinity" {
            return .infinity
        }
        if let num = value as? NSNumber {
            return CGFloat(num.doubleValue)
        }
        return nil
    }
    
    private static func numberValue(_ value: Any?) -> CGFloat? {
        guard let num = value as? NSNumber else { return nil }
        return CGFloat(num.doubleValue)
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch frameMode {
        case .none:
            content
        case .max(let alignment):
            content.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
        case .fixed(let width, let height, let alignment):
            content.frame(width: width, height: height, alignment: alignment)
        case .flexible(let minWidth, let maxWidth, let minHeight, let maxHeight, let alignment):
            content.frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, alignment: alignment)
        }
    }
    
    static func getAlignmentFromName(_ name: String) -> Alignment {
        switch name {
        case "center": return .center
        case "leading": return .leading
        case "trailing": return .trailing
        case "top": return .top
        case "bottom": return .bottom
        case "topLeading": return .topLeading
        case "topTrailing": return .topTrailing
        case "bottomLeading": return .bottomLeading
        case "bottomTrailing": return .bottomTrailing
        default: return .center
        }
    }
}

struct ScriptWidgetAttributeFrameModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .fill(.red)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
            Rectangle()
                .fill(.green)
                .frame(width: 50,height: 50)
        }
        .frame(width: 200,height: 300)
        .border(.gray)
    }
}
