//
//  Untitled.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//
import Foundation

class WeatherViewModel {
    // MARK: - Properties
    private let networkManager: WeatherRequests
    
    init(networkManager: WeatherRequests = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// Fetches and combines current weather and forecast data for a specified city.
    ///
    /// This asynchronous method retrieves current weather and forecast data concurrently, processes them,
    /// and returns a `CombinedWeather` object containing aggregated information.
    ///
    /// - Parameter city: The name of the city for which to fetch weather data.
    /// - Returns: A `CombinedWeather` object containing current weather details and hourly forecasts.
    /// - Throws: Propagates any errors thrown by the network manager or during data processing.
    func fetchCombinedWeather(for city: String) async throws -> CombinedWeather {
        async let currentWeather = try networkManager.fetchCurrentWeather(for: city)
        async let forecastWeather = try networkManager.fetchForecast(for: city)
        
        return try combineCurrentAndForecast(
            currentWeather: await currentWeather,
            forecast: await forecastWeather
        )
    }
    
    // MARK: - Private Methods
    
    /// Combines current weather and forecast data into a unified `CombinedWeather` object.
    ///
    /// This method processes the fetched data, converting timestamps to local times and filtering forecast entries
    /// to include only those that are relevant (e.g., future hours).
    ///
    /// - Parameters:
    ///   - currentWeather: The current weather data fetched from the network.
    ///   - forecast: The forecast weather data fetched from the network.
    /// - Returns: A `CombinedWeather` object with aggregated weather information.
    /// - Throws: Throws `NetworkError.noCurrentWeatherData` if current weather data is missing,
    ///           or `NetworkError.unknownError` if date conversion fails.
    
    private func combineCurrentAndForecast(currentWeather: CurrentWeather, forecast: ForecastWeather) throws -> CombinedWeather {
        guard let currentData = currentWeather.data.first else {
            throw NetworkError.noCurrentWeatherData
        }
        
        let cityName = currentData.cityName ?? "N/A"
        let currentTemp = Int(currentData.temp)
        let currentDesc = currentData.weather.description
        
        let currentTime = convertUTCToLocalTime(from: currentData.ts, timeZoneIdentifier: currentData.timezone)
        
        guard let currentDate = DateFormatter.hourMinute.date(from: currentTime),
              let nextFullHourDate = currentDate.nextFullHour() else {
            throw NetworkError.unknownError
        }
        
        let hourlyForecasts = forecast.data.compactMap { datum -> HourlyForecast? in
            guard let isoString = datum.timestampLocal,
                  let forecastDate = Date(iso8601String: isoString),
                  forecastDate >= nextFullHourDate else {
                return nil
            }
            
            let time = forecastDate.toHourMinuteString()
            return HourlyForecast(
                time: time,
                temperature: Int(datum.temp),
                description: datum.weather.description
            )
        }
        
        return CombinedWeather(
            cityName: cityName,
            currentTemperature: currentTemp,
            currentDescription: currentDesc,
            currentLocalTime: currentTime,
            hourlyForecasts: hourlyForecasts
        )
    }
    
    /// Converts a UTC timestamp to a local time string based on the provided timezone identifier.
    ///
    /// - Parameters:
    ///   - timestamp: The UTC timestamp (in seconds since 1970) to convert.
    ///   - timeZoneIdentifier: The identifier of the timezone (e.g., "America/New_York").
    /// - Returns: A string representing the local time in "HH:mm" format.
    ///
    private func convertUTCToLocalTime(from timestamp: Int?, timeZoneIdentifier: String?) -> String {
        guard let timestamp = timestamp else { return "N/A" }
        let timeZone = (timeZoneIdentifier.flatMap { TimeZone(identifier: $0) }) ?? TimeZone.current
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date.toHourMinuteString(timeZone: timeZone)
    }
}
