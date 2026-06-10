//
//  HomeScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 26/05/26.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Query private var profiles: [ChildProfile]
    @AppStorage(LearningProgress.completedLevelsKey)
    private var completedLevels = 0
    var onOpenParent: () -> Void = {}
    var onOpenRoadmap: () -> Void = {}

    private var topics: [TopicData] {
        [
            TopicData(
                number: 1,
                title: "Body Parts & Boundaries",
                characterImage: "HomeGirl",
                currentStep: min(max(completedLevels, 0), LearningProgress.totalLevels),
                totalSteps: LearningProgress.totalLevels,
                isLocked: false
            ),
            TopicData(number: 2, title: "Personal Hygiene", characterImage: "HomeBoy", isLocked: true),
            TopicData(number: 3, title: "Saying \nYes or No", characterImage: "HomeGirl", isLocked: true),
            TopicData(number: 4, title: "Trusted Adults", characterImage: "HomeBoy", isLocked: true),
        ]
    }
    private var profile: ChildProfile? {
        profiles.first
    }

    private var learningPrompt: String {
        completedLevels > 0
            ? "Let’s pick up from where we left"
            : "What do you want to learn?"
    }

    @State private var showIntro = false
    let screenSize = UIScreen.main.bounds.size
    var body: some View {
        ZStack {
                //background
                Image(.homeBg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        //greeting bubble + avatar
                        HStack(alignment: .top, spacing: 8) {
                            greetingBubble

                            Button {
                                onOpenParent()
                            } label: {
                                if let avatar = profile?.avatar {
                                    Image(avatar)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(profile?.avatar == "Mascot" || profile?.avatar == "Pip"
                                                 ? 6
                                                 : 4)
                                        .frame(width: 48, height: 48)
                                        .background(Circle().fill(.white))
                                        .clipShape(Circle())
                                } else {
                                    Image(.pip)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(4)
                                        .frame(width: 48, height: 48)
                                        .background(Circle().fill(.white))
                                        .clipShape(Circle())
                                }
                            }
                            .buttonStyle(.plain)
                            .tapSound()
                        }
                        .padding(.horizontal, 40)
                        .zIndex(2)

                        //mascot
                        Image("NomiHome")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .offset(y: -60)
                            .shadow(radius: 15)
                            .zIndex(0)

                        //cardlist
                        VStack(spacing: 12) {
                            ForEach(topics) { topic in
                                TopicCard(
                                    number: topic.number,
                                    title: topic.title,
                                    characterImage: topic.characterImage,
                                    currentStep: topic.currentStep,
                                    totalSteps: topic.totalSteps,
                                    isLocked: topic.isLocked
                                ) {
                                    openTopic()
                                }
                            }
                        }
                        .padding(.horizontal, 46)
                        .padding(.top, -90)
                        .padding(.bottom, 30)
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showIntro) {
            NomiIntroductionView(
                childName: profile?.name ?? "Friend",
                onContinue: { showIntro = false }
            )
        }
        .navigationBarBackButtonHidden(true)
    }

    private func openTopic() {
        onOpenRoadmap()
    }

    // MARK: - Greeting bubble
    private var greetingBubbleOld: some View {
        ZStack {
            GreetingBubbleShape()
                .fill(Color.nomiSurfaceTint)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    Text("\(greeting(for: context.date)), \(profile?.name ?? "Friend")")
                        .font(.heading2())
                        .foregroundColor(.nomiTextPrimary)
                }
                
                Text(learningPrompt)
                    .font(.bodyLarge())
                    .foregroundColor(.nomiTextPrimary)
                
                Text("Get to know me")
                    .font(.bodyMedium(weight: .bold))
                    .foregroundColor(.nomiPrimary)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
        .aspectRatio(305.0/206.0, contentMode: .fit)
    }
    
    private var greetingBubble: some View {
        ZStack {
            GreetingBubbleShape2()
                .fill(Color.nomiSurfaceTint)
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 4) {
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    Text("\(greeting(for: context.date)), \(profile?.name ?? "Friend")")
                        .font(.heading3())
                        .foregroundColor(.nomiTextPrimary)
                }
                
                Text(learningPrompt)
                    .font(.bodyLarge())
                    .foregroundColor(.nomiTextPrimary)

                Text("Get to know me")
                    .font(.bodyMedium(weight: .bold))
                    .foregroundColor(.nomiPrimary)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .frame(width: 305, height: completedLevels > 0 ? 148 : 128)
        .padding(.bottom, 30)
        .contentShape(Rectangle())
        .onTapGesture {
            showIntro = true
        }
    }

    private func greeting(for date: Date) -> String {
        switch Calendar.current.component(.hour, from: date) {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
