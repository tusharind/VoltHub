import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var current: Theme {
        didSet { save() }
    }

    private let defaultsKey = "VoltHub.Theme"

    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let theme = try? JSONDecoder().decode(Theme.self, from: data) {
            current = theme
        } else {
            current = .ocean
        }
    }

    func set(_ theme: Theme) {
        current = theme
    }

    private func save() {
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}
