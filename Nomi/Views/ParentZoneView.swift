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
    @State private var selectedPad: String?
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
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .fill(Color.nomiPrimary)
                            .frame(width: 18, height: 18)
                    }
                }
                .padding(.bottom, 20)
                
                LazyVGrid(
                    columns: columns,
                    spacing: 10
                ) {
                    KeypadButton(value: "1", selectedPad: $selectedPad)
                    KeypadButton(value: "2", label: "ABC", selectedPad: $selectedPad)
                    KeypadButton(value: "3", label: "DEF", selectedPad: $selectedPad)
                    KeypadButton(value: "4", label: "GHI", selectedPad: $selectedPad)
                    KeypadButton(value: "5", label: "JKL", selectedPad: $selectedPad)
                    KeypadButton(value: "6", label: "MNO", selectedPad: $selectedPad)
                    KeypadButton(value: "7", label: "PQRS", selectedPad: $selectedPad)
                    KeypadButton(value: "8", label: "TUV", selectedPad: $selectedPad)
                    KeypadButton(value: "9", label: "WXYZ", selectedPad: $selectedPad)
                    KeypadButton(value: "👆", selectedPad: $selectedPad)
                    KeypadButton(value: "0", selectedPad: $selectedPad)
                    Image(systemName: "delete.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
                .padding(.bottom, 32)
                
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.nomiPrimary)
                    Text("Back to Child Zone")
                        .font(.button())
                        .foregroundColor(.nomiPrimary)
                        .underline()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }
}

#Preview {
    ParentZoneView()
}
