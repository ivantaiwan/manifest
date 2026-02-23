import PhotosUI
import SwiftUI
import ImageIO

struct GratitudeView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @EnvironmentObject var settings: AppSettingsViewModel

    @State private var selectedEntry: GratitudeEntry?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoAlert = false

    private let moodItems: [(value: Int, emoji: String)] = [
        (1, "😔"), (2, "🙂"), (3, "😊"), (4, "😄"), (5, "🤩")
    ]

    private var filteredEntries: [GratitudeEntry] {
        viewModel.entries(for: viewModel.selectedDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                editorCard
                moodPicker
                photoPickerCard
                saveButton
                datePickerBar
                entriesList
            }
            .navigationTitle(L10n.t(.gratitudeTitle, settings.language))
            .manifestBackground()
            .sheet(item: $selectedEntry) { entry in
                GratitudeDetailCard(entry: entry, language: settings.language) {
                    selectedEntry = nil
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            if isPhotoFromToday(data) {
                                viewModel.pendingImageData = data
                            } else {
                                viewModel.pendingImageData = nil
                                showPhotoAlert = true
                            }
                        }
                    }
                }
            }
            .alert("這張照片不是今天拍的", isPresented: $showPhotoAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("感恩日記目前只允許上傳當天拍攝的照片。")
            }
        }
    }

    private var editorCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.t(.gratitudePrompt, settings.language))
                .font(.headline)
            TextEditor(text: $viewModel.inputText)
                .frame(minHeight: 120)
        }
        .padding()
        .background(ManifestTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(L10n.t(.mood, settings.language))：\(viewModel.mood)")
                .font(.subheadline.weight(.semibold))
            HStack(spacing: 10) {
                ForEach(moodItems, id: \.value) { mood in
                    MoodChip(emoji: mood.emoji, selected: viewModel.mood == mood.value) {
                        viewModel.mood = mood.value
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var photoPickerCard: some View {
        HStack(spacing: 10) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                Label("選擇當天照片（可選）", systemImage: "photo")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.bordered)

            if let imageData = viewModel.pendingImageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var saveButton: some View {
        Button(L10n.t(.saveGratitude, settings.language)) {
            viewModel.addEntry()
        }
        .buttonStyle(.borderedProminent)
        .tint(ManifestTheme.pink)
    }

    private var datePickerBar: some View {
        DatePicker(
            "日曆",
            selection: $viewModel.selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.compact)
        .padding(.horizontal)
    }

    private var entriesList: some View {
        List(filteredEntries) { entry in
            Button {
                selectedEntry = entry
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(firstLine(of: entry.text))
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                    Text(entry.createdAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }

    private func firstLine(of text: String) -> String {
        let line = text.split(whereSeparator: \.isNewline).first.map(String.init)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return (line?.isEmpty == false ? line! : text).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func isPhotoFromToday(_ data: Data) -> Bool {
        guard
            let source = CGImageSourceCreateWithData(data as CFData, nil),
            let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
        else {
            return false
        }

        let exif = metadata[kCGImagePropertyExifDictionary] as? [CFString: Any]
        let tiff = metadata[kCGImagePropertyTIFFDictionary] as? [CFString: Any]
        let dateString =
            (exif?[kCGImagePropertyExifDateTimeOriginal] as? String) ??
            (tiff?[kCGImagePropertyTIFFDateTime] as? String)

        guard let dateString else { return false }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else { return false }
        return Calendar.current.isDateInToday(date)
    }
}

private struct MoodChip: View {
    let emoji: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.title3)
                .frame(width: 44, height: 44)
                .background(backgroundShape)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selected ? ManifestTheme.pink : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundShape: some View {
        if selected {
            RoundedRectangle(cornerRadius: 12).fill(ManifestTheme.cardGradient)
        } else {
            RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.7))
        }
    }
}

private struct GratitudeDetailCard: View {
    let entry: GratitudeEntry
    let language: AppLanguage
    let onDone: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    if let imageData = entry.imageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 190)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Text(entry.createdAt, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(L10n.t(.mood, language))：\(entry.mood)")
                        .font(.subheadline.weight(.semibold))
                    Text(entry.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(ManifestTheme.cardGradient)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding()
            }
            .navigationTitle(L10n.t(.gratitudeTitle, language))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: onDone)
                }
            }
            .manifestBackground()
        }
        .presentationDetents([.medium, .large])
    }
}
