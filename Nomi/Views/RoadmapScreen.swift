//
//  RoadmapScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import SwiftUI

private struct ReturnToRoadmapKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var returnToRoadmap: () -> Void {
        get { self[ReturnToRoadmapKey.self] }
        set { self[ReturnToRoadmapKey.self] = newValue }
    }
}

struct RoadmapScreen: View {
    var onReturnHome: () -> Void = {}

    @AppStorage(LearningProgress.completedLevelsKey)
    private var completedLevels = 0

    @State private var selectedLevel = 1
    @State private var isShowingLevel = false

    let nodes: [RoadmapNodeData] = RoadmapData.nodes
    
    var body: some View {
        roadmap
            .navigationDestination(isPresented: $isShowingLevel) {
                LevelDestination(
                    level: selectedLevel,
                    onReturnHome: returnHome
                )
                .toolbar(.hidden, for: .navigationBar)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                lockToPortrait()
            }
    }

    private var roadmap: some View {
        GeometryReader { geo in
            ZStack {
                Image(.roadmapBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: screenSize.width,
                        height: screenSize.height
                    )
                    .clipped()
                    .ignoresSafeArea()

                ForEach(0..<nodes.count, id: \.self) { i in
                    let node = nodes[i]
                    let state = state(for: node)

                    Button {
                        guard state != .locked,
                              let level = node.levelLabel?.level else { return }
                        selectedLevel = level
                        isShowingLevel = true
                    } label: {
                        nodeView(for: node)
                    }
                    .buttonStyle(.plain)
                    .tapSound()
                    .allowsHitTesting(state != .locked)
                    .position(
                        x: geo.size.width * node.x,
                        y: geo.size.height * node.y
                    )
                }

                NomiBackButton(action: returnHome)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.leading, 20)
                    .padding(.top, 12)
                    .zIndex(1)
            }
        }
    }
    
    @ViewBuilder
    func nodeView(for node: RoadmapNodeData) -> some View {
        let state = state(for: node)

        VStack(spacing: 6) {
    
            if let label = node.levelLabel, label.position == .above {
                LevelBadge(level: label.level, title: label.title, pointerUp: false)
            }

            circleView(for: node, state: state)

            if let label = node.levelLabel, label.position == .below {
                LevelBadge(level: label.level, title: label.title, pointerUp: true)
            }
        }
    }

    @ViewBuilder
    func circleView(for node: RoadmapNodeData, state: NodeState) -> some View {
        switch state {
        case .completed:
            Image(node.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 3))

        case .current:
            Image(node.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.9), lineWidth: 4))
                .shadow(color: .white.opacity(0.9), radius: 15)
                .shadow(color: Color.nomiPrimary.opacity(0.8), radius: 25)

        case .locked:
            ZStack {
                Image(node.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                Circle()
                    .fill(Color.black.opacity(0.55))
                    .frame(width: 70, height: 70)

                Image(.lock)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
            }
        }
    }

    private func state(for node: RoadmapNodeData) -> NodeState {
        guard let level = node.levelLabel?.level else { return .locked }

        let progress = min(
            max(completedLevels, 0),
            LearningProgress.totalLevels
        )

        if level <= progress {
            return .completed
        }

        return level == progress + 1 ? .current : .locked
    }

    private func lockToPortrait() {
#if os(iOS)
        OrientationManager.shared.lock(to: .portrait)
        UIDevice.current.setValue(
            UIInterfaceOrientation.portrait.rawValue,
            forKey: "orientation"
        )
        UIViewController.attemptRotationToDeviceOrientation()
#endif
    }

    private func returnHome() {
        onReturnHome()
    }

}

private struct LevelDestination: View {
    @Environment(\.dismiss) private var dismiss

    let level: Int
    let onReturnHome: () -> Void

    var body: some View {
        Group {
            switch level {
            case 1:
                Level1LaunchView(onReturnHome: onReturnHome)
                    .environment(\.returnToRoadmap, dismiss.callAsFunction)
            case 2:
                Level2ExplanationScreen(
                    onComplete: dismiss.callAsFunction,
                    onBack: dismiss.callAsFunction
                )
            case 3:
                Level3ExplanationView(
                    onComplete: dismiss.callAsFunction,
                    onBack: dismiss.callAsFunction
                )
            case 4:
                Level4ExplanationView(
                    onComplete: dismiss.callAsFunction,
                    onBack: dismiss.callAsFunction
                )
            case 5:
                Level5ExplanationView(
                    onComplete: onReturnHome,
                    onBack: dismiss.callAsFunction
                )
            default:
                EmptyView()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RoadmapScreen()
}
