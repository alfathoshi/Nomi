//
//  AvatarButton.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct AvatarButton: View {
    let avatar: String
    @Binding var selectedAvatar: String?

    var body: some View {
        Button {
            selectedAvatar = avatar
        } label: {
            Text(avatar)
                .font(.display())
                .foregroundColor(selectedAvatar == avatar ? .nomiTextOnDark : .nomiTextPrimary)
                .frame(width: 72, height: 72)
                .background(
                    RoundedRectangle(cornerRadius: 21)
                        .fill(selectedAvatar == avatar ? Color.nomiSurfaceTint : .clear)
                        .stroke(selectedAvatar == avatar ? Color.nomiPrimary : .clear, lineWidth: 2.5)
                        .frame(width: 66, height: 66)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2.5)
                )
        }
    }
}
