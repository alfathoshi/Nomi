//
//  ContentView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

enum Route: Hashable {
    case parentPasscode
    case parentDashboard
}

struct ContentView: View {
    @State private var launchPhase: LaunchPhase = .splash
    @State private var isSplashVisible = true
    @State private var nextLaunchPhase: LaunchPhase?

    var body: some View {
        ZStack {
            if let nextLaunchPhase {
                launchDestination(for: nextLaunchPhase)
                    .opacity(isSplashVisible ? 0 : 1)
            } else if launchPhase != .splash {
                launchDestination(for: launchPhase)
            }

            if launchPhase == .splash {
                SplashScreen { hasProfile in
                    finishSplash(hasProfile: hasProfile)
                }
                .opacity(isSplashVisible ? 1 : 0)
            }
        }
    }

    private func finishSplash(hasProfile: Bool) {
        guard nextLaunchPhase == nil else { return }
        nextLaunchPhase = hasProfile ? .main : .onboarding

        withAnimation(.easeInOut(duration: 0.45)) {
            isSplashVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            launchPhase = nextLaunchPhase ?? .main
            nextLaunchPhase = nil
            isSplashVisible = true
        }
    }

    @ViewBuilder
    private func launchDestination(for phase: LaunchPhase) -> some View {
        switch phase {
        case .splash:
            EmptyView()
        case .onboarding:
            NavigationStack {
                OnBoardingView {
                    launchPhase = .main
                }
            }
        case .main:
            MainNavigationView()
        }
    }
}

private enum LaunchPhase: Equatable {
    case splash
    case onboarding
    case main
}

private struct MainNavigationView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeScreen {
                path.append(Route.parentPasscode)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .parentPasscode:
                    ParentZoneView(path: $path)
                case .parentDashboard:
                    ParentDashboardView {
                        path = NavigationPath()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
