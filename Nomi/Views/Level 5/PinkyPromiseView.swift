//
//  PinkyPromiseView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct PinkyPromiseView: View {
    @State private var navigateToCongratsScreen: Bool = false
    @State private var showConfetti = false
    @StateObject private var audio = AudioManager()

    var body: some View {
        NavigationStack {
            ZStack {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width, height: screenSize.height)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack() {
                    Text("PINKY PROMISE")
                        .font(.heading1(size: 40))
                        .foregroundColor(.nomiPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 90)
                    
                    Text("PINKY PROMISE")
                        .font(.heading3())
                        .foregroundColor(.nomiPrimarySoft)
                        .multilineTextAlignment(.center)
                    
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Image("NomiHome")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .background(
                                Circle()
                                    .fill(Color.nomiPrimary.opacity(0.18))
                                    .frame(width: 120, height: 120)
                            )
                            .padding(.bottom, 24)
                        
                        Text("Pinky Promise mean:")
                            .font(.heading3())
                            .foregroundColor(Color.nomiPrimary)
                        
                        
                        Text("""
                            Listeing, helping,
                            keepig each other safe
                            """)
                            .font(.heading3())
                            .foregroundColor(.nomiTextPrimary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.nomiSurfaceTint)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.nomiPrimary.opacity(0.65), lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    TwoFingerHoldArea(duration: 5) {
                        completePinkyPromise()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)

                if showConfetti {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()

                    LottieWrapper(fileName: "confetti")
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
            .navigationDestination(isPresented: $navigateToCongratsScreen) {
                CongratsView()
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                audio.play(audioName: "PinkyPromise")
            }
            .onDisappear {
                audio.stop()
            }
        }
    }

    private func completePinkyPromise() {
        LearningProgress.complete(level: 5)
        showConfetti = true
        audio.play(audioName: "correct-answer")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            showConfetti = false
            navigateToCongratsScreen = true
        }
    }
}

#Preview {
    PinkyPromiseView()
}
