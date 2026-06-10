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
            x: 0.78,
            y: 0.15,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 5, title: "Final Quiz", position: .above),
            icon: .level5
        ),
        RoadmapNodeData(
            x: 0.35,
            y: 0.35,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 4, title: "What to do if unsafe", position: .above),
            icon: .level4
        ),
        RoadmapNodeData(
            x: 0.70,
            y: 0.52,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 3, title: "Safe Touch", position: .above),
            icon: .level3
        ),
        RoadmapNodeData(
            x: 0.78,
            y: 0.75,
            state: .current,
            levelLabel: LevelLabelInfo(level: 2, title: "Private Parts", position: .above),
            icon: .level2
        ),
        RoadmapNodeData(
            x: 0.35,
            y: 0.90,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 1, title: "My Body", position: .below),
            icon: .level1
        ),
    ]
}

#Preview {
    RoadmapScreen()
}

