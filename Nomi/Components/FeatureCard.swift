//
//  FeatureCard.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 27/05/26.
//

import SwiftUI

struct FeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let iconColor: Color

    var body: some View {
        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.heading2())
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.bodySmall(weight: .bold))

                Text(subtitle)
                    .font(.bodySmall(weight: .regular))
            }

            Spacer()
        }
        .padding()
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    FeatureCard(icon: "star", title: "Starred", subtitle: "100+", color: .yellow, iconColor: .white)
}
