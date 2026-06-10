//
//  Level4ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI

struct Level4ExplanationView: View {
    var onComplete: () -> Void = {}
    var onBack: () -> Void = {}

    let highlight1 = Text("SAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("UNSAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToScenarioQuiz = false
    @StateObject private var audio = AudioManager()
    var body: some View {
        Group {
            if navigateToScenarioQuiz {
                ScenarioQuizView(
                    onComplete: onComplete,
                    onBack: {
                        navigateToScenarioQuiz = false
                    }
                )
            } else {
            LevelExplanationScreen(
                title: "Safety Detective",
                mascotImage: "NomiDefault",
                paragraphs: [
                    Text("Your private parts belong only to you. Some situations are \(highlight1), like getting help from a parent or doctor. Other situations are \(highlight2). Let's decide which is which!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
                onBack: onBack,
                isMuted: audio.isMuted,
                onToggleMute: toggleMute
            ) {
                navigateToScenarioQuiz.toggle()
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
        audio.play(audioName: "Level-4-Explanation")
    }
}

#Preview {
    Level4ExplanationView()
}
