//
//  ScenarioQuizView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI

struct ScenarioQuizView: View {
    var onComplete: () -> Void = {}

    private let scenarioData = ScenarioData()
    private let correctAnswers: [Bool] = [false, true]
    @StateObject private var narrationAudio = AudioManager()
    @StateObject private var feedbackAudio = AudioManager()
    
    @State private var currentIndex = 0
    @State private var shakeAmount: CGFloat = 0
    @State private var showCelebration = false
    @State private var showCongratsPopup = false
    @State private var narrationTask: Task<Void, Never>?
    @State private var feedbackTask: Task<Void, Never>?
    
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
                    if showCongratsPopup {
                        CongratsPopUp(
                            title: "Level 4 Complete",
                            mascotImage: "NomiHome",
                            buttonTitle: "Next",
                            onDismiss: {
                                showCongratsPopup = false
                            },
                            onNext: {
                                showCongratsPopup = false
                                onComplete()
                            }
                        )
                        .zIndex(100)
                    }
                }
            }
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                playCurrentScenarioAudio()
            }
            .onChange(of: currentIndex) { _, _ in
                playCurrentScenarioAudio()
            }
            .onDisappear {
                narrationTask?.cancel()
                feedbackTask?.cancel()
                narrationAudio.stop()
                feedbackAudio.stop()
            }
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
        narrationTask?.cancel()
        narrationAudio.stop()
        playFeedbackAfterDelay("correct-answer")
    }

    private func playWrongAnswerSound() {
        playFeedbackAfterDelay("wrong-answer")
    }

    private func playCurrentScenarioAudio() {
        let audioNames = scenarioData.scenarios[currentIndex].audioNames
        narrationAudio.stop()
        narrationTask?.cancel()

        narrationTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            guard !Task.isCancelled else { return }
            narrationAudio.playSequence(audioNames: audioNames)
        }
    }

    private func playFeedbackAfterDelay(_ audioName: String) {
        feedbackAudio.stop()
        feedbackTask?.cancel()

        feedbackTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5))
            guard !Task.isCancelled else { return }
            feedbackAudio.play(audioName: audioName)
        }
    }

    private func goToNextScenario() {
        if currentIndex < scenarioData.scenarios.count - 1 {
            currentIndex += 1
        } else {
            LearningProgress.complete(level: 4)
            showCongratsPopup = true
        }
    }

    private func finishCelebration() {
        guard showCelebration else { return }
        showCelebration = false
        goToNextScenario()
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
