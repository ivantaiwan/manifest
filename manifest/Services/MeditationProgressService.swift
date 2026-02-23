import Foundation

struct MeditationProgress: Codable {
    var streakDays: Int
    var lastCompletedDayKey: String?
    var completedDayKeys: [String]

    static let empty = MeditationProgress(streakDays: 0, lastCompletedDayKey: nil, completedDayKeys: [])
}

final class MeditationProgressService {
    private let persistence = PersistenceService.shared
    private let key = "manifest.meditation.progress"
    private let calendar = Calendar(identifier: .gregorian)

    func load() -> MeditationProgress {
        persistence.load(MeditationProgress.self, key: key) ?? .empty
    }

    func markCompleted(on date: Date = Date()) -> MeditationProgress {
        var progress = load()
        let todayKey = dayKey(for: date)

        if progress.lastCompletedDayKey == todayKey {
            return progress
        }

        if
            let lastKey = progress.lastCompletedDayKey,
            let lastDate = dayDate(from: lastKey),
            let yesterday = calendar.date(byAdding: .day, value: -1, to: date),
            calendar.isDate(lastDate, inSameDayAs: yesterday)
        {
            progress.streakDays += 1
        } else {
            progress.streakDays = 1
        }

        progress.lastCompletedDayKey = todayKey
        if progress.completedDayKeys.contains(todayKey) == false {
            progress.completedDayKeys.append(todayKey)
        }
        persistence.save(progress, key: key)
        return progress
    }

    func formatDate(_ date: Date = Date(), language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale(for: language)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    func formatDayKey(_ dayKey: String?, language: AppLanguage) -> String {
        guard let dayKey, let date = dayDate(from: dayKey) else { return L10n.t(.notCompletedYet, language) }
        return formatDate(date, language: language)
    }

    private func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func dayDate(from dayKey: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dayKey)
    }

    private func locale(for language: AppLanguage) -> Locale {
        switch language {
        case .zhHant:
            return Locale(identifier: "zh-Hant-TW")
        case .en:
            return Locale(identifier: "en_US")
        case .ja:
            return Locale(identifier: "ja_JP")
        case .ko:
            return Locale(identifier: "ko_KR")
        }
    }
}
