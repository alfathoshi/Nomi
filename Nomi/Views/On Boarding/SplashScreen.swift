//
//  SplashScreen.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI
import SwiftData
import DotLottie

struct SplashScreen: View {
    @Query private var profiles: [ChildProfile]
    var onFinished: (Bool) -> Void = { _ in }

    private var hasProfile: Bool {
        !profiles.isEmpty
    }

    var body: some View {
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
                if !hasProfile {
                    WideButton(
                        title: "Let's Go",
                        icon: "play.fill",
                        background: .nomiSurface,
                        foreground: .nomiPrimary
                    ) {
                        onFinished(false)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .task(id: hasProfile) {
            guard hasProfile else { return }

            try? await Task.sleep(nanoseconds: 1_500_000_000)
            guard !Task.isCancelled else { return }
            onFinished(true)
        }
    }
}

#Preview {
    SplashScreen()
        .modelContainer(for: ChildProfile.self, inMemory: true)
}
