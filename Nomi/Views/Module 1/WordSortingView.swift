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
    @State private var privateContainerShake: CGFloat = 0
    @State private var nonPrivateContainerShake: CGFloat = 0
    @State private var showPrivateWrongOverlay = false
    @State private var showNonPrivateWrongOverlay = false
    @State private var privateWordOrder: [UUID] = []
    @State private var nonPrivateWordOrder: [UUID] = []
    @State private var bankWordOrder: [UUID] = []
    @State private var initialBankOrder: [UUID] = []
    @State private var initialBankPositions: [UUID: CGPoint] = [:]
    @State private var initialBankRotations: [UUID: Double] = [:]
    
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
                            title: "Private",
                            frame: $doctorsFrame,
                            showWrongOverlay: showPrivateWrongOverlay
                        )
                        .offset(x: privateContainerShake)
                        
                        DropContainer(
                            title: "Non-Private",
                            frame: $strangersFrame,
                            showWrongOverlay: showNonPrivateWrongOverlay
                        )
                        .offset(x: nonPrivateContainerShake)
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
                .padding(.top, 84)
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
                            selectedText: $selectedText,
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
        
        if category != .unassigned {
            let expectedCategory = correctCategory(for: words[wordIndex])

            if expectedCategory != category {
                triggerWrongDropFeedback(for: category)

                removeWordFromAllOrders(wordID)
                appendWord(wordID, to: .unassigned)

                let bankSlotIndex = slotIndex(for: wordID, in: .unassigned)

                words[wordIndex].category = .unassigned
                words[wordIndex].rotation = initialBankRotations[wordID] ?? randomWordBankRotation(for: bankSlotIndex)
                words[wordIndex].scale = 1

                if let originalPosition = initialBankPositions[wordID] {
                    return originalPosition
                }

                return randomWordBankPosition(
                    for: bankSlotIndex,
                    in: wordBankFrame
                )
            }
        }
        
        let targetFrame: CGRect
        switch category {
        case .doctors:
            targetFrame = doctorsFrame
        case .strangers:
            targetFrame = strangersFrame
        case .unassigned:
            targetFrame = wordBankFrame
        }
        
        removeWordFromAllOrders(wordID)
        appendWord(wordID, to: category)

        words[wordIndex].category = category

        let slotIndex = slotIndex(for: wordID, in: category)
        
        let snapPoint: CGPoint

        if category == .unassigned {
            snapPoint = initialBankPositions[wordID]
                ?? randomWordBankPosition(for: slotIndex, in: targetFrame)
        } else {
            let verticalPadding: CGFloat = 46
            let chipHeight: CGFloat = 44
            let rowSpacing: CGFloat = 32
            
            snapPoint = CGPoint(
                x: targetFrame.midX,
                y: targetFrame.minY + verticalPadding + (CGFloat(slotIndex) * (chipHeight + rowSpacing))
            )
        }
        
        words[wordIndex].rotation = category == .unassigned
            ? (initialBankRotations[wordID] ?? randomWordBankRotation(for: slotIndex))
            : 0
        words[wordIndex].scale = 1
        
        return snapPoint
    }
    
    private func randomWordBankRotation(for index: Int) -> Double {
        let rotations: [Double] = [-0.12, 0.09, -0.07, 0.11, -0.09, 0.06]
        return rotations[index % rotations.count]
    }
    
    private func randomWordBankPosition(for index: Int, in frame: CGRect) -> CGPoint {
        let positions: [(CGFloat, CGFloat)] = [
            (0.20, 0.20),
            (0.50, 0.14),
            (0.80, 0.20),
            (0.15, 0.55),
            (0.50, 0.50),
            (0.85, 0.55),
            (0.50, 0.82)
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
        bankWordOrder = words.map(\.id).shuffled()
        initialBankOrder = bankWordOrder
        privateWordOrder = []
        nonPrivateWordOrder = []

        for wordID in bankWordOrder {
            guard let wordIndex = words.firstIndex(where: { $0.id == wordID }) else { continue }
            let slotIndex = slotIndex(for: wordID, in: .unassigned)

            words[wordIndex].category = .unassigned
            words[wordIndex].scale = 1
            words[wordIndex].rotation = randomWordBankRotation(for: slotIndex)

            let position = randomWordBankPosition(
                for: slotIndex,
                in: wordBankFrame
            )

            words[wordIndex].posX = position.x
            words[wordIndex].posY = position.y
            initialBankPositions[wordID] = position
            initialBankRotations[wordID] = words[wordIndex].rotation
        }
    }
    
    private func removeWordFromAllOrders(_ wordID: UUID) {
        privateWordOrder.removeAll { $0 == wordID }
        nonPrivateWordOrder.removeAll { $0 == wordID }
        bankWordOrder.removeAll { $0 == wordID }
    }
    
    private func appendWord(_ wordID: UUID, to category: WordCategory) {
        switch category {
        case .doctors:
            if !privateWordOrder.contains(wordID) {
                privateWordOrder.append(wordID)
            }
        case .strangers:
            if !nonPrivateWordOrder.contains(wordID) {
                nonPrivateWordOrder.append(wordID)
            }
        case .unassigned:
            guard !bankWordOrder.contains(wordID) else { return }

            let originalIndex = initialBankOrder.firstIndex(of: wordID) ?? initialBankOrder.count

            let insertIndex = bankWordOrder.firstIndex { existingID in
                let existingOriginalIndex = initialBankOrder.firstIndex(of: existingID) ?? initialBankOrder.count
                return existingOriginalIndex > originalIndex
            } ?? bankWordOrder.count

            bankWordOrder.insert(wordID, at: insertIndex)
        }
    }
    
    private func slotIndex(for wordID: UUID, in category: WordCategory) -> Int {
        switch category {
        case .doctors:
            return privateWordOrder.firstIndex(of: wordID) ?? privateWordOrder.count
        case .strangers:
            return nonPrivateWordOrder.firstIndex(of: wordID) ?? nonPrivateWordOrder.count
        case .unassigned:
            return bankWordOrder.firstIndex(of: wordID) ?? bankWordOrder.count
        }
    }
    
    private func correctCategory(for word: DragWordModel) -> WordCategory {
        switch word.text.lowercased() {
        case "penis", "vagina", "chest", "buttock":
            return .doctors
        default:
            return .strangers
        }
    }
    
    private func triggerWrongDropFeedback(for category: WordCategory) {
        let isPrivate = category == .doctors
        
        if isPrivate {
            showPrivateWrongOverlay = true
        } else {
            showNonPrivateWrongOverlay = true
        }

        withAnimation(.easeInOut(duration: 0.05)) {
            if isPrivate {
                privateContainerShake = -5
            } else {
                nonPrivateContainerShake = -5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.05)) {
                if isPrivate {
                    privateContainerShake = 5
                } else {
                    nonPrivateContainerShake = 5
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.9)) {
                privateContainerShake = 0
                nonPrivateContainerShake = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.easeOut(duration: 0.15)) {
                showPrivateWrongOverlay = false
                showNonPrivateWrongOverlay = false
            }
        }
    }
}

struct DropContainer: View {
    let title: String
    @Binding var frame: CGRect
    let showWrongOverlay: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.heading2(weight:.extraBold))
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
                            title == "Private"
                            ? Color.nomiSuccess.opacity(0.5)
                            : Color.nomiDanger.opacity(0.5),
                            lineWidth: 2
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.red.opacity(showWrongOverlay ? 0.18 : 0))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.red.opacity(showWrongOverlay ? 0.9 : 0), lineWidth: 3)
                )
                .animation(.easeInOut(duration: 0.12), value: showWrongOverlay)
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
