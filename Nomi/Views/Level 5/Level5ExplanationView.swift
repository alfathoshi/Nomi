//
//  Level5ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct Level5ExplanationView: View {
    let highlight = Text("Trust Promise together")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var showParentPasscode = false
    @State private var navigateToChildPromise = false
    @State private var proceedAfterPasscode = false
    @StateObject private var audio = AudioManager()

    var body: some View {
        NavigationStack {
            LevelExplanationScreen(
                title: "The Trust Contract",
                mascotImage: "NomiDefault",
                paragraphs: [
                    Text("Now it’s time to find your Trusted Adult!").font(.heading2(weight: .black, size: 20)),
                    Text(" Go invite a Parent, Guardian, or safe grown-up to join you for a special \(highlight)").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "My Trusted Adult is Here",
            ) {
                audio.stop()
                showParentPasscode = true
            }
            .onAppear {
                audio.play(audioName: "Level-5-Explanation")
            }
            .onDisappear {
                audio.stop()
            }
            .navigationDestination(isPresented: $navigateToChildPromise) {
                ChildPromiseView()
                    .navigationBarBackButtonHidden(true)
            }
            .fullScreenCover(isPresented: $showParentPasscode, onDismiss: {
                if proceedAfterPasscode {
                    proceedAfterPasscode = false
                    navigateToChildPromise = true
                } else {
                    audio.play(audioName: "Level-5-Explanation")
                }
            }) {
                NavigationStack {
                    ParentPasscodeView {
                        proceedAfterPasscode = true
                        showParentPasscode = false
                    } onBack: {
                        showParentPasscode = false
                    }
                }
            }
        }
    }
}

#Preview {
    Level5ExplanationView()
}
