//
//  LearningAnalytics.swift
//  Nomi
//

import Foundation

enum LearningAnalytics {
    static let activeTimeDateKey = "learningAnalyticsActiveTimeDate"
    static let activeTimeSecondsKey = "learningAnalyticsActiveTimeSeconds"
    static let correctAnswersKey = "learningAnalyticsCorrectAnswers"
    static let totalAnswersKey = "learningAnalyticsTotalAnswers"

    static var activeTimeToday: TimeInterval {
        storedActiveTimeToday + AppUsageTracker.shared.currentSessionDuration
    }

    static var quizAccuracy: Double? {
        let totalAnswers = UserDefaults.standard.integer(forKey: totalAnswersKey)
        guard totalAnswers > 0 else { return nil }

        let correctAnswers = UserDefaults.standard.integer(forKey: correctAnswersKey)
        return Double(correctAnswers) / Double(totalAnswers)
    }

    static func recordQuizAnswer(isCorrect: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(
            defaults.integer(forKey: totalAnswersKey) + 1,
            forKey: totalAnswersKey
        )

        guard isCorrect else { return }
        defaults.set(
            defaults.integer(forKey: correctAnswersKey) + 1,
            forKey: correctAnswersKey
        )
    }

    static func reset() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: activeTimeDateKey)
        defaults.removeObject(forKey: activeTimeSecondsKey)
        defaults.removeObject(forKey: correctAnswersKey)
        defaults.removeObject(forKey: totalAnswersKey)
    }

    static func addActiveTime(_ duration: TimeInterval, on date: Date) {
        guard duration > 0 else { return }

        let defaults = UserDefaults.standard
        let calendar = Calendar.current
        let storedDate = defaults.object(forKey: activeTimeDateKey) as? Date
        let isSameDay = storedDate.map {
            calendar.isDate($0, inSameDayAs: date)
        } ?? false
        let currentSeconds = isSameDay
            ? defaults.double(forKey: activeTimeSecondsKey)
            : 0

        defaults.set(date, forKey: activeTimeDateKey)
        defaults.set(
            currentSeconds + duration,
            forKey: activeTimeSecondsKey
        )
    }

    private static var storedActiveTimeToday: TimeInterval {
        let defaults = UserDefaults.standard
        guard
            let storedDate = defaults.object(forKey: activeTimeDateKey) as? Date,
            Calendar.current.isDateInToday(storedDate)
        else {
            return 0
        }

        return defaults.double(forKey: activeTimeSecondsKey)
    }
}

@MainActor
final class AppUsageTracker {
    static let shared = AppUsageTracker()

    private var sessionStartedAt: Date?

    var currentSessionDuration: TimeInterval {
        guard let sessionStartedAt else { return 0 }
        let todayStartedAt = Calendar.current.startOfDay(for: .now)
        let effectiveStart = max(sessionStartedAt, todayStartedAt)
        return max(Date.now.timeIntervalSince(effectiveStart), 0)
    }

    private init() {}

    func start() {
        guard sessionStartedAt == nil else { return }
        sessionStartedAt = .now
    }

    func stop() {
        guard let sessionStartedAt else { return }
        let endedAt = Date.now
        let dayStartedAt = Calendar.current.startOfDay(for: endedAt)
        let effectiveStart = max(sessionStartedAt, dayStartedAt)
        LearningAnalytics.addActiveTime(
            endedAt.timeIntervalSince(effectiveStart),
            on: endedAt
        )
        self.sessionStartedAt = nil
    }

    func reset() {
        sessionStartedAt = nil
        LearningAnalytics.reset()
    }
}
