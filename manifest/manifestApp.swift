import SwiftUI

@main
struct ManifestApp: App {
    @StateObject private var morningVM = MorningTodoViewModel()
    @StateObject private var gratitudeVM = GratitudeViewModel()
    @StateObject private var meditationVM = MeditationViewModel()
    @StateObject private var universeVM = UniverseViewModel()
    @StateObject private var settingsVM = AppSettingsViewModel()
    @State private var showIntro = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    MorningTodoView(viewModel: morningVM)
                        .environmentObject(settingsVM)
                        .tabItem {
                            Label(L10n.t(.tabMorning, settingsVM.language), systemImage: "sun.max.fill")
                        }

                    GratitudeView(viewModel: gratitudeVM)
                        .environmentObject(settingsVM)
                        .tabItem {
                            Label(L10n.t(.tabGratitude, settingsVM.language), systemImage: "heart.text.square.fill")
                        }

                    MeditationView(viewModel: meditationVM)
                        .environmentObject(settingsVM)
                        .tabItem {
                            Label(L10n.t(.tabMeditation, settingsVM.language), systemImage: "moon.stars.fill")
                        }

                    UniverseView(viewModel: universeVM)
                        .environmentObject(settingsVM)
                        .tabItem {
                            Label(L10n.t(.tabUniverse, settingsVM.language), systemImage: "sparkles")
                        }

                    SettingsView()
                        .environmentObject(settingsVM)
                        .tabItem {
                            Label(L10n.t(.tabSettings, settingsVM.language), systemImage: "gearshape.fill")
                        }
                }
                .tint(ManifestTheme.pink)

                if showIntro {
                    IntroManifestView()
                        .environmentObject(settingsVM)
                        .transition(.opacity)
                        .zIndex(10)
                }
            }
            .task {
                await universeVM.bootstrapNotifications()
                if showIntro {
                    try? await Task.sleep(for: .seconds(1.8))
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showIntro = false
                    }
                }
            }
        }
    }
}
