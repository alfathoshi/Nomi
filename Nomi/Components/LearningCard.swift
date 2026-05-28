//
//  LearningCard.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 27/05/26.
//
import SwiftUI

struct LearningCard: View {
    let title: String
    let icon: String
    let level: Int
    let color: Color
    let progress: Double
    let isLocked: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Layer 1: Background pastel
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.2))
            
            // Layer 2: Content (icon + title + progress)
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundStyle(color)

                Spacer()
                
                Text(title)
                    .font(.heading3())
                    .foregroundColor(isLocked ? .nomiTextSecondary : .nomiTextPrimary)
                    .multilineTextAlignment(.leading)
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.nomiSurfaceTint)
                        Capsule()
                            .fill(color)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 6)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Layer 3: Level badge (top-right)
            Text("Lvl \(level)")
                .font(.label())
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().fill(.white))
                .padding(10)

            // Layer 4: Lock overlay
            if isLocked {
                Image(systemName: "lock.fill")
                    .font(.title)
                    .foregroundColor(.nomiTextSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: 180)
        .opacity(isLocked ? 0.6 : 1.0)
    }
}

#Preview("LearningCard - Unlocked") {
    LearningCard(title: "Body Parts &\nBoundaries", icon: "brain.head.profile", level: 2, color: .purple, progress: 0.4, isLocked: false)
        .frame(width: 180)
        .padding()
}

#Preview("LearningCard - Locked") {
    LearningCard(title: "Trusted Adults", icon: "shield.lefthalf.filled", level: 1, color: .mint, progress: 0, isLocked: true)
        .frame(width: 180)
        .padding()
}
