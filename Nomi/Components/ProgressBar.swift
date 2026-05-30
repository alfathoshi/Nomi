//
//  ProgressBar.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import SwiftUI

struct ProgressBar: View {
    let height: CGFloat
    let progress: CGFloat
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 999)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: 999)
                    .fill(
                        LinearGradient(
                            colors: [
                                .nomiPrimarySoft,
                                .nomiPrimarySoft,
                                .nomiPrimary,
                                
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: geometry.size.width * progress,
                        height: height
                    )
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    ProgressBar(height: 12, progress: 0.8)
}
