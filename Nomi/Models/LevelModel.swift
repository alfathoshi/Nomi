//
//  LevelModel.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import Foundation

struct Level {
    let id: UUID
    let title: String
    let type: LevelType
}

enum LevelType {
    case storyBook(StoryBook)
}
