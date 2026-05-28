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

struct LevelLabelInfo {
    let level: Int
    let title: String
}

struct RoadmapNodeData {
    let x: Double
    let y: Double
    let state: NodeState
    var levelLabel: LevelLabelInfo? = nil
}

struct RoadmapScreen: View {
    let nodes: [RoadmapNodeData] = [
        RoadmapNodeData(x: 0.78, y: 0.20, state: .completed),
        RoadmapNodeData(x: 0.40, y: 0.35, state: .completed),
        RoadmapNodeData(x: 0.70, y: 0.52, state: .completed),
        RoadmapNodeData(x: 0.78, y: 0.75, state: .current),
        RoadmapNodeData(
            x: 0.40,
            y: 0.88,
            state: .locked,
            levelLabel: LevelLabelInfo(level: 1, title: "My Body")),
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
                            .blendMode(.overlay)   // ← blend mode bikin warna nyatu
                    )

                // Nodes
                ForEach(0..<nodes.count, id: \.self) { i in
                    nodeView(for: nodes[i])
                        .position(
                            x: geo.size.width * nodes[i].x,
                            y: geo.size.height * nodes[i].y
                        )
                }
                
                // Mascot
//                VStack {
//                    Spacer()
//                    HStack(alignment: .bottom) {
//                        MascotBubble(message: "Don't worry, I'm here")
//                        Spacer()
//                    }
//                    .padding(.bottom, 20)
//    
//                    LevelBadge(level: 1, title: "My Body")
//                        .padding(.bottom, 30)
//                }
//                .padding(.horizontal, 20)

            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func nodeView(for node: RoadmapNodeData) -> some View {
        VStack(spacing: 6) {
            // The circle (based on state)
            circleView(state: node.state)

            // Optional level badge
            if let label = node.levelLabel {
                LevelBadge(level: label.level, title: label.title)
            }
        }
    }
    
    @ViewBuilder
    func circleView(state: NodeState) -> some View {
        switch state {
        case .completed:
            Circle()
                .fill(Color.nomiPrimary)
                .frame(width: 70, height: 70)
                .overlay(Circle().stroke(.white, lineWidth: 3))
    
        case .current:
            Circle()
                .fill(.white)
                .frame(width: 90, height: 90)
                .shadow(color: .white.opacity(0.9), radius: 15)
                .shadow(color: Color.nomiPrimary.opacity(0.5), radius: 25)

        case .locked:
            Circle()
                .fill(Color.nomiTextSecondary)
                .frame(width: 70, height: 70)
                .opacity(0.4)
        }
    }

}

#Preview {
    RoadmapScreen()
}
