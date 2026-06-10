//
//  DoctorWordsScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

let screenSize = UIScreen.main.bounds.size

struct Level2ExplanationScreen: View {
    var onComplete: () -> Void = {}
    var onBack: () -> Void = {}

    @State private var navigateToFlipCard = false
    @StateObject private var audio = AudioManager()
    var body: some View {
        let highlight = Text("\"The Doctor Words\"")
            .foregroundColor(.nomiPrimary)
            .font(.heading3())

        Group {
            if navigateToFlipCard {
                FlipCardScreen(
                    onComplete: onComplete,
                    onBack: {
                        navigateToFlipCard = false
                    }
                )
            } else {
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
                
                VStack() {
                    Spacer()
                    // Title
                    Text("Doctor's Words")
                        .font(.heading1(size: 36))
                        .foregroundColor(.nomiTextPrimary)
                        .padding(.top, 100)
                    
                    // Mascot
                    Image("NomiDoctor")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 280)
                        .shadow(color: .nomiPrimary.opacity(0.3), radius: 15)
                        .padding(.top, 46)
                    
                    // Body text — 2 paragraf
                    VStack(spacing: 20) {
                        Text("Now that you know about where your private parts are, let's learn about their real names!")
                            .font(.bodyLarge())
                            .foregroundColor(.nomiTextSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("These real names of your private parts are called \(highlight)")
                            .font(.bodyLarge())
                            .foregroundColor(.nomiTextSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 36)
                    .frame(width: 335, height:  189)
                    
                    Spacer()
                    
                    // CTA Button
                    WideButton(title: "Start", icon: nil) {
                       navigateToFlipCard.toggle()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 48)
                }

                NomiBackButton(action: onBack)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 20)
                .padding(.top, 62)

                AudioMuteButton(isMuted: audio.isMuted) {
                    audio.toggleMute()
                    if !audio.isMuted {
                        playNarration()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, 20)
                .padding(.top, 62)
            }
            .onAppear {
                playNarration()
            }
            .onDisappear {
                audio.stop()
            }
            }
        }
    }

    private func playNarration() {
        audio.play(audioName: "Level-2-Explanation")
    }
}

#Preview {
    Level2ExplanationScreen()
}
