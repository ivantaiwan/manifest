import SwiftUI

struct UniverseView: View {
    @ObservedObject var viewModel: UniverseViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("宇宙小語")
                    .font(.title2.bold())

                Text(viewModel.currentQuote)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ManifestTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                Button("換一句") {
                    viewModel.refreshQuote()
                }
                .buttonStyle(.borderedProminent)
                .tint(ManifestTheme.babyBlue)

                Text("通知會每天每 3 小時循環，並直接顯示一句宇宙小語")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("宇宙")
            .manifestBackground()
        }
    }
}
