//
//  WeatherSDKCore.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

class WeatherSDKCore: NSObject {
    
    static let shared: WeatherSDKCore = {
        let instance = WeatherSDKCore()
        return instance
    }()
    
    private override init() {}
    
    private var networkManager = NetworkManager.shared
    private var isInitialized = false
    
    /// Initializes the SDK with the provided configuration.
    /// - Parameter config: The configuration object containing necessary keys.
    func initializeSDK(withConfig config: WeatherConfig) {
        guard !isInitialized else {
            print("WeatherSDKCore: SDK is already initialized.")
            return
        }
        configureSDK(using: config)
        isInitialized = true
    }
    
    /// Configures the SDK using the provided configuration.
    /// - Parameter config: The configuration object containing necessary keys.
    private func configureSDK(using config: WeatherConfig) {
        // Ensure API key is valid
        guard !config.apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            fatalError("WeatherSDKCore: API Key is missing or empty. Please provide a valid API Key.")
        }
        
        // Set the API key in the NetworkManager
        networkManager.setApiKey(config.apiKey)
    }
}
