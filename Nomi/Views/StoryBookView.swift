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
    @State private var isMuted = false
    @Environment(\.dismiss) private var dismiss
    var data = StoryBookData()
    
    var page: StoryPage {
        data.pages[currentPage]
    }
    
    let screenSize = UIScreen.main.bounds.size
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Image(page.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width, height: screenSize.height)
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(spacing: 10) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.nomiPrimary)
                                    .frame(width: 64, height: 64)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            
                            Text("\(currentPage + 1)/\(totalPages)")
                                .font(.caption.bold())
                                .foregroundColor(.nomiPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.white)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Button {
                            isMuted.toggle()
                        }
                        label: {
                            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.nomiPrimary)
                                .frame(width: 64, height: 64)
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    HStack(spacing: 24) {
                        Button {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        } label: {
                            Image(systemName: "arrowtriangle.backward.fill")
                                .font(.system(size: 58, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        page.content
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.nomiTextPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                        Button {
                            if currentPage < totalPages - 1 {
                                currentPage += 1
                            }
                        } label: {
                            Image(systemName: "arrowtriangle.right.fill")
                                .font(.system(size: 58, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            rotate(to: .landscapeRight)
        }
        .onDisappear {
            rotate(to: .portrait)
        }
    }
    
    private func rotate(to orientation: UIInterfaceOrientationMask) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        windowScene.requestGeometryUpdate(
            .iOS(interfaceOrientations: orientation)
        ) { error in
            print("Failed to rotate screen: \(error.localizedDescription)")
        }
    }
}

#Preview {
    StoryBookView()
}
