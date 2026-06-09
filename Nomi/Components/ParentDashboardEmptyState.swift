//
//  ParentDashboardEmptyState.swift
//  Nomi
//

import SwiftUI

struct ParentDashboardEmptyState: View {
    let childName: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 34))
                .foregroundStyle(Color.nomiPrimary)

            Text("No learning progress yet")
                .font(.heading3())
                .foregroundStyle(Color.nomiTextPrimary)

            Text("\(childName)'s completed levels and recent activity will appear here.")
                .font(.bodySmall())
                .foregroundStyle(Color.nomiTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 36)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.06),
            radius: 12,
            x: 0,
            y: 2
        )
    }
}
