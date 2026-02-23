import SwiftUI

@main
struct ManifestApp: App {
    @StateObject private var morningVM = MorningTodoViewModel()
    @StateObject private var gratitudeVM = GratitudeViewModel()
    @StateObject private var meditationVM = MeditationViewModel()
    @StateObject private var universeVM = UniverseViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                MorningTodoView(viewModel: morningVM)
                    .tabItem {
                        Label("早晨", systemImage: "sun.max.fill")
                    }

                GratitudeView(viewModel: gratitudeVM)
                    .tabItem {
                        Label("感恩", systemImage: "heart.text.square.fill")
                    }

                MeditationView(viewModel: meditationVM)
                    .tabItem {
                        Label("冥想", systemImage: "moon.stars.fill")
                    }

                UniverseView(viewModel: universeVM)
                    .tabItem {
                        Label("宇宙", systemImage: "sparkles")
                    }
            }
            .tint(ManifestTheme.pink)
            .task {
                await universeVM.bootstrapNotifications()
            }
        }
    }
}
