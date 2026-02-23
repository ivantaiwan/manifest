import SwiftUI

struct MeditationView: View {
    @ObservedObject var viewModel: MeditationViewModel
    @EnvironmentObject var settings: AppSettingsViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(L10n.t(.today, settings.language))：\(viewModel.todayText)")
                        .font(.subheadline)
                    Text("\(L10n.t(.streak, settings.language))：\(viewModel.streakDays) 日")
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

                Picker("分鐘", selection: $viewModel.selectedMinutes) {
                    Text("5 分").tag(5)
                    Text("10 分").tag(10)
                    Text("15 分").tag(15)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

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
        }
    }
}
