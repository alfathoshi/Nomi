//
//  ParentDashboardView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI
import SwiftData

struct ParentDashboardView: View {
    @Query private var profiles: [ChildProfile]
    @AppStorage(LearningProgress.completedLevelsKey)
    private var completedLevels = 0
    var onExit: () -> Void = {}

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    private var profile: ChildProfile? {
        profiles.first
    }

    private var dashboardData: ParentDashboardData {
        ParentDashboardData.make(completedLevels: completedLevels)
    }

    private var childName: String {
        profile?.name ?? "Your child"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headline
                .padding(.horizontal, 20)
                .padding(.top, 20)

            ScrollView {
                VStack(alignment: .leading) {
                    if dashboardData.hasProgress {
                        progressContent
                    } else {
                        ParentDashboardEmptyState()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarBackButtonHidden(true)
    }

    private var headline: some View {
            VStack(alignment: .leading) {
            HStack {
                ChipCapsule(
                    title: "Parent Mode",
                    leftIcon: "figure.2.and.child.holdinghands",
                    foregroundColor: .nomiPrimary,
                    backgroundColor: .nomiSurfaceTint
                )
                Spacer()
                ChipCapsule(
                    title: "Exit",
                    rightIcon: "arrow.right",
                    foregroundColor: .nomiTextSecondary,
                    backgroundColor: Color.gray.opacity(0.2),
                ) {
                    onExit()
                }
            }

            HStack {
                Image(profile?.avatar ?? "Mascot")
                    .resizable()
                    .scaledToFit()
                    .padding(
                        profile?.avatar == "Mascot" || profile?.avatar == "Pip"
                        ? 10
                        : 4
                    )
                    .frame(width: 72, height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 21)
                            .fill(Color.nomiSurfaceTint)
                            .frame(width: 66, height: 66)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.clear)
                    )

                VStack(alignment: .leading) {
                    Text("\(childName)'s Progress")
                        .font(.heading2())
                    Text(
                        "Age \(profile?.age ?? 0) · "
                        + "\(dashboardData.completedLevels)/\(dashboardData.totalLevels) levels"
                    )
                    .font(.label(weight: .regular))
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("🌟 \(dashboardData.totalCoins)")
                        .font(.heading2())
                        .foregroundColor(.nomiAccent)
                    Text("Total Coins")
                        .font(.label(weight: .regular))
                }
            }

            Divider()
                .padding(.horizontal, -20)
                .padding(.bottom, 20)
        }
    }

    private var progressContent: some View {
        Group {
            Section("Overview") {
                LazyVGrid(
                    columns: columns,
                    spacing: 10
                ) {
                    StatCard(
                        icon: "books.vertical.fill",
                        value: "\(dashboardData.completedLevels)",
                        label: "Levels completed",
                        iconColor: .nomiAccent
                    )

                    StatCard(
                        icon: "clock.fill",
                        value: formattedActiveTime,
                        label: "Time spent today",
                        iconColor: .nomiPrimary
                    )

                    StatCard(
                        icon: "trophy.fill",
                        value: "\(dashboardData.badgesEarned)",
                        label: "Badges earned",
                        iconColor: .nomiPrimary
                    )

                    StatCard(
                        icon: "checkmark.square.fill",
                        value: formattedQuizAccuracy,
                        label: "Quiz accuracy",
                        iconColor: .nomiSuccess
                    )
                }
            }
            .font(.heading3())
            .padding(.bottom, 20)

            Section("Topics") {
                VStack(spacing: 10) {
                    TopicProgressCard(
                        emoji: "🧠",
                        title: "Body Parts & Boundaries",
                        progress: CGFloat(dashboardData.topicProgress),
                        progressColor: .nomiPrimary
                    )
                }
            }
            .font(.heading3())
            .padding(.bottom, 20)

            Text("Recent Activity")
                .font(.heading3())
                .padding(.bottom, 20)

            VStack(alignment: .leading) {
                ForEach(Array(dashboardData.activities.enumerated()), id: \.element.id) { index, activity in
                    ActivityItem(
                        emoji: "✅",
                        title: activity.title,
                        time: activity.timeText,
                        showDivider: index < dashboardData.activities.count - 1
                    )
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .shadow(
                color: .black.opacity(0.06),
                radius: 12,
                x: 0,
                y: 2
            )
        }
    }

    private var formattedActiveTime: String {
        let totalMinutes = Int(LearningAnalytics.activeTimeToday / 60)

        if totalMinutes < 60 {
            return "\(totalMinutes) min"
        }

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return minutes == 0 ? "\(hours) hr" : "\(hours)h \(minutes)m"
    }

    private var formattedQuizAccuracy: String {
        guard let accuracy = LearningAnalytics.quizAccuracy else {
            return "—"
        }

        return accuracy.formatted(.percent.precision(.fractionLength(0)))
    }
}

#Preview {
    ParentDashboardView()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
