import Foundation
import Combine

@MainActor
final class MorningTodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    @Published var newTaskTitle = ""

    private let persistence = PersistenceService.shared
    private let stateKey = "manifest.morning.todo.state"
    private static let defaultTasks = ["喝一杯溫水", "寫下今天最重要的一件事", "做 5 分鐘伸展"]

    private struct DailyState: Codable {
        let dayKey: String
        var items: [TodoItem]
    }

    init() {
        loadToday()
    }

    var doneCount: Int {
        items.filter(\.isDone).count
    }

    var progress: Double {
        guard items.isEmpty == false else { return 0 }
        return Double(doneCount) / Double(items.count)
    }

    func loadToday() {
        let today = Self.dayKey(for: Date())
        let state = persistence.load(DailyState.self, key: stateKey)

        if let state, state.dayKey == today {
            items = state.items
            return
        }

        items = Self.defaultTasks.map { TodoItem(title: $0) }
        saveToday()
    }

    func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        items.append(TodoItem(title: trimmed))
        newTaskTitle = ""
        saveToday()
    }

    func toggle(_ item: TodoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isDone.toggle()
        saveToday()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            items.remove(at: index)
        }
        saveToday()
    }

    private func saveToday() {
        let state = DailyState(dayKey: Self.dayKey(for: Date()), items: items)
        persistence.save(state, key: stateKey)
    }

    private static func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
