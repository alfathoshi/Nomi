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
    var onHome: () -> Void = {}

    private var currentPage: StoryPage { pages[currentIndex] }
    private var canGoPrev: Bool { currentIndex > 0 }
    private var canGoNext: Bool { currentIndex < pages.count - 1 }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PageCurlCarousel(config: config, currentPage: $currentIndex) { size in
                    ForEach(0..<pages.count, id: \.self) { index in
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipped()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)

                // ── UI OVERLAY (fixed, di luar carousel jadi gak ikut curl) ──
                uiOverlay
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - UI Overlay (home, counter, arrows, text)
    private var uiOverlay: some View {
        ZStack {
            // Top-left: Home + Page Counter
            VStack(alignment: .leading, spacing: 8) {
                homeButton
                pageCounter
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)

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

    private var pageCounter: some View {
        Text("\(currentIndex + 1)/\(pages.count)")
            .font(.label(weight: .bold))
            .foregroundColor(.nomiPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .background(Capsule().fill(.white))
            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
    }

    // MARK: - Text Overlay (bottom)

    private var storyTextOverlay: some View {
        Text(processedText(currentPage.text))
            .font(.bodyLarge())
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
