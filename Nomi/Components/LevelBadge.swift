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

    var body: some View {
        VStack(spacing: 2) {
            Text("Level \(level)")
                .font(.label())
            Text(title)
                .font(.label())
        }
        .foregroundColor(.white)
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 60)
                .fill(Color.nomiPrimary)
        )
    }
}


#Preview {
    LevelBadge(level: 1, title: "My Body")
}
