//
//  LearningProgress.swift
//  Nomi
//

import Foundation

enum LearningProgress {
    static let completedLevelsKey = "bodyPartsCompletedLevels"
    static let completionDatesKey = "bodyPartsCompletionDates"
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

        var dates = completionDates
        dates[completedLevel] = .now
        saveCompletionDates(dates)
        UserDefaults.standard.set(completedLevel, forKey: completedLevelsKey)
    }

    static var completionDates: [Int: Date] {
        guard
            let data = UserDefaults.standard.data(forKey: completionDatesKey),
            let storedDates = try? JSONDecoder().decode([String: Date].self, from: data)
        else {
            return [:]
        }

        return Dictionary(
            uniqueKeysWithValues: storedDates.compactMap { key, value in
                guard let level = Int(key) else { return nil }
                return (level, value)
            }
        )
    }

    private static func saveCompletionDates(_ dates: [Int: Date]) {
        let storedDates = Dictionary(
            uniqueKeysWithValues: dates.map { (String($0.key), $0.value) }
        )

        guard let data = try? JSONEncoder().encode(storedDates) else { return }
        UserDefaults.standard.set(data, forKey: completionDatesKey)
    }
}
