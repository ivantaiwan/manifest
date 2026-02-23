import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.t(.settingsLanguage, settings.language)) {
                    Picker(L10n.t(.settingsLanguage, settings.language), selection: $settings.language) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.label).tag(language)
                        }
                    }
                }

                Section(L10n.t(.settingsLogin, settings.language)) {
                    Picker(L10n.t(.settingsLogin, settings.language), selection: $settings.preferredLogin) {
                        Text(L10n.t(.loginApple, settings.language)).tag(LoginProvider.apple)
                        Text(L10n.t(.loginGoogle, settings.language)).tag(LoginProvider.google)
                        Text(L10n.t(.loginEmail, settings.language)).tag(LoginProvider.email)
                    }
                    Text(L10n.t(.settingsLoginHint, settings.language))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(L10n.t(.settingsTitle, settings.language))
            .scrollContentBackground(.hidden)
            .manifestBackground()
        }
    }
}
