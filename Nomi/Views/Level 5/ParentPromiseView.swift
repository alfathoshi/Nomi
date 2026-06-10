//
//  ParentPromiseView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct ParentPromiseView: View {
    var onComplete: () -> Void = {}
    var onBack: () -> Void = {}

    @StateObject private var audio = AudioManager()

    var body: some View {
        ZStack {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width, height: screenSize.height)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("TRUST\nCONTRACT")
                        .font(.heading1(size: 40))
                        .foregroundColor(.nomiAccent)
                        .multilineTextAlignment(.center)
                        .padding(.top, 90)
                    
                    Spacer()
                    
                    TrustContractCard(
                        mascotImage: "Pip",
                        title: "Parent's Promise",
                        dividerIcon: "🧡",
                        promiseText: """
                        I promise to listen, stay 
                        calm, and help keep my 
                        child safe. I will always 
                        support them when they 
                        share their feelings or 
                        worries.
                        """,
                        surfaceColor: .nomiSurfaceAccent,
                        color: .nomiAccent
                    )
                    
                    Spacer()
                    
                    WideButton(title: "I PROMISE!", icon: nil, background: .nomiAccent, foreground: .nomiSurface) {
                        onComplete()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 44)
                }

                NomiBackButton(action: onBack)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 20)
                    .padding(.top, 62)
            }
            .onAppear {
                audio.play(audioName: "ParentPromise", volume: 6)
            }
            .onDisappear {
                audio.stop()
            }
    }
}

#Preview {
    ParentPromiseView()
}
