//
//  GenderButton.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct GenderButton: View {
    let title: String
    @Binding var selectedGender: String?

    var body: some View {
        Button {
            selectedGender = title
        } label: {
            Text(title)
                .font(.bodyLarge())
                .foregroundColor(selectedGender == title ? .nomiTextOnDark : .nomiTextPrimary)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedGender == title ? Color.nomiPrimary : .clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                )
        }
    }
}
