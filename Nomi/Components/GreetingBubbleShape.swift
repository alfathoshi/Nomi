//
//  GreetingBubbleShape.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//
//  Translated from bubble.svg
//  Capsule body (305×114) + organic dripping tail to (211, 206)
//

import SwiftUI

struct GreetingBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // SVG reference: 305 × 206
        let sx = rect.width / 305
        let sy = rect.height / 206

        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: x * sx, y: y * sy)
        }

        // Capsule constants — body 305×114 with radius 57 (= height/2)
        let k: CGFloat = 31.48   // bezier kappa: 57 * 0.5523

        // ─── Start at top-left after rounded corner ───
        path.move(to: p(57, 0))

        // Top edge to top-right corner start
        path.addLine(to: p(248, 0))

        // RIGHT semicircle (CW)
        path.addCurve(to: p(305, 57),  control1: p(248 + k, 0),   control2: p(305, 57 - k))
        path.addCurve(to: p(248, 114), control1: p(305, 57 + k),  control2: p(248 + k, 114))

        // Bottom edge to tail entry (right side)
        path.addLine(to: p(231.23, 114))

        // ─── TAIL: organic dripping curves (decoded from SVG bezier) ───
        // Right side going DOWN to tip at (210.93, 206)
        path.addCurve(to: p(225.36, 119.81), control1: p(228.36, 114),    control2: p(226.64, 115.93))
        path.addCurve(to: p(222.06, 137.24), control1: p(224.07, 123.68), control2: p(223.21, 129.49))
        path.addCurve(to: p(218.62, 162.91), control1: p(220.91, 144.99), control2: p(219.77, 153.71))
        path.addCurve(to: p(215.18, 191.48), control1: p(217.48, 172.11), control2: p(216.33, 181.79))
        path.addCurve(to: p(210.93, 206),    control1: p(214.03, 201.16), control2: p(212.49, 206))   // ← TIP

        // Left side going UP back to bubble bottom
        path.addCurve(to: p(206.69, 191.48), control1: p(209.38, 206),    control2: p(207.83, 201.16))
        path.addCurve(to: p(203.25, 162.91), control1: p(205.54, 181.79), control2: p(204.39, 172.11))
        path.addCurve(to: p(199.81, 137.24), control1: p(202.10, 153.71), control2: p(200.95, 144.99))
        path.addCurve(to: p(196.51, 119.81), control1: p(198.66, 129.49), control2: p(197.80, 123.68))
        path.addCurve(to: p(190.64, 114),    control1: p(195.22, 115.93), control2: p(193.50, 114))

        // Bottom edge to left semicircle start
        path.addLine(to: p(57, 114))

        // LEFT semicircle (CW)
        path.addCurve(to: p(0, 57),  control1: p(57 - k, 114), control2: p(0, 57 + k))
        path.addCurve(to: p(57, 0),  control1: p(0, 57 - k),   control2: p(57 - k, 0))

        path.closeSubpath()
        return path
    }
}

#Preview("Shape Only") {
    GreetingBubbleShape()
        .fill(Color(red: 0.953, green: 0.937, blue: 0.996))   // #F3EFFE
        .frame(width: 305, height: 206)
        .padding()
        .background(Color.purple.opacity(0.3))
}

#Preview("With Text") {
    ZStack {
        GreetingBubbleShape()
            .fill(Color(red: 0.953, green: 0.937, blue: 0.996))

        VStack(alignment: .leading, spacing: 4) {
            Text("Morning, Xatriya")
                .font(.heading2())
                .foregroundColor(.nomiTextPrimary)
            Text("What do you want to learn?")
                .font(.bodyMedium())
                .foregroundColor(.nomiTextPrimary)
            Text("Tap me to know me 👆")
                .font(.bodySmall(weight: .bold))
                .foregroundColor(.nomiPrimary)
                .padding(.top, 4)
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 100)
    }
    .frame(width: 305, height: 206)
    .padding()
    .background(Color.purple.opacity(0.5))
}
