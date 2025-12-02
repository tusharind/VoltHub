import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case ocean
    case sunset
    case forest

    var id: String { rawValue }

    var primary: Color {
        switch self {
        case .ocean: return Color.blue
        case .sunset: return Color.orange
        case .forest: return Color.green
        }
    }

    var background: Color {
        switch self {
        case .ocean: return Color(.systemGray6)
        case .sunset: return Color(.systemGray6)
        case .forest: return Color(.systemGray6)
        }
    }

    var textOnPrimary: Color {
        Color.white
    }
}
