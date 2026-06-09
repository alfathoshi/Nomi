//
//  TwoFingerHoldArea.swift
//  Nomi
//

import SwiftUI
import UIKit

struct TwoFingerHoldArea: View {
    let duration: TimeInterval
    let onComplete: () -> Void

    @State private var progress: CGFloat = 0
    @State private var holdTask: Task<Void, Never>?
    @State private var hasCompleted = false
    @State private var isPulsing = false
    @State private var isHolding = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.nomiPrimary.opacity(0.1))
                .overlay {
                    GeometryReader { geometry in
                        ZStack {
                            Color.nomiPrimary.opacity(0.18)
                                .frame(width: geometry.size.width * progress / 2)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Color.nomiAccent.opacity(0.18)
                                .frame(width: geometry.size.width * progress / 2)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            isHolding
                            ? AnyShapeStyle(meetingGradient)
                            : AnyShapeStyle(Color.nomiPrimary.opacity(0.35)),
                            lineWidth: 2
                        )
                }
                .shadow(color: isHolding ? Color.nomiPrimary.opacity(0.18) : .clear, radius: 16, x: -8)
                .shadow(color: isHolding ? Color.nomiAccent.opacity(0.18) : .clear, radius: 16, x: 8)

            VStack(spacing: 16) {
                Text(progress > 0 ? "Keep holding together!" : "Place one finger each")
                    .font(.heading3())
                    .foregroundStyle(
                        isHolding
                        ? AnyShapeStyle(meetingGradient)
                        : AnyShapeStyle(Color.nomiPrimary)
                    )
                    .transaction { transaction in
                        transaction.animation = nil
                    }

                HStack(spacing: 44) {
                    touchIndicator(label: "Kid", color: .nomiPrimary)
                    touchIndicator(label: "Parent", color: .nomiAccent)
                }

                GeometryReader { geometry in
                    ZStack {
                        Capsule()
                            .fill(Color.nomiPrimary.opacity(0.15))

                        Color.nomiPrimary
                            .frame(width: geometry.size.width * progress / 2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Color.nomiAccent
                            .frame(width: geometry.size.width * progress / 2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .clipShape(Capsule())
                }
                .frame(height: 10)
                .padding(.horizontal, 28)

                Text(progress > 0 ? "Hold for 5 seconds" : "Touch anywhere in this area")
                    .font(.bodySmall())
                    .foregroundColor(.nomiTextSecondary)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
            .padding(.vertical, 20)

            MultiTouchCaptureView(
                minimumTouchCount: 2,
                onTouchStateChanged: handleTouchState
            )
        }
        .frame(height: 210)
        .contentShape(RoundedRectangle(cornerRadius: 28))
        .accessibilityLabel("Hold with two fingers for five seconds")
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
        .onDisappear {
            cancelHold()
        }
    }

    private var meetingGradient: LinearGradient {
        LinearGradient(
            colors: [.nomiPrimary, .nomiPrimary, .nomiAccent, .nomiAccent],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func touchIndicator(label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 96, height: 96)
                    .scaleEffect(isPulsing ? (isHolding ? 1.18 : 1.12) : 1)
                    .opacity(isPulsing ? 0.55 : 0.9)

                Circle()
                    .fill(color.opacity(0.18))
                    .frame(width: 72, height: 72)
                    .scaleEffect(isPulsing ? (isHolding ? 1.12 : 1.08) : 1)
                    .opacity(isPulsing ? 0.7 : 1)

                Circle()
                    .fill(progress > 0 ? color : .white)
                    .frame(width: 52, height: 52)
                    .shadow(color: .black.opacity(0.08), radius: 5, y: 2)

                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(progress > 0 ? .white : color)
            }

            Text(label)
                .font(.bodySmall(weight: .bold))
                .foregroundColor(color)
        }
    }

    private func handleTouchState(_ isHolding: Bool) {
        guard !hasCompleted else { return }

        if isHolding {
            startHold()
        } else {
            cancelHold()
        }
    }

    private func startHold() {
        guard holdTask == nil else { return }

        withAnimation(.easeInOut(duration: 0.35)) {
            isHolding = true
        }
        withAnimation(.linear(duration: duration)) {
            progress = 1
        }

        holdTask = Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }

            await MainActor.run {
                hasCompleted = true
                holdTask = nil
                onComplete()
            }
        }
    }

    private func cancelHold() {
        holdTask?.cancel()
        holdTask = nil

        guard !hasCompleted else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            progress = 0
            isHolding = false
        }
    }
}

private struct MultiTouchCaptureView: UIViewRepresentable {
    let minimumTouchCount: Int
    let onTouchStateChanged: (Bool) -> Void

    func makeUIView(context: Context) -> MultiTouchView {
        let view = MultiTouchView()
        view.minimumTouchCount = minimumTouchCount
        view.onTouchStateChanged = onTouchStateChanged
        return view
    }

    func updateUIView(_ uiView: MultiTouchView, context: Context) {
        uiView.minimumTouchCount = minimumTouchCount
        uiView.onTouchStateChanged = onTouchStateChanged
    }
}

private final class MultiTouchView: UIView {
    var minimumTouchCount = 2
    var onTouchStateChanged: ((Bool) -> Void)?

    private var activeTouches = Set<ObjectIdentifier>()
    private var isHolding = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { activeTouches.insert(ObjectIdentifier($0)) }
        updateHoldingState()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        remove(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        remove(touches)
    }

    private func remove(_ touches: Set<UITouch>) {
        touches.forEach { activeTouches.remove(ObjectIdentifier($0)) }
        updateHoldingState()
    }

    private func updateHoldingState() {
        let newValue = activeTouches.count >= minimumTouchCount
        guard newValue != isHolding else { return }
        isHolding = newValue
        onTouchStateChanged?(newValue)
    }
}
