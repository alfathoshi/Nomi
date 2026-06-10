//
//  RoadmapNode.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import SwiftUI

enum NodeState: Equatable {
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
    var levelLabel: LevelLabelInfo? = nil
    var icon: ImageResource
}
