//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//
import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            // Static Background Image
            Image("gg")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Search Bar at the Top
                HStack {
                    TextField("Enter City", text: $weatherViewModel.selectedCity) // Use stored city
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        weatherViewModel.fetchWeather(city: weatherViewModel.selectedCity) // Corrected function call
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Weather Icon
                if let icon = weatherViewModel.weatherIcon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .padding()
                }

                // Weather Description
                Text(weatherViewModel.description)
                    .font(.system(size: CGFloat(appSettings.fontSize))) // Applied global font size
                    .bold()
                    .foregroundColor(appSettings.getTextColor()) // Applied global text color

                // Temperature Display
                Text(weatherViewModel.temperature)
                    .font(.system(size: 50))
                    .bold()
                    .foregroundColor(appSettings.getTextColor()) // Applied global text color

                // Weather Details
                VStack(spacing: 10) {
                    HStack {
                        WeatherDetailView(label: "Humidity", value: weatherViewModel.humidity)
                        WeatherDetailView(label: "Wind Speed", value: weatherViewModel.windSpeed)
                    }

                    HStack {
                        WeatherDetailView(label: "Pressure", value: weatherViewModel.pressure)
                        WeatherDetailView(label: "Visibility", value: weatherViewModel.visibility)
                    }

                    HStack {
                        WeatherDetailView(label: "Feels Like", value: weatherViewModel.feelsLike)
                        WeatherDetailView(label: "Max Temp", value: weatherViewModel.maxTemp)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                .padding()

                Spacer()
            }
        }
        .onAppear {
            weatherViewModel.fetchWeather(city: weatherViewModel.selectedCity) // Corrected fetchWeather call
        }
    }
}

// Weather Detail View Component
struct WeatherDetailView: View {
    let label: String
    let value: String
    
    @EnvironmentObject var appSettings: AppSettings // Now appSettings is accessible

    var body: some View {
        VStack {
            Text(label)
                .font(.system(size: CGFloat(appSettings.fontSize))) // Applied font size
                .foregroundColor(appSettings.getTextColor()) // Applied text color
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 120, height: 70)
        .background(Color.blue.opacity(0.6))
        .cornerRadius(10)
    }
}
