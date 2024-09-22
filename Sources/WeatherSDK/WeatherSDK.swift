// The Swift Programming Language
// https://docs.swift.org/swift-book

// WeatherSDK.swift

import Foundation
import SwiftUICore

@objc public final class WeatherSDK: NSObject {
    
    // MARK: - Properties
    
     private override init() { }
    
     private static let sdk = WeatherSDKCore.shared

    /// Initializes the SDK with your configuration.
    /// - Parameter withConfig: config object containing initialization parameters
    @objc public static func initializeSDK(withConfig: WeatherConfig) {
        
        sdk.initializeSDK(withConfig: withConfig)
    }
}
