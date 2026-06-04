//
//  ChipCapsule.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 28/05/26.
//

import SwiftUI

struct ChipCapsule: View {
    let title: String
    let leftIcon: String?
    let rightIcon: String?
    let foregroundColor: Color
    let backgroundColor: Color
    let action: (() -> Void)?

    init(
        title: String,
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        foregroundColor: Color,
        backgroundColor: Color,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }

    var body: some View {
        Button(action: {action?()}) {
            HStack(spacing: 6) {

                if let leftIcon {
                    Image(systemName: leftIcon)
                        .font(.caption)
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                if let rightIcon {
                    Image(systemName: rightIcon)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
