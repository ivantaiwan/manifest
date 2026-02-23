import AVFoundation
import Foundation

final class MeditationAudioService {
    static let shared = MeditationAudioService()

    private var player: AVAudioPlayer?
    private let candidates: [(name: String, ext: String)] = [
        ("meditation_bg_1", "m4a"),
        ("meditation_bg_2", "m4a"),
        ("meditation_bg_1", "mp3"),
        ("meditation_bg_2", "mp3"),
        ("meditation_bg_1", "wav"),
        ("meditation_bg_2", "wav"),
    ]

    private init() {}

    func playCue() {
        let urls = candidates.compactMap { Bundle.main.url(forResource: $0.name, withExtension: $0.ext) }
        guard let url = urls.randomElement() else {
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            if let duration = player?.duration, duration > 1 {
                let safeEnd = max(0.0, duration - 1.0)
                player?.currentTime = Double.random(in: 0.0...safeEnd)
            }
            player?.prepareToPlay()
            player?.play()
        } catch {
            player = nil
        }
    }

    func stop() {
        player?.stop()
    }
}
