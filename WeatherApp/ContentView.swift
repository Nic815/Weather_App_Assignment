//
//  ContentView.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentWeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }

            ForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "calendar")
                }

            WeatherMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .navigationBarHidden(true)
        }
    }
}
