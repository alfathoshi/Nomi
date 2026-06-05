//
//  ScenarioModel.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import Foundation
import SwiftUI

struct ScenarioModel: Identifiable {
    let id = UUID()
    let image: ImageResource
    let content: String
}
