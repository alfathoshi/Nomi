//
//  ParentDashboardData.swift
//  Nomi
//

import Foundation

struct ParentDashboardActivity: Identifiable {
    let level: Int
    let title: String
    let completedAt: Date?

    var id: Int { level }

    var timeText: String {
        guard let completedAt else { return "Checkpoint saved" }
        return completedAt.formatted(date: .abbreviated, time: .shortened)
    }
}

struct ParentDashboardData {
    let completedLevels: Int
    let totalLevels: Int
    let activities: [ParentDashboardActivity]

    var hasProgress: Bool {
        completedLevels > 0
    }

    var topicProgress: Double {
        guard totalLevels > 0 else { return 0 }
        return Double(completedLevels) / Double(totalLevels)
    }

    var badgesEarned: Int {
        completedLevels == totalLevels ? 1 : 0
    }

    var totalCoins: Int {
        completedLevels * 2
    }

    static func make(
        completedLevels: Int,
        completionDates: [Int: Date] = LearningProgress.completionDates
    ) -> ParentDashboardData {
        let clampedLevels = min(
            max(completedLevels, 0),
            LearningProgress.totalLevels
        )

        let activities: [ParentDashboardActivity]
        if clampedLevels > 0 {
            activities = (1...clampedLevels).reversed().map { level in
                ParentDashboardActivity(
                    level: level,
                    title: levelTitle(for: level),
                    completedAt: completionDates[level]
                )
            }
        } else {
            activities = []
        }

        return ParentDashboardData(
            completedLevels: clampedLevels,
            totalLevels: LearningProgress.totalLevels,
            activities: activities
        )
    }

    private static func levelTitle(for level: Int) -> String {
        switch level {
        case 1:
            return #"Completed "What is your body?" — Level 1"#
        case 2:
            return #"Completed "Private body parts" — Level 2"#
        case 3:
            return #"Completed "Private and non-private parts" — Level 3"#
        case 4:
            return #"Completed "Safety Detective" — Level 4"#
        default:
            return #"Completed "Trust Contract" — Level 5"#
        }
    }
}
