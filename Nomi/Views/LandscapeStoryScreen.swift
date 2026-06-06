//
//  LandscapeStoryScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

struct StoryPageNew {
    let imageName: String
    let text: String
}

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
    let pages: [StoryPageNew] = [
        StoryPageNew(imageName: "landscape 0",
                  text: "In a land full of wonder, there lived a small, spiky hedgehog named Nomi ..."),
        StoryPageNew(imageName: "landscape 0",
                  text: "One day, Nomi met her friend Pip, a tiny turtle squeezing into his shell that didn’t quite fit anymore."),
        StoryPageNew(imageName: "landscape 0",
                  text: "One day, they found a magical adventure waiting ..."),
    ]

    @State private var currentIndex: Int = 0
    @State private var showMenu: Bool = false
    @State private var textSize: TextSize = .medium
    @StateObject private var tts = TTSManager()
    @State private var navigateToFlipCard = false

    var onHome: () -> Void = {}

    private var currentPage: StoryPageNew { pages[currentIndex] }
    private var canGoPrev: Bool { currentIndex > 0 }
    private var canGoNext: Bool { currentIndex < pages.count }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PageCurlCarousel(config: config, currentPage: $currentIndex) { size in
                    ForEach(0..<pages.count, id: \.self) { index in
                        ZStack {
                            Image(pages[index].imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipped()
                            
                            uiOverlay
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
        .navigationDestination(isPresented: $navigateToFlipCard) {
            DoctorWordsScreen()
                .navigationBarBackButtonHidden(true)
                .onAppear {
#if os(iOS)
                    OrientationManager.shared.lock(to: .portrait)
#endif
                }
        }
        .onAppear {
#if os(iOS)
            OrientationManager.shared.lock(to: .landscape)
#endif
        }
        .onDisappear {
#if os(iOS)
            OrientationManager.shared.lock(to: .portrait)
#endif
        }
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
                        navigateToPortraitScreen()
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
            tts.speak(currentPage.text)
        } label: {
            Image(systemName: tts.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
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
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)

            menuRow(icon: "square.grid.2x2.fill", label: "Contents") {
                showMenu = false
            }

            Divider()
                .background(Color.white.opacity(0.4))
                .padding(.horizontal, 16)

            menuRow(icon: "textformat.size", label: "Text Size  \(textSize.rawValue)") {
                textSize = textSize.next
            }
        }
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.nomiPrimary)
        )
        .shadow(color: .black.opacity(0.25), radius: 10, y: 6)
        .transition(.scale(scale: 0.8, anchor: .topTrailing).combined(with: .opacity))
    }

    @ViewBuilder
    private func menuRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.heading3())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var storyTextOverlay: some View {
        Text(processedText(currentPage.text))
            .font(.system(size: textSize.fontSize, weight: .semibold))
            .foregroundColor(.nomiTextPrimary)
            .multilineTextAlignment(.leading)
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

    private func processedText(_ raw: String) -> AttributedString {
        var attr = AttributedString(raw)
        if let range = attr.range(of: "Nomi") {
            attr[range].foregroundColor = .nomiPrimary
            attr[range].font = .bodyLarge(weight: .bold)
        }
        return attr
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
        tts.stop()
        withAnimation(.easeInOut(duration: 1.2)) {
            currentIndex = index
        }
    }

    private func navigateToPortraitScreen() {
        tts.stop()
#if os(iOS)
        OrientationManager.shared.lock(to: .portrait)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
#endif
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navigateToFlipCard = true
        }
    }

    var config: PageCurlCarouselConfig {
        .init(curlRadius: 120)
    }
}

#Preview {
    LandscapeStoryScreen()
}
