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
    let cards: [FlipCard] = [
        FlipCard(
            frontLabel: "Boy's Private\nPart",
            frontEmoji: "🩲",
            realNames: ["Penis"],
            alternativeName: "Burung"
        ),
        FlipCard(
            frontLabel: "Girl's Private\nPart",
            frontEmoji: "👙",
            realNames: ["Vagina"],
            alternativeName: nil
        ),
        FlipCard(
            frontLabel: "Upper Private\nPart",
            frontEmoji: "👕",
            realNames: ["Chest", "Nipple"],
            alternativeName: nil
        ),
        FlipCard(
            frontLabel: "Back Private\nPart",
            frontEmoji: "🍑",
            realNames: ["Buttocks", "Bottom"],
            alternativeName: nil
        ),
    ]

    @State private var currentIndex = 0
    @State private var showCompletionPopup = false       // ← NEW: track popup visibility

    private var currentCard: FlipCard {
        cards[currentIndex]
    }

    var body: some View {
        ZStack {
            // Faded background
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
                // Title
                Text("Doctor's Words")
                    .font(.heading1(size: 36))
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 100)

                cardStack
                    .padding(.top, 78)

                Spacer()
                Spacer()
            }

            // Completion popup overlay
            if showCompletionPopup {
                completionPopup
            }
        }
    }

    // MARK: - Card Stack
    private var cardStack: some View {
        ZStack {
            // Background depth cards (decorative, static)
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

            // Active card — punya flip state sendiri
            // .id(currentIndex) → setiap card baru = view baru = state fresh
            FlippableCardView(card: currentCard, onNext: nextCard)
                .id(currentIndex)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.85).combined(with: .opacity),
                    removal: .shuffleAway
                ))
        }
    }

    // MARK: - Action — langsung shuffle tanpa flip animation
    private func nextCard() {
        // Kalau ini card terakhir → show popup, bukan loop ke card pertama
        if currentIndex >= cards.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showCompletionPopup = true
            }
        } else {
            // Belum terakhir → shuffle ke card berikutnya
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex += 1
            }
        }
    }

    // MARK: - Completion Popup (muncul setelah card terakhir)
    private var completionPopup: some View {
        ZStack {
            // Dim backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    // Optional: dismiss on background tap
                    dismissPopup()
                }

            // Popup card
            VStack(spacing: 24) {
                Text("Level 2 Complete")
                    .font(.heading1())
                    .foregroundColor(.nomiTextPrimary)
                    .padding(.top, 24)

                Image("NomiHome")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                Button(action: dismissPopup) {
                    HStack(spacing: 8) {
                        Text("Next Level")
                            .font(.heading3())
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(Color.nomiPrimary))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(.white)
            )
            .padding(.horizontal, 32)
            .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
            .transition(.scale(scale: 0.7).combined(with: .opacity))
        }
    }

    private func dismissPopup() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showCompletionPopup = false
            currentIndex = 0   // reset ke card pertama (atau navigate ke next screen)
        }
    }
}

// MARK: - Flippable Card View (encapsulates flip state)
struct FlippableCardView: View {
    let card: FlipCard
    let onNext: () -> Void

    // ← Flip state isolated per card instance
    //   New card = fresh state = isFlipped: false (front)
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            // FRONT
            frontCard
                .opacity(isFlipped ? 0 : 1)

            // BACK (pre-rotated 180° biar text readable saat flipped)
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
        .animation(.easeInOut(duration: 0.6), value: isFlipped)
    }

    // MARK: - Front (purple, tap to flip)
    private var frontCard: some View {
        Button {
            isFlipped = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(Color.nomiPrimarySoft)

                VStack(spacing: 24) {
                    Spacer()

                    Text(card.frontEmoji)
                        .font(.system(size: 100))

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

    // MARK: - Back (white, shows result + next button)
    private var backCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(.white)

            VStack(spacing: 8) {
                Spacer()

                ForEach(card.realNames.indices, id: \.self) { i in
                    if i > 0 {
                        Text("or")
                            .font(.bodyMedium())
                            .foregroundColor(.nomiTextSecondary)
                    }
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

    // MARK: - Tap Indicator
    private var tapIndicator: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 80, height: 80)

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
    }
}

// MARK: - Custom Shuffle Transition
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
