import Foundation

struct GratitudeEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    var text: String
    var mood: Int
    var imageData: Data?

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        text: String,
        mood: Int,
        imageData: Data? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.mood = max(1, min(5, mood))
        self.imageData = imageData
    }
}
