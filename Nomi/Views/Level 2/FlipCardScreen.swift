//
//  FlipCardScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

let cardWidth: CGFloat = 320
let cardHeight: CGFloat = 390
let cardCornerRadius: CGFloat = 32

struct FlipCardScreen: View {
    var onComplete: () -> Void = {}

    let cards: [FlipCard] = FlipCardData.cards

    @State private var currentIndex = 0
    @State private var showCompletionPopup = false
    @State private var showConfetti = false
    @StateObject private var audio = AudioManager()
    private var currentCard: FlipCard {
        cards[currentIndex]
    }

    var body: some View {
        ZStack {
            Image(.storyBackground)
                .resizable()
                .scaledToFill()
                .frame(
                    width: screenSize.width,
                    height: screenSize.height
                )
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Doctor's Words")
                    .font(.heading1(size: 36))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 100)

                cardStack
                    .padding(.top, 78)

                Spacer()
                Spacer()
            }

            if showConfetti {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                LottieWrapper(fileName: "confetti")
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            if showCompletionPopup {
                CongratsPopUp(
                    title: "Level 2 Complete",
                    mascotImage: "NomiDoctor",
                    buttonTitle: "Next",
                    onDismiss: dismissPopup,
                    onNext: {
                        showCompletionPopup = false
                        onComplete()
                    }
                )
                .zIndex(100)
            }
        }
        .onDisappear {
            audio.stop()
        }
    }

    // card stack
    private var cardStack: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(.white)
                .frame(width: cardWidth, height: cardHeight)
                .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
                .offset(x: 12, y: 12)
                .rotationEffect(.degrees(4))

            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(.white)
                .frame(width: cardWidth, height: cardHeight)
                .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
                .offset(x: 6, y: 6)
                .rotationEffect(.degrees(2))

            FlippableCardView(
                card: currentCard,
                onPlayAudio: { audioName in
                    audio.play(audioName: audioName)
                },
                onNext: nextCard
            )
                .id(currentIndex)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.85).combined(with: .opacity),
                    removal: .shuffleAway
                ))
        }
    }

    private func nextCard() {
        if currentIndex >= cards.count - 1 {
            audio.stop()
            audio.play(audioName: "correct-answer")
            LearningProgress.complete(level: 2)
            showConfetti = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                audio.stop()
                showConfetti = false

                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showCompletionPopup = true
                }
            }
        } else {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex += 1
            }
        }
    }

    private func dismissPopup() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompletionPopup = false
            currentIndex = 0
        }
    }
}

// flippable
struct FlippableCardView: View {
    let card: FlipCard
    let onPlayAudio: (String) -> Void
    let onNext: () -> Void

    @State private var isFlipped = false
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            frontCard
                .opacity(isFlipped ? 0 : 1)

            backCard
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.8), value: isFlipped)
        .onAppear {
            onPlayAudio(card.frontAudioName)
        }
    }

    private var frontCard: some View {
        Button {
            isFlipped = true
            onPlayAudio(card.backAudioName)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(Color.nomiPrimarySoft)

                VStack(spacing: 24) {
                    Spacer()

                    Image(card.frontImage)
                        .fixedSize()

                    Text(card.frontLabel)
                        .font(.display())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)


                    tapIndicator
                        .padding(.bottom, 30)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .shadow(color: .nomiPrimary.opacity(0.3), radius: 10, y: 6)
        }
        .buttonStyle(CardButtonStyle())
    }

    private var backCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(.white)

            VStack(spacing: 8) {
                Spacer()

                ForEach(card.realNames.indices, id: \.self) { i in
                    Text(card.realNames[i])
                        .font(.heading1())
                        .foregroundColor(.nomiPrimary)
                }

                if let alternative = card.alternativeName {
                    Text("also known as")
                        .font(.bodyMedium())
                        .foregroundColor(.nomiTextSecondary)
                        .padding(.top, 8)

                    Text("\u{201C}\(alternative)\u{201D}")
                        .font(.heading3())
                        .foregroundColor(.nomiTextPrimary)
                }

                Spacer()

                Button(action: onNext) {
                    HStack(spacing: 8) {
                        Text("Next Card")
                            .font(.heading3())
                            .foregroundColor(.white)

                        Image(systemName: "rectangle.portrait.on.rectangle.portrait")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.nomiPrimary))
                }
                .padding(.bottom, 30)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
    }


    private var tapIndicator: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 80, height: 80)
                .scaleEffect(isPulsing ? 1.15 : 1.0)
                .opacity(isPulsing ? 0.3 : 0.8)

            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .opacity(isPulsing ? 0.4 : 0.9)

            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)

            VStack() {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.nomiPrimary)
                    .offset(y:3)
                Text("Tap")
                    .font(.bodySmall())
                    .foregroundColor(Color.nomiPrimary)
                    .offset(y:-2)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

struct ShuffleAwayModifier: ViewModifier {
    var progress: Double

    func body(content: Content) -> some View {
        content
            .offset(
                x: progress * 30,
                y: progress * 80
            )
            .rotationEffect(.degrees(progress * 15))
            .scaleEffect(1 - progress * 0.3)
            .opacity(1 - progress)
    }
}

extension AnyTransition {
    static var shuffleAway: AnyTransition {
        .modifier(
            active: ShuffleAwayModifier(progress: 1),
            identity: ShuffleAwayModifier(progress: 0)
        )
    }
}

#Preview {
    FlipCardScreen()
}
