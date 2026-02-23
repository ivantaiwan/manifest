import Foundation

struct GratitudeEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    var text: String
    var mood: Int

    init(id: UUID = UUID(), createdAt: Date = Date(), text: String, mood: Int) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.mood = max(1, min(5, mood))
    }
}
