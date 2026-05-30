//
//  KeypadButton.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct KeypadButton: View {

    let value: String?
    let label: String?
    let icon: String?
    let action: () -> Void
    
    init(value: String? = nil, label: String? = nil, icon: String? = nil, action: @escaping () -> Void) {
        self.value = value
        self.label = label
        self.icon = icon
        self.action = action
    }

    var body: some View {

        Button {

            action()

        } label: {

            VStack(spacing: 4) {

                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(Color.nomiTextPrimary)
                }

                if let value {
                    Text(value)
                        .font(.heading1())
                        .foregroundStyle(Color.nomiTextPrimary)
                }

                if let label {
                    Text(label)
                        .font(.label(size: 10))
                        .foregroundStyle(Color.nomiTextSecondary)
                }
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 64
            )
            .padding(16)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .shadow(
                color: .black.opacity(0.06),
                radius: 8,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(.plain)
    }
}
