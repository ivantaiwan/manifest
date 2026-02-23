import Foundation
import Combine

@MainActor
final class MeditationViewModel: ObservableObject {
    @Published var selectedDuration: TimeInterval = 10 * 60 {
        didSet {
            if !isRunning {
                remainingSeconds = Int(selectedDuration.rounded())
            }
        }
    }
    @Published private(set) var remainingSeconds = 0
    @Published private(set) var isRunning = false
    @Published private(set) var didComplete = false
    @Published private(set) var streakDays = 0
    @Published private(set) var todayText = ""
    @Published private(set) var lastCompletedText = ""

    private var timer: Timer?
    private var endDate: Date?
    private var currentLanguage: AppLanguage = .zhHant
    private let progressService = MeditationProgressService()
    private let audioService = MeditationAudioService.shared

    init() {
        let progress = progressService.load()
        streakDays = progress.streakDays
        remainingSeconds = Int(selectedDuration)
        applyLanguage(.zhHant)
    }

    func start() {
        let duration = Int(selectedDuration.rounded())
        guard duration > 0 else { return }
        didComplete = false
        isRunning = true
        remainingSeconds = duration
        endDate = Date().addingTimeInterval(TimeInterval(duration))
        audioService.playCue()

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
        audioService.stop()
    }

    func timeText() -> String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func applyLanguage(_ language: AppLanguage) {
        currentLanguage = language
        let progress = progressService.load()
        todayText = progressService.formatDate(Date(), language: language)
        lastCompletedText = progressService.formatDayKey(progress.lastCompletedDayKey, language: language)
    }

    private func tick() {
        guard let endDate else { stop(); return }
        remainingSeconds = max(0, Int(endDate.timeIntervalSinceNow.rounded(.down)))

        if remainingSeconds == 0 {
            stop()
            didComplete = true
            let progress = progressService.markCompleted(on: Date())
            streakDays = progress.streakDays
            todayText = progressService.formatDate(Date(), language: currentLanguage)
            lastCompletedText = progressService.formatDayKey(progress.lastCompletedDayKey, language: currentLanguage)
        }
    }
}
