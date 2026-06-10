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
    let background: Color?
    let foreground: Color?
    let action: () -> Void
    
    init(title: String, icon: String? = nil, background: Color? = nil, foreground: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.background = background
        self.foreground = foreground
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.button())

                if let icon {
                    Image(systemName: icon)
                }
            }
            .foregroundStyle(foreground ?? .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .shadow(
                color: (background ?? Color.nomiPrimary).opacity(0.35),
                radius: 20,
                x: 0,
                y: 6
            )
        }
        .buttonStyle(.glassProminent)
        .tint(background ?? Color.nomiPrimary)
    }
}

#Preview {
    WideButton(title: "Login", icon: "person.crop.circle", action: {})
}
