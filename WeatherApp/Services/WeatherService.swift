//
//  WeatherService.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//

import Foundation

class WeatherService {
    private let apiKey = "af5d7e7542312ed1cd0760723bedb77b"
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchForecast(for city: String, completion: @escaping (Result<[DailyForecast], Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                let dailyForecasts = forecastResponse.list.map { DailyForecast(date: $0.dt, temp: $0.main.temp, description: $0.weather.first?.description ?? "N/A") }
                
                DispatchQueue.main.async {
                    completion(.success(dailyForecasts))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}

