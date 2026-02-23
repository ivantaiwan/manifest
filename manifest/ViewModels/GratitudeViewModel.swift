import Foundation
import Combine

@MainActor
final class GratitudeViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var mood = 3
    @Published var selectedDate = Date()
    @Published var pendingImageData: Data?
    @Published private(set) var entries: [GratitudeEntry] = []

    private let persistence = PersistenceService.shared
    private let key = "manifest.gratitude.entries"

    init() {
        entries = persistence.load([GratitudeEntry].self, key: key) ?? []
        entries.sort { $0.createdAt > $1.createdAt }
    }

    func addEntry() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        let entry = GratitudeEntry(text: trimmed, mood: mood, imageData: pendingImageData)
        entries.insert(entry, at: 0)
        persistence.save(entries, key: key)
        inputText = ""
        mood = 3
        pendingImageData = nil
        selectedDate = Date()
    }

    func entries(for date: Date) -> [GratitudeEntry] {
        let cal = Calendar.current
        return entries.filter { cal.isDate($0.createdAt, inSameDayAs: date) }
    }
}
