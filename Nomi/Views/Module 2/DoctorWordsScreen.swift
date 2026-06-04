//
//  DoctorWordsScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

let screenSize = UIScreen.main.bounds.size

struct DoctorWordsScreen: View {
    var body: some View {
        let highlight = Text("\"The Doctor Words\"")
            .foregroundColor(.nomiPrimary)
            .font(.heading3())

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
            
            VStack(spacing: 24) {
                // Title
                Text("Doctor's Words")
                    .font(.heading1(size: 36))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 100)

                // Mascot
                Image("NomiHome")
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
                        .fixedSize(horizontal: false, vertical: true)   // ← force vertical expansion
                }
                .padding(.horizontal)
                .padding(.top, 36)
                .frame(width: 335, height:  189)

                Spacer()

                // CTA Button
                WideButton(title: "Start", icon: nil) {
                    // TODO: navigate to next screen
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    DoctorWordsScreen()
}
