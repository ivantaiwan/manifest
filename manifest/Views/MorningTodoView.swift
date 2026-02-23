import SwiftUI

struct MorningTodoView: View {
    @ObservedObject var viewModel: MorningTodoViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("今日進度")
                        .font(.headline)
                    Text("\(viewModel.doneCount)/\(max(viewModel.items.count, 1)) 已完成")
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
                    TextField("新增待辦", text: $viewModel.newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                    Button("新增") { viewModel.addTask() }
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
                    }
                    .onDelete(perform: viewModel.delete)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("早上 To-Do")
            .manifestBackground()
        }
    }
}
