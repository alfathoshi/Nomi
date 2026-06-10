//
//  ContentView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

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
        .onAppear {
            if scenePhase == .active {
                AppUsageTracker.shared.start()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                AppUsageTracker.shared.start()
            } else {
                AppUsageTracker.shared.stop()
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
            MainNavigationView {
                nextLaunchPhase = nil
                isSplashVisible = true
                launchPhase = .splash
            }
        }
    }
}

private enum LaunchPhase: Equatable {
    case splash
    case onboarding
    case main
}

private struct MainNavigationView: View {
    let onLogout: () -> Void

    @State private var showRoadmap = false
    @State private var showParentZone = false

    var body: some View {
        NavigationStack {
            HomeScreen(
                onOpenParent: {
                    showParentZone = true
                },
                onOpenRoadmap: {
                    showRoadmap = true
                }
            )
            .navigationDestination(isPresented: $showRoadmap) {
                RoadmapScreen {
                    showRoadmap = false
                }
            }
            .navigationDestination(isPresented: $showParentZone) {
                ParentZoneView(
                    onExit: {
                        showParentZone = false
                    },
                    onLogout: onLogout
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
