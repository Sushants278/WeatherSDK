//
//  WeatherRequest.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

public protocol WeatherRequests {
    func fetchCurrentWather(for city: String) async throws ->
    func fetchForecast(for city: String) async throws -> 
}
