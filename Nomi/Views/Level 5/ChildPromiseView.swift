//
//  TrustContractView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct TrustContractView: View {
    @State private var navigateToParentPromise = false
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
                        .foregroundColor(.nomiPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 90)
                    
                    Spacer()
                    
                    TrustContractCard(
                        mascotImage: "NomiHome",
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
                    
                    WideButton(title: "I PROMISE! 👊", icon: nil) {
                        navigateToParentPromise.toggle()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 44)
                }
            }
            .navigationDestination(isPresented: $navigateToParentPromise) {
                ParentPromiseView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    TrustContractView()
}
