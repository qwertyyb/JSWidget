//
//  ScriptWidgetAttributePaddingModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/21.
//

import Foundation
import SwiftUI

/*
 padding={10}
 padding={{horizontal: 10, vertical: 20}}
 padding={{top: 10, bottom: 20}}
 padding={{top: 10, trailing: 20, bottom: 30, leading: 40}}
 padding={{left: 10, right: 20}}
 padding={{horizontal: 10, top: 5}}
 */
struct ScriptWidgetAttributePaddingModifier: ViewModifier {
    
    enum PaddingMode {
        case none
        case uniform(CGFloat)
        case edges(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat)
    }
    
    let mode: PaddingMode
    
    init(_ element: ScriptWidgetRuntimeElement) {
        switch element.getPropValue("padding") {
        case .number(let value):
            self.mode = .uniform(CGFloat(value))
        case .dict(let dict):
            self.mode = ScriptWidgetAttributePaddingModifier.parseDictPadding(dict)
        case .string, nil:
            self.mode = .none
        }
    }
    
    private static func parseDictPadding(_ dict: [String: Any]) -> PaddingMode {
        let h = numberValue(dict["horizontal"])
        let v = numberValue(dict["vertical"])
        
        let top = numberValue(dict["top"]) ?? v ?? 0
        let bottom = numberValue(dict["bottom"]) ?? v ?? 0
        let leading = numberValue(dict["leading"]) ?? numberValue(dict["left"]) ?? h ?? 0
        let trailing = numberValue(dict["trailing"]) ?? numberValue(dict["right"]) ?? h ?? 0
        
        return .edges(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    private static func numberValue(_ value: Any?) -> CGFloat? {
        guard let num = value as? NSNumber else { return nil }
        return CGFloat(num.doubleValue)
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch mode {
        case .none:
            content
        case .uniform(let value):
            content.padding(value)
        case .edges(let top, let leading, let bottom, let trailing):
            content
                .padding(.top, top)
                .padding(.leading, leading)
                .padding(.bottom, bottom)
                .padding(.trailing, trailing)
        }
    }
    
}
