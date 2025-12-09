import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case ocean
    case sunset
    case forest

    var id: String { rawValue }

    var primary: Color {
        switch self {
        case .ocean: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .sunset: return Color(red: 0.95, green: 0.5, blue: 0.3)
        case .forest: return Color(red: 0.3, green: 0.65, blue: 0.5)
        }
    }

    var background: Color {
        switch self {
        case .ocean: return Color(.systemBackground)
        case .sunset: return Color(.systemBackground)
        case .forest: return Color(.systemBackground)
        }
    }

    var textOnPrimary: Color {
        Color.white
    }

    var secondary: Color {
        switch self {
        case .ocean: return Color(red: 0.4, green: 0.6, blue: 0.85)
        case .sunset: return Color(red: 0.98, green: 0.65, blue: 0.5)
        case .forest: return Color(red: 0.5, green: 0.75, blue: 0.6)
        }
    }

    var accent: Color {
        switch self {
        case .ocean: return Color(red: 0.15, green: 0.4, blue: 0.7)
        case .sunset: return Color(red: 0.9, green: 0.4, blue: 0.2)
        case .forest: return Color(red: 0.25, green: 0.55, blue: 0.45)
        }
    }
}
