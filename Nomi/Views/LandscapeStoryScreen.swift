//
//  LandscapeStoryScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 04/06/26.
//

import SwiftUI

// MARK: - Data Model
struct StoryPage {
    let imageName: String
    let text: String
}

// MARK: - Text Size Options
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

    // Cycle ke size berikutnya
    var next: TextSize {
        let all = TextSize.allCases
        let i = all.firstIndex(of: self) ?? 0
        return all[(i + 1) % all.count]
    }
}

struct LandscapeStoryScreen: View {
    let pages: [StoryPage] = [
        StoryPage(imageName: "landscape 0",
                  text: "In a land full of wonder, there lived a small, spiky hedgehog named Nomi ..."),
        StoryPage(imageName: "landscape 0",
                  text: "Nomi loved exploring the forest with friends ..."),
        StoryPage(imageName: "landscape 0",
                  text: "One day, they found a magical adventure waiting ..."),
    ]

    @State private var currentIndex: Int = 0
    @State private var showMenu: Bool = false
    @State private var textSize: TextSize = .medium
    @StateObject private var tts = TTSManager()
    
    var onHome: () -> Void = {}

    private var currentPage: StoryPage { pages[currentIndex] }
    private var canGoPrev: Bool { currentIndex > 0 }
    private var canGoNext: Bool { currentIndex < pages.count - 1 }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PageCurlCarousel(config: config, currentPage: $currentIndex) { size in
                    uiOverlay

                    ForEach(0..<pages.count, id: \.self) { index in
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipped()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)

                //if dont want to follow curl
                //uiOverlay
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Force landscape pas masuk screen ini
            #if os(iOS)
            OrientationManager.shared.lock(to: .landscape)
            #endif
        }
        .onDisappear {
            // Unlock pas user keluar dari screen
            #if os(iOS)
            OrientationManager.shared.unlock()
            #endif
        }
    }

    private var uiOverlay: some View {
        ZStack {
            // Top-left: Home + Page Counter
            VStack(alignment: .leading, spacing: 8) {
                homeButton
                pageCounter
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            
            // Top right: sound + burger (atau menu kalau open)
            VStack(alignment: .trailing, spacing: 8) {
                soundButton

                // Burger toggles menu
                if showMenu {
                    menuPanel
                } else {
                    burger
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: showMenu)

            // Bottom: Arrows + Text overlay
            HStack(spacing: 12) {
                navButton(pointsLeft: true, isEnabled: canGoPrev) {
                    goToPage(currentIndex - 1)
                }

                storyTextOverlay

                navButton(pointsLeft: false, isEnabled: canGoNext) {
                    goToPage(currentIndex + 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(20)
        }
    }

    // MARK: - Top-Left Components

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

    // MARK: - Menu Panel (Contents + Text Size)
    private var menuPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header: X close button
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

            // Row 1: Contents (placeholder, belum wired)
            menuRow(icon: "square.grid.2x2.fill", label: "Contents") {
                // TODO: show contents
                showMenu = false
            }

            Divider()
                .background(Color.white.opacity(0.4))
                .padding(.horizontal, 16)

            // Row 2: Text Size (cycles small → medium → large)
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
            .contentShape(Rectangle())   // tap area = seluruh row, bukan cuma text
        }
        .buttonStyle(.plain)
    }

    // MARK: - Text Overlay (bottom) — font size dinamis ngikutin textSize
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

    // Auto-highlight kata "Nomi" pake AttributedString
    private func processedText(_ raw: String) -> AttributedString {
        var attr = AttributedString(raw)
        if let range = attr.range(of: "Nomi") {
            attr[range].foregroundColor = .nomiPrimary
            attr[range].font = .bodyLarge(weight: .bold)
        }
        return attr
    }

    // MARK: - Nav Arrow Button
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

    // MARK: - Action
    private func goToPage(_ index: Int) {
        guard index >= 0, index < pages.count else { return }
        // Auto-stop TTS pas ganti page
        tts.stop()
        // Slow + natural page-flip feel (kayak ngebalik buku)
        withAnimation(.easeInOut(duration: 1.2)) {
            currentIndex = index
        }
    }

    // MARK: - PageCurl Config
    var config: PageCurlCarouselConfig {
        // curlRadius lebih besar → curl lebih lebar/dramatic kayak halaman buku tebel
        .init(curlRadius: 120)
    }
}

#Preview {
    LandscapeStoryScreen()
}
