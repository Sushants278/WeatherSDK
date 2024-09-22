//
//  SwiftUIView.swift
//  WeatherSDK
//
//  Created by Sushant Shinde on 22/09/24.
//

import SwiftUI

public struct WeatherView: View {
    public let cityName: String
    @Binding public var showWeatherView: Bool
    private let weatherViewModel =  WeatherViewModel()
    @State private var combinedWeather: CombinedWeather?
    weak var delegate: WeatherSDKDelegate?
    public init(cityName: String, showWeatherView: Binding<Bool>, delegate: WeatherSDKDelegate?) {
        self.cityName = cityName
        _showWeatherView = showWeatherView
        self.delegate = delegate
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                if let weather = combinedWeather {
                    VStack(spacing: 10) {
                        Text("The weather in \(weather.cityName) is :")
                        Text("\(weather.currentTemperature)°C")
                            .font(.system(size: 30))
                            .bold()
                        Text(weather.currentDescription)
                        Text("AT \(weather.currentLocalTime) LOCAL TIME ")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                    
                    List(weather.hourlyForecasts, id: \.time) { forecast in
                        HStack {
                            Text(forecast.time)
                            Text("\(forecast.temperature)°C")
                                .bold()
                            Text(forecast.description)
                        }
                    }
                } else {
                    Text("Loading...")
                }
            }
            .navigationTitle("24H Forecast")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                showWeatherView = false
                delegate?.weatherSDKDidFinish()
            })
            .onAppear {
                Task {
                    await loadWeather(for: cityName)
                }
            }
        }
    }
    
    func loadWeather(for city: String) async {
        do {
            combinedWeather = try await weatherViewModel.fetchCombinedWeather(for: city)
        } catch let error as NetworkError {
            let nsError = NSError(domain: "WeatherError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error: \(error.localizedDescription)"])
            delegate?.weatherSDKDidFinishWithError(nsError)
            showWeatherView.toggle()
        } catch {
            let nsError = NSError(domain: "WeatherError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected error: \(error.localizedDescription)"])
            delegate?.weatherSDKDidFinishWithError(nsError)
            showWeatherView.toggle()
        }
    }
}

