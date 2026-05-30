//
//  StoryBookView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 30/05/26.
//

import SwiftUI

struct StoryBookView: View {
    let totalPages = 3
    @State private var currentPage = 0
    var data = StoryBookData()

    var page: StoryPage {
        data.pages[currentPage]
    }
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Text("Level 1 · Storybook")
                            .font(.label(weight: .extraBold, size: 10))
                            .foregroundColor(.nomiTextSecondary)
                        Spacer()
                        Text("Page \(currentPage + 1) of \(totalPages)")
                            .font(.label(weight: .extraBold, size: 10))
                            .foregroundColor(.nomiPrimary)
                    }
                    
                    ProgressBar(height: 6, progress: Double(currentPage + 1) / Double(totalPages))
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                    
                    Image(page.image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, -20)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Image(.moni)
                            .padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text("MONI SAYS 💜")
                                .font(.label(weight: .extraBold, size: 10))
                                .foregroundColor(.nomiPrimary)
                            Text("Tap read all to hear it")
                                .font(.label(weight: .extraBold, size: 10))
                                .foregroundColor(.nomiTextSecondary)
                        }
                        Spacer()
                        ChipCapsule(title: "Read all", leftIcon: "speaker.wave.2.fill", foregroundColor: .nomiPrimary, backgroundColor: .nomiSurfaceTint)
                        
                        
                    }
                    .padding(.bottom, 16)
                    
                    page.content
                        .font(.heading2(weight: .bold))
                        .foregroundColor(.nomiTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.nomiPrimary, lineWidth: 2)
                            
                        )
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.nomiPrimary)
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.12),
                            radius: 12,
                            x: 0,
                            y: 2
                        )
                        
                        Spacer()
                        
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
                        
                        Spacer()
                        
                        Button {
                            if currentPage < totalPages - 1 {
                                currentPage += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.nomiPrimary)
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.12),
                            radius: 12,
                            x: 0,
                            y: 2
                        )
                        
                    }
                    
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(.horizontal, 20)
                .navigationTitle("Module 1 · The Personal Bubble & Swim Suit Rule")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
        }
    }
}

#Preview {
    StoryBookView()
}
