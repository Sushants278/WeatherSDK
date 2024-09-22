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
    let cityName : String?
    let ts : Int
    let weather: Weather
    let temp: Double
    let timestampLocal: String? 
    let timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case timestampLocal = "timestamp_local"
        case cityName = "city_name"
        case ts,weather,temp, timezone
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

struct CombinedWeather {
    let cityName: String
    let currentTemperature: Int
    let currentDescription: String
    let currentLocalTime: String
    let hourlyForecasts: [HourlyForecast]
}

struct HourlyForecast {
    let time: String
    let temperature: Int
    let description: String
}
