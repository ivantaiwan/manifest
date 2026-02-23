import Combine
import Foundation

@MainActor
final class AppSettingsViewModel: ObservableObject {
    @Published var language: AppLanguage {
        didSet { defaults.set(language.rawValue, forKey: languageKey) }
    }

    @Published var preferredLogin: LoginProvider {
        didSet { defaults.set(preferredLogin.rawValue, forKey: loginKey) }
    }

    private let defaults = UserDefaults.standard
    private let languageKey = "manifest.settings.language"
    private let loginKey = "manifest.settings.loginProvider"

    init() {
        let rawLanguage = defaults.string(forKey: languageKey) ?? AppLanguage.zhHant.rawValue
        language = AppLanguage(rawValue: rawLanguage) ?? .zhHant

        let rawLogin = defaults.string(forKey: loginKey) ?? LoginProvider.apple.rawValue
        preferredLogin = LoginProvider(rawValue: rawLogin) ?? .apple
    }
}
