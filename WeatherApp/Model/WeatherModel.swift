//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
    let pressure: Int
    let feels_like: Double
    let temp_max: Double  
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: TimeInterval
    let temp: Double
    let description: String
}

