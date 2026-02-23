import SwiftUI

struct MeditationView: View {
    @ObservedObject var viewModel: MeditationViewModel
    @EnvironmentObject var settings: AppSettingsViewModel
    private let minuteRange = Array(0...180)
    private let secondRange = Array(0...59)

    private var minuteBinding: Binding<Int> {
        Binding(
            get: { Int(viewModel.selectedDuration) / 60 },
            set: { newMinute in
                let seconds = Int(viewModel.selectedDuration) % 60
                viewModel.selectedDuration = TimeInterval((newMinute * 60) + seconds)
            }
        )
    }

    private var secondBinding: Binding<Int> {
        Binding(
            get: { Int(viewModel.selectedDuration) % 60 },
            set: { newSecond in
                let minutes = Int(viewModel.selectedDuration) / 60
                viewModel.selectedDuration = TimeInterval((minutes * 60) + newSecond)
            }
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(L10n.t(.today, settings.language))：\(viewModel.todayText)")
                        .font(.subheadline)
                    Text("\(L10n.t(.streak, settings.language))：\(viewModel.streakDays) \(L10n.t(.dayUnit, settings.language))")
                        .font(.headline)
                    Text("\(L10n.t(.latestCompletion, settings.language))：\(viewModel.lastCompletedText)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(ManifestTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                HStack(spacing: 0) {
                    Picker(L10n.t(.minuteUnit, settings.language), selection: minuteBinding) {
                        ForEach(minuteRange, id: \.self) { minute in
                            Text("\(minute) \(L10n.t(.minuteUnit, settings.language))").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)

                    Picker(L10n.t(.secondUnit, settings.language), selection: secondBinding) {
                        ForEach(secondRange, id: \.self) { second in
                            Text("\(second) \(L10n.t(.secondUnit, settings.language))").tag(second)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .frame(height: 170)
                .background(ManifestTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .disabled(viewModel.isRunning)

                Text(viewModel.timeText())
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(ManifestTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                HStack(spacing: 12) {
                    Button(L10n.t(.start, settings.language)) { viewModel.start() }
                        .buttonStyle(.borderedProminent)
                        .tint(ManifestTheme.lilac)
                        .disabled(viewModel.isRunning)

                    Button(L10n.t(.stop, settings.language)) { viewModel.stop() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isRunning)
                }

                if viewModel.didComplete {
                    Text(L10n.t(.completedMeditation, settings.language))
                        .foregroundStyle(.green)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle(L10n.t(.meditationTitle, settings.language))
            .manifestBackground()
            .onAppear {
                viewModel.applyLanguage(settings.language)
            }
            .onChange(of: settings.language) { _, newLanguage in
                viewModel.applyLanguage(newLanguage)
            }
        }
    }
}
