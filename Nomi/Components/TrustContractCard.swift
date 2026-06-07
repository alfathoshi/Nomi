//
//  TrustContractCard.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct TrustContractCard: View {
    let mascotImage: String
    let title: String
    let dividerIcon: String
    let promiseText: String
    let surfaceColor: Color
    let color: Color

    var body: some View {
        VStack(spacing: 0) {
            Image(mascotImage)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .background(
                    Circle()
                        .fill(color.opacity(0.18))
                        .frame(width: 120, height: 120)
                )
                .padding(.bottom, 24)

            Text(title)
                .font(.heading3())
                .foregroundColor(color)
                
            Spacer()

            ZStack {
                Rectangle()
                    .fill(Color.nomiTextHint.opacity(0.25))
                    .frame(height: 1)

                Text(dividerIcon)
                    .font(.system(size: 16))
                    .background(surfaceColor)
            }
            .padding(.horizontal, 20)
            
            Spacer()

            Text(promiseText)
                .font(.heading3())
                .foregroundColor(.nomiTextPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                
        }
        .frame(width: 340, height: 380)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(surfaceColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.65), lineWidth: 1)
        )
    }
}

#Preview {
    TrustContractCard(
        mascotImage: "NomiHome",
        title: "Child’s Promise",
        dividerIcon: "💜",
        promiseText: """
        I promise to speak up
        when something doesn't
        feel right and ask for
        help when I need it.
        """,
        surfaceColor: .nomiSurfaceTint,
        color: .nomiPrimary
    )
}
