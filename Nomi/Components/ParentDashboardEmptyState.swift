//
//  ParentDashboardEmptyState.swift
//  Nomi
//

import SwiftUI

struct ParentDashboardEmptyState: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            emptyOverview
            emptyTopics
            emptyRecentActivity
        }
        .padding(.bottom, 20)
    }

    private var emptyOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Overview")

            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.nomiPrimary)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Find your child’s progress once they start playing.")
                        .font(.bodyLarge(weight: .bold))
                        .foregroundStyle(Color.nomiTextPrimary)

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.nomiSurfaceTint)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var emptyTopics: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Topics")

            VStack(spacing: 8) {
                Text("0")
                    .font(.display(size: 56))
                    .foregroundStyle(Color.nomiSuccess)

                Text("Completed")
                    .font(.bodyLarge())
                    .foregroundStyle(Color.nomiTextSecondary)

                Text("No topics completed yet")
                    .font(.bodySmall(weight: .bold))
                    .foregroundStyle(Color.nomiTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.nomiSuccess.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var emptyRecentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Recent Activity")

            VStack(spacing: 0) {
                activityPlaceholder(showDivider: false)
            }
            .padding(.horizontal, 16)
            .background(Color.nomiAccentSoft.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: .black.opacity(0.06),
                radius: 12,
                x: 0,
                y: 2
            )
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.heading3())
            .foregroundStyle(Color.nomiTextPrimary)
    }

    private func activityPlaceholder(showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text("—")
                    .font(.bodySmall(weight: .bold))
                    .foregroundStyle(Color.nomiTextSecondary)

                Text("Module Progress")
                    .font(.bodySmall(size: 13))
                    .foregroundStyle(Color.nomiTextSecondary)

                Spacer()
            }
            .padding(.vertical, 18)

            if showDivider {
                Divider()
            }
        }
    }
}

#Preview {
    ScrollView {
        ParentDashboardEmptyState()
            .padding(20)
    }
}
