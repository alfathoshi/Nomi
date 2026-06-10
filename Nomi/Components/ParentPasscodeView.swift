//
//  ParentPasscodeView.swift
//  Nomi
//

import SwiftUI

struct ParentPasscodeView: View {
    let onAuthenticated: () -> Void
    let onBack: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    @State private var service: ParentZoneViewModel

    init(
        mode: ParentPinMode? = nil,
        onAuthenticated: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.onAuthenticated = onAuthenticated
        self.onBack = onBack
        _service = State(
            initialValue: ParentZoneViewModel(initialMode: mode)
        )
    }

    var body: some View {
        VStack {
            Image(.lock)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)

            Text(service.title)
                .font(.heading2())
                .padding(.bottom, 10)

            Text(service.instruction)
                .multilineTextAlignment(.center)
                .font(.bodySmall(weight: .regular))
                .foregroundColor(.nomiTextSecondary)
                .padding(.bottom, 20)

            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(
                            index < service.enteredPin.count
                            ? Color.nomiPrimary
                            : .gray.opacity(0.2)
                        )
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.bottom, 20)

            if let message = service.message {
                Text(message)
                    .font(.label(weight: .regular))
                    .foregroundColor(.nomiDanger)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...9, id: \.self) { digit in
                    KeypadButton(value: String(digit)) {
                        enterDigit(String(digit))
                    }
                }

                Color.clear

                KeypadButton(value: "0") {
                    enterDigit("0")
                }

                Button {
                    service.deleteDigit()
                } label: {
                    Image(systemName: "delete.left")
                        .font(.heading1())
                        .foregroundColor(.nomiTextPrimary)
                }
            }
            .padding(.bottom, 32)

            Button(action: onBack) {
                Label("Back", systemImage: "arrow.left")
                    .font(.button())
                    .underline()
                    .foregroundStyle(Color.nomiPrimary)
            }
            .buttonStyle(.plain)
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }

    private func enterDigit(_ digit: String) {
        service.handleDigit(digit)

        guard service.enteredPin.count == 4 else { return }
        submitPin()
    }

    private func submitPin() {
        service.submitPin()

        guard service.isAuthenticated else { return }
        service.isAuthenticated = false
        onAuthenticated()
    }
}

#Preview {
    ParentPasscodeView(onAuthenticated: {}, onBack: {})
}
