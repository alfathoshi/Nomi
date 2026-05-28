//
//  TopicProgressCard.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct TopicProgressCard: View {

    let emoji: String
    let title: String
    let progress: CGFloat
    let progressColor: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .center) {

                Text(emoji)
                    .font(.heading1())

                VStack(alignment: .leading) {

                    HStack {
                        Text(title)
                            .font(.bodySmall(weight: .bold))
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.label())
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.bottom, 8)
                    

                    GeometryReader { geometry in

                        ZStack(alignment: .leading) {

                            Capsule()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 6)

                            Capsule()
                                .fill(progressColor)
                                .frame(
                                    width: geometry.size.width * progress,
                                    height: 6
                                )
                        }
                    }
                    .frame(height: 14)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.06  ),
            radius: 12,
            x: 0,
            y: 2
        )
    }
}
