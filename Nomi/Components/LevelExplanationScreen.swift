//
//  LevelExplanationScreen.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//


import SwiftUI

struct LevelExplanationScreen: View {
    let title: String
    let mascotImage: String
    let paragraphs: [Text]
    let buttonTitle: String
    let onBack: () -> Void
    var isMuted: Bool? = nil
    var onToggleMute: () -> Void = {}
    let onStart: () -> Void

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

            VStack() {
                Spacer()
                Text(title)
                    .font(.heading1(weight: .extraBold, size: 40))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 100)

                Image(mascotImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .shadow(color: .nomiPrimary.opacity(0.3), radius: 15)
                    .padding(.top, 46)

                VStack(spacing: 20) {
                    ForEach(paragraphs.indices, id: \.self) { index in
                        paragraphs[index]
                            .font(.bodyLarge())
                            .foregroundColor(.nomiTextSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 36)
                .frame(width: 335, height: 189)

                Spacer()

                WideButton(title: buttonTitle, icon: nil) {
                    onStart()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
            }

            NomiBackButton(action: onBack)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 20)
            .padding(.top, 62)

            if let isMuted {
                AudioMuteButton(isMuted: isMuted, action: onToggleMute)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 20)
                    .padding(.top, 62)
            }
        }
    }
}

#Preview {
    LevelExplanationScreen(
        title: "The Trust Contract",
        mascotImage: "mascot",
        paragraphs: [
            Text("This is a description of the level"),
            ],
        buttonTitle: "Start",
        onBack: {},
        onStart: {}
    )
}
