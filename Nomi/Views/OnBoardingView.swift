//
//  OnBoardingView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image("Mascot")
                    .resizable()
                    .scaledToFill()
                    .padding(24)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.nomiPrimarySoft, .nomiPrimary],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 4
                            )
                    )
                Spacer()
            }
            .padding(.bottom, 8)
            
            Text("SAFE • FUN • EDUCATIONAL")
                .foregroundColor(.nomiPrimary)
                .font(.heading3())
                .padding(.bottom, 16)
            
            Text("Hello there! 👋\nI'm Luna")
                .font(.heading2())
                .padding(.bottom, 10)
            
            Text("I'm here to help you learn about your body, feelings, and how to stay safe in a fun way!")
                .font(.bodySmall())
            
            FeatureCard(
                icon: "gamecontroller.fill",
                title: "Learn through stories & games",
                subtitle: "Interactive lessons made just for you",
                color: .surfaceTint,
                iconColor: .textSecondary,
            )
            FeatureCard(
                icon: "star.fill",
                title: "Earn coins & badges",
                subtitle: "Get rewarded as you learn",
                color: .surfaceTint,
                iconColor: .accent,
            )
            
            FeatureCard(
                icon: "lock.fill",
                title: "Parents can check in too",
                subtitle: "A special area just for grown-ups",
                color: .surfaceAccent,
                iconColor: .accentSoft,)
            
            Spacer()
            
            WideButton(
                title: "Start My Adventure",
                icon: "paperplane.fill"
            ) {

            }
            
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding(20)
        
        
        
    }
}

#Preview {
    OnBoardingView()
}
