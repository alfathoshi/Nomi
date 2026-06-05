//
//  ParentPromiseView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct ParentPromiseView: View {
    @State private var navigateToPinkyPromise: Bool = false
    var body: some View {
        NavigationStack {
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
                        mascotImage: "NomiHome",
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
                    
                    WideButton(title: "I PROMISE! 👊", icon: nil, background: .nomiAccent, foreground: .nomiSurface) {
                        navigateToPinkyPromise.toggle()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 44)
                }
            }
            .navigationDestination(isPresented: $navigateToPinkyPromise) {
                PinkyPromiseView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    ParentPromiseView()
}
