//
//  Level4ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI
import AVFoundation

struct Level4ExplanationView: View {
    var onComplete: () -> Void = {}

    let highlight1 = Text("SAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("UNSAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToScenarioQuiz = false
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        Group {
            if navigateToScenarioQuiz {
                ScenarioQuizView(onComplete: onComplete)
            } else {
            LevelExplanationScreen(
                title: "Safety Detective",
                mascotImage: "NomiDefault",
                paragraphs: [
                    Text("Your private parts belong only to you. Some situations are \(highlight1), like getting help from a parent or doctor. Other situations are \(highlight2). Let's decide which is which!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
            ) {
                navigateToScenarioQuiz.toggle()
            }
            .onAppear {
                playNarration(named: "Level-4-Explanation", fileExtension: "mp3")
            }
            .onDisappear {
                stopNarration()
            }
            }
        }
    }

    private func playNarration(named fileName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Narration audio not found: \(fileName).\(fileExtension)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play narration audio: \(error.localizedDescription)")
        }
    }

    private func stopNarration() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

#Preview {
    Level4ExplanationView()
}
