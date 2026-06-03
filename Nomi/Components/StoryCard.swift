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
            // Left arrow (triangle pointing left)
            arrowButton(pointsLeft: true, action: onPrev)

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

            // Right arrow (triangle pointing right)
            arrowButton(pointsLeft: false, action: onNext)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func arrowButton(pointsLeft: Bool, action: (() -> Void)?) -> some View {
        if let action {
            Button(action: action) {
                TriangleShape()
                    .fill(Color.nomiPrimarySoft)
                    .rotationEffect(.degrees(pointsLeft ? 180 : 0))
                    .frame(width: 28, height: 28)
                    .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
            }
        } else {
            // Placeholder kosong biar layout tetap simetris
            Color.clear.frame(width: 28, height: 28)
        }
    }
}

// MARK: - Triangle Shape (default points right, dengan rounded corners)
struct TriangleShape: Shape {
    var cornerRadius: CGFloat = 6   // 0 = sharp, > 0 = rounded

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // 3 corner points
        let topLeft     = CGPoint(x: rect.minX, y: rect.minY)
        let rightPeak   = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomLeft  = CGPoint(x: rect.minX, y: rect.maxY)

        if cornerRadius > 0 {
            // Start di midpoint edge top-left → right-peak
            path.move(to: CGPoint(
                x: (topLeft.x + rightPeak.x) / 2,
                y: (topLeft.y + rightPeak.y) / 2
            ))
            // Round corner di right-peak (heading from current point ke arah bottom-left)
            path.addArc(tangent1End: rightPeak,  tangent2End: bottomLeft, radius: cornerRadius)
            // Round corner di bottom-left
            path.addArc(tangent1End: bottomLeft, tangent2End: topLeft,    radius: cornerRadius)
            // Round corner di top-left
            path.addArc(tangent1End: topLeft,    tangent2End: rightPeak,  radius: cornerRadius)
            path.closeSubpath()
        } else {
            // Sharp triangle
            path.move(to: topLeft)
            path.addLine(to: rightPeak)
            path.addLine(to: bottomLeft)
            path.closeSubpath()
        }
        return path
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
