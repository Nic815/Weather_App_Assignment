//
//  AppSettings.swift
//  WeatherApp
//
//  Created by NIKHIL on 26/02/25.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var fontSize: Double {
        didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") }
    }

    @Published var textColor: String {
        didSet { UserDefaults.standard.set(textColor, forKey: "textColor") }
    }

    init() {
        self.fontSize = UserDefaults.standard.double(forKey: "fontSize") == 0 ? 16 : UserDefaults.standard.double(forKey: "fontSize")
        self.textColor = UserDefaults.standard.string(forKey: "textColor") ?? "Black"
    }

    func getTextColor() -> Color {
        switch textColor {
        case "Black": return .black
        case "Blue": return .blue
        case "Red": return .red
        default: return .black
        }
    }
}
