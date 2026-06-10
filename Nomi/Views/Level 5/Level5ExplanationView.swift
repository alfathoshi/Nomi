//
//  Level5ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 05/06/26.
//

import SwiftUI

struct Level5ExplanationView: View {
    var onComplete: () -> Void = {}
    var onBack: () -> Void = {}

    private enum Phase {
        case explanation
        case childPromise
        case parentPromise
        case pinkyPromise
        case congratulations
    }

    let highlight = Text("Trust Promise together")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var showParentPasscode = false
    @State private var proceedAfterPasscode = false
    @State private var phase: Phase = .explanation
    @StateObject private var audio = AudioManager()

    var body: some View {
        Group {
            switch phase {
            case .explanation:
                explanationView
            case .childPromise:
                ChildPromiseView(
                    onComplete: {
                        phase = .parentPromise
                    },
                    onBack: {
                        phase = .explanation
                    }
                )
            case .parentPromise:
                ParentPromiseView(
                    onComplete: {
                        phase = .pinkyPromise
                    },
                    onBack: {
                        phase = .childPromise
                    }
                )
            case .pinkyPromise:
                PinkyPromiseView(
                    onComplete: {
                        phase = .congratulations
                    },
                    onBack: {
                        phase = .parentPromise
                    }
                )
            case .congratulations:
                CongratsView(onComplete: onComplete)
            }
        }
        .fullScreenCover(isPresented: $showParentPasscode, onDismiss: {
            if proceedAfterPasscode {
                proceedAfterPasscode = false
                phase = .childPromise
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

    private var explanationView: some View {
        LevelExplanationScreen(
            title: "The Trust Contract",
            mascotImage: "NomiDefault",
            paragraphs: [
                Text("Now it’s time to find your Trusted Adult!").font(.heading2(weight: .black, size: 20)),
                Text(" Go invite a Parent, Guardian, or safe grown-up to join you for a special \(highlight)").font(.heading2(weight: .semiBold, size: 20))
            ],
            buttonTitle: "My Trusted Adult is Here",
            onBack: onBack,
            isMuted: audio.isMuted,
            onToggleMute: {
                audio.toggleMute()
                if !audio.isMuted {
                    audio.play(audioName: "Level-5-Explanation")
                }
            }
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
    }
}

#Preview {
    Level5ExplanationView()
}
