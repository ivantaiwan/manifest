import SwiftUI

struct GratitudeView: View {
    @ObservedObject var viewModel: GratitudeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("今晚想感謝什麼？")
                        .font(.headline)
                    TextEditor(text: $viewModel.inputText)
                        .frame(minHeight: 130)
                }
                .padding()
                .background(ManifestTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                HStack {
                    Text("心情：\(viewModel.mood)")
                    Slider(value: Binding(
                        get: { Double(viewModel.mood) },
                        set: { viewModel.mood = Int($0) }
                    ), in: 1...5, step: 1)
                }
                .padding(.horizontal)

                Button("儲存今晚感恩") {
                    viewModel.addEntry()
                }
                .buttonStyle(.borderedProminent)
                .tint(ManifestTheme.pink)

                List(viewModel.entries) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.text)
                        Text(entry.createdAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("感恩日記")
            .manifestBackground()
        }
    }
}
