//
//  ContentView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let amazing = Text("AMAZING?").foregroundColor(.nomiPrimary)
    @State private var currentPage: Int = 0
    private let totalPages = 4                        // 0..3 (index)

    var body: some View {
        GeometryReader{
            let viewSize = $0.size
            let pageSize = self.pageSize(viewSize)

            PageCurlCarousel(config: config, currentPage: $currentPage) { size in
                ForEach(0...3, id: \.self) { index in
                    ZStack{
                        Image("page \(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                        if(index == 0){
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
                            .frame(maxWidth: 350, maxHeight: .infinity, alignment: .top)
                            .padding(.top, 40)
                        }
                    }

                }
            }
            .frame(width: pageSize.width, height: pageSize.height)
        }
        .padding(30)

    }
    //    var body: some View {
    //        Image("page 0")
    //            .resizable()
    //            .aspectRatio(contentMode: .fit)
    //            .padding()
    //    }
    
    func pageSize(_ viewSize: CGSize) -> CGSize {
        let actualSize = CGSize(width: 411, height: 800)
        
        // Calculate aspect ratios
        let widthFactor = viewSize.width / actualSize.width
        let heightFactor = viewSize.height / actualSize.height
        let aspectScale = min(widthFactor, heightFactor)
        
        return CGSize(
            width: actualSize.width * aspectScale,
            height: actualSize.height * aspectScale
        )
    }
    
    var config: PageCurlCarouselConfig{
        return .init(
            curlRadius: 80,
        //            curlCenter: .init(x: 1, y: 1)
        )
    }
}

#Preview {
    ContentView()
}
