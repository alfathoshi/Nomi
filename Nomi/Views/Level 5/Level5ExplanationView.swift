//
//  Level5ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI
import AVFoundation

struct Level5ExplanationView: View {
    let highlight = Text("Trust Promise together")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToChildPromise = false
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        NavigationStack {
            LevelExplanationScreen(
                title: "The Trust Contract",
                mascotImage: "NomiDefault",
                paragraphs: [
                    Text("Now it’s time to find your Trusted Adult!").font(.heading2(weight: .black, size: 20)),
                    Text(" Go invite a Parent, Guardian, or safe grown-up to join you for a special \(highlight)").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "My Trusted Adult is Here",
            ) {
                navigateToChildPromise.toggle()
            }
            .onAppear {
                playNarration(named: "Level-5-Explanation", fileExtension: "mp3")
            }
            .onDisappear {
                stopNarration()
            }
            .navigationDestination(isPresented: $navigateToChildPromise) {
                ChildPromiseView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func playNarration(named fileName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Narration audio not found: \(fileName).\(fileExtension)")
            return
        }

        print("Narration audio found: \(url.lastPathComponent)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

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
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

#Preview {
    Level5ExplanationView()
}
