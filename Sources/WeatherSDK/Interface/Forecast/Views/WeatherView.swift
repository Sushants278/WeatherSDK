//
//  SwiftUIView.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import SwiftUI

public struct WeatherView: View {
    @State private var combinedWeather: CombinedWeather?
    @State private var errorMessage: String?
    private let weatherViewModel = WeatherViewModel()

    public init() {} 

    public var body: some View {
        VStack {
            if let weather = combinedWeather {
                Text("The weather in \(weather.cityName ?? "Unknown") is")
                Text("\(weather.currentTemperature ?? 0.0)°C")
                Text(weather.currentDescription ?? "N/A")
                
                List(weather.hourlyForecasts ?? [], id: \.time) { forecast in
                    HStack {
                        Text(forecast.time)
                        Text("\(forecast.temperature)°C")
                        Text(forecast.description)
                    }
                }
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            Task {
                await loadWeather(for: "Munich")
            }
        }
    }
    
    func loadWeather(for city: String) async {
        do {
            combinedWeather = try await weatherViewModel.fetchCombinedWeather(for: city)
        } catch {
          /*  if let weatherError = error as? WeatherError {
                errorMessage = weatherError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }*/
        }
    }
}


#Preview {
    WeatherView()
}
