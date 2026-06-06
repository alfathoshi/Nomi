//
//  Level3ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI
import AVFoundation

struct Level3ExplanationView: View {
    let highlight1 = Text("Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("Non-Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToWordSorting = false
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        NavigationStack {
            LevelExplanationScreen(
                title: "Doctor's Words",
                mascotImage: "NomiDoctor",
                paragraphs: [
                    Text("Let’s refresh your memory!").font(.heading2(weight: .black, size: 20)),
                    Text("Drag the \(highlight1) and the \(highlight2) of your body to the designated sides!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
            ) {
                navigateToWordSorting.toggle()
            }
            .onAppear {
                playNarration(named: "Level-3-Explanation", fileExtension: "mp3")
            }
            .onDisappear {
                stopNarration()
            }
            .navigationDestination(isPresented: $navigateToWordSorting) {
                WordSortingView()
                    .navigationBarBackButtonHidden(true)
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
    Level3ExplanationView()
}
