//
//  AudioManager.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 06/06/26.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isMuted: Bool = false
    @Published var isPlaying: Bool = false

    var onPlaybackFinished: (() -> Void)?

    private var player: AVAudioPlayer?
    private var queuedAudioURLs: [URL] = []

    override init() {
        super.init()
        configureAudioSession()
    }

    func play(audioName: String, fileExtension: String = "mp3", volume: Float = 1.0) {
        stop()

        guard !isMuted else { return }

        guard let url = Bundle.main.url(forResource: audioName, withExtension: fileExtension) else {
            print("⚠️ AudioManager: Audio file not found — \(audioName).\(fileExtension)")
            return
        }

        play(url: url, volume: volume)
    }

    func playSequence(audioNames: [String], fileExtension: String = "mp3") {
        stop()

        guard !isMuted else { return }

        queuedAudioURLs = audioNames.compactMap { audioName in
            guard let url = Bundle.main.url(forResource: audioName, withExtension: fileExtension) else {
                print("⚠️ AudioManager: Audio file not found — \(audioName).\(fileExtension)")
                return nil
            }
            return url
        }

        playNextQueuedAudio()
    }

    private func play(url: URL, volume: Float = 1.0) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.volume = volume
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
        } catch {
            print("⚠️ AudioManager: Failed to play — \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
        queuedAudioURLs.removeAll()
        isPlaying = false
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        guard !isMuted, let player else { return }
        player.play()
        isPlaying = true
    }

    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            stop()
        }
    }

    private func configureAudioSession() {
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ AudioManager: Failed to configure audio session — \(error.localizedDescription)")
        }
        #endif
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if queuedAudioURLs.isEmpty {
            onPlaybackFinished?()
        }
        playNextQueuedAudio()
    }

    private func playNextQueuedAudio() {
        guard !queuedAudioURLs.isEmpty else {
            player = nil
            isPlaying = false
            return
        }

        let nextURL = queuedAudioURLs.removeFirst()
        play(url: nextURL)
    }
}
