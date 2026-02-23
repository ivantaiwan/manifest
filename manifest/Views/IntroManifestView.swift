import SwiftUI

struct IntroManifestView: View {
    @EnvironmentObject var settings: AppSettingsViewModel
    @State private var visible = false

    var body: some View {
        ZStack {
            ManifestTheme.appGradient
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

                Text(L10n.t(.universeQuote, settings.language))
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(launchSubtitle)
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
        .onAppear {
            visible = true
        }
    }

    private var launchSubtitle: String {
        switch settings.language {
        case .zhHant: return "你的意圖，正在成形。"
        case .en: return "Your intention is taking shape."
        case .ja: return "あなたの意図は、今かたちになる。"
        case .ko: return "당신의 의도가 형태를 갖추고 있어요."
        }
    }
}
