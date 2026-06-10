//
//  NomiBackButton.swift
//  Nomi
//

import SwiftUI

struct NomiBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.nomiPrimary)
                .frame(width: 48, height: 48)
                .background(Circle().fill(Color.white))
                .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
        .tapSound()
    }
}
