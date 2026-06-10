//
//  MascotBubble.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 28/05/26.
//

import SwiftUI

struct MascotBubble: View {
    let message: String
    var mascotImage: ImageResource = .mascot
    
    //to adjust the bubblechat
    var bubbleOffsetFromLeft: CGFloat = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack {
                SpeechBubbleShape()
                    .fill(.white)

                Text(message)
                    .font(.bodySmall(weight: .bold))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 18)
            }
            .fixedSize()
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            .padding(.leading, bubbleOffsetFromLeft)

            Image(mascotImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
        }
    }
}

struct SpeechBubbleShape: Shape {
    var tailWidth: CGFloat = 14
    var tailHeight: CGFloat = 10
    var tailOffsetFromLeft: CGFloat = 30
    var cornerRadius: CGFloat = 18

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let r = cornerRadius
        let k = r * 0.5523
        let bodyBottom = h - tailHeight

        let tailLeft = tailOffsetFromLeft
        let tailRight = tailLeft + tailWidth
        let tailTip = (tailLeft + tailRight) / 2

        path.move(to: CGPoint(x: r, y: 0))
        path.addLine(to: CGPoint(x: w - r, y: 0))
        path.addCurve(
            to: CGPoint(x: w, y: r),
            control1: CGPoint(x: w - r + k, y: 0),
            control2: CGPoint(x: w, y: r - k)
        )

        path.addLine(to: CGPoint(x: w, y: bodyBottom - r))
        path.addCurve(
            to: CGPoint(x: w - r, y: bodyBottom),
            control1: CGPoint(x: w, y: bodyBottom - r + k),
            control2: CGPoint(x: w - r + k, y: bodyBottom)
        )

        path.addLine(to: CGPoint(x: tailRight, y: bodyBottom))
        path.addLine(to: CGPoint(x: tailTip, y: h))
        path.addLine(to: CGPoint(x: tailLeft, y: bodyBottom))
        path.addLine(to: CGPoint(x: r, y: bodyBottom))

        // Bottom-left corner
        path.addCurve(
            to: CGPoint(x: 0, y: bodyBottom - r),
            control1: CGPoint(x: r - k, y: bodyBottom),
            control2: CGPoint(x: 0, y: bodyBottom - r + k)
        )

        // Left edge
        path.addLine(to: CGPoint(x: 0, y: r))

        // Top-left corner
        path.addCurve(
            to: CGPoint(x: r, y: 0),
            control1: CGPoint(x: 0, y: r - k),
            control2: CGPoint(x: r - k, y: 0)
        )

        path.closeSubpath()
        return path
    }
}

#Preview("Mascot Bubble") {
    MascotBubble(message: "Don't worry, I'm here")
        .padding()
}

#Preview("Bubble Shape Only") {
    SpeechBubbleShape()
        .fill(.white)
        .frame(width: 200, height: 60)
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        .padding()
}
