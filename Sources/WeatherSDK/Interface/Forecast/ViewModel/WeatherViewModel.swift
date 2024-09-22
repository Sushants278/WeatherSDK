//
//  Untitled.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//
import Foundation

struct CombinedWeather {
    let cityName: String?
    let currentTemperature: Double?
    let currentDescription: String?
    let hourlyForecasts: [HourlyForecast]?
}

struct HourlyForecast {
    let time: String
    let temperature: Double
    let description: String
}

class WeatherViewModel {
    
    let networkManager: WeatherRequests = NetworkManager.shared
    
    func fetchCombinedWeather(for city: String) async throws -> CombinedWeather {
        let currentWeather = try await networkManager.fetchCurrentWeather(for: city)
        let forecastWeather = try await networkManager.fetchForecast(for: city)
        
        return combineCurrentAndForecast(currentWeather: currentWeather, forecast: forecastWeather)
    }
    
    private func fetchCurrentWeather(for city: String) async throws -> ForecastWeather {
     
        return try await networkManager.fetchForecast(for: "Mumbai")
    }
    
    private func fetchCurrentWeather(for city: String) async throws -> CurrentWeather {
   
        return try await networkManager.fetchCurrentWeather(for: city)
    }
    
    func combineCurrentAndForecast(currentWeather: CurrentWeather, forecast: ForecastWeather) -> CombinedWeather {
        let cityName =    currentWeather.data.first?.cityName ?? "N/A"
        let currentTemp = currentWeather.data.first?.temp ?? 0.0
        let currentDesc = currentWeather.data.first?.weather.description ?? "N/A"
        
        let hourlyForecasts = forecast.data.compactMap { datum in
            HourlyForecast(
                time: convertUTCToLocalTime(utcDateString: datum.timestampLocal ?? ""),
                temperature: datum.temp,
                description: datum.weather.description
            )
        }
        
        return CombinedWeather(
            cityName: cityName,
            currentTemperature: currentTemp,
            currentDescription: currentDesc,
            hourlyForecasts: hourlyForecasts
        )
    }
    
    func convertUTCToLocalTime(utcDateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = formatter.date(from: utcDateString) {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        return utcDateString
    }
}
