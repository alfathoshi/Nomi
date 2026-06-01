//
//  LevelBadge.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 28/05/26.
//

import SwiftUI

struct LevelBadge: View {
    let level: Int
    let title: String
    var pointerUp: Bool = true

    var body: some View {
        ZStack {
            LevelBadgeShape()
                .fill(Color.nomiPrimary)
                .scaleEffect(y: pointerUp ? 1 : -1)   // flip shape kalau pointer ke bawah

            VStack(spacing: 2) {
                Text("Level \(level)")
                Text(title)
            }
            .font(.bodySmall(weight: .bold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            // Padding swap berdasarkan arah pointer
            .padding(.top, pointerUp ? 22 : 8)
            .padding(.bottom, pointerUp ? 8 : 22)
            .padding(.horizontal, 24)
        }
        .fixedSize()
    }
}

#Preview("Pointer Up (badge BELOW node)") {
    LevelBadge(level: 1, title: "My Body", pointerUp: true)
        .padding()
}

#Preview("Pointer Down (badge ABOVE node)") {
    LevelBadge(level: 4, title: "What to do if unsafe", pointerUp: false)
        .padding()
}
