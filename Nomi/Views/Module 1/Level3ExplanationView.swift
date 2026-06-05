//
//  Level3ExplanationView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 06/06/26.
//

import SwiftUI

struct Level3ExplanationView: View {
    let highlight1 = Text("Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    let highlight2 = Text("Non-Private Part")
        .foregroundColor(.nomiPrimary)
        .font(.heading3())
    @State private var navigateToWordSorting = false
    var body: some View {
        NavigationStack {
            LevelExplanationScreen(
                title: "Doctor's Words",
                mascotImage: "NomiDoctor",
                paragraphs: [
                    Text("Let’s refresh your memory!").font(.heading2(weight: .black, size: 20)),
                    Text("Drag the \(highlight1) and the \(highlight2) of your body to the designated sides!").font(.heading2(weight: .semiBold, size: 20))
                ],
                buttonTitle: "Start",
            ) {
                navigateToWordSorting.toggle()
            }
            .navigationDestination(isPresented: $navigateToWordSorting) {
                WordSortingView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    Level3ExplanationView()
}
