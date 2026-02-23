import SwiftUI

enum ManifestTheme {
    static let pink = Color(red: 0.98, green: 0.62, blue: 0.78)
    static let lilac = Color(red: 0.84, green: 0.72, blue: 0.98)
    static let babyBlue = Color(red: 0.66, green: 0.85, blue: 0.99)
    static let surface = Color.white.opacity(0.84)

    static var appGradient: LinearGradient {
        LinearGradient(
            colors: [pink.opacity(0.32), lilac.opacity(0.32), babyBlue.opacity(0.32)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [pink.opacity(0.20), lilac.opacity(0.18), babyBlue.opacity(0.20)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ManifestBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ManifestTheme.appGradient.ignoresSafeArea())
    }
}

extension View {
    func manifestBackground() -> some View {
        modifier(ManifestBackground())
    }
}
