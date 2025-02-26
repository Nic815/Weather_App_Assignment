//
//  WeatherWidget.swift
//  WeatherApp
//
//  Created by NIKHIL on 26/02/25.
//
import WidgetKit
import SwiftUI

// Define a timeline entry model
struct WeatherEntry: TimelineEntry {
    let date: Date
    let temperature: String
}

// Create the timeline provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: "--°C")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(date: Date(), temperature: "25°C")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

        let entry = WeatherEntry(date: currentDate, temperature: "25°C")
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))

        completion(timeline)
    }
}

// Define the widget UI
struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Weather")
                .font(.headline)
            Text(entry.temperature)
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}

// Define the widget configuration
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Displays current temperature.")
        .supportedFamilies([.systemSmall])
    }
}

// Register the widget
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
    }
}
