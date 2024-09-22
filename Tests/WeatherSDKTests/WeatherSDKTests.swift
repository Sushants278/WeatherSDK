import XCTest
@testable import WeatherSDK

import XCTest

final class WeatherViewModelTests: XCTestCase {
    
      var viewModel: WeatherViewModel!
      var mockNetworkManager: MockWeatherRequests!
      
      override func setUp() {
          super.setUp()
          mockNetworkManager = MockWeatherRequests()
          viewModel = WeatherViewModel(networkManager: mockNetworkManager)
      }
      
      override func tearDown() {
          viewModel = nil
          mockNetworkManager = nil
          super.tearDown()
      }
    
    func testFetchCombinedWeather_Success() async throws {
        // Arrange
        let currentWeather = CurrentWeather(count: 1, data: [
            Datum(
                cityName: "New York",
                ts: 1695472800, // Example timestamp corresponding to 14:00 UTC
                weather: Weather(code: 800, description: "Sunny", icon: "01d"),
                temp: 25.5,
                timestampLocal: nil,
                timezone: "America/New_York"
            )
        ])
        
        let forecastWeather = ForecastWeather(
            cityName: "New York",
            countryCode: "US",
            data: [
                Datum(
                    cityName: nil,
                    ts: 1695476400, // 15:00 UTC
                    weather: Weather(code: 801, description: "Partly Cloudy", icon: "02d"),
                    temp: 26.0,
                    timestampLocal: "2023-09-22T15:00:00",
                    timezone: nil
                ),
                Datum(
                    cityName: nil,
                    ts: 1695480000, // 16:00 UTC
                    weather: Weather(code: 500, description: "Rain", icon: "10d"),
                    temp: 24.0,
                    timestampLocal: "2023-09-22T16:00:00",
                    timezone: nil
                )
            ],
            lat: "40.7128",
            lon: "-74.0060",
            stateCode: "NY",
            timezone: "America/New_York"
        )
        
        mockNetworkManager.fetchCurrentWeatherResult = .success(currentWeather)
        mockNetworkManager.fetchForecastResult = .success(forecastWeather)
        
        // Act
        let combinedWeather = try await viewModel.fetchCombinedWeather(for: "New York")
        
        // Assert
        XCTAssertEqual(combinedWeather.cityName, "New York")
        XCTAssertEqual(combinedWeather.currentTemperature, 25)
        XCTAssertEqual(combinedWeather.currentDescription, "Sunny")
        XCTAssertEqual(combinedWeather.hourlyForecasts.count, 2)
        XCTAssertEqual(combinedWeather.hourlyForecasts[0].time, "15:00")
        XCTAssertEqual(combinedWeather.hourlyForecasts[0].temperature, 26)
        XCTAssertEqual(combinedWeather.hourlyForecasts[0].description, "Partly Cloudy")
        XCTAssertEqual(combinedWeather.hourlyForecasts[1].time, "16:00")
        XCTAssertEqual(combinedWeather.hourlyForecasts[1].temperature, 24)
        XCTAssertEqual(combinedWeather.hourlyForecasts[1].description, "Rain")
    }
    
    func testFetchCombinedWeather_NoCurrentWeatherData_ThrowsError() async {
           // Arrange
           let currentWeather = CurrentWeather(count: 0, data: [])
           let forecastWeather = ForecastWeather(
               cityName: "New York",
               countryCode: "US",
               data: [],
               lat: "40.7128",
               lon: "-74.0060",
               stateCode: "NY",
               timezone: "America/New_York"
           )
           
           mockNetworkManager.fetchCurrentWeatherResult = .success(currentWeather)
           mockNetworkManager.fetchForecastResult = .success(forecastWeather)
           
           // Act & Assert
           do {
               _ = try await viewModel.fetchCombinedWeather(for: "New York")
               XCTFail("Expected to throw NetworkError.noCurrentWeatherData, but no error was thrown.")
           } catch let error as NetworkError {
               XCTAssertEqual(error.errorDescription, NetworkError.noCurrentWeatherData.errorDescription)
           } catch {
               XCTFail("Expected NetworkError.noCurrentWeatherData, but got different error: \(error)")
           }
       }
    
    func testFetchCombinedWeather_FetchCurrentWeatherFailure_ThrowsError() async {
        // Arrange
        mockNetworkManager.fetchCurrentWeatherResult = .failure(NetworkError.noCurrentWeatherData)
        let forecastWeather = ForecastWeather(
            cityName: "New York",
            countryCode: "US",
            data: [],
            lat: "40.7128",
            lon: "-74.0060",
            stateCode: "NY",
            timezone: "America/New_York"
        )
        mockNetworkManager.fetchForecastResult = .success(forecastWeather)
        
        // Act & Assert
        do {
            _ = try await viewModel.fetchCombinedWeather(for: "New York")
            XCTFail("Expected to throw NetworkError.noCurrentWeatherData, but no error was thrown.")
        } catch let error as NetworkError {
            XCTAssertEqual(error.errorDescription, NetworkError.noCurrentWeatherData.errorDescription)
        } catch {
            XCTFail("Expected NetworkError.noCurrentWeatherData, but got different error: \(error)")
        }
    }
    
    func testFetchCombinedWeather_FetchForecastFailure_ThrowsError() async {
        // Arrange
        let currentWeather = CurrentWeather(count: 1, data: [
            Datum(
                cityName: "New York",
                ts: 1695472800, // Example timestamp corresponding to 14:00 UTC
                weather: Weather(code: 800, description: "Sunny", icon: "01d"),
                temp: 25.5,
                timestampLocal: nil,
                timezone: "America/New_York"
            )
        ])
        
        mockNetworkManager.fetchCurrentWeatherResult = .success(currentWeather)
        mockNetworkManager.fetchForecastResult = .failure(NetworkError.unknownError)
        
        // Act & Assert
        do {
            _ = try await viewModel.fetchCombinedWeather(for: "New York")
            XCTFail("Expected to throw NetworkError.unknownError, but no error was thrown.")
        } catch let error as NetworkError {
            XCTAssertEqual(error.errorDescription, NetworkError.unknownError.errorDescription)
        } catch {
            XCTFail("Expected NetworkError.unknownError, but got different error: \(error)")
        }
    }
}


class MockWeatherRequests: WeatherRequests {
    
    var fetchCurrentWeatherResult: Result<CurrentWeather, Error>?
    var fetchForecastResult: Result<ForecastWeather, Error>?
    
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeather {
        guard let result = fetchCurrentWeatherResult else {
            throw NetworkError.unknownError
        }
        
        switch result {
        case .success(let currentWeather):
            return currentWeather
        case .failure(let error):
            throw error
        }
    }
    
    func fetchForecast(for city: String) async throws -> ForecastWeather {
        guard let result = fetchForecastResult else {
            throw NetworkError.unknownError
        }
        
        switch result {
        case .success(let forecastWeather):
            return forecastWeather
        case .failure(let error):
            throw error
        }
    }
}
