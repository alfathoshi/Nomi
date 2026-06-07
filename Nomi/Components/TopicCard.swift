//
//  TopicCard.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 03/06/26.
//

import SwiftUI

struct TopicCard: View {
    let number: Int
    let title: String
    var characterImage: String? = "HomeBoy"
    var currentStep: Int = 0
    var totalSteps: Int = 5
    var isLocked: Bool = false
    var action: () -> Void = {}

    private var hasProgress: Bool { currentStep > 0 }

    private var progressFraction: Double {
        guard totalSteps > 0 else { return 0 }
        return min(Double(currentStep) / Double(totalSteps), 1.0)
    }

    private var buttonLabel: String { hasProgress ? "Continue" : "Start" }

    var body: some View {
        Button(action: action) {
            ZStack {
                // character image
                if let characterImage {
                    Image(characterImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 220)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.nomiPrimary.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.trailing, 16)
                }

                // content
                VStack(alignment: .leading, spacing: 12) {
                    // badge: progress ring or number
                    if hasProgress {
                        progressBadge
                    } else {
                        numberBadge
                    }

                    Spacer(minLength: 0)

                    Text(title)
                        .font(.heading2())
                        .foregroundColor(.nomiTextPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 180, alignment: .leading)
                        .offset(y:-10)

                    // button Start/Continue
                    Text(buttonLabel)
                        .font(.heading1())
                        .foregroundColor(.white)
                        .frame(width: 150, height: 40)
                        .background(Capsule().fill(Color.nomiAccent))
                        .padding(.bottom)
                        .offset(y:-10)
                }
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: 350)
            .frame(height: 210)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.nomiSurfaceTint)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .saturation(isLocked ? 0.2 : 1.0)
            .shadow(radius: 4, x: 0, y: 4)
        }
        .buttonStyle(CardButtonStyle())
        .disabled(isLocked)
    }

    private var numberBadge: some View {
        Text("\(number)")
            .font(.heading2(weight: .bold))
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(Circle().fill(Color.nomiPrimary))
            .padding(.top, 30)
    }


    private var progressBadge: some View {
        ZStack {
            // outer ring
            Circle()
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 60, height: 60)
                .shadow(radius: 0.5)

            Circle()
                .trim(from: 0, to: progressFraction)
                .stroke(
                    Color.nomiPrimary,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 60, height: 60)

            // inner solid
            Circle()
                .fill(Color.nomiPrimary)
                .frame(width: 50, height: 50)

            Text("\(currentStep)/\(totalSteps)")
                .font(.heading2(weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 60)
        .padding(.top, 30)
    }
}

// Custom Button Style (bouncy tap feedback)
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview("New — Start") {
    TopicCard(
        number: 1,
        title: "Body Parts & Boundaries",
        characterImage: "HomeGirl",
        currentStep: 0,
        totalSteps: 5,
        isLocked: false
    )
    .padding()
    .background(Color.nomiPrimary)
}

#Preview("In Progress — Continue") {
    TopicCard(
        number: 1,
        title: "Body Parts & Boundaries",
        characterImage: "HomeGirl",
        currentStep: 2,
        totalSteps: 5,
        isLocked: false
    )
    .padding()
    .background(Color.nomiPrimary)
}

#Preview("Almost Done") {
    TopicCard(
        number: 1,
        title: "Body Parts & Boundaries",
        characterImage: "HomeGirl",
        currentStep: 4,
        totalSteps: 5,
        isLocked: false
    )
    .padding()
    .background(Color.nomiPrimary)
}

#Preview("Locked") {
    TopicCard(
        number: 2,
        title: "Personal Hygiene",
        characterImage: "HomeBoy",
        currentStep: 0,
        totalSteps: 5,
        isLocked: true
    )
    .padding()
    .background(Color.nomiPrimary)
}

#Preview("All States Side by Side") {
    ScrollView {
        VStack(spacing: 16) {
            TopicCard(number: 1, title: "Start State (0/5)",
                      characterImage: "HomeGirl",
                      currentStep: 0, totalSteps: 5)
            TopicCard(number: 2, title: "Mid Progress (2/5)",
                      characterImage: "HomeBoy",
                      currentStep: 2, totalSteps: 5)
            TopicCard(number: 3, title: "Almost Done (4/5)",
                      characterImage: "HomeGirl",
                      currentStep: 4, totalSteps: 5)
            TopicCard(number: 4, title: "Locked State",
                      characterImage: "HomeBoy",
                      currentStep: 0, totalSteps: 5,
                      isLocked: true)
        }
        .padding()
    }
    .background(Color.nomiPrimary)
}
