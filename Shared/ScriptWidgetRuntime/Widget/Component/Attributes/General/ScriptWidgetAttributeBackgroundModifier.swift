//
//  ScriptWidgetAttributeBackgroundModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/18.
//

import Foundation
import SwiftUI


struct ScriptWidgetAttributeBackgroundModifier: ViewModifier {
    
    let backgroundColor: Color?
    let backgroundGradient: AnyView?
    
    init(_ element: ScriptWidgetRuntimeElement) {
        let colorRawValue = element.props?["backgroundColor"]
        self.backgroundColor = ScriptWidgetAttributeColor(colorRawValue).color
        
        if let gradientDict = element.getPropDict("backgroundGradient") {
            self.backgroundGradient = ScriptWidgetElementGradient.getGradientFromDict(gradientDict)
        } else {
            self.backgroundGradient = nil
        }
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if let color = self.backgroundColor {
            content.background(color)
        } else if let gradient = self.backgroundGradient {
            content.background(gradient)
        } else {
            content
        }
    }
    
}
