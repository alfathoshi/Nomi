//
//  HomeScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 26/05/26.
//

import SwiftUI

struct HomeScreen: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            
            //Header
            HStack{
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text("Good morning,")
                            Text("Xatriya")
                                .font(.largeTitle).bold()
                        }
                        Spacer()
                        Image(systemName: "person.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(.blue)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            .padding(.horizontal,20)
            
            //Streak
            HStack {
                Image(systemName: "flame")
                    .font(.largeTitle)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("3 Days Streak!")
                    Text("Keep learning every day")
                }
                
                Spacer()
                
                HStack{
                    Image(systemName: "moon.stars.circle")
                    Text("24")
                }
                .background(Capsule()
                    .fill(.white)
                    .frame(width: 56, height: 35))
                
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 20).fill(.orange.opacity(0.15)))
            .padding(.horizontal)
            
            Text("What do you want to learn?")
                .font(.title2).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical,5)
            
            //Grid
            LazyVGrid(columns: columns, spacing: 16) {
                LearningCard(title: "Body Parts &\nBoundaries", icon: "brain.fill", level: 2, color: .purple, progress: 0.4, isLocked: false)
                LearningCard(title: "Personal Hygiene", icon: "hands.and.sparkles.fill", level: 1, color: .orange, progress: 0.25, isLocked: false)
                LearningCard(title: "Consent &\nSaying Yes or No", icon: "hand.raised.fill", level: 1, color: .green, progress: 0.05, isLocked: false)
                LearningCard(title: "Trusted Adults", icon: "shield.lefthalf.filled", level: 1, color: .mint, progress: 0, isLocked: true)
                LearningCard(title: "Feelings & Emotions", icon: "heart.fill", level: 1, color: .pink, progress: 0, isLocked: true)
                LearningCard(title: "How Families Grow", icon: "figure.2.and.child.holdinghands", level: 1, color: .teal, progress: 0, isLocked: true)
            }
            .padding()
        }
    }
}

struct LearningCard: View {
    let title: String
    let icon: String
    let level: Int
    let color: Color
    let progress: Double
    let isLocked: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Layer 1: Background pastel
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.2))
            
            // Layer 2: Content (icon + title + progress)
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: icon)
                        .font(.system(size: 36))
                        .foregroundStyle(color)
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .offset(x: 20, y: 0)
                    }
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline).bold()
                    .foregroundStyle(isLocked ? .gray : .primary)
                    .multilineTextAlignment(.leading)
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.gray.opacity(0.3))
                        Capsule()
                            .fill(color)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 6)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Layer 3: Level badge (top-right)
            Text("Lvl \(level)")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().fill(.white))
                .padding(10)
        }
        .frame(height: 180)
        .opacity(isLocked ? 0.6 : 1.0)
    }
}

#Preview {
    HomeScreen()
}

#Preview("LearningCard - Unlocked") {
    LearningCard(title: "Body Parts &\nBoundaries", icon: "brain.head.profile", level: 2, color: .purple, progress: 0.4, isLocked: false)
        .frame(width: 180)
        .padding()
}

#Preview("LearningCard - Locked") {
    LearningCard(title: "Trusted Adults", icon: "shield.lefthalf.filled", level: 1, color: .mint, progress: 0, isLocked: true)
        .frame(width: 180)
        .padding()
}
