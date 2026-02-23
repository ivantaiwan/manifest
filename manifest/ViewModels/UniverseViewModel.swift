import Foundation
import Combine

@MainActor
final class UniverseViewModel: ObservableObject {
    @Published private(set) var currentQuote: String

    private let quoteService = UniverseQuoteService()

    init() {
        currentQuote = quoteService.randomQuote()
    }

    func refreshQuote() {
        currentQuote = quoteService.randomQuote()
    }

    func bootstrapNotifications() async {
        await NotificationService.shared.requestPermission()
        await NotificationService.shared.rescheduleEveryThreeHours()
    }
}
