import Foundation
import Combine

@MainActor
final class MeditationViewModel: ObservableObject {
    @Published var selectedMinutes = 10
    @Published private(set) var remainingSeconds = 0
    @Published private(set) var isRunning = false
    @Published private(set) var didComplete = false

    private var timer: Timer?
    private var endDate: Date?

    func start() {
        let duration = selectedMinutes * 60
        guard duration > 0 else { return }
        didComplete = false
        isRunning = true
        remainingSeconds = duration
        endDate = Date().addingTimeInterval(TimeInterval(duration))

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let viewModel = self else { return }
            Task { @MainActor in
                viewModel.tick()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func timeText() -> String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func tick() {
        guard let endDate else { stop(); return }
        remainingSeconds = max(0, Int(endDate.timeIntervalSinceNow.rounded(.down)))

        if remainingSeconds == 0 {
            stop()
            didComplete = true
        }
    }
}
