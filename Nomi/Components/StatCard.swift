//
//  StatCard.swift
//  Nomi
//
//  Created by Muhammad Bintang Al-Fath on 29/05/26.
//

import SwiftUI

struct StatCard: View {
    
    let icon: String
    let value: String
    let label: String
    let iconColor: Color
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(iconColor)
            
            Text(value)
                .font(.heading1())
            
            Text(label)
                .font(.bodySmall())
                .foregroundStyle(.textSecondary)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 166,
            alignment: .leading
        )
        .padding(16)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 8,
            x: 0,
            y: 2
        )
    }
}

#Preview {
    StatCard(icon: "person.crop.circle", value: "100", label: "Followers", iconColor: .red)
}
