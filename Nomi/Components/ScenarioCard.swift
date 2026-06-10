//
//  ScenarioCard.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI

struct ScenarioCard: View {
    let image: ImageResource
    let text: String

    var body: some View {
        VStack() {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 234)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
            Text(text)
                .font(.heading3(weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.nomiTextPrimary)
                .padding(.horizontal, 12)
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .frame(height: 460)
        .background(Color.nomiSurfaceTint)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.06),
            radius: 12,
            x: 0,
            y: 2
        )
        .padding(.horizontal, 22)
    }
}

#Preview {
    ScenarioCard(image: .scenario1, text: "Test")
}
