//
//  RoadmapData.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import Foundation
import SwiftUI

struct RoadmapData {
    static let nodes: [RoadmapNodeData] = [
        RoadmapNodeData(
            x: 0.25,
            y: 0.10,
            levelLabel: LevelLabelInfo(level: 5, title: "Final Quiz", position: .below),
            icon: .level5
        ),
        RoadmapNodeData(
            x: 0.75,
            y: 0.35,
            levelLabel: LevelLabelInfo(level: 4, title: "What to do\nif unsafe", position: .above),
            icon: .level4
        ),
        RoadmapNodeData(
            x: 0.25,
            y: 0.50,
            levelLabel: LevelLabelInfo(level: 3, title: "Safe Touch", position: .above),
            icon: .level3
        ),
        RoadmapNodeData(
            x: 0.75,
            y: 0.70,
            levelLabel: LevelLabelInfo(level: 2, title: "Private Parts", position: .above),
            icon: .level2
        ),
        RoadmapNodeData(
            x: 0.25,
            y: 0.85,
            levelLabel: LevelLabelInfo(level: 1, title: "My Body", position: .above),
            icon: .level1
        ),
    ]
}

#Preview {
    RoadmapScreen()
}
