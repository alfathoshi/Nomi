//
//  Level1LaunchView.swift
//  Nomi
//

import SwiftUI

struct Level1LaunchView: View {
    @Environment(\.returnToRoadmap) private var returnToRoadmap

    var onReturnHome: () -> Void = {}

    private enum Phase {
        case preparing
        case rotating
        case story
        case returning
    }

    @State private var phase: Phase = .preparing
    @State private var launchTask: Task<Void, Never>?

    var body: some View {
        Group {
            if phase == .story {
                LandscapeStoryScreen(onHome: returnHomeFromStory)
                    .environment(\.returnToRoadmap, returnFromStory)
            } else {
                bridgeScreen
            }
        }
        .onAppear {
            startLaunch()
        }
        .onDisappear {
            launchTask?.cancel()
            rotateToPortrait()
        }
    }

    private var bridgeScreen: some View {
        GeometryReader { geo in
            ZStack {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.8)
                        .tint(.nomiPrimary)

                    Text(bridgeMessage)
                        .font(.heading3())
                        .foregroundStyle(Color.nomiTextPrimary)

                    if phase == .rotating || phase == .returning {
                        Image(
                            systemName: phase == .rotating
                            ? "iphone.landscape"
                            : "iphone"
                        )
                        .font(.system(size: 42, weight: .semibold))
                        .foregroundStyle(Color.nomiPrimary)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }

    private func startLaunch() {
        guard launchTask == nil, phase != .story else { return }

        launchTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(700))
            guard !Task.isCancelled else { return }

            phase = .rotating
            rotateToLandscape()

            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }

            phase = .story
            launchTask = nil
        }
    }

    private func rotateToLandscape() {
#if os(iOS)
        OrientationManager.shared.lock(to: .landscapeRight)
        UIDevice.current.setValue(
            UIInterfaceOrientation.landscapeRight.rawValue,
            forKey: "orientation"
        )
        UIViewController.attemptRotationToDeviceOrientation()
#endif
    }

    private var bridgeMessage: String {
        switch phase {
        case .preparing:
            return "Preparing your story..."
        case .rotating:
            return "Turning your story sideways..."
        case .returning:
            return "Turning back the screen..."
        case .story:
            return ""
        }
    }

    private func returnFromStory() {
        returnFromStory(to: returnToRoadmap)
    }

    private func returnHomeFromStory() {
        returnFromStory(to: onReturnHome)
    }

    private func returnFromStory(to destination: @escaping () -> Void) {
        launchTask?.cancel()
        phase = .returning
        rotateToPortrait()

        launchTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(900))
            guard !Task.isCancelled else { return }

            launchTask = nil
            destination()
        }
    }

    private func rotateToPortrait() {
#if os(iOS)
        OrientationManager.shared.lock(to: .portrait)
        UIDevice.current.setValue(
            UIInterfaceOrientation.portrait.rawValue,
            forKey: "orientation"
        )
        UIViewController.attemptRotationToDeviceOrientation()
#endif
    }
}

#Preview {
    Level1LaunchView()
}
