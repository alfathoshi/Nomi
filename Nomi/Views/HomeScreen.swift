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
            TopicData(number: 3, title: "Consent & Saying Yes or No", characterImage: "HomeGirl", isLocked: true),
            TopicData(number: 4, title: "Trusted Adults", characterImage: "HomeBoy", isLocked: true),
        ]
    }
    private var profile: ChildProfile? {
        profiles.first
    }
    @State private var navigateToLearningScreen = false
    @State private var showIntro = false
    @State private var showStoryTransition = false
    @State private var nextLevel = 1
    let screenSize = UIScreen.main.bounds.size
    var body: some View {
        ZStack {
                //background
                Image(.homeBg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        //greeting bubble + avatar
                        HStack(alignment: .top, spacing: 8) {
                            greetingBubble

                            Button {
                                onOpenParent()
                            } label: {
                                if let avatar = profile?.avatar {
                                    Text(avatar)
                                        .frame(width: 48, height: 48)
                                        .background(Circle().fill(.white))
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .frame(width: 48, height: 48)
                                        .background(Circle().fill(.white))
                                        .clipShape(Circle())
                                }
                            }
                            .buttonStyle(.plain)
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
                        ScrollView(showsIndicators: false) {
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
                                        prepareLearningScreen()
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 30)
                        }
                        .padding(.top, -90)
                        .padding(.horizontal, 30)
                    }
                }
                if showStoryTransition {
                    GeometryReader { geo in
                        ZStack {
                            Image(.storyBackground)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()

                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(1.8)
                                    .tint(.white)

                                Text("Preparing your story...")
                                    .font(.heading3())
                                    .foregroundColor(.nomiTextPrimary)
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .ignoresSafeArea()
                    .zIndex(20)
                }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationDestination(isPresented: $navigateToLearningScreen) {
            nextLearningScreen
        }
        .fullScreenCover(isPresented: $showIntro) {
            NomiIntroductionView(
                childName: profile?.name ?? "Friend",
                onContinue: { showIntro = false }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func prepareLearningScreen() {
        nextLevel = min(max(completedLevels + 1, 1), LearningProgress.totalLevels + 1)

        guard nextLevel == 1 else {
            navigateToLearningScreen = true
            return
        }

        showStoryTransition = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            navigateToLearningScreen = true
            showStoryTransition = false
        }
    }

    @ViewBuilder
    private var nextLearningScreen: some View {
        Group {
            switch nextLevel {
            case 1:
                LandscapeStoryScreen()
            case 2:
                Level2ExplanationScreen()
            case 3:
                Level3ExplanationView()
            case 4:
                Level4ExplanationView()
            case 5:
                Level5ExplanationView()
            default:
                CongratsView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Greeting bubble
    private var greetingBubbleOld: some View {
        ZStack {
            GreetingBubbleShape()
                .fill(Color.nomiSurfaceTint)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Morning, \(profile?.name ?? "Friend")")
                    .font(.heading2())
                    .foregroundColor(.nomiTextPrimary)
                
                Text("What do you want to learn?")
                    .font(.bodyLarge())
                    .foregroundColor(.nomiTextPrimary)
                
                Text("Tap me to know me")
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
                Text("Morning, \(profile?.name ?? "Friend")")
                    .font(.heading2())
                    .foregroundColor(.nomiTextPrimary)
                
                Text("What do you want to learn?")
                    .font(.bodyLarge())
                    .foregroundColor(.nomiTextPrimary)

                Text("Tap me to know me")
                    .font(.bodyMedium(weight: .bold))
                    .foregroundColor(.nomiPrimary)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .frame(width: 305, height: 128)
        .padding(.bottom, 30)
        .contentShape(Rectangle())
        .onTapGesture {
            showIntro = true
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
