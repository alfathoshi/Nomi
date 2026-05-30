//
//  ParentDashboardView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct ParentDashboardView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
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
                            dismiss()
                        }
                        
                    }
                    
                    HStack() {
                        Text("👦")
                            .font(.display())
                            .foregroundColor( .nomiTextPrimary)
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
                            Text("Xatriya's Progress")
                                .font(.heading2())
                            Text("Age 8 · 3 day streak 🔥")
                                .font(.label(weight: .regular))
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("🌟 24")
                                .font(.heading2())
                                .foregroundColor(.nomiAccent)
                            Text("Total Coins")
                                .font(.label(weight: .regular))
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, -20)
                        .padding(.bottom, 20)
                    
                    Section("Overview") {
                        
                        LazyVGrid(
                            columns: columns,
                            spacing: 10
                        ) {
                            StatCard(
                                icon: "books.vertical.fill",
                                value: "2",
                                label: "Levels completed",
                                iconColor: .nomiAccent
                            )
                            
                            StatCard(
                                icon: "clock.fill",
                                value: "14m",
                                label: "Time spent today",
                                iconColor: .nomiPrimary
                            )
                            
                            StatCard(
                                icon: "trophy.fill",
                                value: "1",
                                label: "Badges earned",
                                iconColor: .nomiPrimary
                            )
                            
                            StatCard(
                                icon: "checkmark.square.fill",
                                value: "85%",
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
                                progress: 0.6,
                                progressColor: .nomiPrimary
                            )
                            
                            TopicProgressCard(
                                emoji: "🧼",
                                title: "Personal Hygiene",
                                progress: 0.3,
                                progressColor: .nomiAccent
                            )
                            
                            TopicProgressCard(
                                emoji: "✋",
                                title: "Consent & Saying Yes/No",
                                progress: 0.1,
                                progressColor: .nomiSuccess
                            )
                        }
                    }
                    .font(.heading3())
                    .padding(.bottom, 20)
                    
                    Text("Recent Activity")
                        .font(.heading3())
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        ActivityItem(
                            emoji: "✅",
                            title: #"Completed "Private body parts" — Level 2"#,
                            time: "Today · 9:38 AM",
                            showDivider: true
                        )
                        ActivityItem(
                            emoji: "🏆",
                            title: "Earned Body Expert Badge",
                            time: "Today · 9:40 AM",
                            showDivider: true
                        )
                        ActivityItem(
                            emoji: "📝",
                            title: "Quiz: 2/2 correct answers",
                            time: "Today · 9:42 AM",
                            showDivider: true
                        )
                        ActivityItem(
                            emoji: "✅",
                            title: #"Completed "What is your body?" — Level 1"#,
                            time: "Yesterday · 4:20 PM",
                            showDivider: false
                        )
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
    }
}

#Preview {
    ParentDashboardView()
}
