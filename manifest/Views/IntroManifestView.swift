import SwiftUI

struct IntroManifestView: View {
    @EnvironmentObject var settings: AppSettingsViewModel
    @State private var visible = false
    @State private var quote = UniverseQuoteService().randomQuote(for: .zhHant)
    let onEnter: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [ManifestTheme.pink.opacity(0.35), ManifestTheme.lilac.opacity(0.35), ManifestTheme.babyBlue.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("manifest")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ManifestTheme.pink, ManifestTheme.lilac, ManifestTheme.babyBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text(quote)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary.opacity(0.85))
                    .padding(.horizontal, 24)
            }
            .padding(.vertical, 36)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 28)
            .opacity(visible ? 1 : 0)
            .scaleEffect(visible ? 1 : 0.96)
            .animation(.easeOut(duration: 0.45), value: visible)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEnter()
        }
        .onAppear {
            quote = UniverseQuoteService().randomQuote(for: settings.language)
            visible = true
        }
        .onChange(of: settings.language) { _, newLanguage in
            quote = UniverseQuoteService().randomQuote(for: newLanguage)
        }
    }
}
