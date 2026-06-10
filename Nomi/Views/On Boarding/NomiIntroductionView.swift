//
//  NomiIntroductionView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 09/06/26.
//

import SwiftUI

struct NomiIntroductionView: View {
    let childName: String
    var onContinue: () -> Void = {}
    
    @StateObject private var audio = AudioManager()
    
    var body: some View {
        ZStack {
            Image(.storyBackground)
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width, height: screenSize.height)
                .clipped()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                greeting
                    .padding(.horizontal, 28)
                    .padding(.top, 34)
                
                Spacer(minLength: 12)
                
                LottieWrapper(fileName: "NomiIdleFloat", loop: true)
                    .frame(
                        width: min(screenSize.width * 0.9, 380),
                        height: min(screenSize.height * 0.9, 380)
                    )
                    .scaleEffect(1.3)
                    .shadow(color: .nomiPrimary.opacity(0.16), radius: 18, y: 10)
                
                Spacer()
                
                reassurance
                    .padding(.horizontal, 32)
                    .padding(.bottom, 28)
                
                WideButton(
                    title: "Let’s Learn Together",
                    icon: "book.fill",
                    action: onContinue
                )
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 44)
            .padding(.top, 24)

            AudioMuteButton(isMuted: audio.isMuted) {
                audio.toggleMute()
                if !audio.isMuted {
                    audio.play(audioName: "nomi intro")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing, 20)
            .padding(.top, 62)
        }
        
        .navigationBarBackButtonHidden(true)
        .onAppear {
            audio.play(audioName: "nomi intro")
        }
        .onDisappear {
            audio.stop()
        }
    }
    
    private var greeting: some View {
        VStack(spacing: 6) {
            Text(
                "Hello \(displayName), My name is \(Text("Nomi").foregroundColor(.nomiPrimary))"
            )
            .font(.heading2(size: 20))
            .foregroundColor(.nomiTextPrimary)
            .multilineTextAlignment(.center)
            
            Text("I can be a little shy sometimes, maybe\nyou feel that way too?")
                .font(.bodyLarge())
                .foregroundColor(.nomiTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    private var reassurance: some View {
        Text(
            """
            That’s okay! We’ll go on \(Text("adventures").foregroundColor(.nomiPrimary))
            and grow \(Text("braver together!").foregroundColor(.nomiPrimary))
            """
        )
        .font(.bodyLarge())
        .foregroundColor(.nomiTextSecondary)
        .multilineTextAlignment(.center)
        .lineSpacing(3)
    }
    
    private var displayName: String {
        let trimmedName = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "Friend" : trimmedName
    }
}

#Preview {
    NavigationStack {
        NomiIntroductionView(childName: "Xatriya")
    }
}
