//
//  ContentView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 26/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        GeometryReader{
            let viewSize = $0.size
            let pageSize = self.pageSize(viewSize)
            
            PageCurlCarousel(config: config) { size in
                ForEach(0...3, id: \.self) { index in
                    Image("page \(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
