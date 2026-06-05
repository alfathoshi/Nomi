//
//  Level4ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI

struct Level4ExplanationView: View {
    let highlight1 = Text("SAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("UNSAFE")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToScenarioQuiz = false
    var body: some View {
        NavigationStack {
            LevelExplanationScreen(
                title: "Safety Detective",
                mascotImage: "NomiDefault",
                paragraphs: [
                    Text("Your private parts belong only to you. Some situations are \(highlight1), like getting help from a parent or doctor. Other situations are \(highlight2). Let's decide which is which!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
            ) {
                navigateToScenarioQuiz.toggle()
            }
            .navigationDestination(isPresented: $navigateToScenarioQuiz) {
                ScenarioQuizView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    Level4ExplanationView()
}
