//
//  StoryCard.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 31/05/26.
//

import SwiftUI

struct StoryCard<Content: View>: View {
    var onPrev: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(spacing: 12) {
            // Left arrow
            arrowButton(systemName: "chevron.left", action: onPrev)

            // Card body
            VStack(spacing: 12) {
                content()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.nomiPrimarySoft.opacity(0.85))
            )
            .shadow(color: .black.opacity(0.1), radius: 10, y: 4)

            // Right arrow
            arrowButton(systemName: "chevron.right", action: onNext)
        }
        .padding(.horizontal, 16)   // ← outer margin biar gak nempel ke edge
    }

    @ViewBuilder
    private func arrowButton(systemName: String, action: (() -> Void)?) -> some View {
        if let action {
            Button(action: action) {
                Image(systemName: systemName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)         // ← icon putih kontras
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.nomiPrimary))   // ← lingkaran ungu solid
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            }
        } else {
            // Placeholder kosong biar layout tetap simetris
            Color.clear.frame(width: 36, height: 36)
        }
    }
}

#Preview("Story Card — full layout") {
    let amazing = Text("AMAZING?").foregroundColor(.nomiPrimary)

    ZStack {
        // Mock background (kayak page image story)
        LinearGradient(
            colors: [.purple.opacity(0.3), .pink.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack {
            StoryCard(
                onPrev: { print("prev") },
                onNext: { print("next") }
            ) {
                Text("Before we start,\ndid you know your body\nis \(amazing)")
                    .font(.heading3())
                    .multilineTextAlignment(.center)

                Text("It helps you run, jump,\nwiggle, dance, and\ngives the BEST hugs ever!")
                    .font(.bodyMedium(weight: .bold))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)

            Spacer()
        }
    }
}

#Preview("Story Card — no arrows") {
    StoryCard {
        Text("Sometimes our bodies feel ticklish, sometimes sleepy. That's totally normal!")
            .font(.bodyMedium(weight: .bold))
            .multilineTextAlignment(.center)
    }
    .padding(.vertical, 60)
    .background(Color.gray.opacity(0.2))
}
