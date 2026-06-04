//
//  AgeButton.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct AgeButton: View {
    let age: Int
    @Binding var selectedAge: Int?

    var body: some View {
        Button {
            selectedAge = age
        } label: {
            Text("\(age)")
                .font(.bodyLarge())
                .foregroundColor(selectedAge == age ? .nomiTextOnDark : .nomiTextPrimary)
                .frame(width: 80, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedAge == age ? Color.nomiPrimary : .clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                )
        }
    }
}
