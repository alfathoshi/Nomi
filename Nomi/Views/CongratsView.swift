//
//  CongratsView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 08/06/26.
//

import SwiftUI

struct CongratsView: View {
    let screenSize = UIScreen.main.bounds.size
    @State private var navigateToHome = false
    var body: some View {
        ZStack {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: screenSize.width,
                        height: screenSize.height
                    )
                    .clipped()
                    .ignoresSafeArea()
                
                
                VStack {
                    Text("GREAT JOB!")
                        .font(.heading1(size: 40))
                        .foregroundColor(.nomiPrimary)
                    
                    Text("You learned about your body!")
                        .font(.heading3())
                        .foregroundColor(.nomiPrimary)
                        .padding(.bottom, 48)
                    
                    
                    ZStack(alignment: .top) {
                        
                        Image(.nomiDefault)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 269)
                            .zIndex(0)

                        VStack(spacing: 24) {
                            Text("What You Earned")
                                .font(.heading1(size: 22))
                                .foregroundColor(.nomiPrimary)

                            EarnedItem(
                                emoji: "🔥",
                                backgroundColor: Color.orange.opacity(0.18),
                                title: "3-Day Learning Streak",
                                subtitle: "Amazing Consistency!"
                            )

                            Divider()
                                .padding(.leading, 72)

                            EarnedItem(
                                emoji: "✋",
                                backgroundColor: Color.nomiPrimary.opacity(0.18),
                                title: "Learned: Body Parts",
                                subtitle: "You’re Learning So Much!"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 28)
                        .background(Color.nomiSurfaceTint)
                        .overlay {
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.nomiPrimary.opacity(0.7), lineWidth: 2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .padding(.top, 215)
                        .zIndex(1)
                        
                    }
                    
                    
                    Spacer()
                    
                    WideButton(title: "Back Home", icon: "arrow.right") {
                        navigateToHome = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .padding(.bottom, 44)
                .navigationDestination(isPresented: $navigateToHome) {
                    HomeScreen()
                        .navigationBarBackButtonHidden(true)
                }
        }
    }
}

#Preview {
    CongratsView()
}
