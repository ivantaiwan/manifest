import SwiftUI

struct MorningTodoView: View {
    @ObservedObject var viewModel: MorningTodoViewModel
    @EnvironmentObject var settings: AppSettingsViewModel
    @State private var editingItem: TodoItem?
    @State private var editingText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.t(.progress, settings.language))
                        .font(.headline)
                    Text("\(viewModel.doneCount)/\(max(viewModel.items.count, 1)) \(L10n.t(.doneProgress, settings.language))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ProgressView(value: viewModel.progress)
                        .tint(ManifestTheme.pink)
                }
                .padding()
                .background(ManifestTheme.cardGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                HStack {
                    TextField(L10n.t(.addTodoPlaceholder, settings.language), text: $viewModel.newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                    Button(L10n.t(.add, settings.language)) { viewModel.addTask() }
                        .buttonStyle(.borderedProminent)
                        .tint(ManifestTheme.lilac)
                }
                .padding(.horizontal)

                List {
                    ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { idx, item in
                        Button {
                            viewModel.toggle(item)
                        } label: {
                            HStack(spacing: 10) {
                                Text("\(idx + 1).")
                                    .foregroundStyle(.secondary)
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isDone ? .green : ManifestTheme.babyBlue)
                                Text(item.title)
                                    .foregroundStyle(.primary)
                                    .strikethrough(item.isDone)
                                Spacer()
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                editingItem = item
                                editingText = item.title
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(ManifestTheme.babyBlue)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let realIndex = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                    viewModel.delete(at: IndexSet(integer: realIndex))
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle(L10n.t(.morningTitle, settings.language))
            .manifestBackground()
            .alert(L10n.t(.addTodoPlaceholder, settings.language), isPresented: Binding(
                get: { editingItem != nil },
                set: { if !$0 { editingItem = nil } }
            )) {
                TextField(L10n.t(.addTodoPlaceholder, settings.language), text: $editingText)
                Button(L10n.t(.ok, settings.language)) {
                    guard let item = editingItem else { return }
                    viewModel.updateTask(id: item.id, newTitle: editingText)
                    editingItem = nil
                }
                Button(L10n.t(.cancel, settings.language), role: .cancel) {
                    editingItem = nil
                }
            }
        }
    }
}
