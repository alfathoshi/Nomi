//
//  TTSManager.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 05/06/26.
//
//  Reference: https://developer.apple.com/documentation/avfoundation/speech-synthesis
//

import Foundation
import AVFoundation
import Combine

/// Manages Text-to-Speech playback using Apple's AVSpeechSynthesizer.
///
/// Features:
/// - **Best voice auto-pick**: premium → enhanced → default per language
/// - **Audio session config**: ducks other audio (e.g., background music)
/// - **Word range tracking** via `currentWordRange` (useful untuk highlight text)
/// - **Toggle behavior**: `speak()` saat lagi speaking → auto stop
///
/// Usage:
/// ```swift
/// @StateObject private var tts = TTSManager()
/// tts.speak("Hello world")
/// tts.stop()
/// ```
class TTSManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    // MARK: - Published State

    @Published var isSpeaking = false

    /// Range kata yang lagi diucapkan — bisa dipake buat highlight teks.
    /// `nil` saat tidak ada yang sedang diucapkan.
    @Published var currentWordRange: Range<String.Index>? = nil

    // MARK: - Configurable Properties

    /// Language code (e.g., "en-US", "id-ID", "en-GB"). See `AVSpeechSynthesisVoice.speechVoices()` untuk full list.
    var language: String = "en-US"

    /// Speech rate. `AVSpeechUtteranceDefaultSpeechRate` (~0.5) is natural pace.
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate

    /// Pitch multiplier. 0.5 = low, 1.0 = normal, 2.0 = high.
    var pitchMultiplier: Float = 2

    /// Volume (0.0 - 1.0).
    var volume: Float = 1.0

    /// Delay setelah utterance selesai (seconds).
    var postUtteranceDelay: TimeInterval = 0.0

    // MARK: - Private

    private let synthesizer = AVSpeechSynthesizer()

    // MARK: - Init

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    // MARK: - Public Methods

    /// Speak text. Kalau lagi speaking, akan stop instead (toggle).
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

    /// Immediately stop current speech.
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    /// Pause current speech (gak stop, bisa di-resume).
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }

    /// Resume paused speech.
    func resume() {
        synthesizer.continueSpeaking()
    }

    // MARK: - Audio Session

    /// Configure shared audio session — `.spokenAudio` mode dengan `.duckOthers` (ngedukin musik background pas TTS jalan).
    /// Wrapped dalam `#if os(iOS)` karena `AVAudioSession` hanya available di iOS, iPadOS, tvOS, visionOS.
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

    // MARK: - Voice Presets

    /// Preset karakter suara — quick switch antara different "personalities".
    enum VoicePreset {
        case normal            // suara natural default
        case child             // anak-anak (high pitch, slightly fast)
        case robot             // monoton, sedikit slow
        case grandparent       // pelan, low pitch
        case excited           // tinggi & cepet (energi tinggi)
    }

    /// Apply voice preset — adjust pitch + rate.
    func applyPreset(_ preset: VoicePreset) {
        switch preset {
        case .normal:
            pitchMultiplier = 1.0
            rate = AVSpeechUtteranceDefaultSpeechRate
        case .child:
            pitchMultiplier = 1.6                                    // higher pitch = younger
            rate = 0.52                                              // slightly fast, playful
        case .robot:
            pitchMultiplier = 0.8
            rate = 0.45
        case .grandparent:
            pitchMultiplier = 0.85
            rate = 0.40                                              // pelan
        case .excited:
            pitchMultiplier = 1.4
            rate = 0.58
        }
    }

    // MARK: - Voice Selection

    /// Pilih voice terbaik untuk language tertentu.
    /// Prefer urutan: **premium → enhanced → default**.
    /// Voice premium/enhanced perlu di-download manual di Settings → Accessibility → Spoken Content → Voices.
    private func bestVoice(for language: String) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == language }
        return voices.first(where: { $0.quality == .premium })
            ?? voices.first(where: { $0.quality == .enhanced })
            ?? voices.first
            ?? AVSpeechSynthesisVoice(language: language)
    }

    // MARK: - AVSpeechSynthesizerDelegate

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

    /// Tracks kata yang sedang diucapkan — update `currentWordRange` realtime.
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        if let range = Range(characterRange, in: utterance.speechString) {
            currentWordRange = range
        }
    }
}
