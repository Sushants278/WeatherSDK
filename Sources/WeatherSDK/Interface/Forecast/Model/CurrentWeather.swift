//
//  File.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

// MARK: - Weather
struct CurrentWeather: Codable {
    let count: Int
    let data: [Datum]
}

// MARK: - Forecast
struct ForecastWeather: Codable {
    let cityName, countryCode: String
    let data: [Datum]
    let lat, lon, stateCode, timezone: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case countryCode = "country_code"
        case data, lat, lon
        case stateCode = "state_code"
        case timezone
    }
}

// MARK: - Datum
struct Datum: Codable {
    let ts : Int
    let weather: Weather
    let temp: Double
    let timestampLocal: String? 
    
    enum CodingKeys: String, CodingKey {
        case timestampLocal = "timestamp_local"
        case ts,weather,temp
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let code: Int
    let description, icon: String
}
