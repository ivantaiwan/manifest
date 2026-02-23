import Foundation
import Combine

@MainActor
final class MorningTodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    @Published var newTaskTitle = ""

    private let persistence = PersistenceService.shared
    private let defaults = UserDefaults.standard
    private let stateKey = "manifest.morning.todo.state"
    private let languageKey = "manifest.settings.language"
    private static let legacyDefaultTasks: Set<String> = [
        "喝一杯溫水",
        "寫下今天最重要的一件事",
        "做 5 分鐘伸展"
    ]

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
            migrateLegacySeedIfNeeded()
            return
        }

        items = [TodoItem(title: defaultTaskTitle())]
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

    func updateTask(id: UUID, newTitle: String) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].title = trimmed
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

    private func defaultTaskTitle() -> String {
        let languageRaw = defaults.string(forKey: languageKey) ?? AppLanguage.zhHant.rawValue
        let language = AppLanguage(rawValue: languageRaw) ?? .zhHant
        return L10n.t(.defaultMorningTodo, language)
    }

    private func migrateLegacySeedIfNeeded() {
        guard items.count == 3 else { return }
        let allLegacy = items.allSatisfy { Self.legacyDefaultTasks.contains($0.title) }
        let untouched = items.allSatisfy { !$0.isDone }
        guard allLegacy && untouched else { return }
        items = [TodoItem(title: defaultTaskTitle())]
        saveToday()
    }

    private static func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
