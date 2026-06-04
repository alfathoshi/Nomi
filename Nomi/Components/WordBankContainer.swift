//
//  WordBankContainer.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//

import SwiftUI

struct WordBankContainer: View {
    
    let words: [String]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.75))
            .frame(height: 200)
            .overlay {
                
                FlowLayout {
                    ForEach(words, id: \.self) { word in
                        Text(word)
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
