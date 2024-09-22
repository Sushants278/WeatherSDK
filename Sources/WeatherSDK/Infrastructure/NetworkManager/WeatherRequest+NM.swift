//
//  WeatherRequest.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import Foundation

 protocol WeatherRequests {
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeather
    func fetchForecast(for city: String) async throws ->  ForecastWeather
}

// MARK: - NetworkManager Conformance to WeatherRequests

extension NetworkManager: WeatherRequests {
    
    /// Fetches the current weather for a given city.
    /// - Parameter city: The name of the city.
    /// - Returns: A `Weather` object containing the current weather data.
    /// - Throws: `NetworkError` if the request fails or decoding fails.
     func fetchCurrentWeather(for city: String) async throws -> CurrentWeather {
        let endpoint = APIEndpoint.currentWeather(city: city)
        
        let weather: CurrentWeather = try await executeRequest(
            method: .GET,
            path: endpoint.path,
            queryItems: endpoint.queryItems,
            body: nil
        )
        
        return weather
    }
    
    /// Fetches the weather forecast for 24 hours a given city.
    /// - Parameter city: The name of the city.
    /// - Returns: A `Weather` object containing the forecast data.
    /// - Throws: `NetworkError` if the request fails or decoding fails.
     func fetchForecast(for city: String) async throws -> ForecastWeather {
        let endpoint = APIEndpoint.forecastHourly(city: city, hours: 24)
        
        let forecast: ForecastWeather = try await executeRequest(
            method: .GET,
            path: endpoint.path,
            queryItems: endpoint.queryItems,
            body: nil
        )
        
        return forecast
    }
}

