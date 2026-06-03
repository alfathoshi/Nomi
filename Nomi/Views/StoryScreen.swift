//
//  StoryScreen.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 29/05/26.
//

import SwiftUI

struct StoryScreen: View {
    let amazing = Text("AMAZING?").foregroundColor(.nomiPrimary)
    @State private var currentPage: Int = 0
    private let totalPages = 4                        // 0..3 (index)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Carousel — fullscreen edge to edge
            GeometryReader { geo in
                PageCurlCarousel(config: config, currentPage: $currentPage) { size in
                    ForEach(0..<totalPages, id: \.self) { index in
                        ZStack {
                            Image("page \(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()

                            if index == 0 {
                                StoryCard(
                                    onPrev: currentPage > 0 ? {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            currentPage -= 1
                                        }
                                    } : nil,
                                    onNext: currentPage < totalPages - 1 ? {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            currentPage += 1
                                        }
                                    } : nil
                                ) {
                                    Text("Before we start,\ndid you know your body\nis \(amazing)")
                                        .font(.heading3())
                                        .multilineTextAlignment(.center)

                                    Text("It helps you run, jump,\nwiggle, dance, and\ngives the BEST hugs ever!")
                                        .font(.bodyMedium(weight: .bold))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .padding(.top, 80)   // top padding lebih besar biar gak ke-notch
                            }
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }

            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Capsule()
                        .fill(
                            index == currentPage
                            ? Color.nomiPrimary
                            : Color.gray.opacity(0.5)
                        )
                        .frame(
                            width: index == currentPage ? 24 : 8,
                            height: 8
                        )
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
    
    var config: PageCurlCarouselConfig{
        return .init(
            curlRadius: 80,
        //  curlCenter: .init(x: 1, y: 1)
        )
    }

    // MARK: - Disabled (kept for future use)
    // Constrain carousel ke aspect ratio fixed (411×800) — useful kalau mau letterboxed view
    // Pakai: .frame(width: pageSize(geo.size).width, height: pageSize(geo.size).height)
    //
    // func pageSize(_ viewSize: CGSize) -> CGSize {
    //     let actualSize = CGSize(width: 411, height: 800)
    //
    //     // Calculate aspect ratios
    //     let widthFactor = viewSize.width / actualSize.width
    //     let heightFactor = viewSize.height / actualSize.height
    //     let aspectScale = min(widthFactor, heightFactor)
    //
    //     return CGSize(
    //         width: actualSize.width * aspectScale,
    //         height: actualSize.height * aspectScale
    //     )
    // }
}

#Preview {
    StoryScreen()
}
