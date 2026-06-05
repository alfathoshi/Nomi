//
//  TTSManager.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 05/06/26.
//

import Foundation
import AVFoundation
import Combine

class TTSManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    @Published var isSpeaking = false
    @Published var currentWordRange: Range<String.Index>? = nil

    var language: String = "en-US"
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var pitchMultiplier: Float = 2
    var volume: Float = 1.0
    var postUtteranceDelay: TimeInterval = 0.0

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            stop()
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = pitchMultiplier
        utterance.volume = volume
        utterance.postUtteranceDelay = postUtteranceDelay
        utterance.voice = bestVoice(for: language)

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }

    func resume() {
        synthesizer.continueSpeaking()
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
            print("⚠️ TTSManager: Failed to configure audio session — \(error.localizedDescription)")
        }
        #endif
    }

    enum VoicePreset {
        case normal
        case child
        case robot
        case grandparent
        case excited
    }

    func applyPreset(_ preset: VoicePreset) {
        switch preset {
        case .normal:
            pitchMultiplier = 1.0
            rate = AVSpeechUtteranceDefaultSpeechRate
        case .child:
            pitchMultiplier = 1.6
            rate = 0.52
        case .robot:
            pitchMultiplier = 0.8
            rate = 0.45
        case .grandparent:
            pitchMultiplier = 0.85
            rate = 0.40
        case .excited:
            pitchMultiplier = 1.4
            rate = 0.58
        }
    }

    private func bestVoice(for language: String) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == language }
        return voices.first(where: { $0.quality == .premium })
            ?? voices.first(where: { $0.quality == .enhanced })
            ?? voices.first
            ?? AVSpeechSynthesisVoice(language: language)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        currentWordRange = nil
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        currentWordRange = nil
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        if let range = Range(characterRange, in: utterance.speechString) {
            currentWordRange = range
        }
    }
}
