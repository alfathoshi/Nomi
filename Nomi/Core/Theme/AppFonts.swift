//
//  AppFonts.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI

enum NunitoFont: String {

    case black = "Nunito-Black"

    case bold = "Nunito-Bold"

    case extraBold = "Nunito-ExtraBold"

    case italic = "Nunito-Italic"

    case light = "Nunito-Light"

    case medium = "Nunito-Medium"

    case regular = "Nunito-Regular"

    case semiBold = "Nunito-SemiBold"
}

extension Font {

    // Base Helper
    static func nunito(
        _ font: NunitoFont,
        size: CGFloat
    ) -> Font {

        .custom(font.rawValue, size: size)
    }

    // MARK: - Display
    static func display(
        weight: NunitoFont = .black,
        size: CGFloat = 42
    ) -> Font {

        .nunito(weight, size: size)
    }

    // MARK: - Heading
    static func heading1(
        weight: NunitoFont = .black,
        size: CGFloat = 28
    ) -> Font {

        .nunito(weight, size: size)
    }

    static func heading2(
        weight: NunitoFont = .extraBold,
        size: CGFloat = 22
    ) -> Font {

        .nunito(weight, size: size)
    }

    static func heading3(
        weight: NunitoFont = .extraBold,
        size: CGFloat = 18
    ) -> Font {

        .nunito(weight, size: size)
    }

    // MARK: - Body
    static func bodyLarge(
        weight: NunitoFont = .semiBold,
        size: CGFloat = 16
    ) -> Font {

        .nunito(weight, size: size)
    }

    static func bodyMedium(
        weight: NunitoFont = .regular,
        size: CGFloat = 15
    ) -> Font {

        .nunito(weight, size: size)
    }

    static func bodySmall(
        weight: NunitoFont = .semiBold,
        size: CGFloat = 14
    ) -> Font {

        .nunito(weight, size: size)
    }

    // MARK: - Label
    static func label(
        weight: NunitoFont = .bold,
        size: CGFloat = 12
    ) -> Font {

        .nunito(weight, size: size)
    }

    // MARK: - Button
    static func button(
        weight: NunitoFont = .extraBold,
        size: CGFloat = 17
    ) -> Font {

        .nunito(weight, size: size)
    }

    // MARK: - Caption
    static func caption(
        weight: NunitoFont = .medium,
        size: CGFloat = 11
    ) -> Font {

        .nunito(weight, size: size)
    }
}
