//
//  CongratsPopUp.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 08/06/26.
//

import SwiftUI

struct CongratsPopUp: View {
    let title: String
    let mascotImage: String
    let buttonTitle: String
    let onDismiss: () -> Void
    let onNext: () -> Void

    init(
        title: String = "Level Complete",
        mascotImage: String = "NomiHome",
        buttonTitle: String = "Next Level",
        onDismiss: @escaping () -> Void = {},
        onNext: @escaping () -> Void = {}
    ) {
        self.title = title
        self.mascotImage = mascotImage
        self.buttonTitle = buttonTitle
        self.onDismiss = onDismiss
        self.onNext = onNext
    }
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    onDismiss()
                }
            VStack(spacing: 24) {
                Text(title)
                    .font(.heading1())
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 24)

                Image(mascotImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text(buttonTitle)
                            .font(.heading3())
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.nomiPrimary))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(.white)
            )
            .padding(.horizontal, 32)
            .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
            .transition(.scale(scale: 0.7).combined(with: .opacity))
        }
    }
}

#Preview {
    CongratsPopUp(
        title: "Level 2 Complete",
        mascotImage: "NomiHome",
        buttonTitle: "Next Level"
    )
}
 
