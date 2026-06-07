//
//  GreetingBubbleShape2.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 07/06/26.
//
//  Translated from bubble2.svg
//  Capsule body (305×114) + small downward nub to (211, 128)
//

import SwiftUI

struct GreetingBubbleShape2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // SVG reference: 305 × 128
        let sx = rect.width / 305
        let sy = rect.height / 128

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
        path.addLine(to: p(231.22, 114))

        // ─── TAIL: small downward nub (decoded from SVG bezier, reversed for CW) ───
        // Right side going DOWN to tip at (210.93, 128)
        path.addCurve(to: p(225.35, 114.88), control1: p(228.36, 114),    control2: p(226.64, 114.29))
        path.addCurve(to: p(222.06, 117.54), control1: p(224.06, 115.47), control2: p(223.20, 116.36))
        path.addCurve(to: p(218.62, 121.44), control1: p(220.91, 118.72), control2: p(219.77, 120.04))
        path.addCurve(to: p(215.18, 125.79), control1: p(217.47, 122.84), control2: p(216.33, 124.32))
        path.addCurve(to: p(210.93, 128),    control1: p(214.04, 127.26), control2: p(212.49, 128))   // ← TIP

        // Left side going UP back to bubble bottom
        path.addCurve(to: p(206.68, 125.79), control1: p(209.38, 128),    control2: p(207.83, 127.26))
        path.addCurve(to: p(203.25, 121.44), control1: p(205.54, 124.32), control2: p(204.39, 122.84))
        path.addCurve(to: p(199.81, 117.54), control1: p(202.10, 120.04), control2: p(200.95, 118.72))
        path.addCurve(to: p(196.51, 114.88), control1: p(198.66, 116.36), control2: p(197.80, 115.47))
        path.addCurve(to: p(190.64, 114),    control1: p(195.22, 114.29), control2: p(193.50, 114))

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
    GreetingBubbleShape2()
        .fill(Color(red: 0.953, green: 0.937, blue: 0.996))
        .frame(width: 305, height: 128)
        .padding()
        .background(Color.purple.opacity(0.3))
}

#Preview("With Text") {
    ZStack {
        GreetingBubbleShape2()
            .fill(Color(red: 0.953, green: 0.937, blue: 0.996))

        VStack(alignment: .leading, spacing: 4) {
            Text("Morning, Xatriya")
                .font(.heading2())
                .foregroundColor(.nomiTextPrimary)
            Text("What do you want to learn?")
                .font(.bodyMedium())
                .foregroundColor(.nomiTextPrimary)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
    }
    .frame(width: 305, height: 128)
    .padding()
    .background(Color.purple.opacity(0.5))
}
