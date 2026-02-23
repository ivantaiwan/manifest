import Foundation
import Combine

@MainActor
final class UniverseViewModel: ObservableObject {
    @Published private(set) var currentQuote: String

    private let quoteService = UniverseQuoteService()

    init() {
        currentQuote = quoteService.randomQuote(for: .zhHant)
    }

    func refreshQuote(language: AppLanguage) {
        currentQuote = quoteService.randomQuote(for: language)
    }

    func bootstrapNotifications(language: AppLanguage) async {
        await NotificationService.shared.requestPermission()
        await NotificationService.shared.rescheduleEveryThreeHours(language: language)
    }
}
