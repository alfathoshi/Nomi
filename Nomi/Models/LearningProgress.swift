//
//  LearningProgress.swift
//  Nomi
//

import Foundation

enum LearningProgress {
    static let completedLevelsKey = "bodyPartsCompletedLevels"
    static let totalLevels = 5

    static var completedLevels: Int {
        min(
            max(UserDefaults.standard.integer(forKey: completedLevelsKey), 0),
            totalLevels
        )
    }

    static func complete(level: Int) {
        let completedLevel = min(max(level, 0), totalLevels)
        guard completedLevel > completedLevels else { return }
        UserDefaults.standard.set(completedLevel, forKey: completedLevelsKey)
    }
}
