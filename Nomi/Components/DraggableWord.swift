//
//  DraggableWord.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 03/06/26.
//

import SwiftUI
import SwiftData

struct DraggableWord: View {
    
    @Environment(\.modelContext) private var context
    
    @Binding var textItem: DragWordModel
    @Binding var draggingTextID: UUID?
    @Binding var isDragging: Bool
    @Binding var doctorsFrame: CGRect
    @Binding var strangersFrame: CGRect
    @Binding var wordBankFrame: CGRect
    let onDropToCategory: (UUID, WordCategory) -> CGPoint
    
    @State private var lastPosition: CGPoint = .zero
    @State private var lastScale: CGFloat = 1
    @State private var lastRotation: Double = 0
    @State private var currentPosition: CGPoint = .zero
    @State private var currentScale: CGFloat = 1
    @State private var currentRotation: Angle = .zero
    @State private var dragScaleEffect: CGFloat = 1
    
    @Binding var selectedText: UUID?
    
    var body: some View {
        Group {
            Text(textItem.text)
                .frame(width: 120)
                .padding(.vertical, 10)
                .background(Color.nomiPrimarySoft)
                .foregroundColor(Color.nomiSurfaceTint)
                .font(.heading2(weight: .bold))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                    selectedText = textItem.id
                }
        }
        .rotationEffect(currentRotation)
        .scaleEffect(currentScale * dragScaleEffect)
        .position(currentPosition)
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: dragScaleEffect)
        .onAppear {
            syncFromModel()
        }
        .onChange(of: textItem.posX) { _, _ in
            if draggingTextID != textItem.id {
                syncFromModel()
            }
        }
        .onChange(of: textItem.posY) { _, _ in
            if draggingTextID != textItem.id {
                syncFromModel()
            }
        }
        .onChange(of: textItem.scale) { _, _ in
            if draggingTextID != textItem.id {
                syncFromModel()
            }
        }
        .onChange(of: textItem.rotation) { _, _ in
            if draggingTextID != textItem.id {
                syncFromModel()
            }
        }
        .gesture(combinedGesture)
    }
    
    var combinedGesture: some Gesture {
        let drag = DragGesture()
        let scale = MagnificationGesture()
        let rotate = RotationGesture()
        
        return drag
            .simultaneously(with: scale)
            .simultaneously(with: rotate)
            .onChanged { value in
                if draggingTextID != textItem.id {
                    draggingTextID = textItem.id
                }
                if !isDragging {
                    isDragging = true
                }
                if dragScaleEffect != 1.5 {
                    dragScaleEffect = 1.5
                }
                
                let dragValue = value.first?.first
                let scaleValue = value.first?.second
                let rotationValue = value.second
                
                if let dragValue {
                    let t = dragValue.translation
                    let damping = 1 / sqrt(max(textItem.scale, 0.5))
                    
                    currentPosition = CGPoint(
                        x: lastPosition.x + t.width * damping,
                        y: lastPosition.y + t.height * damping
                    )
                }
                
                if let scaleValue {
                    let newScale = lastScale * scaleValue
                    currentScale = min(max(newScale, 0.75), 3.0)
                }
                
                if let rotationValue {
                    currentRotation = Angle(radians: lastRotation + rotationValue.radians)
                }
            }
            .onEnded { _ in
                if doctorsFrame.contains(currentPosition) {
                    let snapPosition = onDropToCategory(textItem.id, .doctors)
                    let resolvedCategory = textItem.category
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        currentPosition = snapPosition
                        currentRotation = resolvedCategory == .unassigned ? textItem.rotationAngle : .zero
                        currentScale = 1
                    }
                    textItem.posX = snapPosition.x
                    textItem.posY = snapPosition.y
                    textItem.scale = 1
                    textItem.rotation = resolvedCategory == .unassigned ? textItem.rotation : 0
                    textItem.category = resolvedCategory
                } else if strangersFrame.contains(currentPosition) {
                    let snapPosition = onDropToCategory(textItem.id, .strangers)
                    let resolvedCategory = textItem.category
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        currentPosition = snapPosition
                        currentRotation = resolvedCategory == .unassigned ? textItem.rotationAngle : .zero
                        currentScale = 1
                    }
                    textItem.posX = snapPosition.x
                    textItem.posY = snapPosition.y
                    textItem.scale = 1
                    textItem.rotation = resolvedCategory == .unassigned ? textItem.rotation : 0
                    textItem.category = resolvedCategory
                } else {
                    let snapPosition = onDropToCategory(textItem.id, .unassigned)
                    
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                        currentPosition = snapPosition
                        currentRotation = textItem.rotationAngle
                        currentScale = 1
                    }
                    
                    textItem.posX = snapPosition.x
                    textItem.posY = snapPosition.y
                    textItem.scale = 1
                    textItem.category = .unassigned
                }
                
                dragScaleEffect = 1
                isDragging = false
                draggingTextID = nil
                
                lastPosition = currentPosition
                lastScale = currentScale
                lastRotation = currentRotation.radians
            }
    }
    
    private func syncFromModel() {
        let position = textItem.position
        let scale = textItem.scaleCGFloat
        let rotation = textItem.rotationAngle
        
        lastPosition = position
        lastScale = scale
        lastRotation = rotation.radians
        currentPosition = position
        currentScale = scale
        currentRotation = rotation
    }
}
