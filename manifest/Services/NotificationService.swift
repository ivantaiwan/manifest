import Foundation
import UserNotifications

actor NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    private let quoteService = UniverseQuoteService()
    private let prefix = "manifest.universe.quote."

    func requestPermission() async {
        _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
    }

    func rescheduleEveryThreeHours(language: AppLanguage) async {
        let pending = await center.pendingNotificationRequests()
        let oldIds = pending
            .filter { $0.identifier.hasPrefix(prefix) }
            .map(\.identifier)
        center.removePendingNotificationRequests(withIdentifiers: oldIds)

        let hours = stride(from: 0, through: 21, by: 3)
        for (index, hour) in hours.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = localizedNotificationTitle(language: language)
            content.body = quoteService.quote(at: index, language: language)
            content.sound = .default

            var components = DateComponents()
            components.hour = hour
            components.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

            let request = UNNotificationRequest(
                identifier: "\(prefix)\(hour)",
                content: content,
                trigger: trigger
            )
            try? await center.add(request)
        }
    }

    private func localizedNotificationTitle(language: AppLanguage) -> String {
        switch language {
        case .zhHant: return "宇宙小語"
        case .en: return "Universe Quote"
        case .ja: return "宇宙メッセージ"
        case .ko: return "우주 문구"
        }
    }
}
