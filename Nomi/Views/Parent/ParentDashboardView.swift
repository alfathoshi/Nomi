//
//  ParentDashboardView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI
import SwiftData

struct ParentDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [ChildProfile]
    @AppStorage(LearningProgress.completedLevelsKey)
    private var completedLevels = 0
    var onExit: () -> Void = {}
    var onLogout: () -> Void = {}

    @State private var isShowingLogoutConfirmation = false
    @State private var logoutErrorMessage: String?

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
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                headline
                    .padding(.horizontal, 20)

                ScrollView {
                    VStack(alignment: .leading) {
                        if dashboardData.hasProgress {
                            progressContent
                        } else {
                            ParentDashboardEmptyState()
                        }
                        logoutButton
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
                .scrollIndicators(.hidden)
            }

            if isShowingLogoutConfirmation {
                LogoutConfirmationDialog(
                    onCancel: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isShowingLogoutConfirmation = false
                        }
                    },
                    onConfirm: logout
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarBackButtonHidden(true)
        .alert(
            "Could Not Log Out",
            isPresented: Binding(
                get: { logoutErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        logoutErrorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(logoutErrorMessage ?? "Please try again.")
        }
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

    private var logoutButton: some View {
        WideButton(
            title: "Log Out & Reset Data",
            icon: "rectangle.portrait.and.arrow.right",
            background: .nomiDanger
        ) {
            withAnimation(.easeOut(duration: 0.2)) {
                isShowingLogoutConfirmation = true
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
    }

    private func logout() {
        do {
            let storedProfiles = try modelContext.fetch(FetchDescriptor<ChildProfile>())
            let storedItems = try modelContext.fetch(FetchDescriptor<Item>())

            storedProfiles.forEach(modelContext.delete)
            storedItems.forEach(modelContext.delete)
            try modelContext.save()

            LearningProgress.reset()
            AppUsageTracker.shared.reset()
            onLogout()
        } catch {
            isShowingLogoutConfirmation = false
            logoutErrorMessage = error.localizedDescription
        }
    }
}

private struct LogoutConfirmationDialog: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.nomiDanger)
                    .frame(width: 72, height: 72)
                    .background(Color.nomiDanger.opacity(0.12))
                    .clipShape(Circle())

                VStack(spacing: 8) {
                    Text("Log Out & Reset Data?")
                        .font(.heading2())
                        .foregroundStyle(Color.nomiTextPrimary)
                        .multilineTextAlignment(.center)

                    Text("This permanently deletes the child profile, learning progress, and activity data.")
                        .font(.bodyMedium())
                        .foregroundStyle(Color.nomiTextSecondary)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 12) {
                    Button("Cancel", action: onCancel)
                        .font(.button())
                        .foregroundStyle(Color.nomiTextPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray.opacity(0.12))
                        .clipShape(Capsule())
                        .buttonStyle(.plain)

                    Button(action: onConfirm) {
                        Label(
                            "Log Out",
                            systemImage: "rectangle.portrait.and.arrow.right"
                        )
                        .font(.button())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.nomiDanger)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: .black.opacity(0.2), radius: 24, y: 10)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    ParentDashboardView()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
