//
//  ChildPromiseView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct ChildPromiseView: View {
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
                        .foregroundColor(.nomiPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 90)
                    
                    Spacer()
                    
                    TrustContractCard(
                        mascotImage: "Mascot",
                        title: "Child’s Promise",
                        dividerIcon: "💜",
                        promiseText: """
                        I promise to speak up
                        when something doesn't
                        feel right and ask for
                        help when I need it.
                        """,
                        surfaceColor: .nomiSurfaceTint,
                        color: .nomiPrimary
                    )
                    
                    Spacer()
                    
                    WideButton(title: "I PROMISE!", icon: nil) {
                        onComplete()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 44)
                }

                NomiBackButton(action: onBack)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 20)
                    .padding(.top, 62)

                AudioMuteButton(isMuted: audio.isMuted) {
                    audio.toggleMute()
                    if !audio.isMuted {
                        audio.play(audioName: "ChildPromise")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, 20)
                .padding(.top, 62)
            }
            .onAppear {
                audio.play(audioName: "ChildPromise")
            }
            .onDisappear {
                audio.stop()
            }
    }
}

#Preview {
    ChildPromiseView()
}
