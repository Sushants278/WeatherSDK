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

// MARK: - Datum
struct Datum: Codable {
    let appTemp: Double
    let aqi: Int
    let cityName: String
    let clouds: Int
    let countryCode, datetime: String
    let dewpt: Double
    let dhi, dni: Int
    let elevAngle: Double
    let ghi: Int
    let gust: Double
    let hAngle: Int
    let lat, lon: Double
    let obTime, pod: String
    let precip, pres, rh, slp: Int
    let snow, solarRAD: Int
    let sources: [String]
    let stateCode, station, sunrise, sunset: String
    let temp: Double
    let timezone: String
    let ts, uv, vis: Int
    let weather: WeatherClass
    let windCdir, windCdirFull: String
    let windDir: Int
    let windSpd: Double

    enum CodingKeys: String, CodingKey {
        case appTemp = "app_temp"
        case aqi
        case cityName = "city_name"
        case clouds
        case countryCode = "country_code"
        case datetime, dewpt, dhi, dni
        case elevAngle = "elev_angle"
        case ghi, gust
        case hAngle = "h_angle"
        case lat, lon
        case obTime = "ob_time"
        case pod, precip, pres, rh, slp, snow
        case solarRAD = "solar_rad"
        case sources
        case stateCode = "state_code"
        case station, sunrise, sunset, temp, timezone, ts, uv, vis, weather
        case windCdir = "wind_cdir"
        case windCdirFull = "wind_cdir_full"
        case windDir = "wind_dir"
        case windSpd = "wind_spd"
    }
}

// MARK: - WeatherClass
struct WeatherClass: Codable {
    let description: Description
    let code: Int
    let icon: String
}

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

enum Description: String, Codable {
    case brokenClouds = "Broken clouds"
    case fewClouds = "Few clouds"
    case overcastClouds = "Overcast clouds"
    case scatteredClouds = "Scattered clouds"
}
