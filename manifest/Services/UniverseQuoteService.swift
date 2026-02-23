import Foundation

struct UniverseQuoteService: Sendable {
    let quotes: [String]

    nonisolated init(quotes: [String] = UniverseQuoteService.defaultQuotes) {
        self.quotes = quotes
    }

    nonisolated func randomQuote() -> String {
        quotes.randomElement() ?? "你已經在對的道路上。"
    }

    nonisolated func quote(at index: Int) -> String {
        guard quotes.isEmpty == false else { return "你已經在對的道路上。" }
        return quotes[abs(index) % quotes.count]
    }

    nonisolated static let defaultQuotes: [String] = [
        "你今天的念頭，正在建造明天的世界。",
        "你值得被好事找到。",
        "放鬆一點，宇宙正在安排。",
        "當你準備好，機會就會現身。",
        "你專注的地方，能量就流向哪裡。",
        "相信你已經被支持著。",
        "每一次深呼吸，都是回到力量中心。",
        "你不是太慢，你正在準時抵達。",
        "把焦慮交給宇宙，把行動留給自己。",
        "今天也允許自己閃閃發光。",
        "你內在的平靜，比外在的喧囂更真實。",
        "改變從一個小決定開始。",
        "你比自己想像的更有韌性。",
        "感謝當下，豐盛就會靠近。",
        "今天會有一件小驚喜等你。",
        "你的心越清晰，路就越明亮。",
        "你正在吸引與你頻率相同的美好。",
        "保持善意，就是最強大的顯化。",
        "願望已經在路上，耐心一點。",
        "先成為那個版本的你，好事就會跟上。",
        "每個今天，都是重新開始的入口。",
        "你釋放的愛，會以不同形式回來。",
        "讓身體放鬆，答案會浮現。",
        "你所期待的，也正在期待你。",
        "你的存在，本身就有價值。",
        "把注意力放在可能，而不是恐懼。",
        "你正在學會與宇宙同頻。",
        "一切都在為你最好的版本服務。",
        "穩穩地走，你會走到想去的地方。",
        "此刻就很好，而你會更好。"
    ]
}
