//
//  WeatherMapView.swift
//  WeatherApp
//
//  Created by NIKHIL on 26/02/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct WeatherMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            // Map showing user location
            Map(position: $position) {
                if let userLocation = locationManager.userLocation {
                    Marker("You Are Here", coordinate: userLocation.coordinate)
                }
            }
            .edgesIgnoringSafeArea(.all)

            // Floating arrow button to re-center map and zoom in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if let userLocation = locationManager.userLocation {
                            withAnimation(.easeInOut(duration: 0.5)) {  // Smooth zoom-in animation
                                position = .region(
                                    MKCoordinateRegion(
                                        center: userLocation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // More zoomed-in view
                                    )
                                )
                            }
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if let userLocation = locationManager.userLocation {
                position = .region(
                    MKCoordinateRegion(
                        center: userLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Default zoom-out level
                    )
                )
            }
        }
    }
}
