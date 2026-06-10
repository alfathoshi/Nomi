//
//  Level3ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI

struct Level3ExplanationView: View {
    var onComplete: () -> Void = {}
    var onBack: () -> Void = {}

    let highlight1 = Text("Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("Non-Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToWordSorting = false
    @StateObject private var audio = AudioManager()
    var body: some View {
        Group {
            if navigateToWordSorting {
                WordSortingView(
                    onComplete: onComplete,
                    onBack: {
                        navigateToWordSorting = false
                    }
                )
            } else {
            LevelExplanationScreen(
                title: "Doctor's Words",
                mascotImage: "NomiDoctor",
                paragraphs: [
                    Text("Let’s refresh your memory!").font(.heading2(weight: .black, size: 20)),
                    Text("Drag the \(highlight1) and the \(highlight2) of your body to the designated sides!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
                onBack: onBack,
                isMuted: audio.isMuted,
                onToggleMute: toggleMute
            ) {
                navigateToWordSorting.toggle()
            }
            .onAppear {
                playNarration()
            }
            .onDisappear {
                audio.stop()
            }
            }
        }
    }

    private func toggleMute() {
        audio.toggleMute()
        if !audio.isMuted {
            playNarration()
        }
    }

    private func playNarration() {
        audio.play(audioName: "Level-3-Explanation")
    }
}

#Preview {
    Level3ExplanationView()
}
