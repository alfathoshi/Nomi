//
//  SoundButtonStyle.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct SoundButtonStyle: ButtonStyle {
    var soundName: String = "ClickButton"
    var fileExtension: String = "m4a"
    var volume  : Float = 1.3
    var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed else { return }
                SoundEffectsPlayer.shared.play(soundName, fileExtension: fileExtension, volume: volume)
                #if canImport(UIKit)
                if let style = haptic {
                    UIImpactFeedbackGenerator(style: style).impactOccurred()
                }
                #endif
            }
    }
}

extension View {
    func tapSound(_ name: String = "ClickButton", fileExtension: String = "m4a", volume: Float = 1.5) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                SoundEffectsPlayer.shared.play(name, fileExtension: fileExtension, volume: volume)
            }
        )
    }
}
