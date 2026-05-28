//
//  MascotBubble.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 28/05/26.
//

import SwiftUI

struct MascotBubble: View {
    let message: String

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            VStack(alignment: .leading) {
                Text(message)
                    .font(.bodySmall(weight: .bold))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                    )
            }
            // Mascot
            Image("Mascot")
                .font(.system(size: 50))
                .foregroundStyle(Color.nomiPrimary)
        }
    }
}
