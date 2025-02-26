//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(weatherViewModel)
                    .environmentObject(appSettings) 
            }
        }
    }
}
