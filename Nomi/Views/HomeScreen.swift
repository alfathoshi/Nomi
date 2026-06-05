//
//  HomeScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 26/05/26.
//

import SwiftUI

struct HomeScreen: View {
    let topics: [TopicData] = [
        TopicData(number: 1, title: "Body Parts & Boundaries",     characterImage: "HomeGirl", currentStep: 2, totalSteps: 5, isLocked: false),
        TopicData(number: 2, title: "Personal Hygiene",            characterImage: "HomeBoy",  currentStep: 0, totalSteps: 5, isLocked: true),
        TopicData(number: 3, title: "Consent & Saying Yes or No",  characterImage: "HomeGirl", currentStep: 0, totalSteps: 5, isLocked: true),
        TopicData(number: 4, title: "Trusted Adults",              characterImage: "HomeBoy",  currentStep: 0, totalSteps: 5, isLocked: true),
    ]
    @State private var navigateToStoryBook = false
    var body: some View {
        
        NavigationStack {
            ZStack {
                //background
                Image("HomeBg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.5)
                //                .brightness(-0.2)
                
                VStack(spacing: 0) {
                    //greeting bubble + avatar
                    HStack(alignment: .top, spacing: 8) {
                        greetingBubble
                        
                        NavigationLink(destination: ParentZoneView(), label: {
                            Image(systemName: "person.fill")
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(.white))
                                .padding(.top, 8)
                        }
                        )
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
                                        navigateToStoryBook = true
                                        print("tapped")
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
            .navigationDestination(isPresented: $navigateToStoryBook) {
                StoryBookView()
                    .navigationBarBackButtonHidden(true)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Greeting bubble
    private var greetingBubble: some View {
        ZStack {
            GreetingBubbleShape()
                .fill(Color(red: 0.953, green: 0.937, blue: 0.996))   // #F3EFFE
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Morning, Xatriya")
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
}

#Preview {
    HomeScreen()
}
