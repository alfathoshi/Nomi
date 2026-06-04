//
//  DragWordModel.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//

import Foundation
import SwiftUI

enum WordCategory {
    case doctors
    case strangers
    case unassigned
}

struct DragWordModel: Identifiable {
    var id = UUID()
    var text: String
    var posX: Double
    var posY: Double
    var rotation: Double
    var scale: Double
    var category: WordCategory = .unassigned
    
    var position: CGPoint {
        CGPoint(x: posX, y: posY)
    }
    
    var rotationAngle: Angle {
        Angle(radians: rotation)
    }
    
    var scaleCGFloat: CGFloat {
        CGFloat(scale)
    }

    init(id: UUID = UUID(), text: String, posX: Double, posY: Double, rotation: Double, scale: Double, category: WordCategory = .unassigned) {
        self.id = id
        self.text = text
        self.posX = posX
        self.posY = posY
        self.rotation = rotation
        self.scale = scale
        self.category = category
    }
}
