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
                                .font(.bodyMedium())
                                .foregroundColor(.nomiTextSecondary)
                            Text("Xatriya")
                                .font(.heading1())

                        }
                        Spacer()
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.nomiPrimary)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.nomiPrimary, lineWidth: 2)
                                    .padding(-3)
                            )
                    }
                    .padding()
                }
            }
            .padding(.horizontal,20)
            
            //Streak
            HStack(spacing: 12) {
                Image(systemName: "flame")
                    .font(.heading2())
                    .foregroundColor(.nomiDanger)

                VStack(alignment: .leading){
                    Text("3 Day Streak!")
                        .font(.bodyLarge(weight: .bold))
                        .foregroundColor(.nomiAccent)
                    Text("Keep learning every day")
                        .font(.bodySmall())
                        .foregroundColor(.nomiTextSecondary)
                }

                Spacer()

                HStack(spacing: 4){
                    Image(systemName: "star.fill").foregroundColor(.nomiAccent)
                    Text("24")
                        .font(.label())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(.white))

            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.nomiAccentSoft.opacity(0.2)))
            .padding(.horizontal)
            
            Text("What do you want to learn?")
                .font(.heading2())
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



#Preview {
    HomeScreen()
}


