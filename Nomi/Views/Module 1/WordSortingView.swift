//
//  WordSortingView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//


import SwiftUI

struct WordSortingView: View {
    
    @State private var words = SortingWordData.words
    @State private var showCelebration = false
    @State private var draggingTextID: UUID?
    @State private var isDragging = false
    @State private var isOverTrash = false
    @State private var trashFrame: CGRect = .zero
    @State private var doctorsFrame: CGRect = .zero
    @State private var strangersFrame: CGRect = .zero
    @State private var wordBankFrame: CGRect = .zero
    @State private var selectedText: UUID?
    @State private var didPlaceInitialWords = false
    
    let screenSize = UIScreen.main.bounds.size
    
    private var isFinishDisabled: Bool {
        words.contains { $0.category == .unassigned }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.storyBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: screenSize.width,
                        height: screenSize.height
                    )
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        DropContainer(
                            title: "Doctors",
                            frame: $doctorsFrame
                        )
                        
                        DropContainer(
                            title: "Strangers",
                            frame: $strangersFrame
                        )
                    }
                    
                    WordBankDropContainer(frame: $wordBankFrame)
                        .frame(height: 180)
                    
                    WideButton(title: "Finish Sorting", icon: "flag.pattern.checkered") {
                        showCelebration = true
                    }
                    .disabled(isFinishDisabled)
                    .saturation(isFinishDisabled ? 0.1 : 1)
                    .opacity(isFinishDisabled ? 0.7 : 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .padding(.bottom, 44)
                if didPlaceInitialWords {
                    ForEach($words, id: \.id) { $word in
                        DraggableWord(
                            textItem: $word,
                            draggingTextID: $draggingTextID,
                            isDragging: $isDragging,
                            doctorsFrame: $doctorsFrame,
                            strangersFrame: $strangersFrame,
                            wordBankFrame: $wordBankFrame,
                            onDropToCategory: snapPosition,
                            selectedText: $selectedText
                        )
                        .zIndex(draggingTextID == word.id ? 100 : 1)
                    }
                }
                if showCelebration {
                    
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showCelebration = false
                        }
                    
                    LottieWrapper(
                        fileName: "confetti"
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            showCelebration = false
                        }
                    }
                }
            }
            .coordinateSpace(name: "sortingArea")
            .onChange(of: wordBankFrame) { _, newFrame in
                guard !didPlaceInitialWords, newFrame.width > 0, newFrame.height > 0 else { return }
                placeInitialWordsInWordBank()
                didPlaceInitialWords = true
            }
        }
    }
    
    private func snapPosition(for wordID: UUID, category: WordCategory) -> CGPoint {
        guard let wordIndex = words.firstIndex(where: { $0.id == wordID }) else {
            return .zero
        }
        
        let previousCategory = words[wordIndex].category
        
        let targetFrame: CGRect
        switch category {
        case .doctors:
            targetFrame = doctorsFrame
        case .strangers:
            targetFrame = strangersFrame
        case .unassigned:
            targetFrame = wordBankFrame
        }
        
        let slotIndex: Int
        if previousCategory == category {
            let wordsInSameCategory = words.filter { $0.category == category }
            slotIndex = wordsInSameCategory.firstIndex(where: { $0.id == wordID }) ?? 0
        } else {
            slotIndex = words.filter { $0.category == category }.count
        }
        
        words[wordIndex].category = category
        
        let snapPoint: CGPoint
        
        if category == .unassigned {
            snapPoint = randomWordBankPosition(for: slotIndex, in: targetFrame)
        } else {
            let verticalPadding: CGFloat = 46
            let chipHeight: CGFloat = 44
            let rowSpacing: CGFloat = 32
            
            snapPoint = CGPoint(
                x: targetFrame.midX,
                y: targetFrame.minY + verticalPadding + (CGFloat(slotIndex) * (chipHeight + rowSpacing))
            )
        }
        
        words[wordIndex].rotation = category == .unassigned ? randomWordBankRotation(for: slotIndex) : 0
        words[wordIndex].scale = 1
        
        return snapPoint
    }
    
    private func randomWordBankRotation(for index: Int) -> Double {
        let rotations: [Double] = [-0.12, 0.09, -0.07, 0.11, -0.09, 0.06]
        return rotations[index % rotations.count]
    }
    
    private func randomWordBankPosition(for index: Int, in frame: CGRect) -> CGPoint {
        let positions: [(CGFloat, CGFloat)] = [
            (0.15, 0.32),
            (0.50, 0.28),
            (0.85, 0.34),
            (0.35, 0.75),
            (0.65, 0.75),
            (0.18, 0.72),
            (0.82, 0.72)
        ]
        
        let point = positions[index % positions.count]
        let horizontalInset: CGFloat = 56
        let verticalInset: CGFloat = 34
        
        let safeWidth = max(frame.width - (horizontalInset * 2), 1)
        let safeHeight = max(frame.height - (verticalInset * 2), 1)
        
        return CGPoint(
            x: frame.minX + horizontalInset + (safeWidth * point.0),
            y: frame.minY + verticalInset + (safeHeight * point.1)
        )
    }
    
    private func placeInitialWordsInWordBank() {
        for index in words.indices {
            words[index].category = .unassigned
            words[index].scale = 1
            words[index].rotation = randomWordBankRotation(for: index)
            
            let position = randomWordBankPosition(for: index, in: wordBankFrame)
            words[index].posX = position.x
            words[index].posY = position.y
        }
    }
}

struct DropContainer: View {
    let title: String
    @Binding var frame: CGRect
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.heading2(weight:.bold))
                .foregroundStyle(Color.nomiTextPrimary)
            
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.nomiSurfaceTint)
                .frame(maxWidth: .infinity)
            
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                frame = geo.frame(in: .named("sortingArea"))
                            }
                            .onChange(of: geo.size) { _, _ in
                                frame = geo.frame(in: .named("sortingArea"))
                            }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            title == "Doctors"
                            ? Color.nomiSuccess.opacity(0.5)
                            : Color.nomiDanger.opacity(0.5),
                            lineWidth: 2
                        )
                )
        }
    }
}

#Preview {
    WordSortingView()
}


struct WordBankDropContainer: View {
    @Binding var frame: CGRect
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.nomiSurfaceTint)
            .frame(maxWidth: .infinity)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            frame = geo.frame(in: .named("sortingArea"))
                        }
                        .onChange(of: geo.frame(in: .named("sortingArea"))) { _, newFrame in
                            frame = newFrame
                        }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        Color.nomiPrimary.opacity(0.5),
                        lineWidth: 2
                    )
            )
    }
}
