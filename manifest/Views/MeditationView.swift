import SwiftUI

struct MeditationView: View {
    @ObservedObject var viewModel: MeditationViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                    Button("開始") { viewModel.start() }
                        .buttonStyle(.borderedProminent)
                        .tint(ManifestTheme.lilac)
                        .disabled(viewModel.isRunning)

                    Button("停止") { viewModel.stop() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isRunning)
                }

                if viewModel.didComplete {
                    Text("你完成了一次睡前冥想")
                        .foregroundStyle(.green)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("睡前冥想")
            .manifestBackground()
        }
    }
}
