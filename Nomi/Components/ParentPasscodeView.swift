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

    @State private var service = ParentZoneViewModel()

    var body: some View {
        VStack {
            Text("🔐")
                .font(.system(size: 64))

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
                        service.handleDigit(String(digit))
                    }
                }

                KeypadButton(value: "👆") {
                    submitPin()
                }

                KeypadButton(value: "0") {
                    service.handleDigit("0")
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
