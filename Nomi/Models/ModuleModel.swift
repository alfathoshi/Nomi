//
//  ModuleModel.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import Foundation

struct Module: Identifiable {
    let id: UUID
    let title: String
    let levels: [Level]
}
