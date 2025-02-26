//
//  ForecastView.swift
//  WeatherApp
//
//  Created by NIKHIL on 25/02/25.
//

import SwiftUI

struct ForecastView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var city: String = "India"

    var body: some View {
        VStack {
           
            TextField("Enter City", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                weatherViewModel.fetchForecast(city: city)
            }) {
                Text("Get Forecast")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            List(weatherViewModel.forecast) { forecast in
                HStack {
                    Text(Date(timeIntervalSince1970: forecast.date), style: .date)
                    Spacer()
                    Text("\(Int(forecast.temp))°C")
                    Text(forecast.description.capitalized)
                }
            }
        }
        .onAppear {
            weatherViewModel.fetchForecast(city: city)
        }
    }
}
