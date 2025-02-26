//
//  SettingsView.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings  //  Use global settings
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("unit") private var isMetric = true

    var body: some View {
        VStack(spacing: 20) {
            
            Text("\(weatherViewModel.selectedCity)")
                .padding()
            
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()

            Toggle("Use Metric Units", isOn: $isMetric)
                .padding()

            // Font Size Slider
            VStack {
                Text("Font Size: \(Int(appSettings.fontSize))")
                    .font(.system(size: CGFloat(appSettings.fontSize)))
                Slider(value: $appSettings.fontSize, in: 12...30, step: 1)
                    .padding()
            }

            // Text Color Picker
            Picker("Text Color", selection: $appSettings.textColor) {
                Text("Black").tag("Black")
                Text("Blue").tag("Blue")
                Text("Red").tag("Red")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Spacer()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)  // ✅ Dark mode applies globally
    }
}
