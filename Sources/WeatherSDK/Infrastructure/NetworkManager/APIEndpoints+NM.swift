//
//  File.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

enum APIEndpoint {
    case currentWeather(city: String)
    case forecastHourly(city: String, hours: Int)
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/v2.0/current"
        case .forecastHourly:
            return "/2.0/forecast/hourly"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let city):
            return [
                URLQueryItem(name: "city", value: city)
            ]
        case .forecastHourly(let city, let hours):
            return [
                URLQueryItem(name: "city", value: city),
                URLQueryItem(name: "hours", value: "\(hours)")
            ]
        }
    }
}
