//
//  ActivityItem.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct ActivityItem: View {

    let emoji: String
    let title: String
    let time: String
    let showDivider: Bool

    var body: some View {

        VStack(spacing: 20) {

            HStack(alignment: .top, spacing: 16) {

                Text(emoji)
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 4) {

                    Text(title)
                        .font(.bodySmall(size: 13))

                    Text(time)
                        .font(.label(weight: .regular))
                        .foregroundStyle(.textSecondary)
                }

                Spacer()
            }

            if showDivider {

                Divider()
            }
        }
    }
}
