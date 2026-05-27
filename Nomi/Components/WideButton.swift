//
//  WideButton.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 27/05/26.
//

import SwiftUI

struct WideButton: View {

    let title: String
    let icon: String?
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 8) {
                Text(title)
                    .font(.button())
                    .foregroundStyle(.white)
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.nomiPrimary)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 24
                )
            )
            .shadow(
                color: Color.nomiPrimary.opacity(0.35),
                radius: 20,
                x: 0,
                y: 6
            )
        }
    }
}

#Preview {
    WideButton(title: "Login", icon: "person.crop.circle", action: {})
}
