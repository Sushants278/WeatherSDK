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
    
    private override init() {}
     
    private var apiKey: String = ""
        
    func initializeSDK(withConfig: WeatherConfig) {
        
        configureSDK(using: withConfig)
    }
    
    private func configureSDK(using config: WeatherConfig) {

        self.apiKey = config.apiKey
    }
}
