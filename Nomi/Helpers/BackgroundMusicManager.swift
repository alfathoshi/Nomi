//
//  BackgroundMusicManager.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import AVFoundation

final class BackgroundMusicManager {
    static let shared = BackgroundMusicManager()

    private var player: AVAudioPlayer?

    private init() {}

    func playMusic() {
        guard player == nil else { return }

        guard let url = Bundle.main.url(forResource: "bgm-main", withExtension: "mp3") else {
            print("Not Found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.35
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play music:", error.localizedDescription)
        }
    }

    func stopMusic() {
        player?.stop()
        player = nil
    }

    func pauseMusic() {
        player?.pause()
    }

    func resumeMusic() {
        player?.play()
    }

    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
}
