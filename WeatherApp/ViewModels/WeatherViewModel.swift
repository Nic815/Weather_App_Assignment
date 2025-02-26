import Foundation
import UserNotifications
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var humidity: String = "--"
    @Published var windSpeed: String = "--"
    @Published var pressure: String = "--"
    @Published var visibility: String = "--"
    @Published var feelsLike: String = "--"
    @Published var maxTemp: String = "--"
    @Published var description: String = "Loading..."
    @Published var weatherIcon: String?
    @Published var forecast: [DailyForecast] = []
    @Published var selectedCity: String {
           didSet {
               UserDefaults.standard.set(selectedCity, forKey: "selectedCity")
           }
       }
    
    @AppStorage("unit") var isMetric: Bool = true

    private let weatherService = WeatherService()

    init() {
        self.selectedCity = UserDefaults.standard.string(forKey: "selectedCity") ?? "India"
        fetchWeather(city: selectedCity)
        loadCachedWeather()
    }
    
    func fetchWeather(city: String) {
        self.selectedCity = city
        weatherService.fetchWeather(for: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    let temp = self.isMetric ? weather.main.temp : (weather.main.temp * 9/5) + 32
                    let feelsLike = self.isMetric ? weather.main.feels_like : (weather.main.feels_like * 9/5) + 32
                    let maxTemp = self.isMetric ? weather.main.temp_max : (weather.main.temp_max * 9/5) + 32
                    let windSpeed = self.isMetric ? "\(weather.wind.speed) m/s" : "\(weather.wind.speed * 2.237) mph"

                    self.temperature = "\(Int(temp))°" + (self.isMetric ? "C" : "F")
                    self.feelsLike = "\(Int(feelsLike))°" + (self.isMetric ? "C" : "F")
                    self.maxTemp = "\(Int(maxTemp))°" + (self.isMetric ? "C" : "F")
                    self.humidity = "\(weather.main.humidity)%"
                    self.windSpeed = windSpeed
                    self.pressure = "\(weather.main.pressure) hPa"
                    self.visibility = "\(weather.visibility / 1000) km"
                    self.description = weather.weather.first?.description.capitalized ?? "N/A"
                    self.weatherIcon = self.getWeatherIcon(condition: weather.weather.first?.description ?? "Clear")

                    self.cacheWeatherData(city: city, weather: weather)
                }
                
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }
    
    func fetchForecast(city: String) {
        weatherService.fetchForecast(for: city) { result in
            switch result {
            case .success(let forecasts):
                DispatchQueue.main.async {
                    self.forecast = forecasts
                }
            case .failure(let error):
                print("Error fetching forecast: \(error)")
            }
        }
    }

    // Function to get SF Symbol based on weather condition
    func getWeatherIcon(condition: String) -> String {
        switch condition.lowercased() {
        case "clear sky": return "sun.max.fill"
        case "few clouds", "scattered clouds": return "cloud.sun.fill"
        case "broken clouds", "overcast clouds": return "cloud.fill"
        case "shower rain", "rain": return "cloud.rain.fill"
        case "thunderstorm": return "cloud.bolt.rain.fill"
        case "snow": return "snow"
        case "mist", "fog": return "cloud.fog.fill"
        default: return "few clouds"
        }
    }

    private func cacheWeatherData(city: String, weather: WeatherResponse) {
        let cachedData = [
            "city": city,
            "temperature": weather.main.temp,
            "description": weather.weather.first?.description ?? "N/A"
        ] as [String : Any]
        
        UserDefaults.standard.setValue(cachedData, forKey: "cachedWeather")
    }

    private func loadCachedWeather() {
        if let cachedWeather = UserDefaults.standard.dictionary(forKey: "cachedWeather") {
            DispatchQueue.main.async {
                self.temperature = "\(cachedWeather["temperature"] as? Double ?? 0)°C"
                self.description = cachedWeather["description"] as? String ?? "N/A"
            }
        }
    }

    func scheduleWeatherNotification(temp: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Weather Alert!"
        content.body = temp > 35 ? "It's very hot today! Stay hydrated." : "Cool weather today!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "weather_alert", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
