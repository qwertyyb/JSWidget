//
//  ScriptWidgetRuntimeHealth.swift
//  ScriptWidget
//
//  Created by ScriptWidget contributors.
//

import Foundation
import JavaScriptCore

@objc protocol ScriptWidgetRuntimeHealthExports: JSExport {
    static func isAvailable() -> Bool
    static func requestAuthorization() -> ScriptWidgetRuntimePromise
    static func stepCountToday() -> ScriptWidgetRuntimePromise
    static func activeEnergyToday() -> ScriptWidgetRuntimePromise
    static func heartRateLatest() -> ScriptWidgetRuntimePromise
}

@objc public class ScriptWidgetRuntimeHealth: NSObject, ScriptWidgetRuntimeHealthExports {
    static func isAvailable() -> Bool {
        return false
    }

    static func requestAuthorization() -> ScriptWidgetRuntimePromise {
        return rejectedPromise("HealthKit not available")
    }

    static func stepCountToday() -> ScriptWidgetRuntimePromise {
        return rejectedPromise("HealthKit not available")
    }

    static func activeEnergyToday() -> ScriptWidgetRuntimePromise {
        return rejectedPromise("HealthKit not available")
    }

    static func heartRateLatest() -> ScriptWidgetRuntimePromise {
        return rejectedPromise("HealthKit not available")
    }

    private static func rejectedPromise(_ message: String) -> ScriptWidgetRuntimePromise {
        return ScriptWidgetRuntimePromise { _, reject in
            reject.call(withArguments: [message])
        }
    }
}
