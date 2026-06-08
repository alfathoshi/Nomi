//
//  StoryContentsGrid.swift
//  Nomi
//
//  Created by Yohanes Vito Rizki D on 06/06/26.
//

import SwiftUI

struct StoryContentsGrid: View {
    let pages: [StoryPage]
    let currentIndex: Int
    let onSelect: (Int) -> Void
    let onClose: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 0) {
                header
                grid
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.white)
            )
            .shadow(color: .black.opacity(0.25), radius: 20, y: 8)
            .padding(.horizontal, 40)
            .padding(.vertical, 40)
        }
    }

    private var header: some View {
        HStack {
            Text("Contents")
                .font(.heading2())
                .foregroundColor(.nomiTextPrimary)

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.nomiTextPrimary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.gray.opacity(0.15)))
            }
        }
        .padding(.bottom, 16)
    }

    private var grid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(0..<pages.count, id: \.self) { index in
                    pageCell(for: index)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    private func pageCell(for index: Int) -> some View {
        let isCurrent = index == currentIndex

        Button {
            onSelect(index)
            onClose()
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Image(pages[index].image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 130)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    isCurrent ? Color.nomiPrimary : Color.gray.opacity(0.2),
                                    lineWidth: isCurrent ? 3 : 1
                                )
                        )

                    if isCurrent {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.nomiPrimary)
                            .background(Circle().fill(.white))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(10)
                    }
                }

                Text("\(index + 1)")
                    .font(.label(weight: .bold))
                    .foregroundColor(isCurrent ? .nomiPrimary : .nomiTextSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StoryContentsGrid(
        pages: NomiAdventureData.storybook.pages,
        currentIndex: 2,
        onSelect: { _ in },
        onClose: { }
    )
}
