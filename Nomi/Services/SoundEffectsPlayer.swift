//
//  SoundEffectsPlayer.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 10/06/26.
//

import AVFoundation

final class SoundEffectsPlayer {

    static let shared = SoundEffectsPlayer()

    private var players: [String: AVAudioPlayer] = [:]

    private init() {}

    func play(_ name: String, fileExtension: String = "mp3", volume: Float = 1.0) {
        let key = "\(name).\(fileExtension)"

        if players[key] == nil {
            guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
                print("⚠️ SoundEffectsPlayer: file not found — \(key)")
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[key] = player
            } catch {
                print("⚠️ SoundEffectsPlayer: failed to load — \(error.localizedDescription)")
                return
            }
        }

        players[key]?.volume = volume
        players[key]?.currentTime = 0
        players[key]?.play()
    }
}
