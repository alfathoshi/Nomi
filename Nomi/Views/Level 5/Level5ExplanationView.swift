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
    var body: some View {
        LevelExplanationScreen(
            title: "The Trust Contract",
            mascotImage: "NomiHome",
            paragraphs: [
                Text("Now it’s time to find your Trusted Adult!").font(.heading2(weight: .black, size: 20)),
                Text(" Go invite a Parent, Guardian, or safe grown-up to join you for a special \(highlight)").font(.heading2(weight: .semiBold, size: 20))
            ],
            buttonTitle: "My Trusted Adult is Here"
        ) {
            
        }
    }
}

#Preview {
    Level5ExplanationView()
}
