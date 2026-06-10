//
//  RoadmapScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import SwiftUI

struct RoadmapScreen: View {
    let nodes: [RoadmapNodeData] = RoadmapData.nodes
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Image(.roadmapBackground)
                    .resizable()
                    .scaledToFill()
                    .clipped()
//                    .overlay(
//                        Color.nomiPrimarySoft
//                            .opacity(0.80)
//                            .blendMode(.overlay)
//                    )

                // Nodes
                ForEach(0..<nodes.count, id: \.self) { i in
                    nodeView(for: nodes[i])
                        .position(
                            x: geo.size.width * nodes[i].x,
                            y: geo.size.height * nodes[i].y
                        )
                }

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
    
            if let label = node.levelLabel, label.position == .above {
                LevelBadge(level: label.level, title: label.title, pointerUp: false)
            }

            circleView(for: node)

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
