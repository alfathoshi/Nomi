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

    @Binding var selectedPad: String?

    init(
        value: String? = nil,
        label: String? = nil,
        icon: String? = nil,
        selectedPad: Binding<String?>
    ) {
        self.value = value
        self.label = label
        self.icon = icon
        self._selectedPad = selectedPad
    }

    var body: some View {

        Button {

            selectedPad = value

        } label: {

            VStack(spacing: 4) {

                if let icon {

                    Image(systemName: icon)
                        .foregroundColor(selectedPad == value ? .white : .nomiTextPrimary)
                }

                if let value {

                    Text(value)
                        .font(.heading1())
                        .foregroundColor(selectedPad == value ? .white : .nomiTextPrimary)
                }

                if let label {

                    Text(label)
                        .font(.label(size: 10))
                        .foregroundColor(selectedPad == value ? .white : .nomiTextSecondary)
                }
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 64
            )
            .padding(16)
            .background(selectedPad == value ? Color.nomiPrimary : .white)
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
