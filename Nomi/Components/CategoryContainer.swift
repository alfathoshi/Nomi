//
//  CategoryContainer.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//

import SwiftUI

struct CategoryContainer: View {
    let title: String
    let words: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
            
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.75))
                .overlay(alignment: .topLeading) {
                    FlowLayout {
                        ForEach(words, id: \.self) { word in
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.nomiPrimary)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                }
        }
    }
}
