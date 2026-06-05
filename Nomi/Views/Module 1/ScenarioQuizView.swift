//
//  ScenarioQuizView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 04/06/26.
//

import SwiftUI

struct ScenarioQuizView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image(.storyBackground)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()

                    VStack(spacing: 22) {
                        Spacer()
                    Text("Safety Detective")
                        .font(.heading1(weight: .black, size: 38))
                        .foregroundStyle(Color.nomiTextPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 88)
                    Spacer()
                    ScenarioCard(
                        image: .story1,
                        text: """
                        An older kid at the park says, "Let's go behind the tree and show each other our private parts. It's a fun game!"
                        """
                    )
                    .padding(.horizontal, 22)

                    Spacer(minLength: 16)

                    HStack(spacing: 14) {
                        WideButton(title: "Safe", background: .nomiSuccess, foreground: .white) {

                        }

                        WideButton(title: "Unsafe", background: .nomiDanger, foreground: .white) {

                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 44)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ScenarioQuizView()
}
