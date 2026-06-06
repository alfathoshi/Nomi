//
//  ScenarioQuizView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI
import AVFoundation

struct ScenarioQuizView: View {
    private let scenarioData = ScenarioData()
    private let correctAnswers: [Bool] = [false, true]
    private let speechSynthesizer = AVSpeechSynthesizer()
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var currentIndex = 0
    @State private var shakeAmount: CGFloat = 0
    @State private var navigateToTrustContract: Bool = false
    @State private var showCelebration = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image(.storyBackground)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()

                    VStack() {
                        Spacer()
                    Text("Safety Detective")
                        .font(.heading1(weight: .black, size: 38))
                        .foregroundStyle(Color.nomiTextPrimary)
                        .multilineTextAlignment(.center)
                        
                    
                    ScenarioCard(
                        image: scenarioData.scenarios[currentIndex].image,
                        text: scenarioData.scenarios[currentIndex].content
                    )
                    .padding(.horizontal, 22)
                    .modifier(ShakeEffect(animatableData: shakeAmount))

                    Spacer()

                    HStack(spacing: 14) {
                        WideButton(title: "Safe", background: .nomiSuccess, foreground: .white) {
                            checkAnswer(isSafeAnswer: true)
                        }

                        WideButton(title: "Unsafe", background: .nomiDanger, foreground: .white) {
                            checkAnswer(isSafeAnswer: false)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 44)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)

                    if showCelebration {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                finishCelebration()
                            }

                        LottieWrapper(fileName: "confetti")
                            .allowsHitTesting(false)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                    finishCelebration()
                                }
                            }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToTrustContract) {
                Level5ExplanationView()
                    .navigationBarBackButtonHidden(true)
            }
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    private func checkAnswer(isSafeAnswer: Bool) {
        let correctAnswer = correctAnswers[currentIndex]

        if isSafeAnswer == correctAnswer {
            playCorrectAnswerSound()
            showCelebration = true
        } else {
            withAnimation(.easeInOut(duration: 0.45)) {
                shakeAmount += 1
            }
            playWrongAnswerSound()
        }
    }
    
    private func playCorrectAnswerSound() {
        guard let url = Bundle.main.url(forResource: "correct-answer", withExtension: "mp3") else {
            print("Correct answer audio not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play correct answer audio: \(error.localizedDescription)")
        }
    }

    private func playWrongAnswerSound() {
        guard let url = Bundle.main.url(forResource: "wrong-answer", withExtension: "mp3") else {
            print("Wrong answer audio not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play wrong answer audio: \(error.localizedDescription)")
        }
    }

    private func goToNextScenario() {
        if currentIndex < scenarioData.scenarios.count - 1 {
            currentIndex += 1
        } else {
            navigateToTrustContract = true
        }
    }

    private func finishCelebration() {
        guard showCelebration else { return }
        showCelebration = false
        goToNextScenario()
    }

    private func playWrongAnswerVoice() {
        let voice = AVSpeechSynthesisVoice(
            identifier: "com.apple.voice.enhanced.en-US.Samantha"
        ) ?? AVSpeechSynthesisVoice(language: "en-US")

        let utterance = AVSpeechUtterance(string: """
            An older kid at the park says,
            "Let's go behind the tree and show each other our private parts. It's a fun game!"
            """)
        utterance.voice = voice

        speechSynthesizer.speak(utterance)
    }
}

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 20
    var numberOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: travelDistance * sin(animatableData * .pi * numberOfShakes),
                y: 0
            )
        )
    }
}

#Preview {
    ScenarioQuizView()
}
