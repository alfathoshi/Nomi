//
//  LandscapeStoryScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

enum TextSize: String, CaseIterable {
    case small = "A"
    case medium = "AA"
    case large = "AAA"

    var fontSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 26
        }
    }

    var next: TextSize {
        let all = TextSize.allCases
        let i = all.firstIndex(of: self) ?? 0
        return all[(i + 1) % all.count]
    }
}

struct LandscapeStoryScreen: View {
    @Environment(\.returnToRoadmap) private var returnToRoadmap

    let book: StoryBook = NomiAdventureData.storybook

    @State private var currentIndex: Int = 0
    @State private var showMenu: Bool = false
    @State private var showContents: Bool = false
    @State private var textSize: TextSize = .medium
    @State private var multiJumpTarget: Int? = nil
    @State private var audioPlayTask: Task<Void, Never>? = nil
    @State private var isAutoScrolling: Bool = false
    @State private var autoScrollTask: Task<Void, Never>? = nil
    @StateObject private var audio = AudioManager()

    var onHome: () -> Void = {}

    private var pages: [StoryPage] { book.pages }
    private var currentPage: StoryPage { pages[currentIndex] }
    private var canGoPrev: Bool { currentIndex > 0 }
    private var canGoNext: Bool { currentIndex < pages.count - 1 }
    @State private var showCongratsPopup = false
    @State private var showCelebration = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PageCurlCarousel(config: config, currentPage: $currentIndex) { size in
                    ForEach(0..<pages.count, id: \.self) { index in
                        ZStack {
                            Image(pages[index].image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipped()

                            uiOverlay
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)

                if showCelebration {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()

                    LottieWrapper(fileName: "confetti")
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                audio.stop()
                                showCelebration = false
                                showCongratsPopup = true
                            }
                        }
                }

                if showCongratsPopup {
                    CongratsPopUp(
                        title: "Level 1 Complete",
                        mascotImage: "NomiHome",
                        buttonTitle: "Next",
                        onDismiss: {
                            showCongratsPopup = false
                        },
                        onNext: {
                            finishLevel()
                        }
                    )
                    .zIndex(100)
                }

            }
        }
        .ignoresSafeArea()
        .onAppear {
            #if os(iOS)
            OrientationManager.shared.lock(to: .landscapeRight)
            #endif

            audio.onPlaybackFinished = {
                if isAutoScrolling {
                    scheduleAdvanceAfterDelay()
                }
            }

            playCurrentPageAudio(afterSeconds: 1.0)
        }
        .onDisappear {
            audio.stop()
            autoScrollTask?.cancel()
            autoScrollTask = nil
            isAutoScrolling = false
        }
        .onChange(of: currentIndex) { _, newValue in
            if let target = multiJumpTarget {
                if newValue == target {
                    multiJumpTarget = nil
                    playCurrentPageAudio(afterSeconds: 1.3)
                } else {
                    audio.stop()
                    audioPlayTask?.cancel()
                }
                return
            }
            playCurrentPageAudio(afterSeconds: 1.3)
        }
        .overlay {
            if showContents {
                StoryContentsGrid(
                    pages: pages,
                    currentIndex: currentIndex,
                    onSelect: { index in
                        goToPage(index)
                    },
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showContents = false
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showContents)
    }

    private var uiOverlay: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                homeButton
                pageCounter
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)

            autoToggle
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 20)

            VStack(alignment: .trailing, spacing: 8) {
                soundButton

                if showMenu {
                    menuPanel
                } else {
                    burger
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: showMenu)

            HStack(spacing: 12) {
                navButton(pointsLeft: true, isEnabled: canGoPrev) {
                    goToPage(currentIndex - 1)
                }

                storyTextOverlay

                navButton(pointsLeft: false, isEnabled: true) {
                    if currentIndex == pages.count - 1 {
                        audio.stop()
                        audio.play(audioName: "correct-answer")
                        LearningProgress.complete(level: 1)
                        showCelebration = true
                    } else {
                        goToPage(currentIndex + 1)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(20)
        }
    }

    private var homeButton: some View {
        Button(action: returnToRoadmap) {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.nomiPrimary)
                .frame(width: 56, height: 56)
                .background(Circle().fill(.white))
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
    }

    private var soundButton: some View {
        Button {
            audio.toggleMute()
            if !audio.isMuted {
                playCurrentPageAudio()
            }
        } label: {
            Image(systemName: audio.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.nomiPrimary)
                .frame(width: 56, height: 56)
                .background(Circle().fill(.white))
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
    }

    private var autoToggle: some View {
        Button {
            setAutoScrolling(!isAutoScrolling)
        } label: {
            HStack(spacing: 10) {
                Text("Auto")
                    .font(.label(weight: .bold))
                    .foregroundColor(.nomiPrimary)

                ZStack {
                    Capsule()
                        .fill(isAutoScrolling ? Color.nomiPrimary : Color.gray.opacity(0.35))
                        .frame(width: 42, height: 26)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 22, height: 22)
                        .shadow(color: .black.opacity(0.2), radius: 1.5, y: 1)
                        .offset(x: isAutoScrolling ? 8 : -8)
                }
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isAutoScrolling)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Capsule().fill(.white))
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .tapSound()
        .accessibilityLabel("Auto scroll")
        .accessibilityValue(isAutoScrolling ? "On" : "Off")
    }

    private var pageCounter: some View {
        Text("\(currentIndex + 1)/\(pages.count)")
            .font(.label(weight: .bold))
            .foregroundColor(.nomiPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .background(Capsule().fill(.white))
            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
    }

    private var burger: some View {
        Button {
            showMenu = true
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.nomiPrimary)
                .frame(width: 56, height: 56)
                .background(Circle().fill(.white))
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
    }

    private var menuPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    showMenu = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
            }
            .padding(.trailing, 8)
            .padding(.top, 8)

            menuRow(icon: "square.grid.2x2.fill", label: "Contents") {
                showMenu = false
                withAnimation(.easeInOut(duration: 0.25)) {
                    showContents = true
                }
            }

            Rectangle()
                .fill(Color.white.opacity(0.4))
                .frame(height: 1)
                .padding(.horizontal, 16)

            menuRow(icon: "textformat.size", label: "Text Size  \(textSize.rawValue)") {
                textSize = textSize.next
            }
        }
        .padding(.bottom, 12)
        .frame(width: 230)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.nomiPrimary)
        )
        .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        .transition(.scale(scale: 0.8, anchor: .topTrailing).combined(with: .opacity))
    }

    @ViewBuilder
    private func menuRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 24)
                Text(label)
                    .font(.heading3())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tapSound()
    }

    private var storyTextOverlay: some View {
        currentPage.content
            .font(.system(size: textSize.fontSize, weight: .semibold))
            .foregroundColor(.nomiTextPrimary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.white.opacity(0.85))
            )
            .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
            .animation(.easeInOut(duration: 0.2), value: textSize)
    }

    @ViewBuilder
    private func navButton(pointsLeft: Bool, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "play.fill")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
                .rotationEffect(.degrees(pointsLeft ? 180 : 0))
                .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                .opacity(isEnabled ? 1.0 : 0.4)
        }
        .disabled(!isEnabled)
    }

    // TODO: BUG — multi-page jump (delta >= 2) via Contents Grid leaves currentIndex at preTarget (target - 1).
    // Root cause: PageCurlCarousel's .scrollPosition binding setter writes back preTarget value after Phase 1 snap,
    // overriding Phase 2's withAnimation { currentIndex = target }. Tried 100ms delay + linear animation — got worse.
    // Possible fix: refactor PageCurlCarousel to use ScrollViewReader.scrollTo (one-way) instead of bidirectional binding.
    private func goToPage(_ index: Int) {
        guard index >= 0, index < pages.count else { return }
        let delta = index - currentIndex
        guard delta != 0 else { return }

        if abs(delta) == 1 {
            withAnimation(.easeInOut(duration: 1.2)) {
                currentIndex = index
            }
        } else {
            let preTarget = delta > 0 ? index - 1 : index + 1
            multiJumpTarget = index

            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                currentIndex = preTarget
            }

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 1.2)) {
                    currentIndex = index
                }
            }
        }
    }

    private func playCurrentPageAudio(afterSeconds delay: TimeInterval = 0) {
        audio.stop()
        audioPlayTask?.cancel()

        audioPlayTask = Task { @MainActor in
            if delay > 0 {
                try? await Task.sleep(for: .seconds(delay))
                guard !Task.isCancelled else { return }
            }
            if let name = currentPage.audioName {
                audio.play(audioName: name, volume: 5)
            }
        }
    }

    private func setAutoScrolling(_ on: Bool) {
        isAutoScrolling = on
        if on {
            if !audio.isPlaying {
                scheduleAdvanceAfterDelay()
            }
        } else {
            autoScrollTask?.cancel()
            autoScrollTask = nil
        }
    }

    private func scheduleAdvanceAfterDelay() {
        autoScrollTask?.cancel()
        autoScrollTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled, isAutoScrolling else { return }

            if currentIndex < pages.count - 1 {
                goToPage(currentIndex + 1)
            } else {
                isAutoScrolling = false
            }
        }
    }

    private func finishLevel() {
        audio.stop()
        showCongratsPopup = false
        returnToRoadmap()
    }

    var config: PageCurlCarouselConfig {
        .init(curlRadius: 120)
    }
}

#Preview {
    LandscapeStoryScreen()
}
