import SwiftUI

struct UniverseView: View {
    @ObservedObject var viewModel: UniverseViewModel
    @EnvironmentObject var settings: AppSettingsViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(L10n.t(.universeQuote, settings.language))
                    .font(.title2.bold())

                Text(viewModel.currentQuote)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ManifestTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                Button(L10n.t(.changeQuote, settings.language)) {
                    viewModel.refreshQuote(language: settings.language)
                }
                .buttonStyle(.borderedProminent)
                .tint(ManifestTheme.babyBlue)

                Text(L10n.t(.quoteNoticeHint, settings.language))
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.top)
            .navigationTitle(L10n.t(.universeTitle, settings.language))
            .manifestBackground()
            .onAppear {
                viewModel.refreshQuote(language: settings.language)
            }
            .onChange(of: settings.language) { _, newLanguage in
                viewModel.refreshQuote(language: newLanguage)
            }
        }
    }
}
