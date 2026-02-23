import Foundation

struct UniverseQuoteService: Sendable {
    nonisolated func randomQuote(for language: AppLanguage) -> String {
        quotes(for: language).randomElement() ?? fallback(for: language)
    }

    nonisolated func quote(at index: Int, language: AppLanguage) -> String {
        let localizedQuotes = quotes(for: language)
        guard localizedQuotes.isEmpty == false else { return fallback(for: language) }
        return localizedQuotes[abs(index) % localizedQuotes.count]
    }

    nonisolated private func fallback(for language: AppLanguage) -> String {
        switch language {
        case .zhHant: return "你已經在對的道路上。"
        case .en: return "You are already on the right path."
        case .ja: return "あなたはもう正しい道にいます。"
        case .ko: return "당신은 이미 올바른 길 위에 있어요."
        }
    }

    nonisolated private func quotes(for language: AppLanguage) -> [String] {
        switch language {
        case .zhHant:
            return [
                "你今天的念頭，正在建造明天的世界。",
                "你值得被好事找到。",
                "放鬆一點，宇宙正在安排。",
                "你專注的地方，能量就流向哪裡。",
                "把焦慮交給宇宙，把行動留給自己。",
                "感謝當下，豐盛就會靠近。",
                "你的心越清晰，路就越明亮。",
                "願望已經在路上，耐心一點。",
                "每個今天，都是重新開始的入口。",
                "此刻就很好，而你會更好。"
            ]
        case .en:
            return [
                "Your thoughts today are shaping tomorrow.",
                "Good things are looking for you too.",
                "Relax. The universe is arranging the details.",
                "Energy flows where your focus goes.",
                "Release worry to the universe and keep your action.",
                "Gratitude opens the door to abundance.",
                "The clearer your heart, the brighter your path.",
                "Your wish is on its way. Stay patient.",
                "Every today is a fresh beginning.",
                "This moment is enough, and you are growing."
            ]
        case .ja:
            return [
                "今日の思考が、明日の世界をつくる。",
                "良いことはあなたを探している。",
                "力を抜いて。宇宙が整えている。",
                "意識を向けた場所にエネルギーは流れる。",
                "不安は宇宙へ、行動は自分へ。",
                "今に感謝すると豊かさが近づく。",
                "心が澄むほど道は明るくなる。",
                "願いはすでに向かってきている。",
                "今日という日は、いつでも再出発の入口。",
                "この瞬間で十分。あなたはもっと良くなる。"
            ]
        case .ko:
            return [
                "오늘의 생각이 내일의 세상을 만듭니다.",
                "좋은 일도 당신을 찾아오고 있어요.",
                "조금만 힘을 빼세요. 우주가 정리 중이에요.",
                "집중하는 곳으로 에너지가 흐릅니다.",
                "불안은 우주에 맡기고 행동은 내가 합니다.",
                "지금에 감사할수록 풍요가 가까워집니다.",
                "마음이 선명할수록 길이 밝아집니다.",
                "소망은 이미 오고 있어요. 조금만 기다려요.",
                "오늘은 언제나 다시 시작할 수 있는 날이에요.",
                "지금도 충분하고, 당신은 더 좋아질 거예요."
            ]
        }
    }
}
