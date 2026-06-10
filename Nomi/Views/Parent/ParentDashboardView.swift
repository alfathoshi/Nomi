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
        ScrollView {
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
                    
                HStack() {
                        Image(profile?.avatar ?? "Mascot")
                            .resizable()
                            .scaledToFit()
                            .padding(
                                profile?.avatar == "Mascot" || profile?.avatar == "Pip"
                                ? 10
                                : 0
                            )
                            .frame(width: 72, height: 72)
                            .background(
                                RoundedRectangle(cornerRadius: 21)
                                    .fill( Color.nomiSurfaceTint)
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
                            Text("🌟 0")
                                .font(.heading2())
                                .foregroundColor(.nomiAccent)
                            Text("Total Coins")
                                .font(.label(weight: .regular))
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, -20)
                        .padding(.bottom, 20)

                if dashboardData.hasProgress {
                    progressContent
                } else {
                    ParentDashboardEmptyState(childName: childName)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
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
                        value: "—",
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
                        value: "—",
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
}

#Preview {
    ParentDashboardView()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
