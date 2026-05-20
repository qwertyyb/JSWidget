//
//  ScriptWidgetElementTagVStack.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/2/18.
//

import Foundation
import SwiftUI

class ScriptWidgetElementTagStack {
    ///--------------------------------------------------------------------------------------------------------

    static func buildViewVStack(_ element: ScriptWidgetRuntimeElement, _ context: ScriptWidgetElementContext) -> AnyView {
        return AnyView(Self.buildVStack(
            element: element,
            context: context
        ))
    }
    
    @ViewBuilder private static func buildVStack(element: ScriptWidgetRuntimeElement, context: ScriptWidgetElementContext) -> some View {
        let stack = VStack(alignment: Self.getHorizontalAlignment(element), spacing: Self.getSpacing(element)) {
            ForEach(element.childrenAsElements()) { item -> AnyView in
                return ScriptWidgetElementView.buildView(element: item, context: context)
            }
        }
        Self.applyMainAxisJustify(stack, justify: Self.getJustify(element), isHorizontal: false)
            .modifier(ScriptWidgetAttributeGeneralModifier(element, context))
    }
    ///--------------------------------------------------------------------------------------------------------

    static func buildViewHStack(_ element: ScriptWidgetRuntimeElement, _ context: ScriptWidgetElementContext) -> AnyView {
        return AnyView(Self.buildHStack(element: element, context: context))
    }
    
    @ViewBuilder private static func buildHStack(element: ScriptWidgetRuntimeElement, context: ScriptWidgetElementContext) -> some View {
        let stack = HStack(alignment: Self.getVerticalAlignment(element), spacing: Self.getSpacing(element)) {
            ForEach(element.childrenAsElements()) { item -> AnyView in
                return ScriptWidgetElementView.buildView(element: item, context: context)
            }
        }
        Self.applyMainAxisJustify(stack, justify: Self.getJustify(element), isHorizontal: true)
            .modifier(ScriptWidgetAttributeGeneralModifier(element, context))
    }
    ///--------------------------------------------------------------------------------------------------------

    static func getVerticalAlignment(_ element: ScriptWidgetRuntimeElement) -> VerticalAlignment {
        guard let align = element.getPropString("align") else { return .center }
        
        switch align {
        case "start": return .top
        case "end": return .bottom
        case "center": return .center
        case "firstBaseline": return .firstTextBaseline
        case "lastBaseline": return .lastTextBaseline
        default: return .center
        }
    }
    
    static func getHorizontalAlignment(_ element: ScriptWidgetRuntimeElement) -> HorizontalAlignment {
        guard let align = element.getPropString("align") else { return .center }
        
        switch align {
        case "start": return .leading
        case "end": return .trailing
        case "center": return .center
        default: return .center
        }
    }
    
    static func getSpacing(_ element: ScriptWidgetRuntimeElement) -> CGFloat? {
        guard let spacing = element.getPropDouble("spacing") else { return nil }
        return CGFloat(spacing)
    }
    
    enum StackJustify {
        case start
        case center
        case end
    }
    
    static func getJustify(_ element: ScriptWidgetRuntimeElement) -> StackJustify {
        guard let justify = element.getPropString("justify") else { return .center }
        switch justify {
        case "start": return .start
        case "end": return .end
        case "center": return .center
        default: return .center
        }
    }
    
    @ViewBuilder
    static func applyMainAxisJustify<Content: View>(
        _ content: Content,
        justify: StackJustify,
        isHorizontal: Bool
    ) -> some View {
        switch justify {
        case .start:
            content
        case .center:
            if isHorizontal {
                content.frame(maxWidth: .infinity, alignment: .center)
            } else {
                content.frame(maxHeight: .infinity, alignment: .center)
            }
        case .end:
            if isHorizontal {
                content.frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                content.frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
