//
//  WeatherSDKCore.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

protocol WeatherSDKCoreProtocol {
    
    func initializeSDK(withConfig: WeatherConfig)
}

class WeatherSDKCore: NSObject {
       
    static let shared: WeatherSDKCore = {
           let instance = WeatherSDKCore()
           // Additional setup
           return instance
       }()
    private var apiKey: String = ""

    private override init() {}
    
    private var networkManager: WeatherRequests?
    
        
    func initializeSDK(withConfig: WeatherConfig) {
        
        configureSDK(using: withConfig)
    }
    
    private func configureSDK(using config: WeatherConfig) {

        self.apiKey = config.apiKey
        
        self.networkManager = NetworkManager(apiKey: self.apiKey, host: "api.weatherbit.io")
        
        Task {
           try await self.fetchCurrentWeather(for: "Mumbai")
        }
    }

   /* public func fetchCurrentWeather(for city: String) async throws -> ForecastWeather {
            guard let manager = networkManager else {
                throw WeatherSDKError.sdkNotInitialized
            }
        return try await manager.fetchForecast(for: "Mumbai")
        }
    **/
    public func fetchCurrentWeather(for city: String) async throws -> CurrentWeather {
        guard let manager = networkManager else {
            throw WeatherSDKError.sdkNotInitialized
        }
        return try await manager.fetchCurrentWeather(for: city)
    }
}

public enum WeatherSDKError: Error, LocalizedError {
    case sdkNotInitialized

    public var errorDescription: String? {
        switch self {
        case .sdkNotInitialized:
            return "WeatherSDK has not been initialized. Please call `initializeSDK(withConfig:)` before making API calls."
        }
    }
}
