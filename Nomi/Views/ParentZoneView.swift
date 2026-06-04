//
//  ParentZoneView.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct ParentZoneView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    @Environment(\.dismiss) private var dismiss
    @State private var service = ParentZoneViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Text("🔐")
                    .font(.system(size: 64))
                
                Text("Parent Zone")
                    .font(.heading2())
                    .padding(.bottom, 10)
                
                Text("This area is for grown-ups only.\nEnter your PIN to continue.")
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
                
                LazyVGrid(
                    columns: columns,
                    spacing: 10
                ) {
                    KeypadButton(value: "1") {
                        service.handleDigit("1")
                    }
                    KeypadButton(value: "2") {
                        service.handleDigit("2")
                    }
                    KeypadButton(value: "3") {
                        service.handleDigit("3")
                    }
                    KeypadButton(value: "4") {
                        service.handleDigit("4")
                    }
                    KeypadButton(value: "5") {
                        service.handleDigit("5")
                    }
                    KeypadButton(value: "6") {
                        service.handleDigit("6")
                    }
                    KeypadButton(value: "7") {
                        service.handleDigit("7")
                    }
                    KeypadButton(value: "8") {
                        service.handleDigit("8")
                    }
                    KeypadButton(value: "9") {
                        service.handleDigit("9")
                    }
                    KeypadButton(value: "👆") {
                        service.validatePin()
                    }
                    .navigationDestination(
                        isPresented: $service.isAuthenticated
                    ) {
                        ParentDashboardView()
                    }
                    KeypadButton(value: "0") {
                        service.handleDigit("0")
                    }
                    
                    Button {
                        if !service.enteredPin.isEmpty {
                            service.enteredPin.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.heading1())
                            .foregroundColor(.nomiTextPrimary)
                    }
                }
                .padding(.bottom, 32)
                
                Button {
                    dismiss()
                } label: {
                    Label("Back to Child Zone", systemImage: "arrow.left")
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
    }
}

#Preview {
    ParentZoneView()
}
