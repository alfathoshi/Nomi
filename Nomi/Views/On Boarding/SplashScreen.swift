//
//  SplashScreen.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI
import DotLottie

struct SplashScreen: View {
    @State private var isActive = false
    @State private var navigateToOnboarding = false
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.nomiPrimarySoft,
                        Color.nomiPrimary
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack() {
                    Spacer()
                    LottieWrapper(fileName: "splash")
                        .frame(height: 260)
                    
                    Text("NOMI")
                        .font(.heading1(weight: .black, size: 42))
                        .foregroundStyle(Color.nomiSurface)
                    
                    Text("Get to know me")
                        .font(.bodyLarge())
                        .foregroundStyle(Color.nomiSurface)
                    
                    
                    Spacer()
                    WideButton(
                        title: "Let's Go",
                        icon: "play.fill",
                        background: .nomiSurface,
                        foreground: .nomiPrimary
                    ){
                        navigateToOnboarding = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
            }
            .navigationDestination(isPresented: $navigateToOnboarding) {
                OnBoardingView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
