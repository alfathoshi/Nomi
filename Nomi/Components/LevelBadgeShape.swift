//
//  LevelBadgeShape.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 30/05/26.
//

import SwiftUI

struct LevelBadgeShape: Shape {
    var pointerWidth: CGFloat = 36
    var pointerHeight: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Body = capsule, height = total - pointer height
        let bodyTop = pointerHeight
        let bodyBottom = rect.height
        let bodyRight = rect.width
        let bodyHeight = bodyBottom - bodyTop
        let cornerRadius = bodyHeight / 2
        let k = cornerRadius * 0.5523
        let centerX = rect.width / 2

        // Helper: convert SVG pointer coord ke actual coord
        // SVG pointer ref: x=26..78.69 (width 52.69), centered at 52.35
        //                  y=0..13 (height 13)
        func pp(_ svgX: CGFloat, _ svgY: CGFloat) -> CGPoint {
            let dx = (svgX - 52.35) / 52.69 * pointerWidth
            let y = svgY / 13 * pointerHeight
            return CGPoint(x: centerX + dx, y: y)
        }

        // ─── Start at top-left of body straight top edge ───
        path.move(to: CGPoint(x: cornerRadius, y: bodyTop))

        // 1. Line ke pointer left base
        path.addLine(to: pp(26, 13))
        path.addLine(to: pp(32.05, 13))

        // 2. POINTER ascending curves (left side, naik ke peak)
        path.addCurve(to: pp(37.92, 12.18), control1: pp(34.92, 13),    control2: pp(36.64, 12.73))
        path.addCurve(to: pp(41.22, 9.72),  control1: pp(39.21, 11.63), control2: pp(40.07, 10.81))
        path.addCurve(to: pp(44.66, 6.09),  control1: pp(42.37, 8.62),  control2: pp(43.51, 7.39))
        path.addCurve(to: pp(48.10, 2.05),  control1: pp(45.81, 4.79),  control2: pp(46.95, 3.42))
        path.addCurve(to: pp(52.35, 0),     control1: pp(49.25, 0.68),  control2: pp(50.80, 0))

        // 3. POINTER descending curves (right side, turun dari peak)
        path.addCurve(to: pp(56.59, 2.05),  control1: pp(53.90, 0),     control2: pp(55.45, 0.68))
        path.addCurve(to: pp(60.03, 6.09),  control1: pp(57.74, 3.42),  control2: pp(58.89, 4.79))
        path.addCurve(to: pp(63.47, 9.72),  control1: pp(61.18, 7.39),  control2: pp(62.33, 8.62))
        path.addCurve(to: pp(66.77, 12.18), control1: pp(64.62, 10.81), control2: pp(65.48, 11.63))
        path.addCurve(to: pp(72.64, 13),    control1: pp(68.06, 12.73), control2: pp(69.78, 13))
        path.addLine(to: pp(78.69, 13))

        // 4. Line ke top-right corner start
        path.addLine(to: CGPoint(x: bodyRight - cornerRadius, y: bodyTop))

        // 5. Top-right corner (quarter circle CW)
        path.addCurve(
            to: CGPoint(x: bodyRight, y: bodyTop + cornerRadius),
            control1: CGPoint(x: bodyRight - cornerRadius + k, y: bodyTop),
            control2: CGPoint(x: bodyRight, y: bodyTop + cornerRadius - k)
        )

        // 6. Right edge
        path.addLine(to: CGPoint(x: bodyRight, y: bodyBottom - cornerRadius))

        // 7. Bottom-right corner
        path.addCurve(
            to: CGPoint(x: bodyRight - cornerRadius, y: bodyBottom),
            control1: CGPoint(x: bodyRight, y: bodyBottom - cornerRadius + k),
            control2: CGPoint(x: bodyRight - cornerRadius + k, y: bodyBottom)
        )

        // 8. Bottom edge
        path.addLine(to: CGPoint(x: cornerRadius, y: bodyBottom))

        // 9. Bottom-left corner
        path.addCurve(
            to: CGPoint(x: 0, y: bodyBottom - cornerRadius),
            control1: CGPoint(x: cornerRadius - k, y: bodyBottom),
            control2: CGPoint(x: 0, y: bodyBottom - cornerRadius + k)
        )

        // 10. Left edge
        path.addLine(to: CGPoint(x: 0, y: bodyTop + cornerRadius))

        // 11. Top-left corner
        path.addCurve(
            to: CGPoint(x: cornerRadius, y: bodyTop),
            control1: CGPoint(x: 0, y: bodyTop + cornerRadius - k),
            control2: CGPoint(x: cornerRadius - k, y: bodyTop)
        )

        path.closeSubpath()
        return path
    }
}

#Preview("Shape Variations") {
    VStack(spacing: 16) {
        // Narrow badge
        LevelBadgeShape()
            .fill(Color.nomiPrimary)
            .frame(width: 100, height: 60)

        // Medium badge
        LevelBadgeShape()
            .fill(Color.nomiPrimary)
            .frame(width: 140, height: 60)

        // Wide badge
        LevelBadgeShape()
            .fill(Color.nomiPrimary)
            .frame(width: 200, height: 60)
    }
    .padding()
}
