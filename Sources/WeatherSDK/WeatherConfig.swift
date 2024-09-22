//
//  IMConfig.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//


public final class WeatherConfig {
    /// Unique identifier for the API instance
    public let apiKey: String
    
    /// initialize config
    /// - Parameters:
    ///   - apiID: Unique identifier for the api instance
    public init(apiID: String) {
        self.apiKey = apiID
    }
}
