//
//  RoadmapData.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import Foundation

struct RoadmapData {
    static let nodes: [RoadmapNodeData] = [
        RoadmapNodeData(
            x: 0.78,
            y: 0.20,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 5, title: "Final Quiz", position: .above),
            icon: "Level1Node"
        ),
        RoadmapNodeData(
            x: 0.40,
            y: 0.35,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 4, title: "What to do if unsafe", position: .above),
            icon: "Level1Node"
        ),
        RoadmapNodeData(
            x: 0.70,
            y: 0.52,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 3, title: "Safe Touch", position: .above),
            icon: "Level1Node"
        ),
        RoadmapNodeData(
            x: 0.78,
            y: 0.75,
            state: .current,
            levelLabel: LevelLabelInfo(level: 2, title: "Private Parts", position: .above),
            icon: "UnlockedNode"
        ),
        RoadmapNodeData(
            x: 0.40,
            y: 0.88,
            state: .completed,
            levelLabel: LevelLabelInfo(level: 1, title: "My Body", position: .below),
            icon: "Level1Node"
        ),
    ]
}
