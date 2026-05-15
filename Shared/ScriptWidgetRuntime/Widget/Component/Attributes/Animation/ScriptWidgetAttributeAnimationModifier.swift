//
//  ScriptWidgetAttributeAnimationModifier.swift
//  ScriptWidget
//
//  Created by everettjf on 2021/3/15.
//

import SwiftUI
#if IsWidgetTarget
import ClockHandRotationKit

/*
 animation="clockSecond"
 animation="clockMinute"
 animation="clockHour"
 animation={{type: "clock", timezone: "Asia/Shanghai", anchor: "center", interval: 30}}
 animation={{type: "swing", duration: 2, direction: "horizontal", distance: 100}}
 */

struct ScriptWidgetAttributeAnimationModifier: ViewModifier {
    
    let animationType: String
    
    let clockTimezone: TimeZone
    let clockAnchor: UnitPoint
    let clockCustomInterval: TimeInterval
    
    let swingDuration: CGFloat
    let swingDirection: SwingAnimationModifier.Direction
    let swingDistance: CGFloat
    
    init(_ element: ScriptWidgetRuntimeElement) {
        
        var animationType = ""
        
        var clockTimezone: TimeZone = .current
        var clockAnchor: UnitPoint = .center
        var clockCustomInterval: TimeInterval = 10
        
        var swingDuration: CGFloat = 1
        var swingDirection: SwingAnimationModifier.Direction = .horizontal
        var swingDistance: CGFloat = 10
        
        switch element.getPropValue("animation") {
        case .string(let value):
            animationType = value
        case .dict(let dict):
            if let type = dict["type"] as? String {
                animationType = type
                
                if type == "clock" {
                    if let tz = dict["timezone"] as? String {
                        clockTimezone = ScriptWidgetAttributeAnimationModifier.getTimezone(timezone: tz)
                    }
                    if let anchor = dict["anchor"] as? String {
                        clockAnchor = ScriptWidgetElementPoint.getPointFromPointValue(anchor)
                    }
                    if let interval = (dict["interval"] as? NSNumber)?.doubleValue {
                        clockCustomInterval = max(TimeInterval(interval), 1)
                    }
                }
                
                if type == "swing" {
                    if let d = (dict["duration"] as? NSNumber)?.doubleValue {
                        swingDuration = CGFloat(d)
                    }
                    if let dir = dict["direction"] as? String {
                        swingDirection = dir == "vertical" ? .vertical : .horizontal
                    }
                    if let dist = (dict["distance"] as? NSNumber)?.doubleValue {
                        swingDistance = CGFloat(dist)
                    }
                }
            }
        case .number, nil:
            break
        }
        
        self.animationType = animationType
        self.clockTimezone = clockTimezone
        self.clockAnchor = clockAnchor
        self.clockCustomInterval = clockCustomInterval
        self.swingDuration = swingDuration
        self.swingDirection = swingDirection
        self.swingDistance = swingDistance
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch animationType {
        case "clockSecond":
            content.clockHandRotationEffect(period: .secondHand, in: clockTimezone, anchor: clockAnchor)
        case "clockMinute":
            content.clockHandRotationEffect(period: .minuteHand, in: clockTimezone, anchor: clockAnchor)
        case "clockHour":
            content.clockHandRotationEffect(period: .hourHand, in: clockTimezone, anchor: clockAnchor)
        case "clock":
            content.clockHandRotationEffect(period: .custom(clockCustomInterval), in: clockTimezone, anchor: clockAnchor)
        case "swing":
            content.swingAnimation(duration: swingDuration, direction: swingDirection, distance: swingDistance)
        default:
            content
        }
    }
    
    static func getTimezone(timezone: String) -> TimeZone {
        if timezone == "current" {
            return .current
        }
        return TimeZone(identifier: timezone) ?? .current
    }
}

#else

struct ScriptWidgetAttributeAnimationModifier: ViewModifier {
    
    init(_ element: ScriptWidgetRuntimeElement) {
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
    }
}

#endif
