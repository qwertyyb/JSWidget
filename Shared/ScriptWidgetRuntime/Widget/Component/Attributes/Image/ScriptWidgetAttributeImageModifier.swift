//
//  ScriptWidgetAttributeImageModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2022/2/27.
//

import SwiftUI

struct ScriptWidgetAttributeImageModifier: ViewModifier {
    
    let aspectRatio: CGFloat?
    let contentMode: ContentMode
    
    init(_ element: ScriptWidgetRuntimeElement, _ context: ScriptWidgetElementContext) {
        
        var aspectRatio: CGFloat? = nil
        if let value = element.getPropDouble("ratio") {
            aspectRatio = CGFloat(floatLiteral: value)
        }
        self.aspectRatio = aspectRatio
        
        var contentMode: ContentMode = .fit
        if let value = element.getPropString("mode") {
            if value == "fill" {
                contentMode = .fill
            }
        }
        self.contentMode = contentMode
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .aspectRatio(aspectRatio, contentMode: contentMode)
    }
    
}
