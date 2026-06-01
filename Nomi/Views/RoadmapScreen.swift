//
//  RoadmapScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 28/05/26.
//

import SwiftUI

enum NodeState {
    case completed
    case current
    case locked
}

enum BadgePosition {
    case above
    case below
}

struct LevelLabelInfo {
    let level: Int
    let title: String
    var position: BadgePosition = .below
}

struct RoadmapNodeData {
    let x: Double
    let y: Double
    let state: NodeState
    var levelLabel: LevelLabelInfo? = nil
    var icon: String = "level1Bg"
}

struct RoadmapScreen: View {
    let nodes: [RoadmapNodeData] = [
        RoadmapNodeData(
            x: 0.78,
            y: 0.20,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 5, title: "Final Quiz", position: .above),
            icon: "level1Bg",
        ),
        RoadmapNodeData(
            x: 0.40,
            y: 0.35,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 4, title: "What to do if unsafe", position: .above),
            icon: "level1Bg",
        ),
        RoadmapNodeData(
            x: 0.70,
            y: 0.52,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 3, title: "Safe Touch", position: .above),
            icon: "level1Bg",
        ),
        RoadmapNodeData(
            x: 0.78,
            y: 0.75,
            state: .current,
            levelLabel: LevelLabelInfo(level: 2, title: "Private Parts", position: .above),
            icon: "currentLevelBg",
        ),
        RoadmapNodeData(
            x: 0.40,
            y: 0.88,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 1, title: "My Body", position: .below),
            icon: "lockedLevelBg",
        ),
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Image("RoadmapBackground")
                    .resizable()
                    .scaledToFill()
                //incase need to zoom the background
//                    .scaleEffect(1.08)
                    .clipped()
                    .overlay(
                        Color.nomiPrimarySoft
                            .opacity(0.80)
                            .blendMode(.overlay)
                    )

                // Nodes
                ForEach(0..<nodes.count, id: \.self) { i in
                    nodeView(for: nodes[i])
                        .position(
                            x: geo.size.width * nodes[i].x,
                            y: geo.size.height * nodes[i].y
                        )
                }

                // Mascot — fixed in left bottom
                VStack {
                    Spacer()
                    HStack {
                        MascotBubble(message: "Don't worry, I'm here")
                            .padding(.leading, 10)
                            .padding(.bottom, 230)
                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func nodeView(for node: RoadmapNodeData) -> some View {
        VStack(spacing: 6) {
            // Badge above node
            if let label = node.levelLabel, label.position == .above {
                LevelBadge(level: label.level, title: label.title, pointerUp: false)
            }

            circleView(for: node)

            // Badge below node
            if let label = node.levelLabel, label.position == .below {
                LevelBadge(level: label.level, title: label.title, pointerUp: true)
            }
        }
    }

    @ViewBuilder
    func circleView(for node: RoadmapNodeData) -> some View {
        switch node.state {
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
                .shadow(color: .white.opacity(0.9), radius: 15)
                .shadow(color: Color.nomiPrimary.opacity(0.5), radius: 25)

        case .locked:
            Image(node.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .opacity(0.6)
        }
    }

}

#Preview {
    RoadmapScreen()
}
