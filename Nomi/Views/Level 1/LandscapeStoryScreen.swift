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
    let book: StoryBook = NomiAdventureData.storybook

    @State private var currentIndex: Int = 0
    @State private var showMenu: Bool = false
    @State private var showContents: Bool = false
    @State private var textSize: TextSize = .medium
    @State private var multiJumpTarget: Int? = nil
    @StateObject private var audio = AudioManager()

    var onHome: () -> Void = {}

    private var pages: [StoryPage] { book.pages }
    private var currentPage: StoryPage { pages[currentIndex] }
    private var canGoPrev: Bool { currentIndex > 0 }
    private var canGoNext: Bool { currentIndex < pages.count - 1 }
    @State private var navigateToWordScreen = false
    @State private var showCongratsPopup = false
    @State private var showCelebration = false
    @State private var showStoryTransition = false

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
                    Color.black.opacity(0.45)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showCongratsPopup = false
                        }
                        .zIndex(10)

                    VStack(spacing: 18) {
                        Text("Story Complete")
                            .font(.heading1())
                            .foregroundColor(.nomiTextPrimary)
                            .padding(.top, 20)

                        Image("NomiHome")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 170)

                        Button(action: {
                            goToDoctorWordsScreen()
                        }) {
                            HStack(spacing: 8) {
                                Text("Next Level")
                                    .font(.heading3())
                                    .foregroundColor(.white)

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 38)
                            .padding(.vertical, 14)
                            .background(Color.nomiPrimary)
                            .clipShape(Capsule())
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(width: min(geo.size.width * 0.36, 360))
                    .background(Color.nomiSurfaceTint)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.2), radius: 16, y: 8)
                    .zIndex(11)
                }

                if showStoryTransition {
                    GeometryReader { geo in
                        ZStack {
                            Image(.storyBackground)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()

                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(1.8)
                                    .tint(.white)

                                Text("Preparing next level...")
                                    .font(.heading3())
                                    .foregroundColor(.nomiTextPrimary)
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .ignoresSafeArea()
                    .zIndex(20)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            #if os(iOS)
            OrientationManager.shared.lock(to: .landscape)
            #endif

            playCurrentPageAudio()
        }
        .onDisappear {
            #if os(iOS)
            OrientationManager.shared.unlock()
            #endif

            audio.stop()
        }
        .onChange(of: currentIndex) { _, newValue in
            if let target = multiJumpTarget {
                if newValue == target {
                    multiJumpTarget = nil
                    playCurrentPageAudio()
                }
                return
            }
            playCurrentPageAudio()
        }
        .navigationDestination(isPresented: $navigateToWordScreen) {
            DoctorWordsScreen()
                .navigationBarBackButtonHidden(true)
                .onAppear {
#if os(iOS)
                    OrientationManager.shared.lock(to: .portrait)
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UIViewController.attemptRotationToDeviceOrientation()
#endif
                }
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
        Button(action: onHome) {
            Image(systemName: "house.fill")
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

    private func playCurrentPageAudio() {
        audio.stop()
        if let name = currentPage.audioName {
            audio.play(audioName: name)
        }
    }

    private func goToDoctorWordsScreen() {
        audio.stop()
        showCongratsPopup = false
        showStoryTransition = true

#if os(iOS)
        OrientationManager.shared.lock(to: .portrait)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
#endif

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            navigateToWordScreen = true
            showStoryTransition = false
        }
    }

    var config: PageCurlCarouselConfig {
        .init(curlRadius: 120)
    }
}

#Preview {
    LandscapeStoryScreen()
}
