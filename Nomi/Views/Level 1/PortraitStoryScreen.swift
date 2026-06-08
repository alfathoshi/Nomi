//
//  StoryScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 29/05/26.
//

import SwiftUI

// MARK: - Data Model
struct StoryPageContent {
    let imageName: String
    let title: String
}

struct PortraitStoryScreen: View {
    let pages: [StoryPageContent] = [
        StoryPageContent(imageName: "page 0",
                         title: "Let's Go for a Body Adventure\nAre You Ready?"),
        StoryPageContent(imageName: "page 1",
                         title: "Meet your body parts\nLet's explore!"),
        StoryPageContent(imageName: "page 2",
                         title: "Stay safe, stay strong\nYou got this!"),
    ]

    @State private var currentPage: Int = 0
    @State private var navigateToFlipCard = false

    private var canGoBack: Bool { currentPage > 0 }
    private var canGoNext: Bool { currentPage < pages.count}

    var body: some View {
        ZStack {
            GeometryReader { geo in
                PageCurlCarousel(config: config, currentPage: $currentPage) { size in
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack {
                            // Top: page counter + title card
                            topOverlay
                                .padding(.top, 60)

                            Spacer()

                            // Bottom: Back / Next buttons
                            bottomNavigation
                                .padding(.bottom, 40)
                        }
                        .padding(.horizontal, 20)
                        
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipped()
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                
                // ── UI OVERLAY (glass elements, fixed outside carousel) ──
                VStack {
                    // Top: page counter + title card
                    topOverlay
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // Bottom: Back / Next buttons
                    bottomNavigation
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }

            // ── UI OVERLAY (glass elements, fixed outside carousel) ──
//            VStack {
//                // Top: page counter + title card
//                topOverlay
//                    .padding(.top, 60)
//
//                Spacer()
//
//                // Bottom: Back / Next buttons
//                bottomNavigation
//                    .padding(.bottom, 40)
//            }
//            .padding(.horizontal, 20)
        }
    }

    // MARK: - Top Overlay (counter + title card)
    private var topOverlay: some View {
        VStack(spacing: 12) {
            // Page counter
            Text("\(currentPage + 1)/\(pages.count)")
                .font(.bodySmall(weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)

            // Glass title card
            Text(pages[currentPage].title)
                .font(.heading3())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        }
    }

    // MARK: - Bottom Navigation (Back / Next glass buttons)
    private var bottomNavigation: some View {
        HStack {
            glassButton(
                label: "Back",
                icon: "chevron.left",
                iconLeading: true,
                isEnabled: canGoBack
            ) {
                goToPage(currentPage - 1)
            }

            Spacer()

            glassButton(
                label: "Next",
                icon: "chevron.right",
                iconLeading: false,
                isEnabled: canGoNext
            ) {
                if currentPage == pages.count - 1 {
                    navigateToFlipCard.toggle()
                } else {
                    goToPage(currentPage + 1)
                }
            }
        }
    }

    // MARK: - Glass Button
    @ViewBuilder
    private func glassButton(
        label: String,
        icon: String,
        iconLeading: Bool,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if iconLeading {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                    Text(label)
                        .font(.heading3())
                } else {
                    Text(label)
                        .font(.heading3())
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial.opacity(0.9))    // ← GLASS EFFECT
            .background(Color.black.opacity(0.3))           // dim layer behind glass biar text putih kontras
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
            .opacity(isEnabled ? 1.0 : 0.4)
        }
        .disabled(!isEnabled)
    }

    // MARK: - Action
    private func goToPage(_ index: Int) {
        guard index >= 0, index < pages.count else { return }
        withAnimation(.easeInOut(duration: 1.2)) {
            currentPage = index
        }
    }

    // MARK: - PageCurl Config
    var config: PageCurlCarouselConfig {
        .init(curlRadius: 120)
    }
}

#Preview {
    PortraitStoryScreen()
}
