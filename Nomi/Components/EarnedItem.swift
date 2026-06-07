//
//  EarnedItem.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 08/06/26.
//

import SwiftUI

struct EarnedItem: View {
    let emoji: String
    let backgroundColor: Color
    let title: String
    let subtitle: String
    var body: some View {
        HStack(spacing: 24) {
            Text(emoji)
                .font(.system(size: 35))
                .frame(width: 50, height: 50)
                .background(backgroundColor)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.heading3(weight: .extraBold))
                    .foregroundColor(.nomiTextPrimary)
                Text(subtitle)
                    .font(.bodyLarge(size: 14))
                    .foregroundColor(.nomiTextSecondary)
            }
            Spacer()
        }
    }
}
