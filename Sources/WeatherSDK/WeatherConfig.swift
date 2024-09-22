//
//  IMConfig.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//
import Foundation

@objc public final class WeatherConfig: NSObject {
    /// Unique identifier for the API instance
    public let apiKey: String
    
    /// initialize config
    /// - Parameters:
    ///   - apiID: Unique identifier for the api instance
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
